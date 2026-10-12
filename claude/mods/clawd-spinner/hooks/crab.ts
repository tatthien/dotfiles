// Pixel crab "disconnected" animation for the terminal.
// Renders with half-block characters (▀ ▄) and 24-bit ANSI color,
// so every text cell shows two vertical pixels.
//
// Ported from crab.mjs: the CLI and the ANSI escapes are gone (a mod cannot run Node or print);
// renderFrame returns the same ▀/▄ cells as colored runs instead.

import type { Run } from './mascots'

type Rect = [number, number, number, number, keyof typeof COLORS]
type Layer = {
  name: string
  rects: Rect[]
  body?: boolean
  legs?: 'L' | 'R'
  claw?: 'L' | 'R'
  eyes?: boolean
  mouth?: 'A' | 'B'
  spark?: boolean
}

const COLORS = {
  red: '#E04A3F', dark: '#B32F2A', light: '#FF7A66', ink: '#2E2A3F',
  white: '#FFFFFF', blue: '#3A86F0', blueHi: '#6FA8F7', purple: '#6E35F0',
  purpleHi: '#9467F5', yellow: '#FFD83D',
};

// Artwork in the SVG's coordinate space: [x, y, width, height, color]
const LAYERS: Layer[] = [
  { name: 'legsL', body: true, legs: 'L', rects: [
    [150, 300, 20, 10, 'dark'], [140, 310, 10, 25, 'dark'],
    [160, 320, 20, 10, 'dark'], [150, 330, 10, 25, 'dark'],
    [175, 335, 20, 10, 'dark'], [170, 345, 10, 25, 'dark'],
  ] },
  { name: 'legsR', body: true, legs: 'R', rects: [
    [310, 300, 20, 10, 'dark'], [330, 310, 10, 25, 'dark'],
    [300, 320, 20, 10, 'dark'], [320, 330, 10, 25, 'dark'],
    [285, 335, 20, 10, 'dark'], [300, 345, 10, 25, 'dark'],
  ] },
  { name: 'clawL', body: true, claw: 'L', rects: [
    [160, 230, 15, 40, 'red'], [145, 210, 20, 20, 'red'],
    [120, 170, 50, 40, 'red'], [150, 150, 20, 20, 'red'],
    [120, 170, 20, 10, 'light'], [160, 150, 10, 10, 'dark'],
    [170, 175, 10, 10, 'ink'],
    [180, 155, 40, 40, 'blue'], [180, 155, 40, 8, 'blueHi'],
    [220, 162, 20, 8, 'yellow'], [220, 182, 20, 8, 'yellow'],
  ] },
  { name: 'clawR', body: true, claw: 'R', rects: [
    [305, 230, 15, 40, 'red'], [315, 210, 20, 20, 'red'],
    [310, 170, 50, 40, 'red'], [310, 150, 20, 20, 'red'],
    [340, 170, 20, 10, 'light'], [310, 150, 10, 10, 'dark'],
    [300, 175, 10, 10, 'ink'],
    [260, 155, 40, 40, 'purple'], [260, 155, 40, 8, 'purpleHi'],
    [265, 162, 15, 8, 'ink'], [265, 182, 15, 8, 'ink'],
  ] },
  { name: 'stalks', body: true, rects: [
    [210, 220, 10, 30, 'dark'], [260, 220, 10, 30, 'dark'],
    [200, 200, 30, 25, 'white'], [250, 200, 30, 25, 'white'],
  ] },
  { name: 'pupils', body: true, eyes: true, rects: [
    [212, 205, 10, 15, 'ink'], [258, 205, 10, 15, 'ink'],
  ] },
  { name: 'shell', body: true, rects: [
    [170, 250, 140, 100, 'red'],
    [200, 260, 40, 10, 'light'], [180, 270, 20, 10, 'light'],
    [190, 300, 10, 10, 'dark'], [280, 295, 10, 10, 'dark'],
    [170, 340, 140, 10, 'dark'],
  ] },
  { name: 'mouthA', body: true, mouth: 'A', rects: [
    [225, 300, 10, 8, 'ink'], [235, 295, 10, 8, 'ink'], [245, 300, 10, 8, 'ink'],
  ] },
  { name: 'mouthB', body: true, mouth: 'B', rects: [[233, 292, 15, 15, 'ink']] },
  { name: 'spark', spark: true, rects: [
    [240, 168, 16, 16, 'yellow'], [228, 152, 8, 8, 'yellow'],
    [260, 152, 8, 8, 'yellow'], [228, 192, 8, 8, 'yellow'],
    [260, 192, 8, 8, 'yellow'], [244, 140, 8, 8, 'yellow'],
  ] },
];

// Rendering window and resolution (one pixel = 10 SVG units)
const PX = 10, X0 = 100, X1 = 380, Y0 = 130, Y1 = 390;
const FRAMES_PER_LOOP = 14;
export const FRAME_MS = 100; // 14 frames x 100ms = 1.4s loop, same as the SVG

// Linear keyframes, t in [0, 1]
function kf(t: number, keys: [number, number][]) {
  for (let i = 1; i < keys.length; i++) {
    const [t0, v0] = keys[i - 1]!, [t1, v1] = keys[i]!;
    if (t <= t1) return v0 + (v1 - v0) * ((t - t0) / (t1 - t0 || 1));
  }
  return keys[keys.length - 1]![1];
}

function stateAt(index: number) {
  const loop = Math.floor(index / FRAMES_PER_LOOP);
  const local = index % FRAMES_PER_LOOP;
  const t = local / FRAMES_PER_LOOP;
  const reach = kf(t, [[0, 0], [0.42, 7], [0.5, 7], [0.58, -8], [0.75, -3], [1, 0]]);
  const legUp = Math.floor(t * 8) % 2 === 0; // scuttle 4x per loop
  return {
    bodyY: Math.round(kf(t, [[0, 0], [0.4, -10], [0.55, 10], [0.7, 0], [1, 0]]) / PX) * PX,
    legL: legUp ? -10 : 0,
    legR: legUp ? 0 : -10,
    clawL: reach,
    clawR: -reach,
    spark: t >= 0.42 && t < 0.56,
    oh: t >= 0.56 && t < 0.75,
    blink: loop === 1 && local === 3, // blink once every two loops
  };
}

function rotateBack(x: number, y: number, cx: number, cy: number, deg: number): [number, number] {
  const a = (-deg * Math.PI) / 180, dx = x - cx, dy = y - cy;
  return [cx + dx * Math.cos(a) - dy * Math.sin(a), cy + dx * Math.sin(a) + dy * Math.cos(a)];
}

function colorAt(px: number, py: number, s: ReturnType<typeof stateAt>) {
  for (let i = LAYERS.length - 1; i >= 0; i--) {
    const L = LAYERS[i]!;
    if (L.spark && !s.spark) continue;
    if (L.mouth === 'A' && s.oh) continue;
    if (L.mouth === 'B' && !s.oh) continue;
    if (L.eyes && s.blink) continue;
    let x = px, y = py;
    if (L.body) y -= s.bodyY;
    if (L.legs === 'L') y -= s.legL;
    if (L.legs === 'R') y -= s.legR;
    if (L.claw === 'L') [x, y] = rotateBack(x, y, 170, 270, s.clawL);
    if (L.claw === 'R') [x, y] = rotateBack(x, y, 310, 270, s.clawR);
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

export const frames = Array.from({ length: FRAMES_PER_LOOP * 2 }, (_, i) => renderFrame(i));
