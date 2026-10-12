import { atom, read, update } from 'claude-code'
import type { EngineInterface, Register } from 'claude-code'

type Rows = Awaited<ReturnType<EngineInterface['clawd']['frame']>>

const pending = atom({ plugin: 'prompt-enhancer', key: 'pending' } as const, null)
const tick = atom({ plugin: 'prompt-enhancer', key: 'tick' } as const, 0)

const MODEL = 'sonnet'
const MIN_WORDS = 4
const TICK_MS = 250
const ACCENT = '#d97757'
const PREVIEW_CHARS = 72

const SYSTEM = `You rewrite prompts that a developer is about to send to Claude Code, a coding agent working in their repository.

Make the prompt clearer and more actionable: state the goal, the scope, any constraints, and what a finished result looks like. Keep every fact, file path, name and requirement the developer gave, keep their intent and voice, and do not invent details they did not give. If the prompt is already clear, return it almost unchanged.

Reply with the rewritten prompt only: no preamble, no quotes, no explanation.`

export const register: Register = on => {
  let timer: { cancel: () => void } | null = null
  let skipNext = false

  on('prompt.submit', async ($, e, next) => {
    if (e.origin.kind === 'composer' && skipNext) {
      skipNext = false
      return next(e)
    }

    const text = e.text.trim()
    const words = text.split(/\s+/).length
    // A plugin's resubmission loses attachments, extra context and @file expansion, so those prompts go straight through.
    const canResubmit = !e.attachments?.length && !e.context?.length && !/(^|\s)@\S/.test(text)
    if (e.origin.kind !== 'composer' || text.startsWith('/') || words < MIN_WORDS || !canResubmit) return next(e)

    const mascot = Math.floor(Math.random() * (await $.clawd.count()))
    // A hook may not wait on a click (its budget is 10s), so the prompt is held here and resubmitted from the band.
    await update($, pending, () => ({ text: e.text, mascot, isImproving: false }))
    timer?.cancel()
    let isBoxChecked = false
    timer = $.clock.every(TICK_MS, async () => {
      if (!(await read($, pending))) {
        timer?.cancel()
        timer = null
        return
      }
      // The dropped prompt comes back into the box, and the band's 1/2 hotkeys only answer from an empty box.
      if (!isBoxChecked) {
        isBoxChecked = true
        if ((await $.prompt.read()).text.trim() === text) await $.prompt.fill({ text: '' })
      }
      await update($, tick, n => n + 1)
    })

    return { drop: 'Held for the prompt enhancer: choose above the prompt box.' }
  }).catch(($, e, next) => next(e))

  on('ui.render', { component: 'AbovePrompt' }, async ($, e, next) => {
    const held = await read($, pending)
    if (!held) return next(e)

    const { Box, Button, Text } = $.ui.resolve(e)
    const lines = await $.clawd.frame({ mascot: held.mascot, tick: await read($, tick) })
    const showMascot = lines.length <= e.props.maxRows

    const send = async (improve: boolean) => {
      if (improve) {
        await update($, pending, p => (p ? { ...p, isImproving: true } : p))
        const result = await $.model
          .complete({ model: MODEL, system: SYSTEM, prompt: held.text, maxTokens: 4096, effort: 'low' })
          .catch(() => ({ isAnswered: false as const, reason: 'request refused' }))
        if (result.isAnswered && result.text.trim()) {
          const improved = result.text.trim()
          $.ui.log(`Improved prompt:\n${improved}`)
          await update($, pending, () => null)
          // The person reviews it in the box; their own Enter sends it, unasked.
          skipNext = true
          const filled = await $.prompt.fill({ text: improved, mode: 'replace' })
          if (!filled.isFilled) {
            skipNext = false
            $.ui.toast('Could not put the improved prompt in the prompt box; it is in the transcript above.')
          }
          return
        }
        $.ui.toast(`Could not improve the prompt (${result.isAnswered ? 'empty reply' : result.reason}); sent it as typed.`)
      }
      await update($, pending, () => null)
      // The held prompt's text comes back into the box after the drop, so it is cleared once sent.
      await $.prompt.submit({ text: held.text, asUser: true })
      await $.prompt.fill({ text: '' })
    }

    return (
      <Box flexDirection="row" columnGap={2} alignItems="flex-end">
        {showMascot && <Box flexDirection="column">{rows(Text, lines)}</Box>}
        <Box flexDirection="column" flexGrow={1}>
          <Box borderStyle="round" borderColor={ACCENT} paddingX={1} flexDirection="column">
            <Text bold>
              {held.isImproving ? 'Polishing your prompt…' : 'Psst! Want me to polish this prompt before it goes out?'}
            </Text>
            <Text dimColor>“{preview(held.text)}”</Text>
          </Box>
          {held.isImproving ? (
            <Text dimColor> Hang tight, this takes a few seconds.</Text>
          ) : (
            <Box flexDirection="row" columnGap={1}>
              <Button key="yes" hotkey="1" variant="primary" label="Yes, polish it" onPress={() => void send(true)} />
              <Button key="no" hotkey="2" label="No, send as is" onPress={() => void send(false)} />
              <Text dimColor>press 1 or 2</Text>
            </Box>
          )}
        </Box>
      </Box>
    )
  })
}

function preview(text: string) {
  const flat = text.replace(/\s+/g, ' ').trim()
  return flat.length > PREVIEW_CHARS ? `${flat.slice(0, PREVIEW_CHARS - 1)}…` : flat
}

function rows(Text: (props: any) => any, lines: Rows) {
  return lines.map((runs, y) => (
    <Text key={`row-${y}`}>
      {runs.map((r, i) => (
        <Text key={`run-${i}`} color={r.fg} backgroundColor={r.bg}>
          {r.text}
        </Text>
      ))}
    </Text>
  ))
}
