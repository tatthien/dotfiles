import { atom, read, update } from 'claude-code'
import type { Register } from 'claude-code'

import { FRAME_MS, MASCOTS, draw, type Run } from './mascots'

const state = atom({ plugin: 'clawd-spinner', key: 'state' } as const, { tick: 0, mascot: 0 })
const galleryTick = atom({ plugin: 'clawd-spinner', key: 'galleryTick' } as const, 0)

// The turn timer ticks every TICK_MS; the mascot advances one frame per FRAME_MS.
const TICK_MS = 100
const GALLERY = 'clawd-gallery'

export const register: Register = on => {
  let timer: { cancel: () => void } | null = null
  let galleryTimer: { cancel: () => void } | null = null
  let reduceMotion = false

  const stop = () => {
    timer?.cancel()
    timer = null
  }

  on('session.start', async ($, e, next) => {
    await $.command.register({ name: 'mascots', description: 'Show every spinner mascot, animated, in a pane' })
    await pickNext($)
    // The terminal has no prefers-reduced-motion, so Claude Code's own setting stands in for it.
    reduceMotion = (await $.settings.read()).prefersReducedMotion === true

    return next(e)
  })

  on('command.run', { command: 'mascots' }, async $ => {
    await $.ui.open({ id: GALLERY, title: 'Mascots' })
    galleryTimer?.cancel()
    galleryTimer = $.clock.every(FRAME_MS, async () => {
      if (!(await $.ui.panes()).some(p => p.id === GALLERY)) {
        galleryTimer?.cancel()
        galleryTimer = null
        return
      }
      await update($, galleryTick, n => n + 1)
    })

    return { text: `Showing ${MASCOTS.length} ${MASCOTS.length === 1 ? 'mascot' : 'mascots'}.` }
  })

  on('turn.start', async ($, e, next) => {
    stop()
    timer = $.clock.every(TICK_MS, () => update($, state, s => ({ ...s, tick: s.tick + 1 })))

    return next(e)
  })

  on('turn.complete', async ($, e, next) => {
    stop()
    await pickNext($)

    return next(e)
  })

  on('ui.render', { component: 'Spinner' }, async ($, e, next) => {
    const { Box, Text } = $.ui.resolve(e)
    const s = await read($, state)
    const lines = draw(MASCOTS[s.mascot % MASCOTS.length]!, Math.floor((s.tick * TICK_MS) / FRAME_MS), reduceMotion)

    return (
      <Box flexDirection="column">
        <Box flexDirection="column">{rows(Text, lines)}</Box>
        {await next({ ...e, props: { ...e.props, word: 'Thinking' } })}
      </Box>
    )
  })

  on('ui.render', { component: 'Pane', requestId: GALLERY }, async ($, e) => {
    const { Box, Text } = $.ui.resolve(e)
    const tick = await read($, galleryTick)

    return (
      <Box flexDirection="row" flexWrap="wrap" columnGap={2}>
        {MASCOTS.map(m => (
          <Box key={m.name} flexDirection="column" marginBottom={1}>
            {rows(Text, draw(m, tick, reduceMotion))}
            <Text dimColor>{m.name}</Text>
          </Box>
        ))}
      </Box>
    )
  })
}

// The spinner can paint before turn.start's state write lands, so the next mascot is picked when the previous turn ends.
// Offsetting by 1..n-1 never lands on the current mascot, so the same one never shows twice in a row.
function pickNext($: Parameters<typeof read>[0]) {
  const n = MASCOTS.length
  return update($, state, s => ({
    tick: 0,
    mascot: n > 1 ? (s.mascot + 1 + Math.floor(Math.random() * (n - 1))) % n : 0,
  }))
}

function rows(Text: (props: any) => any, lines: Run[][]) {
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
