import * as crab from './crab'
import * as crabLift from './crab-lift'
import * as crabAngry from './crab-angry'
import * as crabFine from './crab-fine'
import * as crabFlag from './crab-flag'
import * as crabReview from './crab-review'
import { toOctants } from './octants'

export type Run = { text: string; fg?: string; bg?: string }

type Mascot = { name: string; frames: Run[][][] }

// Every crab steps every 95ms, 5% faster than the 100ms its SVG uses.
export const FRAME_MS = 95

export const MASCOTS: Mascot[] = [
  { name: 'crab', frames: toOctants(crab.frames) },
  { name: 'crab-lift', frames: toOctants(crabLift.frames) },
  { name: 'crab-angry', frames: toOctants(crabAngry.frames) },
  { name: 'crab-fine', frames: toOctants(crabFine.frames) },
  { name: 'crab-flag', frames: toOctants(crabFlag.frames) },
  { name: 'crab-review', frames: toOctants(crabReview.frames) },
]

/** The mascot's frame at `tick`, its renderFrame redrawn in octants; frozen on frame 0 under reduced motion. */
export function draw(m: Mascot, tick: number, reduceMotion = false): Run[][] {
  return m.frames[reduceMotion ? 0 : tick % m.frames.length]!
}
