// Pixel crab celebrating with a checkered flag, for the terminal.
// Half-block characters (▀ ▄) + 24-bit ANSI color: two pixels per text cell.
//
// Ported from crab-flag.mjs: the CLI and the ANSI escapes are gone (a mod cannot run Node or print);
// renderFrame returns the same ▀/▄ cells as colored runs instead.

import type { Run } from './mascots'

type State = ReturnType<typeof stateAt>
type Rect = [number, number, number, number, keyof typeof COLORS]
type Layer = {
  rects: Rect[]
  conf?: number
  when?: (s: State) => boolean
  dy?: (s: State) => number
  pivot?: [number, number]
  angle?: (s: State) => number
}

const COLORS = {
  red: '#E04A3F',
  dark: '#B32F2A',
  light: '#FF7A66',
  ink: '#2E2A3F',
  white: '#FFFFFF',
  pink: '#F59AB5',
  pole: '#8F8AA0',
  yellow: '#FDC232',
  purple: '#9467F5',
  cyan: '#3AD0E0',
  rose: '#FF7AB0',
};
// The flag's dark squares use a slightly lighter ink so they still read on dark terminals
COLORS.ink = '#3A3550';

// Artwork in the SVG's coordinate space: [x, y, width, height, color], drawn in order
const LAYERS: Layer[] = [
  { conf: 0, rects: [[90, 60, 10, 10, 'yellow']] },
  { conf: 0.25, rects: [[140, 40, 10, 10, 'purple']] },
  { conf: 0.5, rects: [[230, 50, 10, 10, 'cyan']] },
  { conf: 0.75, rects: [[420, 40, 10, 10, 'rose']] },
  { conf: 0.6, rects: [[60, 120, 10, 10, 'cyan']] },
  { conf: 0.1, rects: [[440, 140, 10, 10, 'yellow']] },
  { conf: 0.35, rects: [[270, 30, 10, 10, 'rose']] },
  { conf: 0.85, rects: [[180, 90, 10, 10, 'yellow']] },
  { dy: (s) => s.hop + s.legL, rects: [[150, 300, 20, 10, 'dark'], [140, 310, 10, 25, 'dark'], [160, 320, 20, 10, 'dark'], [150, 330, 10, 25, 'dark'], [175, 335, 20, 10, 'dark'], [170, 345, 10, 25, 'dark']] },
  { dy: (s) => s.hop + s.legR, rects: [[310, 300, 20, 10, 'dark'], [330, 310, 10, 25, 'dark'], [300, 320, 20, 10, 'dark'], [320, 330, 10, 25, 'dark'], [285, 335, 20, 10, 'dark'], [300, 345, 10, 25, 'dark']] },
  { dy: (s) => s.hop, pivot: [160, 270], angle: (s) => s.pump, rects: [[160, 230, 15, 40, 'red'], [145, 210, 20, 20, 'red'], [120, 170, 50, 40, 'red'], [150, 150, 20, 20, 'red'], [120, 170, 20, 10, 'light'], [160, 150, 10, 10, 'dark']] },
  { dy: (s) => s.hop, pivot: [310, 270], angle: (s) => s.wave, when: (s) => s.flagA, rects: [[345, 70, 10, 10, 'white'], [345, 80, 10, 10, 'ink'], [345, 90, 10, 10, 'white'], [345, 100, 10, 10, 'ink'], [345, 110, 10, 10, 'white'], [355, 70, 10, 10, 'ink'], [355, 80, 10, 10, 'white'], [355, 90, 10, 10, 'ink'], [355, 100, 10, 10, 'white'], [355, 110, 10, 10, 'ink'], [365, 80, 10, 10, 'white'], [365, 90, 10, 10, 'ink'], [365, 100, 10, 10, 'white'], [365, 110, 10, 10, 'ink'], [365, 120, 10, 10, 'white'], [375, 80, 10, 10, 'ink'], [375, 90, 10, 10, 'white'], [375, 100, 10, 10, 'ink'], [375, 110, 10, 10, 'white'], [375, 120, 10, 10, 'ink'], [385, 70, 10, 10, 'white'], [385, 80, 10, 10, 'ink'], [385, 90, 10, 10, 'white'], [385, 100, 10, 10, 'ink'], [385, 110, 10, 10, 'white'], [395, 70, 10, 10, 'ink'], [395, 80, 10, 10, 'white'], [395, 90, 10, 10, 'ink'], [395, 100, 10, 10, 'white'], [395, 110, 10, 10, 'ink'], [405, 80, 10, 10, 'white'], [405, 90, 10, 10, 'ink'], [405, 100, 10, 10, 'white'], [405, 110, 10, 10, 'ink'], [405, 120, 10, 10, 'white'], [415, 80, 10, 10, 'ink'], [415, 90, 10, 10, 'white'], [415, 100, 10, 10, 'ink'], [415, 110, 10, 10, 'white'], [415, 120, 10, 10, 'ink']] },
  { dy: (s) => s.hop, pivot: [310, 270], angle: (s) => s.wave, when: (s) => !s.flagA, rects: [[345, 70, 10, 10, 'white'], [345, 80, 10, 10, 'ink'], [345, 90, 10, 10, 'white'], [345, 100, 10, 10, 'ink'], [345, 110, 10, 10, 'white'], [355, 80, 10, 10, 'ink'], [355, 90, 10, 10, 'white'], [355, 100, 10, 10, 'ink'], [355, 110, 10, 10, 'white'], [355, 120, 10, 10, 'ink'], [365, 70, 10, 10, 'white'], [365, 80, 10, 10, 'ink'], [365, 90, 10, 10, 'white'], [365, 100, 10, 10, 'ink'], [365, 110, 10, 10, 'white'], [375, 70, 10, 10, 'ink'], [375, 80, 10, 10, 'white'], [375, 90, 10, 10, 'ink'], [375, 100, 10, 10, 'white'], [375, 110, 10, 10, 'ink'], [385, 80, 10, 10, 'white'], [385, 90, 10, 10, 'ink'], [385, 100, 10, 10, 'white'], [385, 110, 10, 10, 'ink'], [385, 120, 10, 10, 'white'], [395, 80, 10, 10, 'ink'], [395, 90, 10, 10, 'white'], [395, 100, 10, 10, 'ink'], [395, 110, 10, 10, 'white'], [395, 120, 10, 10, 'ink'], [405, 70, 10, 10, 'white'], [405, 80, 10, 10, 'ink'], [405, 90, 10, 10, 'white'], [405, 100, 10, 10, 'ink'], [405, 110, 10, 10, 'white'], [415, 70, 10, 10, 'ink'], [415, 80, 10, 10, 'white'], [415, 90, 10, 10, 'ink'], [415, 100, 10, 10, 'white'], [415, 110, 10, 10, 'ink']] },
  { dy: (s) => s.hop, pivot: [310, 270], angle: (s) => s.wave, rects: [[335, 70, 10, 110, 'pole'], [305, 230, 15, 40, 'red'], [315, 210, 20, 20, 'red'], [310, 170, 50, 40, 'red'], [310, 150, 20, 20, 'red'], [340, 170, 20, 10, 'light'], [310, 150, 10, 10, 'dark']] },
  { dy: (s) => s.hop, rects: [[210, 220, 10, 30, 'dark'], [260, 220, 10, 30, 'dark'], [195, 195, 40, 30, 'white'], [245, 195, 40, 30, 'white'], [200, 210, 10, 10, 'ink'], [210, 200, 10, 10, 'ink'], [220, 210, 10, 10, 'ink'], [250, 210, 10, 10, 'ink'], [260, 200, 10, 10, 'ink'], [270, 210, 10, 10, 'ink'], [170, 250, 140, 100, 'red'], [185, 260, 30, 10, 'light'], [180, 270, 20, 10, 'light'], [190, 320, 10, 10, 'dark'], [280, 315, 10, 10, 'dark'], [170, 340, 140, 10, 'dark'], [225, 282, 30, 16, 'ink'], [232, 290, 16, 8, 'pink']] },
];

