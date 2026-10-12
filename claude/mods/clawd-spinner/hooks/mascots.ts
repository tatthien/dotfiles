import { SPRITES, type Sprite } from './sprites'

export type Run = { text: string; fg?: string; bg?: string }

type Grid = (string | undefined)[][]
type Mascot = { name: string; frames: Grid[] }

const BODY = '#d97757'
const EYE = '#2f2f38'
const WHITE = '#ffffff'
const ALPHABET = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'

function decode(s: Sprite): Grid {
  return s.rows.map(r => [...r].map(c => (c === '.' ? undefined : s.palette[ALPHABET.indexOf(c)])))
}

// One empty row on top gives floating props room to rise.
const padTop = (g: Grid): Grid => [Array<string | undefined>(g[0]!.length).fill(undefined), ...g]

// The body's rows are the ones mostly made of body color; legs hang below them.
function bodyBox(g: Grid) {
  const counts = g.map(r => r.filter(c => c === BODY).length)
  const max = Math.max(...counts)
  const rows = counts.flatMap((n, y) => (n >= max / 2 ? [y] : []))
  const top = rows[0]!
  const bottom = rows[rows.length - 1]!
  const xs = g.slice(top, bottom + 1).flatMap(r => r.flatMap((c, x) => (c === BODY ? [x] : [])))
  return { top, bottom, left: Math.min(...xs), right: Math.max(...xs) }
}

const clone = (g: Grid): Grid => g.map(r => [...r])

// Connected non-body pixels that reach outside the body are props; each bobs up a pixel as one piece.
function props(g: Grid, box: ReturnType<typeof bodyBox>) {
  const seen = new Set<string>()
  const found: [number, number][][] = []

  for (let y = 0; y < g.length; y++) {
    for (let x = 0; x < g[y]!.length; x++) {
      const c = g[y]![x]
      if (c === undefined || c === BODY || seen.has(`${x},${y}`)) continue

      const piece: [number, number][] = []
      const stack: [number, number][] = [[x, y]]
      seen.add(`${x},${y}`)
      while (stack.length) {
        const [px, py] = stack.pop()!
        piece.push([px, py])
        for (let dy = -1; dy <= 1; dy++) {
          for (let dx = -1; dx <= 1; dx++) {
            const n = g[py + dy]?.[px + dx]
            const key = `${px + dx},${py + dy}`
            if (n === undefined || n === BODY || seen.has(key)) continue
            seen.add(key)
            stack.push([px + dx, py + dy])
          }
        }
      }
      if (piece.some(([px, py]) => py < box.top || px < box.left || px > box.right)) found.push(piece)
    }
  }
  return found
}

// Props bob up a pixel and the feet step sideways.
function step(g: Grid): Grid {
  const box = bodyBox(g)
  const out = clone(g)
  const inside = (x: number, y: number) => y >= box.top && y <= box.bottom && x >= box.left && x <= box.right
  const pieces = props(g, box)

  for (const piece of pieces) for (const [x, y] of piece) out[y]![x] = inside(x, y) ? BODY : undefined
  for (const piece of pieces) for (const [x, y] of piece) if (y > 0) out[y - 1]![x] = g[y]![x]
  for (let y = box.bottom + 1; y < g.length; y++) {
    const row = g[y]!
    out[y] = row.map(c => (c === BODY ? undefined : c))
    row.forEach((c, x) => {
      if (c === BODY && x + 1 < row.length) out[y]![x + 1] = BODY
    })
  }
  return out
}

function blink(g: Grid): Grid {
  const box = bodyBox(g)
  return g.map((r, y) => r.map(c => (c === EYE && y >= box.top && y <= box.bottom ? BODY : c)))
}

export const MASCOTS: Mascot[] = SPRITES.map(s => {
  const base = padTop(decode(s))
  const moved = step(base)
  return { name: s.name, frames: [base, moved, base, moved, base, moved, blink(base), moved] }
})

// Sextant glyph for a 2x3 mask (bit 0 top-left, row by row); the two full columns live in Block Elements.
function sextant(mask: number) {
  if (mask === 0) return ' '
  if (mask === 63) return '█'
  if (mask === 21) return '▌'
  if (mask === 42) return '▐'
  return String.fromCodePoint(0x1fb00 + mask - 1 - (mask > 21 ? 1 : 0) - (mask > 42 ? 1 : 0))
}

// A cell shows two colors at most, so the face's eyes and mouth outrank larger patches of body.
function weight(c: string | undefined, count: number) {
  return count + (c === EYE || c === WHITE ? 4 : 0)
}

// Each terminal cell holds 2x3 pixels, which keeps every pixel of the art at about the old footprint.
export function draw(m: Mascot, tick: number): Run[][] {
  const g = m.frames[tick % m.frames.length]!
  const lines: Run[][] = []

  for (let y = 0; y < g.length; y += 3) {
    const line: Run[] = []

    for (let x = 0; x < g[0]!.length; x += 2) {
      const px = [0, 1, 2].flatMap(dy => [g[y + dy]?.[x], g[y + dy]?.[x + 1]])
      const counts = new Map<string | undefined, number>()
      for (const c of px) counts.set(c, (counts.get(c) ?? 0) + 1)
      const [bg, fg] = [...counts].sort((a, b) => weight(b[0], b[1]) - weight(a[0], a[1])).map(([c]) => c)

      let run: Run
      if (fg === undefined && bg === undefined) run = { text: ' ' }
      else if (counts.size === 1) run = { text: '█', fg: bg }
      else {
        // Pixels of a third color go to whichever of the two is not empty space.
        const ink = bg === undefined ? fg : fg === undefined ? bg : fg
        const paper = ink === fg ? bg : fg
        const mask = px.reduce((acc, c, i) => (c === paper ? acc : acc | (1 << i)), 0)
        run = { text: sextant(mask), fg: ink, bg: paper }
      }

      const last = line[line.length - 1]
      if (last && last.fg === run.fg && last.bg === run.bg) last.text += run.text
      else line.push(run)
    }

    lines.push(line)
  }

  return lines
}
