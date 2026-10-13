# Visual Review And Artifacts

## Iteration checklist

Inspect the rendered image after every meaningful change. Check:

- correct component and intended state
- visual hierarchy and action priority
- spacing rhythm and alignment
- text wrapping, truncation, and long values
- clipping, unintended scrollbars, and viewport overflow
- loading/error/empty state clarity
- focus, selected, disabled, expanded, or pending state when relevant
- consistency with nearby production UI and its design system
- useful behavior at the narrowest supported viewport

Use the gallery for side-by-side human feedback across scenarios. Overview is the collection view in the scenario browser. Selecting a scenario opens its detail workspace, where Live renders the React scenario and History shows retained PNG captures. Overview uses a saved PNG only while a live thumbnail is loading or when that thumbnail cannot render.

In Live, use viewport presets, enter exact dimensions and commit with Enter or blur, or drag the right, bottom, and corner handles. Collapse the scenario browser or inspector when the canvas needs more room.

## Responsive review

Do not scale the same screenshot and call it responsive validation. Render the scenario at actual browser viewport sizes. Start with the component's relevant product breakpoints; when none are known, use a narrow phone around `390x844` and the normal desktop viewport.

## Saved history

`capture_component_shot` with `saveScreenshot: { type: "history" }` and CLI `--save` publish:

```text
component-shot/screenshots/<artifact-key>/latest.png
component-shot/screenshots/<artifact-key>/history/<timestamp>-<id>.png
```

Use history for meaningful checkpoints, not every edit. Existing history is user output; do not delete it unless asked.

## PR and documentation images

Use `capture_component_shot` with `saveScreenshot: { type: "file", path: "..." }` or CLI `--output` with a project-relative path such as:

```text
docs/images/invoice-payment-failed.png
```

Before using an exported image:

1. Render at an intentional viewport.
2. Inspect the returned image.
3. Use stable fixture content with no secrets or personal data.
4. Confirm the exported file is the requested state and not an old `latest.png`.
5. Keep scenario source when the image should be reproducible later.