const PX = 10, X0 = 40, X1 = 460, Y0 = 20, Y1 = 380;
const FRAME_COUNT = 16;
export const FRAME_MS = 100; // 16 x 100ms = 1.6s, same as the SVG

function stateAt(i: number) {
  const t = i / FRAME_COUNT;
  return {
    hop: i % 4 < 2 ? 0 : -10,
    legL: i % 2 === 0 ? 0 : -10,
    legR: i % 2 === 0 ? -10 : 0,
    wave: i % 8 < 4 ? 0 : -8,
    pump: i % 8 < 4 ? 12 : 0,
    flagA: i % 4 < 2,
    t,
  };
}

function rotateBack(x: number, y: number, [cx, cy]: [number, number], deg: number): [number, number] {
  const a = (-deg * Math.PI) / 180, dx = x - cx, dy = y - cy;
  return [cx + dx * Math.cos(a) - dy * Math.sin(a), cy + dx * Math.sin(a) + dy * Math.cos(a)];
}

function colorAt(px: number, py: number, s: State) {
  for (let i = LAYERS.length - 1; i >= 0; i--) {
    const L = LAYERS[i]!;
    if (L.when && !L.when(s)) continue;
    let x = px, y = py;
    if (L.conf !== undefined) {
      const local = (s.t + L.conf) % 1;
      if (local >= 0.85) continue;
      y -= Math.floor(local * 8) * 20;
    }
    if (L.dy) y -= L.dy(s);
    if (L.angle) [x, y] = rotateBack(x, y, L.pivot!, L.angle(s));
    for (let j = L.rects.length - 1; j >= 0; j--) {
      const [rx, ry, rw, rh, c] = L.rects[j]!;
      if (x >= rx && x < rx + rw && y >= ry && y < ry + rh) return COLORS[c];
    }
  }
  return null;
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
