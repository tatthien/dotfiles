import { expect, test } from "@playwright/test";

/**
 * Worked example. Note what is *not* here: no import from the skill, no
 * fixture, no evidence API. This is ordinary Playwright.
 *
 * Three conventions are all the reporter needs:
 *   - the test title is the claim
 *   - `@flow` marks a check whose proof is a recording
 *   - `testInfo.attach(caption, …)` captures a state, and the name is the caption
 */

const SEED_ORDER = [
  "Write the release notes",
  "Ship the docs update",
  "Tag the release",
  "Announce in #engineering",
];

test.beforeEach(async ({ page }) => {
  await page.goto("/");
});

// ── States: one frame settles each of these ──────────────────────────────────

test("rejects a task with no title", async ({ page }, testInfo) => {
  await page.getByRole("button", { name: "Add task" }).click();
  await expect(page.getByRole("alert")).toHaveText(
    "Give the task a title before adding it.",
  );

  await testInfo.attach("Submitting an empty title shows an inline error", {
    body: await page.screenshot(),
    contentType: "image/png",
  });
});

test("rejects a duplicate task title", async ({ page }, testInfo) => {
  await page.getByLabel("Task title").fill("Tag the release");
  await page.getByRole("button", { name: "Add task" }).click();

  await expect(page.getByRole("alert")).toHaveText(
    '"Tag the release" is already on the checklist.',
  );
  await expect(page.getByRole("listitem")).toHaveCount(4);

  await testInfo.attach("A duplicate title is refused and nothing is added", {
    body: await page.screenshot(),
    contentType: "image/png",
  });
});

test("filters narrow the checklist and explain an empty result", async ({
  page,
}, testInfo) => {
  await page.getByRole("tab", { name: "Done" }).click();
  await expect(page.getByRole("listitem")).toHaveCount(1);
  await testInfo.attach("The Done filter shows only completed tasks", {
    body: await page.screenshot(),
    contentType: "image/png",
  });

  // Seeded through storage so the check stays about rendering, not about how
  // the app got into that state.
  await page.evaluate(() => {
    localStorage.setItem(
      "qa-evidence-demo/tasks",
      JSON.stringify([{ id: "a", title: "Tag the release", done: true }]),
    );
  });
  await page.goto("/");
  await page.getByRole("tab", { name: "Open" }).click();

  await expect(page.getByText("Every task is done. Ship it.")).toBeVisible();
  await testInfo.attach("An empty filter result explains itself", {
    body: await page.screenshot(),
    contentType: "image/png",
  });
});

// ── Transitions: these only exist across time, so they are recorded ───────────

test(
  "dragging a task to the top survives a reload",
  { tag: "@flow" },
  async ({ page }) => {
    await expect(page.locator(".task-title")).toHaveText(SEED_ORDER);

    await test.step("Drag 'Tag the release' to the top", async () => {
      const handle = page.getByRole("button", {
        name: "Reorder Tag the release",
      });
      const from = await handle.boundingBox();
      const target = await page.getByRole("listitem").first().boundingBox();
      if (!from || !target) throw new Error("Could not locate the rows");

      // Stepped movement so the recording shows a drag, not a jump cut.
      await page.mouse.move(from.x + from.width / 2, from.y + from.height / 2);
      await page.mouse.down();
      await page.mouse.move(from.x + from.width / 2, target.y + 2, {
        steps: 24,
      });
      await page.mouse.up();
    });

    await test.step("Reload — the new order must come back from storage", async () => {
      await page.reload();
    });

    await expect(page.locator(".task-title")).toHaveText([
      "Tag the release",
      "Write the release notes",
      "Ship the docs update",
      "Announce in #engineering",
    ]);
  },
);

test(
  "publishing runs every stage before reporting success",
  { tag: "@flow" },
  async ({ page }, testInfo) => {
    const panel = page.locator(".publish-panel");
    await expect(panel).toBeHidden();

    await test.step("Publish the release and watch each stage", async () => {
      await page.getByRole("button", { name: "Publish release" }).click();
      await expect(panel).toContainText("Release published");
    });

    await expect(panel.locator(".publish-steps li")).toHaveText([
      "Validating checklist",
      "Building release",
      "Uploading artifacts",
    ]);

    await testInfo.attach("The published panel lists every completed stage", {
      body: await panel.screenshot(),
      contentType: "image/png",
    });
  },
);

test(
  "undo restores a deleted task to its original position",
  { tag: "@flow" },
  async ({ page }) => {
    const titles = page.locator(".task-title");
    await expect(titles).toHaveText(SEED_ORDER);

    // A chapter card is optional narration, and native Playwright — it needs no
    // screencast.start() of its own. Use it where a step title is too terse.
    await page.screencast.showChapter("Delete the second task", {
      description: "It goes immediately, with a countdown to undo",
    });

    await test.step("Delete 'Ship the docs update'", async () => {
      await page
        .getByRole("button", { name: "Delete Ship the docs update" })
        .click();
      await expect(page.getByRole("status")).toContainText("Deleted");
    });

    await test.step("Undo before the countdown ends", async () => {
      await page.getByRole("button", { name: /^Undo/ }).click();
    });

    // The claim is that it comes back second, not last.
    await expect(titles).toHaveText(SEED_ORDER);
  },
);
