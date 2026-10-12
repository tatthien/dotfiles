import { atom, read, update } from 'claude-code'
import type { Register } from 'claude-code'

import { MASCOTS, draw, type Run } from './mascots'

const state = atom({ plugin: 'clawd-spinner', key: 'state' } as const, { tick: 0, mascot: 0 })
const galleryTick = atom({ plugin: 'clawd-spinner', key: 'galleryTick' } as const, 0)

const TICK_MS = 250
const GALLERY = 'clawd-gallery'

export const register: Register = on => {
  let timer: { cancel: () => void } | null = null
  let galleryTimer: { cancel: () => void } | null = null

  const stop = () => {
    timer?.cancel()
    timer = null
  }

  on('session.start', async ($, e, next) => {
    await $.command.register({ name: 'mascots', description: 'Show every spinner mascot, animated, in a pane' })

    return next(e)
  })

  on('command.run', { command: 'mascots' }, async $ => {
    await $.ui.open({ id: GALLERY, title: 'Mascots' })
    galleryTimer?.cancel()
    galleryTimer = $.clock.every(TICK_MS, async () => {
      if (!(await $.ui.panes()).some(p => p.id === GALLERY)) {
        galleryTimer?.cancel()
        galleryTimer = null
        return
      }
      await update($, galleryTick, n => n + 1)
    })

    return { text: `Showing ${MASCOTS.length} mascots.` }
  })

  on('turn.start', ($, e, next) => {
    stop()
    const mascot = Math.floor(Math.random() * MASCOTS.length)
    update($, state, () => ({ tick: 0, mascot }))
    timer = $.clock.every(TICK_MS, () => update($, state, s => ({ ...s, tick: s.tick + 1 })))

    return next(e)
  })

  on('turn.complete', ($, e, next) => {
    stop()

    return next(e)
  })

  on('ui.render', { component: 'Spinner' }, async ($, e) => {
    const { Box, Text } = $.ui.resolve(e)
    const s = await read($, state)
    const lines = draw(MASCOTS[s.mascot % MASCOTS.length]!, s.tick)

    return (
      <Box flexDirection="row" alignItems="flex-end">
        <Box flexDirection="column">{rows(Text, lines)}</Box>
        <Text dimColor>{` ${e.props.message ?? 'thinking'}`}</Text>
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
            {rows(Text, draw(m, tick))}
            <Text dimColor>{m.name}</Text>
          </Box>
        ))}
      </Box>
    )
  })
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
