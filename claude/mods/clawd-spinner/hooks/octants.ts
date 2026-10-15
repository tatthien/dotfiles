// Redraws half-block frames (1x2 pixels per cell) with octants (2x4 per cell), so a mascot keeps
// every pixel at half the width and half the height.

import type { Run } from './mascots'

type Px = string | null

// Indexed by the cell's pixel mask, bits row by row, left then right (Unicode's octant numbering).
// From UnicodeData 16.0, where 26 patterns reuse older block characters.
const GLYPHS = [...' 𜺨𜺫🮂𜴀▘𜴁𜴂𜴃𜴄▝𜴅𜴆𜴇𜴈▀𜴉𜴊𜴋𜴌🯦𜴍𜴎𜴏𜴐𜴑𜴒𜴓𜴔𜴕𜴖𜴗𜴘𜴙𜴚𜴛𜴜𜴝𜴞𜴟🯧𜴠𜴡𜴢𜴣𜴤𜴥𜴦𜴧𜴨𜴩𜴪𜴫𜴬𜴭𜴮𜴯𜴰𜴱𜴲𜴳𜴴𜴵🮅𜺣𜴶𜴷𜴸𜴹𜴺𜴻𜴼𜴽𜴾𜴿𜵀𜵁𜵂𜵃𜵄▖𜵅𜵆𜵇𜵈▌𜵉𜵊𜵋𜵌▞𜵍𜵎𜵏𜵐▛𜵑𜵒𜵓𜵔𜵕𜵖𜵗𜵘𜵙𜵚𜵛𜵜𜵝𜵞𜵟𜵠𜵡𜵢𜵣𜵤𜵥𜵦𜵧𜵨𜵩𜵪𜵫𜵬𜵭𜵮𜵯𜵰𜺠𜵱𜵲𜵳𜵴𜵵𜵶𜵷𜵸𜵹𜵺𜵻𜵼𜵽𜵾𜵿𜶀𜶁𜶂𜶃𜶄𜶅𜶆𜶇𜶈𜶉𜶊𜶋𜶌𜶍𜶎𜶏▗𜶐𜶑𜶒𜶓▚𜶔𜶕𜶖𜶗▐𜶘𜶙𜶚𜶛▜𜶜𜶝𜶞𜶟𜶠𜶡𜶢𜶣𜶤𜶥𜶦𜶧𜶨𜶩𜶪𜶫▂𜶬𜶭𜶮𜶯𜶰𜶱𜶲𜶳𜶴𜶵𜶶𜶷𜶸𜶹𜶺𜶻𜶼𜶽𜶾𜶿𜷀𜷁𜷂𜷃𜷄𜷅𜷆𜷇𜷈𜷉𜷊𜷋𜷌𜷍𜷎𜷏𜷐𜷑𜷒𜷓𜷔𜷕𜷖𜷗𜷘𜷙𜷚▄𜷛𜷜𜷝𜷞▙𜷟𜷠𜷡𜷢▟𜷣▆𜷤𜷥█']
// Catppuccin Macchiato base: the color an empty pixel is compared as.
const BACKGROUND = '#24273a'

export function toOctants(frames: Run[][][]): Run[][][] {
  const grids = frames.map(decode)
  const freq = new Map<string, number>()
  for (const g of grids) for (const row of g) for (const c of row) if (c) freq.set(c, (freq.get(c) ?? 0) + 1)
  const most = Math.max(...freq.values())
  // A cell holds two colors; rarer ones (eyes, mouths, highlights) outrank the shell when three meet.
  const weight = (c: Px) => (c === null ? 1 : Math.sqrt(most / (freq.get(c) ?? most)))

  return grids.map(grid => {
    const width = Math.max(...grid.map(r => r.length))
    const lines: Run[][] = []
    for (let y = 0; y < grid.length; y += 4) {
      const line: Run[] = []
      for (let x = 0; x < width; x += 2) {
        const px: Px[] = []
        for (let dy = 0; dy < 4; dy++) for (let dx = 0; dx < 2; dx++) px.push(grid[y + dy]?.[x + dx] ?? null)
        const counts = new Map<Px, number>()
        for (const c of px) counts.set(c, (counts.get(c) ?? 0) + 1)
        const [a = null, b = null] = [...counts].sort((p, q) => q[1] * weight(q[0]) - p[1] * weight(p[0])).map(([c]) => c)
        const ink = a ?? b, paper = a === null ? null : b
        if (ink === null) {
          line.push({ text: ' ' })
          continue
        }
        let mask = 0
        px.forEach((c, i) => {
          const pick = c === a || c === b ? c : distance(c, a) <= distance(c, b) ? a : b
          if (pick === ink) mask |= 1 << i
        })
        line.push(paper ? { text: GLYPHS[mask]!, fg: ink, bg: paper } : { text: GLYPHS[mask]!, fg: ink })
      }
      lines.push(line)
    }
    return lines
  })
}

function decode(frame: Run[][]): Px[][] {
  const grid: Px[][] = []
  for (const line of frame) {
    const top: Px[] = [], bottom: Px[] = []
    for (const r of line) {
      for (const ch of [...r.text]) {
        if (ch === '▀') { top.push(r.fg ?? null); bottom.push(r.bg ?? null) }
        else if (ch === '▄') { top.push(r.bg ?? null); bottom.push(r.fg ?? null) }
        else if (ch === '█') { top.push(r.fg ?? null); bottom.push(r.fg ?? null) }
        else { top.push(r.bg ?? null); bottom.push(r.bg ?? null) }
      }
    }
    grid.push(top, bottom)
  }
  return grid
}

function distance(a: Px, b: Px) {
  const [r1, g1, b1] = rgb(a ?? BACKGROUND), [r2, g2, b2] = rgb(b ?? BACKGROUND)
  return (r1 - r2) ** 2 + (g1 - g2) ** 2 + (b1 - b2) ** 2
}

function rgb(hex: string) {
  const n = parseInt(hex.slice(1), 16)
  return [(n >> 16) & 255, (n >> 8) & 255, n & 255] as const
}
