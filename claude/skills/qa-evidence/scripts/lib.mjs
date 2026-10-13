import { execFileSync } from "node:child_process";
import { createHash } from "node:crypto";
import { readFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { basename, join, resolve } from "node:path";

/**
 * Shared vocabulary for the reporter (which writes evidence) and the CLI
 * (which publishes it). No dependencies: this bundle is meant to be copied
 * into any repository and run with nothing installed but Playwright and gh.
 */

let cachedRoot;

/** The repository being QA'd: its git root, or the cwd outside a checkout. */
export function repoRoot() {
  if (cachedRoot) return cachedRoot;
  try {
    cachedRoot = execFileSync("git", ["rev-parse", "--show-toplevel"], {
      encoding: "utf8",
      stdio: ["ignore", "pipe", "ignore"],
    }).trim();
  } catch {
    cachedRoot = process.cwd();
  }
  return cachedRoot;
}

/**
 * Evidence root. It lives in the system temp directory, keyed by repository,
 * so a run leaves nothing in the checkout and there is nothing to gitignore.
 * The key is stable across `run`, `report` and `pr`, and distinct per repo.
 */
export function qaDir() {
  if (process.env.QA_EVIDENCE_DIR) return resolve(process.env.QA_EVIDENCE_DIR);
  const root = repoRoot();
  const key = createHash("sha1").update(root).digest("hex").slice(0, 8);
  return join(tmpdir(), "qa-evidence", `${slug(basename(root))}-${key}`);
}

export function mediaDir() {
  return join(qaDir(), "media");
}

/** Where the wrapper config sends Playwright's own artifacts. */
export function playwrightOutputDir() {
  return join(qaDir(), "playwright");
}

export function manifestPath() {
  return join(qaDir(), "run.json");
}

export function readRun() {
  return JSON.parse(readFileSync(manifestPath(), "utf8"));
}

/**
 * Failures first. A QA report that buries the one broken flow under five green
 * ones is worse than no report. Ties keep a stable spec/title order.
 */
export function sortForReview(tests) {
  return [...tests].sort((a, b) => {
    const aOk = a.status === "passed" ? 1 : 0;
    const bOk = b.status === "passed" ? 1 : 0;
    if (aOk !== bOk) return aOk - bOk;
    return a.spec.localeCompare(b.spec) || a.title.localeCompare(b.title);
  });
}

export function slug(value) {
  return value
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-|-$/g, "")
    .slice(0, 60);
}

/**
 * Renders a run as the Markdown body of a pull request. Media is referenced by
 * absolute path; `gh --attach` uploads each file and rewrites the reference to
 * the uploaded asset.
 */
export function renderReport(run) {
  const tests = sortForReview(run.tests);
  const passed = tests.filter((t) => t.status === "passed").length;
  const failed = tests.length - passed;

  const lines = [
    "## QA evidence",
    "",
    `**${passed} passed${failed > 0 ? ` · ${failed} failed` : ""}** — ${describeRun(run.metadata)}`,
    "",
    "Screenshots prove a state; recordings prove a transition.",
  ];

  for (const test of tests) lines.push("", "---", "", ...renderTest(test));
  return `${lines.join("\n")}\n`;
}

function describeRun(metadata) {
  const parts = [
    `${metadata.browser} ${metadata.viewport}`,
    `Playwright ${metadata.playwrightVersion}`,
  ];
  if (metadata.commit) parts.push(`commit \`${metadata.commit}\``);
  return parts.join(" · ");
}

function renderTest(test) {
  const lines = [
    `### ${test.status === "passed" ? "✅" : "❌"} ${test.title}`,
    "",
    `\`${test.spec}\` · ${(test.durationMs / 1000).toFixed(1)}s`,
  ];

  if (test.error) lines.push("", `> ${test.error}`);
  if (test.items.length === 0) {
    lines.push("", "_No evidence recorded for this check._");
  }
  for (const item of test.items) lines.push("", ...renderItem(item));
  return lines;
}

function renderItem(item) {
  if (item.kind === "screenshot") {
    return [`**${item.caption}**`, "", `![${item.caption}](${item.file})`];
  }
  // GitHub gives a video asset no alt text, so the label goes above it. An
  // image-style reference is what `gh` rewrites into a bare URL, which is the
  // form GitHub renders as a player.
  const lines = [`**${item.caption}**`, "", `![](${item.file})`];
  if (item.steps?.length > 0)
    lines.push("", `Steps: ${item.steps.join(" → ")}`);
  return lines;
}
