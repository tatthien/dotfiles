# MCP And CLI

## MCP loop

The MCP server derives a React project for each request and caches one renderer session, local asset server, and browser per project. Prefer it for autonomous iteration because each capture returns structured diagnostics and the PNG image in the same call.

1. Inspect any `component-shot/setup.*` and existing scenarios with normal filesystem tools.
2. Edit a real component and scenario, or prepare complete TSX for a disposable prototype.
3. Call `capture_component_shot` with a scenario or source target.
4. Inspect the image returned by the tool itself.
5. Iterate with another capture after each meaningful visual change.
6. Add `persistAs` or `saveScreenshot` only when source or pixels should remain.

An existing scenario path derives its project. Temporary source requires `project`. A repository-relative or absolute `persistAs` path derives its project when it points inside `<project>/component-shot/scenarios`. Supplying `project` with either anchored mode is allowed when it agrees with the path. `persistAs` never overwrites an existing file, `saveScreenshot` file paths are relative to the resolved project, and gallery history requires a persistent scenario.

## Existing scenario

```json
{
  "target": {
    "type": "scenario",
    "path": "component-shot/scenarios/card/loading.tsx"
  },
  "viewport": { "width": 390, "height": 844 }
}
```

## Complete source example

The source target requires a complete default-exporting module, not a JSX fragment:

```tsx
import { UserMenu } from '../../src/navigation/UserMenu'

export default {
  title: 'User menu open',
  viewport: { width: 390, height: 844 },
  rootStyle: { display: 'block', minHeight: '100vh' },
  render: () => <UserMenu open user={{ name: 'Ada Lovelace' }} />,
}
```

Relative imports resolve from the scenario file location. Temporary source is staged in `<project>/component-shot/scenarios`; persisted source resolves from its `persistAs` destination. Choose nested paths deliberately so imports stay understandable.

Capture temporary source by passing `{ "type": "source", "project": "apps/web", "code": "..." }`. To retain it, add a self-locating path such as `"persistAs": "apps/web/component-shot/scenarios/navigation/menu-open.tsx"`; `project` may then be omitted or retained as a consistency check. Use `area: { "type": "element", "selector": "[data-shot=menu]" }` to render a complete composition while returning only one region.

Component Shot loads `<project>/component-shot/setup.*` when present and otherwise uses its no-op provider. When a capture fails without setup, the MCP error includes that context without assuming providers were necessarily the cause.

## Setup commands

```bash
component-shot init
component-shot doctor
component-shot browser install chromium
component-shot mcp install --client codex
component-shot skill
```

The browser installer invokes Component Shot's packaged Playwright CLI. Capture automatically uses a supported local Chrome or Edge when the packaged Chromium is absent.

## Capture commands

```bash
component-shot capture --scenario component-shot/scenarios/card/loading.tsx --json
component-shot capture --scenario component-shot/scenarios/card/loading.tsx --save --json
component-shot capture --scenario component-shot/scenarios/card/loading.tsx --output docs/images/card-loading.png
component-shot gallery
component-shot list --json
```

`gallery`, `list`, and `doctor` prefer the current project's `component-shot/scenarios` directory and otherwise auto-select one nested Component Shot project. In a monorepo with several configured apps, pass `--cwd apps/web` (or an explicit `--scenario-dir`) to select one; the CLI lists the candidates instead of opening an empty gallery.

Useful flags include `--viewport 390x844`, `--full-page`, `--selector`, `--wait-for`, `--setup`, `--scenario-dir`, `--screenshots-dir`, `--allow-network`, and `--animations allow`.

## Failures

Errors identify a stage: `discover`, `build`, `serve`, `render`, `capture`, or `artifact`.

- `discover`: verify project, scenario, `persistAs`, setup, and output paths.
- `build`: inspect scenario imports and run the app typecheck.
- `render`: inspect provider errors, browser console diagnostics, and readiness hooks.
- `capture`: verify selector visibility and viewport bounds.
- `artifact`: verify the project-relative export path is writable.

Run `component-shot doctor --json` when setup or browser availability is uncertain. Use `--debug` only when regular structured diagnostics are insufficient.
