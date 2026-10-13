---
name: qa-evidence
description: QA a UI change in a real browser and attach the screenshots and screen recordings to the pull request. Use when opening a PR that changes UI behaviour, when asked to prove a change works, to show your work, to record or demo what you built, or to re-QA a PR after review feedback.
allowed-tools: Bash(node:*), Bash(npx:*), Bash(gh:*), Read, Write, Edit
---

# QA evidence on a pull request

Prove a change works by driving it in a real browser and attaching the proof to
the PR, so a reviewer never has to check out the branch.

Two upstream primitives do the work. Playwright (1.59+) records annotated WebM
from config — animated cursor, action labels, step titles. `gh --attach` (2.99+)
uploads media into the PR body, where video renders as a player. The scripts
here are the glue.

**Nothing in this skill is imported by the project's tests, and the project's
`playwright.config.ts` is read, never written.** `qa.mjs run` generates a
throwaway config beside it that layers on evidence capture, then deletes it.

## Setup

Only two things must be true:

- `gh --version` is 2.99 or later and `gh auth status` is signed in.
- The project has Playwright ≥1.59 with a `webServer` that starts the app. If it
  does not, set that up first (`npm init playwright@latest`) — that is ordinary
  Playwright setup, not configuration for this skill.

Nothing else to install or configure.

## 1. State the claims first

Write down what the change should do, in the reviewer's terms, *before*
capturing anything. Each claim becomes one check, and **the test title is the
claim**. Evidence not attached to a claim proves nothing — a success banner does
not show the record was saved.

Three good claims beat ten incidental ones.

## 2. Pick the evidence from the claim

| The claim is about | Use | Why |
| --- | --- | --- |
| A state — an error, an empty view, a total, a rendered result | `testInfo.attach(caption, …)` | One frame settles it |
| A transition — a drag, a staged job, undo, optimistic update | tag the test `@flow` | The claim only exists across time |

Never record a flow to prove a state, and never screenshot a state to imply a
transition. Before/after screenshots show that something differs, not that the
interaction caused it.

A recording is kept when the test is tagged `@flow` **or when it fails**.
Everything else would attach a video of nothing happening.

## 3. Write the checks — plain Playwright

```ts
test("undo restores a deleted task to its original position", { tag: "@flow" },
  async ({ page }) => {
    await page.goto("/");

    // Optional: a centred card where a step title is too terse. Native
    // Playwright — it needs no screencast.start() of its own.
    await page.screencast.showChapter("Delete the second task", {
      description: "It goes immediately, with a countdown to undo",
    });

    // Step titles are burned into the recording automatically.
    await test.step("Delete 'Ship the docs update'", async () => {
      await page.getByRole("button", { name: "Delete Ship the docs" }).click();
    });
    await test.step("Undo before the countdown ends", async () => {
      await page.getByRole("button", { name: /^Undo/ }).click();
    });

    await expect(page.locator(".task-title")).toHaveText(ORIGINAL_ORDER);
  });
```

For a state, attach it — the attachment name becomes the caption:

```ts
await testInfo.attach("Submitting an empty title shows an inline error", {
  body: await page.screenshot(),
  contentType: "image/png",
});
```

Still assert with `expect`. Evidence shows a reviewer what happened; the
assertions are what fail the run. A recording of a broken flow is not a pass.

See `references/demo.spec.ts` for all of this in one file.

## 4. Run and attach

Run from inside the repository being QA'd: Playwright is resolved from there
and `gh` needs to see the branch. Evidence goes to a per-repository temp
directory — the run prints where — so nothing is written into the checkout.

```bash
S=~/.claude/skills/qa-evidence/scripts        # installed globally by ai-config

node $S/qa.mjs run                            # run the suite, record evidence
node $S/qa.mjs run -- --grep @flow            # args after -- go to Playwright
node $S/qa.mjs pr --dry-run                   # inspect the body, upload nothing
node $S/qa.mjs pr --draft --title "…" --intro notes.md
node $S/qa.mjs update                         # re-QA: replace the PR body
node $S/qa.mjs comment 42                     # or post it as a comment
```

`--intro` prepends your own summary of the change above the evidence. Always
`--dry-run` first and read the body.

Then confirm the upload really happened:

```bash
gh pr view --json body --jq .body | grep -c user-attachments
```

Local file paths still in the body mean nothing was uploaded.

## Rules

- **Fix the app, not the check.** A failing check is a real finding. Report it;
  do not delete the check or loosen the assertion to get a green report.
- **Failures are the most valuable evidence.** The report leads with them, and a
  failing check keeps both its recording and its final frame.
- **Recordings are not pixel-perfect.** They prove behaviour, not visual
  fidelity. Use visual regression tooling for that.
- **One claim per recording.** Long videos are large and go unwatched. GitHub
  caps images at 10 MB and video at 100 MB, 50 files per command.
- **Evidence never touches the repository.** It lives in a temp directory and
  is uploaded to GitHub's CDN. There is nothing to gitignore or commit.
- **Check what the app under test actually is.** If the project's `webServer`
  sets `reuseExistingServer: true`, a stray server left on that port will be
  QA'd instead of the branch. Evidence of the wrong app is worse than none.

## Self-test

Verify the whole path without touching the host project:

```bash
node $S/qa.mjs run --config ~/.claude/skills/qa-evidence/references/playwright.config.ts
node $S/qa.mjs report
```

That runs six checks against `references/demo/index.html`, a dependency-free app
carrying both shapes of behaviour, and prints the report.

## Related

`npx playwright init-agents --loop=claude` installs Playwright's own planner,
generator and healer agents for writing and repairing specs. They stop at a
passing suite; this skill covers turning that run into reviewable evidence.
