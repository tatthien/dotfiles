// Pixel crab calmly sipping coffee while everything around it is on fire.
// Half-block characters (▀ ▄) + 24-bit ANSI color: two pixels per text cell.
//
// Ported from crab-fine.mjs: the CLI and the ANSI escapes are gone (a mod cannot run Node or print);
// renderFrame returns the same ▀/▄ cells as colored runs instead.

import type { Run } from './mascots'

type State = ReturnType<typeof stateAt>
type Rect = [number, number, number, number, keyof typeof COLORS]
type Layer = {
  rects: Rect[]
  when?: (s: State) => boolean
  dy?: (s: State) => number
  pivot?: [number, number]
  angle?: (s: State) => number
}

const COLORS = {
  red: '#E04A3F', dark: '#B32F2A', light: '#FF7A66', ink: '#2E2A3F', white: '#FFFFFF',
  mug: '#F2E6C4', coffee: '#6B3E26', steam: '#C9C5D3', smoke: '#B4B0C0',
  yellow: '#FDC232', orange: '#FF8A2A', ember: '#E5502A',
};

const flamesA: Rect[] = [
  [60, 330, 60, 40, 'yellow'], [70, 300, 40, 30, 'yellow'], [80, 280, 20, 20, 'yellow'], [90, 260, 10, 20, 'yellow'],
  [360, 330, 60, 40, 'yellow'], [370, 300, 40, 30, 'yellow'], [380, 280, 20, 20, 'yellow'], [380, 260, 10, 20, 'yellow'],
  [135, 350, 15, 20, 'yellow'], [325, 345, 15, 25, 'yellow'],
  [70, 340, 40, 30, 'orange'], [80, 315, 20, 25, 'orange'], [370, 340, 40, 30, 'orange'], [380, 315, 20, 25, 'orange'],
  [80, 355, 20, 15, 'ember'], [380, 355, 20, 15, 'ember'],
];
const flamesB: Rect[] = [
  [60, 320, 60, 50, 'yellow'], [65, 295, 35, 25, 'yellow'], [75, 270, 15, 25, 'yellow'], [100, 285, 15, 20, 'yellow'],
  [360, 320, 60, 50, 'yellow'], [380, 295, 35, 25, 'yellow'], [390, 270, 15, 25, 'yellow'], [365, 285, 15, 20, 'yellow'],
  [130, 345, 15, 25, 'yellow'], [330, 352, 15, 18, 'yellow'],
  [70, 335, 40, 35, 'orange'], [75, 310, 20, 25, 'orange'], [370, 335, 40, 35, 'orange'], [385, 310, 20, 25, 'orange'],
  [85, 350, 20, 20, 'ember'], [375, 350, 20, 20, 'ember'],
];

