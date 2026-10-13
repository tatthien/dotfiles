import { defineConfig, devices } from "@playwright/test";

/**
 * An ordinary Playwright config — nothing here knows about QA evidence.
 * `qa.mjs run` wraps this at run time to add annotated video and the evidence
 * reporter; this file is read, never written.
 *
 * Copy this shape for your own project. The only thing that matters is that
 * `webServer` knows how to start your app.
 */
export default defineConfig({
  testDir: ".",
  use: {
    baseURL: "http://localhost:9491",
    viewport: { width: 1280, height: 800 },
  },
  projects: [
    {
      name: "chromium",
      use: {
        ...devices["Desktop Chrome"],
        viewport: { width: 1280, height: 800 },
      },
    },
  ],
  webServer: {
    command: "node ../scripts/serve.mjs --dir demo --port 9491",
    url: "http://localhost:9491",
    // Never QA a stray server someone else left on this port. Evidence of the
    // wrong app is worse than no evidence.
    reuseExistingServer: false,
  },
});
