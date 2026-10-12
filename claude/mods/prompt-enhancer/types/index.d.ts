declare module 'claude-code' {
  interface PluginState {
    'prompt-enhancer': {
      pending: { text: string; isImproving: boolean } | null
    }
  }
}
