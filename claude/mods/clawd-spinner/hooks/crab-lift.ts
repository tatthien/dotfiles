// Pixel crab pressing a barbell, for the terminal.
// Half-block characters (▀ ▄) + 24-bit ANSI color: two pixels per text cell.
//
// Ported from crab-lift.mjs: the CLI and the ANSI escapes are gone (a mod cannot run Node or print);
// renderFrame returns the same ▀/▄ cells as colored runs instead.

import type { Run } from './mascots'

type Rect = [number, number, number, number, keyof typeof COLORS]
type Layer = {
  rects: Rect[]
  body?: boolean
  lift?: boolean
  happy?: boolean
  strain?: boolean
  sweat?: boolean
  sparkle?: boolean
}

const COLORS = {
  red: '#E04A3F', dark: '#B32F2A', light: '#FF7A66', ink: '#2E2A3F',
  white: '#FFFFFF', bar: '#6B7499', plate: '#3A47E0', plateHi: '#6672F5',
  sweat: '#6FA8F7', yellow: '#FFD83D',
};

// Artwork in the SVG's coordinate space: [x, y, width, height, color]
const LAYERS: Layer[] = [
  { rects: [ // legs stay planted
    [150, 300, 20, 10, 'dark'], [140, 310, 10, 60, 'dark'],
    [160, 320, 20, 10, 'dark'], [155, 330, 10, 40, 'dark'],
    [175, 335, 20, 10, 'dark'], [170, 345, 10, 25, 'dark'],
    [310, 300, 20, 10, 'dark'], [330, 310, 10, 60, 'dark'],
    [300, 320, 20, 10, 'dark'], [315, 330, 10, 40, 'dark'],
    [285, 335, 20, 10, 'dark'], [300, 345, 10, 25, 'dark'],
  ] },
  { body: true, lift: true, rects: [
    [160, 200, 15, 90, 'red'], [145, 205, 20, 15, 'red'],
    [120, 170, 50, 40, 'red'], [120, 140, 15, 30, 'red'], [155, 140, 15, 30, 'red'],
    [305, 200, 15, 90, 'red'], [315, 205, 20, 15, 'red'],
    [310, 170, 50, 40, 'red'], [310, 140, 15, 30, 'red'], [345, 140, 15, 30, 'red'],
    [120, 170, 20, 10, 'light'], [340, 170, 20, 10, 'light'],
    [80, 150, 320, 10, 'bar'],
    [70, 120, 20, 70, 'plate'], [60, 135, 10, 40, 'plateHi'],
    [390, 120, 20, 70, 'plate'], [410, 135, 10, 40, 'plateHi'],
  ] },
  { body: true, rects: [[210, 220, 10, 30, 'dark'], [260, 220, 10, 30, 'dark']] },
  { body: true, happy: true, rects: [
    [200, 200, 30, 25, 'white'], [250, 200, 30, 25, 'white'],
    [212, 205, 10, 15, 'ink'], [258, 205, 10, 15, 'ink'],
  ] },
  { body: true, strain: true, rects: [[200, 210, 30, 10, 'ink'], [250, 210, 30, 10, 'ink']] },
  { body: true, rects: [
    [170, 250, 140, 100, 'red'],
    [200, 260, 40, 10, 'light'], [180, 270, 20, 10, 'light'],
    [190, 320, 10, 10, 'dark'], [280, 315, 10, 10, 'dark'], [170, 340, 140, 10, 'dark'],
  ] },
  { body: true, strain: true, rects: [[225, 295, 30, 10, 'ink']] },
  { body: true, happy: true, rects: [
    [225, 290, 10, 10, 'ink'], [235, 300, 10, 10, 'ink'], [245, 290, 10, 10, 'ink'],
  ] },
  { body: true, sweat: true, rects: [[290, 230, 10, 10, 'sweat']] },
  { sparkle: true, rects: [
    [40, 80, 10, 10, 'yellow'], [30, 90, 10, 10, 'yellow'], [50, 90, 10, 10, 'yellow'], [40, 100, 10, 10, 'yellow'],
    [430, 80, 10, 10, 'yellow'], [420, 90, 10, 10, 'yellow'], [440, 90, 10, 10, 'yellow'], [430, 100, 10, 10, 'yellow'],
    [235, 70, 10, 10, 'yellow'],
  ] },
];

const PX = 10, X0 = 20, X1 = 460, Y0 = 60, Y1 = 380;
const FRAME_COUNT = 16;
export const FRAME_MS = 100; // 16 x 100ms = 1.6s, same as the SVG

function kf(t: number, keys: [number, number][]) {
  for (let i = 1; i < keys.length; i++) {
    const [t0, v0] = keys[i - 1]!, [t1, v1] = keys[i]!;
    if (t <= t1) return v0 + (v1 - v0) * ((t - t0) / (t1 - t0 || 1));
  }
  return keys[keys.length - 1]![1];
}
const snap = (v: number) => Math.round(v / PX) * PX;

function stateAt(i: number) {
  const t = i / FRAME_COUNT;
  return {
    bodyY: snap(kf(t, [[0, 0], [0.15, 10], [0.3, 10], [0.45, 0], [0.55, -10], [0.62, 0], [1, 0]])),
    liftY: snap(kf(t, [[0, 0], [0.3, 0], [0.45, -40], [0.7, -40], [0.85, 0], [1, 0]])),
    strain: t < 0.45,
    sparkle: (t >= 0.5 && t < 0.58) || (t >= 0.6 && t < 0.72),
    sweat: t >= 0.1 && t < 0.41,
    sweatY: snap(kf(t, [[0.1, 0], [0.4, 30]])),
  };
}

function colorAt(px: number, py: number, s: ReturnType<typeof stateAt>) {
  for (let i = LAYERS.length - 1; i >= 0; i--) {
    const L = LAYERS[i]!;
    if (L.strain && !s.strain) continue;
    if (L.happy && s.strain) continue;
    if (L.sparkle && !s.sparkle) continue;
    if (L.sweat && !s.sweat) continue;
    let y = py;
    if (L.body) y -= s.bodyY;
    if (L.lift) y -= s.liftY;
    if (L.sweat) y -= s.sweatY;
    for (let j = L.rects.length - 1; j >= 0; j--) {
      const [rx, ry, rw, rh, c] = L.rects[j]!;
      if (px >= rx && px < rx + rw && y >= ry && y < ry + rh) return COLORS[c];
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
