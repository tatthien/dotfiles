declare module 'claude-code' {
  interface PluginState {
    'prompt-enhancer': {
      pending: { text: string; mascot: number; isImproving: boolean } | null
      tick: number
    }
  }
}
