// Pixel crab reviewing a long data log, for the terminal: it holds the scroll in one claw while the
// rows run up the paper, its eyes scan each line, and the other claw taps.
// Half-block characters (▀ ▄) + 24-bit color: two pixels per text cell, like the other crabs.

import type { Run } from './mascots'

type State = ReturnType<typeof stateAt>
type Rect = [number, number, number, number, keyof typeof COLORS]
type Layer = {
  rects: Rect[]
  when?: (s: State) => boolean
  dx?: (s: State) => number
  dy?: (s: State) => number
  pivot?: [number, number]
  angle?: (s: State) => number
}

const COLORS = {
  red: '#E04A3F',
  dark: '#B32F2A',
  light: '#FF7A66',
  ink: '#3A3550',
  white: '#FFFFFF',
  paper: '#C4BEE9',
  shade: '#A29ED6',
  text: '#8985CE',
};

// Artwork in the same coordinate space as the other crabs: [x, y, width, height, color], drawn in order
const LAYERS: Layer[] = [
  { rects: [[150, 300, 20, 10, 'dark'], [140, 310, 10, 25, 'dark'], [160, 320, 20, 10, 'dark'], [150, 330, 10, 25, 'dark'], [175, 335, 20, 10, 'dark'], [170, 345, 10, 25, 'dark']] },
  { dy: (s) => s.tapLeg, rects: [[310, 300, 20, 10, 'dark'], [330, 310, 10, 25, 'dark'], [300, 320, 20, 10, 'dark'], [320, 330, 10, 25, 'dark'], [285, 335, 20, 10, 'dark'], [300, 345, 10, 25, 'dark']] },
  // Holds the scroll's edge
  { rects: [[160, 230, 15, 40, 'red'], [145, 210, 20, 20, 'red'], [120, 170, 50, 40, 'red'], [150, 150, 20, 20, 'red'], [120, 170, 20, 10, 'light'], [160, 150, 10, 10, 'dark']] },
  { pivot: [310, 270], angle: (s) => s.tap, rects: [[305, 230, 15, 40, 'red'], [315, 210, 20, 20, 'red'], [310, 170, 50, 40, 'red'], [310, 150, 20, 20, 'red'], [340, 170, 20, 10, 'light'], [310, 150, 10, 10, 'dark']] },
  { rects: [[210, 220, 10, 30, 'dark'], [260, 220, 10, 30, 'dark'], [170, 250, 140, 100, 'red'], [185, 260, 30, 10, 'light'], [180, 270, 20, 10, 'light'], [190, 320, 10, 10, 'dark'], [280, 315, 10, 10, 'dark'], [170, 340, 140, 10, 'dark'], [225, 290, 30, 10, 'ink']] },
  { when: (s) => !s.blink, rects: [[195, 195, 40, 30, 'white'], [245, 195, 40, 30, 'white']] },
  { when: (s) => !s.blink, dx: (s) => s.lookX, rects: [[195, 205, 10, 20, 'ink'], [245, 205, 10, 20, 'ink']] },
  { when: (s) => s.blink, rects: [[195, 210, 40, 10, 'ink'], [245, 210, 40, 10, 'ink']] },
];

// The scroll sits behind the crab. Each paper row is shifted sideways so the long sheet curls like the original.
const PAPER_TOP = 110, PAPER_W = 80;
const PAPER_SHIFT = [10, 10, 0, 0, -10, -10, -10, -10, -10, 0, 0, 0, 0, 10, 10, 10, 10, 10, 0, 0, 0, -10, -10, -10, -10, -10];
// Lengths of the data rows, repeating; 4 rows take 16 frames to scroll by, so the loop is seamless.
const LINES = [50, 30, 60, 40];

const PX = 10, X0 = 30, X1 = 370, Y0 = 100, Y1 = 380;
const FRAME_COUNT = 16;
export const FRAME_MS = 100;

function stateAt(i: number) {
  return {
    scroll: Math.floor(i / 2),
    lookX: i % 4 < 2 ? 0 : 10,
    blink: i === 13,
    tap: i % 8 < 4 ? 0 : -8,
    tapLeg: i % 8 === 6 || i % 8 === 7 ? -10 : 0,
  };
}

function rotateBack(x: number, y: number, [cx, cy]: [number, number], deg: number): [number, number] {
  const a = (-deg * Math.PI) / 180, dx = x - cx, dy = y - cy;
  return [cx + dx * Math.cos(a) - dy * Math.sin(a), cy + dx * Math.sin(a) + dy * Math.cos(a)];
}

function paperAt(x: number, y: number, s: State) {
  const row = Math.floor((y - PAPER_TOP) / PX);
  if (row < 0 || row >= PAPER_SHIFT.length) return null;
  const left = 50 + PAPER_SHIFT[row]!;
  if (x < left || x >= left + PAPER_W) return null;
  // Rolled ends and the right edge are in shade
  if (row === 0 || row === PAPER_SHIFT.length - 1 || x >= left + PAPER_W - PX) return COLORS.shade;
  const k = row + s.scroll;
  if (row >= 2 && row < PAPER_SHIFT.length - 2 && k % 2 === 1) {
    const len = LINES[Math.floor(k / 2) % LINES.length]!;
    if (x >= left + PX && x < left + PX + len) return COLORS.text;
  }
  return COLORS.paper;
}

function colorAt(px: number, py: number, s: State) {
  for (let i = LAYERS.length - 1; i >= 0; i--) {
    const L = LAYERS[i]!;
    if (L.when && !L.when(s)) continue;
    let x = px, y = py;
    if (L.dx) x -= L.dx(s);
    if (L.dy) y -= L.dy(s);
    if (L.angle) [x, y] = rotateBack(x, y, L.pivot!, L.angle(s));
    for (let j = L.rects.length - 1; j >= 0; j--) {
      const [rx, ry, rw, rh, c] = L.rects[j]!;
      if (x >= rx && x < rx + rw && y >= ry && y < ry + rh) return COLORS[c];
    }
  }
  return paperAt(px, py, s);
}

export function renderFrame(index: number) {
  const s = stateAt(index);
  const lines: Run[][] = [];
  for (let y = Y0; y < Y1; y += PX * 2) {
    const line: Run[] = [];
    for (let x = X0; x < X1; x += PX) {
      const top = colorAt(x + PX / 2, y + PX / 2, s);
      const bottom = colorAt(x + PX / 2, y + PX * 1.5, s);
      if (top && bottom) line.push({ text: '▀', fg: top, bg: bottom });
      else if (top) line.push({ text: '▀', fg: top });
      else if (bottom) line.push({ text: '▄', fg: bottom });
      else line.push({ text: ' ' });
    }
    lines.push(line);
  }
  return lines;
}

export const frames = Array.from({ length: FRAME_COUNT }, (_, i) => renderFrame(i));
