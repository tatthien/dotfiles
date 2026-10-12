export type ClawdRun = { text: string; fg?: string; bg?: string }

export type ClawdFrameArgs = { mascot: number; tick: number }

export type Clawd = {
  count: () => Promise<number>
  /** Terminal rows of `mascot` (taken modulo the count) at animation `tick`, as runs of colored text. */
  frame: (args: ClawdFrameArgs) => Promise<ClawdRun[][]>
}

declare module 'claude-code' {
  interface EngineInterface {
    clawd: Clawd
  }

  interface PluginState {
    'clawd-spinner': { state: { tick: number; mascot: number }; galleryTick: number }
  }
}