// Artwork in the SVG's coordinate space: [x, y, width, height, color], drawn in order
const LAYERS: Layer[] = [
  { when: (s) => s.flameA, rects: [[180, 225, 15, 25, 'yellow'], [285, 230, 15, 20, 'yellow']] },
  { when: (s) => !s.flameA, rects: [[175, 230, 15, 20, 'yellow'], [290, 220, 15, 30, 'yellow']] },
  { when: (s) => s.smoke, dy: (s) => s.smokeY, rects: [
    [80, 240, 10, 10, 'smoke'], [95, 225, 10, 10, 'smoke'], [380, 235, 10, 10, 'smoke'], [390, 220, 10, 10, 'smoke'],
  ] },
  { rects: [
    [150, 300, 20, 10, 'dark'], [140, 310, 10, 60, 'dark'], [160, 320, 20, 10, 'dark'], [155, 330, 10, 40, 'dark'],
    [175, 335, 20, 10, 'dark'], [170, 345, 10, 25, 'dark'], [310, 300, 20, 10, 'dark'], [330, 310, 10, 60, 'dark'],
    [300, 320, 20, 10, 'dark'], [315, 330, 10, 40, 'dark'], [285, 335, 20, 10, 'dark'], [300, 345, 10, 25, 'dark'],
  ] },
  { pivot: [160, 270], angle: (s) => s.sip, rects: [
    [160, 230, 15, 40, 'red'], [145, 210, 20, 20, 'red'],
    [125, 135, 30, 40, 'mug'], [115, 145, 10, 20, 'mug'], [125, 135, 30, 8, 'coffee'],
    [120, 170, 50, 40, 'red'], [150, 150, 20, 20, 'red'], [120, 170, 20, 10, 'light'], [160, 150, 10, 10, 'dark'],
  ] },
  { pivot: [160, 270], angle: (s) => s.sip, dy: (s) => s.steamY, rects: [
    [130, 115, 10, 10, 'steam'], [140, 105, 10, 10, 'steam'],
  ] },
  { pivot: [310, 270], angle: (s) => s.wave, rects: [
    [305, 230, 15, 40, 'red'], [315, 210, 20, 20, 'red'], [310, 170, 50, 40, 'red'], [310, 150, 20, 20, 'red'],
    [340, 170, 20, 10, 'light'], [310, 150, 10, 10, 'dark'],
  ] },
  { rects: [
    [210, 220, 10, 30, 'dark'], [260, 220, 10, 30, 'dark'],
    [200, 200, 30, 25, 'white'], [250, 200, 30, 25, 'white'],
    [210, 210, 10, 15, 'ink'], [260, 210, 10, 15, 'ink'],
    [200, 200, 30, 10, 'red'], [250, 200, 30, 10, 'red'],
    [170, 250, 140, 100, 'red'], [200, 260, 40, 10, 'light'], [180, 270, 20, 10, 'light'],
    [190, 320, 10, 10, 'dark'], [280, 315, 10, 10, 'dark'], [170, 340, 140, 10, 'dark'],
    [220, 290, 10, 10, 'ink'], [230, 300, 20, 10, 'ink'], [250, 290, 10, 10, 'ink'],
  ] },
  { when: (s) => s.flameA, rects: flamesA },
  { when: (s) => !s.flameA, rects: flamesB },
  { rects: [
    [350, 50, 100, 10, 'ink'], [350, 100, 100, 10, 'ink'], [340, 60, 10, 40, 'ink'], [450, 60, 10, 40, 'ink'],
    [350, 110, 10, 10, 'ink'], [340, 120, 10, 10, 'ink'], [350, 60, 100, 40, 'white'],
  ] },
  { when: (s) => s.dots >= 1, rects: [[370, 75, 10, 10, 'ink']] },
  { when: (s) => s.dots >= 2, rects: [[395, 75, 10, 10, 'ink']] },
  { when: (s) => s.dots >= 3, rects: [[420, 75, 10, 10, 'ink']] },
];

const PX = 10, X0 = 50, X1 = 470, Y0 = 40, Y1 = 380;
const FRAME_COUNT = 16;
export const FRAME_MS = 100; // 16 x 100ms = 1.6s, same as the SVG

function kf(t: number, keys: [number, number][]) {
  for (let i = 1; i < keys.length; i++) {
    const [t0, v0] = keys[i - 1]!, [t1, v1] = keys[i]!;
    if (t <= t1) return v0 + (v1 - v0) * ((t - t0) / (t1 - t0 || 1));
  }
  return keys[keys.length - 1]![1];
}

function stateAt(i: number) {
  const t = i / FRAME_COUNT;
  return {
    flameA: i % 4 < 2,
    sip: kf(t, [[0, 0], [0.25, 0], [0.4, 14], [0.6, 14], [0.75, 0], [1, 0]]),
    wave: i % 16 < 8 ? 0 : -6,
    steamY: i % 8 < 4 ? 0 : -10,
    smoke: t < 0.9,
    smokeY: -Math.round((t * 50) / PX) * PX,
    dots: t >= 0.65 ? 3 : t >= 0.4 ? 2 : t >= 0.15 ? 1 : 0,
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
    if (L.angle) [x, y] = rotateBack(x, y, L.pivot!, L.angle(s));
    if (L.dy) y -= L.dy(s);
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
