import * as crab from './crab'
import * as crabLift from './crab-lift'
import * as crabAngry from './crab-angry'
import * as crabFine from './crab-fine'

export type Run = { text: string; fg?: string; bg?: string }

type Mascot = { name: string; frames: Run[][][] }

// Every crab steps every 100ms.
export const FRAME_MS = crab.FRAME_MS

export const MASCOTS: Mascot[] = [
  { name: 'crab', frames: crab.frames },
  { name: 'crab-lift', frames: crabLift.frames },
  { name: 'crab-angry', frames: crabAngry.frames },
  { name: 'crab-fine', frames: crabFine.frames },
]

/** The mascot's frame at `tick`, drawn exactly as its renderFrame made it; frozen on frame 0 under reduced motion. */
export function draw(m: Mascot, tick: number, reduceMotion = false): Run[][] {
  return m.frames[reduceMotion ? 0 : tick % m.frames.length]!
}
