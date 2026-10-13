# Scenario Authoring

A scenario is a TSX module with a default export. Prefer the typed helper from the project setup.

## Real component state

```tsx
import { scenario } from '../setup'
import { InvoicePanel } from '../../src/billing/InvoicePanel'

export default scenario({
  title: 'Invoice payment failed',
  description: 'Retryable card failure with a past-due invoice.',
  tags: ['billing', 'error'],
  viewport: { width: 1024, height: 768 },
  providerOptions: { route: '/billing/invoices/inv_123' },
  rootStyle: { display: 'block', width: '100%' },
  render: () => (
    <InvoicePanel
      invoice={{ id: 'inv_123', status: 'past_due', total: 12900 }}
      paymentError="Card declined"
    />
  ),
})
```

## Important fields

| Field | Purpose |
| --- | --- |
| `render` | Return the React UI to mount. Required for object scenarios. |
| `title`, `description`, `tags` | Human and agent discovery metadata. |
| `providerOptions` | Configure the shared setup provider for this state. |
| `viewport` | Default review/capture viewport. |
| `environment` | Locale, timezone, color scheme, reduced motion, DPR, and network policy. |
| `rootStyle` | Stable bounds for the scenario canvas. |
| `capture` | Selector, full-page, and animation defaults. |
| `setup` | Prepare deterministic browser state before rendering. |
| `afterRender` | Wait after React mounts, before final settling. |
| `beforeScreenshot` | Last deterministic wait or adjustment before readiness. |
| `wrapper` | Scenario-local React wrapper. Prefer shared setup for app infrastructure. |

## State coverage

Create scenarios for states that materially change layout or decisions:

- default and populated
- loading and skeleton
- empty and first-use
- validation and server error
- disabled, read-only, or insufficient permission
- modal, popover, expanded row, selected item, and pending action
- long content, many items, missing media, and edge values
- narrow and wide responsive layouts
- light/dark only when both are supported and visually distinct

Avoid a combinatorial matrix. Keep states that help implementation, review, regression diagnosis, or documentation.

## Readiness

Do not add arbitrary sleeps when an explicit condition exists. In `afterRender` or `beforeScreenshot`, wait on application state, fonts, or a DOM condition. Component Shot already waits for React mount, multiple animation frames, document fonts, and the configured selector.

## Sizing

- Use `rootStyle: { display: 'block', width: '100%' }` for page-like surfaces.
- Use a stable pixel width for isolated controls or cards.
- Declare `viewport` for layout states tied to a breakpoint.
- Use `capture.fullPage` only when the complete page is the intended artifact.
