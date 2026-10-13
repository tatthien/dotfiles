# React Providers

Use one setup module to reproduce the minimum app environment needed by scenarios. It is optional for self-contained UI; without it, Component Shot uses a no-op provider.

## Initialize

```bash
component-shot init
component-shot doctor
```

The setup module is discovered beside the scenario directory, normally at `component-shot/setup.tsx`.

## Typed setup

```tsx
import type { ReactNode } from 'react'
import { createComponentShot } from '@lioneltay/component-shot/react'
import { MemoryRouter } from 'react-router-dom'
import { AppThemeProvider } from '../src/theme/AppThemeProvider'

type ShotOptions = {
  route?: string
  theme?: 'light' | 'dark'
}

export const componentShot = createComponentShot<ShotOptions>()
export const scenario = componentShot.scenario

function Provider({ children, options }: { children: ReactNode; options?: ShotOptions }) {
  return (
    <AppThemeProvider mode={options?.theme ?? 'light'}>
      <MemoryRouter initialEntries={[options?.route ?? '/']}>
        {children}
      </MemoryRouter>
    </AppThemeProvider>
  )
}

export default componentShot.setup({ Provider })
```

Use the real provider components when practical. Create fresh stateful clients inside the provider or per render so scenarios do not leak cache or store state into each other.

## Scenario options

```tsx
import { scenario } from '../setup'
import { AccountPage } from '../../src/AccountPage'

export default scenario({
  providerOptions: { route: '/account/billing', theme: 'dark' },
  render: () => <AccountPage />,
})
```

Set `providerOptions: false` only for components that intentionally need no app provider.

## Data and network

- Inject deterministic fixture data through existing provider APIs.
- Prefer mock adapters or in-memory clients over intercepting live services.
- Keep external network blocked. Allow it only when the task specifically requires integration behavior and nondeterminism is acceptable.
- For asynchronous providers, use the scenario `afterRender` or `beforeScreenshot` hook to wait for an explicit ready condition.
