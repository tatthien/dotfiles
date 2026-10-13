import { describe, expect, test } from "claude-code/testing";
import type { On } from "claude-code";

const PROMPT = "fix the login redirect bug after sign in";
const IMPROVED = "Fix the bug where signing in redirects to the wrong page.";

type Seen = { asked: string[]; polished: string[]; filled: string[]; sent: string[] };

// Stands in for the dialog, the model and the prompt box; `settled` resolves at the enhancer's last step, a fill of the box.
function stub(on: On, answer?: string | "dismiss") {
  const seen: Seen = { asked: [], polished: [], filled: [], sent: [] };
  let settle = () => {};
  const settled = new Promise<void>((resolve) => (settle = resolve));

  on("tool.call", { tool: "AskUserQuestion" }, async (_$, e) => {
    const question = e.questions[0]!.question;
    seen.asked.push(question);
    if (!answer || answer === "dismiss") return { deny: "dismissed" };
    return { result: { questions: e.questions, answers: { [question]: answer } } };
  });
  on("model.complete", async (_$, e) => {
    seen.polished.push(e.prompt);
    return { value: { isAnswered: true, text: IMPROVED, usage: { input_tokens: 1, output_tokens: 1, cache_read_input_tokens: 0, cache_creation_input_tokens: 0 } } };
  });
  on("prompt.fill", async (_$, e) => {
    if (e.text) seen.filled.push(e.text);
    settle();
    return { isFilled: true };
  });
  on("prompt.submit", async (_$, e) => {
    seen.sent.push(e.text);
    return { text: e.text };
  });
  on("ui.status", async () => ({ value: undefined }));
  on("ui.log", async () => ({ value: undefined }));
  on("ui.toast", async () => ({ value: undefined }));

  return { seen, settled };
}

describe("prompt enhancer", () => {
  test("a prompt without >> is sent untouched, unasked and unpolished", async ($, on) => {
    const { seen } = stub(on);
    await $.prompt.submit({ text: PROMPT, origin: { kind: "composer" }, wait: false });
    expect(seen.asked).toEqual([]);
    expect(seen.polished).toEqual([]);
    expect(seen.sent).toEqual([PROMPT]);
  });

  test(">> asks first, then polishes the prompt without the prefix", async ($, on) => {
    const { seen, settled } = stub(on, "Yes, polish it");
    await $.prompt.submit({ text: `>> ${PROMPT}`, origin: { kind: "composer" }, wait: false });
    await settled;
    expect(seen.asked).toHaveLength(1);
    expect(seen.asked[0]).toContain(PROMPT);
    expect(seen.asked[0]).not.toContain(">>");
    expect(seen.polished).toEqual([PROMPT]);
    expect(seen.filled).toEqual([IMPROVED]);
  });

  test(">> then No sends the prompt as is, without the prefix", async ($, on) => {
    const { seen, settled } = stub(on, "No, send as is");
    await $.prompt.submit({ text: `>> ${PROMPT}`, origin: { kind: "composer" }, wait: false });
    await settled;
    expect(seen.asked).toHaveLength(1);
    expect(seen.polished).toEqual([]);
    expect(seen.sent).toEqual([PROMPT]);
  });

  test(">> then Esc puts the prompt back as typed", async ($, on) => {
    const { seen, settled } = stub(on, "dismiss");
    await $.prompt.submit({ text: `>> ${PROMPT}`, origin: { kind: "composer" }, wait: false });
    await settled;
    expect(seen.polished).toEqual([]);
    expect(seen.sent).toEqual([]);
    expect(seen.filled).toEqual([`>> ${PROMPT}`]);
  });

  test("a short >> prompt is sent without the prefix, unasked", async ($, on) => {
    const { seen } = stub(on);
    await $.prompt.submit({ text: ">> hi there", origin: { kind: "composer" }, wait: false });
    expect(seen.asked).toEqual([]);
    expect(seen.polished).toEqual([]);
    expect(seen.sent).toEqual(["hi there"]);
  });
});
