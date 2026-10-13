---
name: component-shot
description: Use when creating, changing, rendering, inspecting, visually testing, or documenting React UI with Component Shot; when an agent needs immediate visual feedback without navigating the real app; when a loading, empty, error, modal, permission, responsive, or other intermediate state is hard to reach; or when reusable component screenshots are needed for review, pull requests, or documentation.
---

# Component Shot

Use Component Shot as the visual loop for React work: mount a real component or prototype in a deterministic scenario, render it directly, inspect the returned image, and iterate.

## Core workflow

1. Inspect the workspace with normal filesystem tools.
   - Identify the React project root, any `component-shot/setup.*`, and related scenarios.
   - Run `component-shot doctor` or `component-shot list --json` only when setup or discovery is unclear.
2. Choose the smallest useful capture target.
   - Prefer a real application component with mocked props/providers when implementing production UI.
   - Pass an existing scenario path after editing a real component or reusable state.
   - Pass complete TSX source plus its React `project` directory for a disposable idea that does not need a workspace file.
   - Add `persistAs` to source only when the state should remain visible in the gallery.
   - Update an existing scenario when it already represents the requested state.
3. Render immediately after each meaningful UI change.
   - Call `capture_component_shot`; it builds, renders, captures, and returns the PNG in one call.
   - Use `area.type: "element"` with a stable selector to isolate part of a larger composition.
   - Use actual viewport dimensions for responsive review.
   - Inspect the returned image itself, not only success metadata.
4. Iterate on visible issues: hierarchy, spacing, clipping, overflow, responsive behavior, content, interaction state, and fidelity to the surrounding app.
5. Keep only useful artifacts.
   - Omit `saveScreenshot` during ordinary iteration.
   - Use `saveScreenshot: { type: "history" }` for a persistent scenario checkpoint.
   - Use `saveScreenshot: { type: "file", path: "...png" }` for a stable PR or documentation image.
6. Open `component-shot gallery` when a person needs to inspect scenarios, compare saved history, change viewports, or provide feedback.

## Scenario rules

- Put reusable scenarios under `component-shot/scenarios` unless project configuration uses another root.
- Import and render real app components directly. Do not add production routes or debug flags solely to reach a visual state.
- Use fixed props, dates, IDs, locale, and mocked data. External network is blocked by default.
- Represent important states as separate, descriptively named scenarios such as `invoice/loading.tsx`, `invoice/empty.tsx`, and `invoice/payment-failed.tsx`.
- Use the project's `component-shot/setup.tsx` for themes, routers, query clients, stores, feature flags, and other app providers.
- Temporary source requires `project` because it has no filesystem anchor for imports, dependencies, TypeScript configuration, or providers.
- Existing scenario and repository-relative `persistAs` paths derive their project automatically. An optional `project` must agree with the path.
- `persistAs` must point inside `<project>/component-shot/scenarios`. It creates a scenario and never overwrites one. Edit existing scenarios with normal filesystem tools.
- Gallery history requires an existing scenario or source with `persistAs`; an explicit file export can come from temporary source.
- Do not save history on every iteration.

## Capture selection

| Need | `capture_component_shot` input |
| --- | --- |
| Inspect an existing state | `target: { type: "scenario", path }` |
| Prototype without keeping source | `target: { type: "source", project, code }` |
| Create a gallery scenario and inspect it | Source target with a repository-relative `persistAs` |
| Capture the visible viewport | Omit `area` or use `{ type: "viewport" }` |
| Capture a complete scrollable composition | `area: { type: "page" }` |
| Capture one component inside a larger UI | `area: { type: "element", selector }` |
| Keep local comparison history | `saveScreenshot: { type: "history" }` |
| Create a durable PNG | `saveScreenshot: { type: "file", path }` |

## References

- Read [providers.md](references/providers.md) when configuring React context or app infrastructure.
- Read [scenarios.md](references/scenarios.md) when authoring state files or using lifecycle metadata.
- Read [mcp-and-cli.md](references/mcp-and-cli.md) for the MCP schema, CLI commands, path behavior, and troubleshooting.
- Read [visual-review.md](references/visual-review.md) when doing responsive review or creating PR/documentation captures.

## Completion

Before reporting React UI work complete, render every changed state, inspect the resulting image, check at least one relevant narrow viewport for responsive work, and run the app's normal typecheck or focused tests. Report any render or test that could not be run.
