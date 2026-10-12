// Pixel crab furiously pounding a glitching laptop, for the terminal.
// Half-block characters (▀ ▄) + 24-bit ANSI color: two pixels per text cell.
//
// Ported from crab-angry.mjs: the CLI and the ANSI escapes are gone (a mod cannot run Node or print);
// renderFrame returns the same ▀/▄ cells as colored runs instead.

import type { Run } from './mascots'

type Rect = [number, number, number, number, keyof typeof COLORS]
type Layer = {
  rects: Rect[]
  laptop?: boolean
  glitch?: 'A' | 'B'
  smoke?: boolean
  pivot?: [number, number]
  angle?: 'fist' | 'slam'
  anger?: boolean
  burst?: boolean
}

const COLORS = {
  red: '#E04A3F', dark: '#B32F2A', light: '#FF7A66', ink: '#2E2A3F', white: '#FFFFFF',
  lid: '#5B30D0', lidHi: '#8A6CF5', screen: '#241A55', magenta: '#B033D0', cyan: '#3AD0E0',
  smoke: '#9A97A8', yellow: '#FDC232', orange: '#FF6B35', anger: '#FF5A3C',
};

// Artwork in the SVG's coordinate space: [x, y, width, height, color]
const LAYERS: Layer[] = [
  { laptop: true, rects: [[350, 265, 70, 90, 'lid'], [358, 273, 54, 74, 'screen']] },
  { laptop: true, glitch: 'A', rects: [[365, 285, 40, 8, 'magenta'], [365, 305, 25, 8, 'magenta'], [375, 325, 30, 8, 'magenta']] },
  { laptop: true, glitch: 'B', rects: [[370, 280, 20, 8, 'cyan'], [360, 300, 45, 8, 'cyan'], [365, 320, 15, 8, 'cyan']] },
  { laptop: true, rects: [[270, 355, 150, 15, 'lid'], [270, 355, 150, 5, 'lidHi']] },
  { smoke: true, rects: [[395, 245, 10, 10, 'smoke'], [405, 235, 10, 10, 'smoke'], [385, 225, 10, 10, 'smoke']] },
  { rects: [
    [90, 300, 20, 10, 'dark'], [80, 310, 10, 60, 'dark'], [100, 320, 20, 10, 'dark'], [95, 330, 10, 40, 'dark'],
    [115, 335, 20, 10, 'dark'], [110, 345, 10, 25, 'dark'], [250, 300, 20, 10, 'dark'], [270, 310, 10, 60, 'dark'],
    [240, 320, 20, 10, 'dark'], [255, 330, 10, 40, 'dark'], [225, 335, 20, 10, 'dark'], [240, 345, 10, 25, 'dark'],
  ] },
  { pivot: [100, 270], angle: 'fist', rects: [
    [100, 230, 15, 40, 'red'], [85, 210, 20, 20, 'red'], [60, 170, 50, 40, 'red'], [90, 150, 20, 20, 'red'],
    [60, 170, 20, 10, 'light'], [100, 150, 10, 10, 'dark'],
  ] },
  { pivot: [250, 292], angle: 'slam', rects: [
    [245, 285, 45, 15, 'red'], [285, 265, 50, 40, 'red'], [315, 245, 20, 20, 'red'],
    [285, 265, 20, 10, 'light'], [325, 245, 10, 10, 'dark'],
  ] },
  { rects: [
    [150, 220, 10, 30, 'dark'], [200, 220, 10, 30, 'dark'],
    [140, 200, 30, 25, 'white'], [190, 200, 30, 25, 'white'],
    [158, 208, 10, 12, 'ink'], [208, 208, 10, 12, 'ink'],
    [135, 185, 15, 10, 'ink'], [150, 195, 20, 10, 'ink'], [190, 195, 20, 10, 'ink'], [210, 185, 15, 10, 'ink'],
  ] },
  { rects: [
    [110, 250, 140, 100, 'red'], [140, 260, 40, 10, 'light'], [120, 270, 20, 10, 'light'],
    [130, 320, 10, 10, 'dark'], [220, 315, 10, 10, 'dark'], [110, 340, 140, 10, 'dark'],
    [165, 300, 10, 10, 'ink'], [175, 290, 10, 10, 'ink'], [185, 300, 10, 10, 'ink'],
  ] },
  { anger: true, rects: [[235, 175, 10, 10, 'anger'], [255, 175, 10, 10, 'anger'], [235, 195, 10, 10, 'anger'], [255, 195, 10, 10, 'anger']] },
  { burst: true, rects: [
    [300, 320, 10, 10, 'yellow'], [280, 330, 10, 10, 'yellow'], [330, 330, 10, 10, 'yellow'],
    [270, 310, 10, 10, 'yellow'], [335, 305, 10, 10, 'yellow'], [305, 300, 10, 10, 'yellow'],
    [290, 320, 10, 10, 'orange'], [310, 320, 10, 10, 'orange'], [300, 310, 10, 10, 'orange'],
  ] },
];

const PX = 10, X0 = 40, X1 = 440, Y0 = 140, Y1 = 380;
const FRAME_COUNT = 12;
export const FRAME_MS = 100; // 12 x 100ms = 1.2s, same as the SVG

function stateAt(i: number) {
  const t = i / FRAME_COUNT;
  const slamming = (t >= 0.15 && t < 0.45) || (t >= 0.55 && t < 0.85);
  const impact = (t >= 0.15 && t < 0.31) || (t >= 0.55 && t < 0.71);
  return {
    fist: i % 4 < 2 ? -10 : 8,
    slam: slamming ? 35 : -30,
    burst: impact,
    laptopY: (t >= 0.15 && t < 0.2) || (t >= 0.55 && t < 0.6) ? 10 : 0,
    glitchA: i % 4 < 2,
    anger: i % 6 < 4,
    smokeY: -Math.round((t * 60) / PX) * PX,
    smoke: t < 0.9,
  };
}

function rotateBack(x: number, y: number, [cx, cy]: [number, number], deg: number): [number, number] {
  const a = (-deg * Math.PI) / 180, dx = x - cx, dy = y - cy;
  return [cx + dx * Math.cos(a) - dy * Math.sin(a), cy + dx * Math.sin(a) + dy * Math.cos(a)];
}

function colorAt(px: number, py: number, s: ReturnType<typeof stateAt>) {
  for (let i = LAYERS.length - 1; i >= 0; i--) {
    const L = LAYERS[i]!;
    if (L.glitch === 'A' && !s.glitchA) continue;
    if (L.glitch === 'B' && s.glitchA) continue;
    if (L.burst && !s.burst) continue;
    if (L.anger && !s.anger) continue;
    if (L.smoke && !s.smoke) continue;
    let x = px, y = py;
    if (L.laptop) y -= s.laptopY;
    if (L.smoke) y -= s.smokeY;
    if (L.angle) [x, y] = rotateBack(x, y, L.pivot!, s[L.angle]);
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
