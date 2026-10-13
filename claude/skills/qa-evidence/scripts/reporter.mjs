import { execFileSync } from "node:child_process";
import { copyFileSync, mkdirSync, rmSync, writeFileSync } from "node:fs";
import { createRequire } from "node:module";
import { extname, join, relative } from "node:path";
import { manifestPath, mediaDir, qaDir, slug } from "./lib.mjs";

/**
 * Collects QA evidence from a Playwright run into a per-repository temp
 * directory (see qaDir in lib.mjs), so nothing lands in the checkout.
 *
 * Nothing here is imported by the tests. Playwright already captures video and
 * failure screenshots from config, and `testInfo.attach()` is the standard way
 * a test records an artifact — this reporter just gathers what the run produced
 * and gives it captions a reviewer can read.
 *
 * A recording is kept when the test is tagged `@flow` or when it failed.
 * Everything else would attach a video of nothing happening.
 */
export default class QaEvidenceReporter {
  #tests = [];
  #metadata = {};

  onBegin(config) {
    // Clear first: a green run must never attach a screenshot of a failure
    // that no longer exists. Playwright manages its own output directory.
    rmSync(mediaDir(), { recursive: true, force: true });
    rmSync(manifestPath(), { force: true });
    mkdirSync(mediaDir(), { recursive: true });

    const project = config.projects[0];
    const viewport = project?.use?.viewport;
    this.#metadata = {
      startedAt: new Date().toISOString(),
      browser: project?.use?.browserName ?? project?.name ?? "chromium",
      viewport: viewport ? `${viewport.width}×${viewport.height}` : "default",
      playwrightVersion: playwrightVersion(),
      commit: headCommit(),
    };
  }

  onTestEnd(test, result) {
    const failed = result.status !== test.expectedStatus;
    const keepVideo = test.tags.includes("@flow") || failed;
    const items = [];
    let index = 0;

    for (const attachment of result.attachments) {
      const kind = kindOf(attachment.contentType);
      if (!kind) continue;
      if (kind === "video" && !keepVideo) continue;

      index += 1;
      const file = this.#save(test, attachment, index);
      items.push({
        kind,
        caption: captionFor(kind, attachment.name),
        file,
        ...(kind === "video" ? { steps: stepTitles(result) } : {}),
      });
    }

    // The recording covers the whole check, so it reads first; screenshots
    // keep the order they were captured in.
    items.sort((a, b) => (a.kind === b.kind ? 0 : a.kind === "video" ? -1 : 1));

    this.#tests.push({
      title: test.title,
      spec: relative(process.cwd(), test.location.file),
      status: failed ? (result.status ?? "failed") : "passed",
      durationMs: result.duration,
      error: failed ? firstLine(result.error?.message) : undefined,
      items,
    });
  }

  onEnd() {
    writeFileSync(
      manifestPath(),
      JSON.stringify({ metadata: this.#metadata, tests: this.#tests }, null, 2),
    );
    process.stdout.write(`\nevidence: ${qaDir()}\n`);
  }

  /** Writes an attachment into the evidence directory; returns its path. */
  #save(test, attachment, index) {
    const base = `${slug(test.location.file.split("/").pop() ?? "spec")}__${slug(test.title)}--${index}`;
    const name = `${base}${extensionFor(attachment)}`;
    const target = join(mediaDir(), name);

    if (attachment.path) copyFileSync(attachment.path, target);
    else writeFileSync(target, toBuffer(attachment.body));

    return target;
  }
}

function kindOf(contentType) {
  if (contentType.startsWith("image/")) return "screenshot";
  if (contentType.startsWith("video/")) return "video";
  return undefined; // Traces and logs belong in CI, not in a PR body.
}

function captionFor(kind, name) {
  if (kind === "video") return "Recording";
  // Playwright names its automatic failure capture "screenshot"; anything else
  // was named by the test through testInfo.attach().
  return name === "screenshot" ? "Failure state at the end of the test" : name;
}

/** Only the steps the author wrote; Playwright's own API calls are noise. */
function stepTitles(result) {
  return result.steps
    .filter((step) => step.category === "test.step")
    .map((step) => step.title);
}

function extensionFor(attachment) {
  if (attachment.path) return extname(attachment.path);
  return attachment.contentType.startsWith("video/") ? ".webm" : ".png";
}

function toBuffer(body) {
  if (!body) return Buffer.alloc(0);
  return Buffer.isBuffer(body) ? body : Buffer.from(body, "base64");
}

function playwrightVersion() {
  try {
    const require = createRequire(import.meta.url);
    return require("@playwright/test/package.json").version;
  } catch {
    return "unknown";
  }
}

function headCommit() {
  try {
    return execFileSync("git", ["rev-parse", "--short", "HEAD"], {
      encoding: "utf8",
    }).trim();
  } catch {
    return undefined; // Evidence is still valid outside a git checkout.
  }
}

const ANSI = new RegExp(`${String.fromCharCode(27)}\\[[0-9;]*m`, "g");

function firstLine(message) {
  if (!message) return undefined;
  return message.replace(ANSI, "").split("\n")[0]?.trim();
}
