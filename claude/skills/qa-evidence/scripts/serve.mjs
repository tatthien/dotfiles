#!/usr/bin/env node
import { readFile } from "node:fs/promises";
import { createServer } from "node:http";
import { extname, join, normalize, resolve } from "node:path";
import { parseArgs } from "node:util";

/** Zero-dependency static server, so the demo needs no build and no install. */
const { values } = parseArgs({
  options: {
    dir: { type: "string", default: "." },
    port: { type: "string", default: "9491" },
  },
});

const root = resolve(values.dir);
const TYPES = {
  ".html": "text/html; charset=utf-8",
  ".js": "text/javascript; charset=utf-8",
  ".css": "text/css; charset=utf-8",
  ".json": "application/json; charset=utf-8",
  ".svg": "image/svg+xml",
  ".png": "image/png",
};

createServer(async (request, response) => {
  // Normalising before joining keeps "../" out of the served path.
  const requested = new URL(request.url ?? "/", "http://localhost").pathname;
  const relative = normalize(requested).replace(/^(\.\.[/\\])+/, "");
  const file = join(
    root,
    relative.endsWith("/") ? `${relative}index.html` : relative,
  );

  try {
    const body = await readFile(file);
    response.writeHead(200, {
      "content-type": TYPES[extname(file)] ?? "application/octet-stream",
    });
    response.end(body);
  } catch {
    response.writeHead(404, { "content-type": "text/plain" });
    response.end("Not found");
  }
}).listen(Number(values.port), () => {
  process.stdout.write(`serving ${root} on http://localhost:${values.port}\n`);
});
