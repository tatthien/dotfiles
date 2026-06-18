// tmux:port — show which tmux session is serving a TCP port.
//
// Built for a monorepo with many worktrees, each living in its own tmux
// session. When a dev server is up on :3000 but you don't know which
// session started it, this walks the listening process up its ancestry
// to the owning tmux pane.
//
// Usage:
//   p tmux:port <port>     e.g. p tmux:port 3000
//   p tmux:port            defaults to 3000

const { execFileSync } = require("node:child_process");

const description = "show which tmux session is serving a TCP port";

function usage(code = 0) {
  process.stdout.write(
    [
      "p tmux:port — show which tmux session is serving a TCP port.",
      "",
      "Usage:",
      "  p tmux:port <port>     e.g. p tmux:port 3000",
      "  p tmux:port            defaults to 3000",
      "",
    ].join("\n"),
  );
  process.exit(code);
}

// Run a command, returning stdout. Returns "" when the command exits
// non-zero (e.g. lsof finds nothing) instead of throwing.
function run(cmd, args) {
  try {
    return execFileSync(cmd, args, { encoding: "utf8" }).trim();
  } catch {
    return "";
  }
}

function parsePort(argv) {
  const arg = argv[0];
  if (arg === "-h" || arg === "--help") usage(0);
  const port = arg === undefined ? 3000 : Number(arg);
  if (!Number.isInteger(port) || port < 1 || port > 65535) {
    process.stderr.write(`p tmux:port: invalid port: ${arg}\n`);
    usage(1);
  }
  return port;
}

// PIDs with a LISTEN socket on the given TCP port.
function listeningPids(port) {
  const out = run("lsof", ["-nP", `-iTCP:${port}`, "-sTCP:LISTEN", "-t"]);
  return out ? [...new Set(out.split("\n").map(Number))] : [];
}

// pid -> ppid map for the whole process table.
function parentMap() {
  const map = new Map();
  for (const line of run("ps", ["-axo", "pid=,ppid="]).split("\n")) {
    const [pid, ppid] = line.trim().split(/\s+/).map(Number);
    if (pid) map.set(pid, ppid);
  }
  return map;
}

// pane_pid -> { session, window, windowName, pane, command }
function tmuxPanes() {
  const fmt =
    "#{pane_pid}\t#{session_name}\t#{window_index}\t#{window_name}\t#{pane_index}\t#{pane_current_command}";
  const out = run("tmux", ["list-panes", "-a", "-F", fmt]);
  const map = new Map();
  if (!out) return map;
  for (const line of out.split("\n")) {
    const [pid, session, window, windowName, pane, command] = line.split("\t");
    map.set(Number(pid), { session, window, windowName, pane, command });
  }
  return map;
}

function commandOf(pid) {
  return run("ps", ["-o", "comm=", "-p", String(pid)]).split("/").pop() || "?";
}

// Walk pid up its ancestry until we hit a pane_pid (or run out).
function paneForPid(pid, parents, panes) {
  let cur = pid;
  const seen = new Set();
  while (cur && cur !== 1 && !seen.has(cur)) {
    if (panes.has(cur)) return panes.get(cur);
    seen.add(cur);
    cur = parents.get(cur);
  }
  return null;
}

function exec(argv) {
  const port = parsePort(argv);

  const pids = listeningPids(port);
  if (pids.length === 0) {
    process.stdout.write(`Nothing is listening on port ${port}.\n`);
    return;
  }

  const parents = parentMap();
  const panes = tmuxPanes();

  const seenSessions = new Set();
  const matched = [];
  const orphans = [];

  for (const pid of pids) {
    const pane = paneForPid(pid, parents, panes);
    const command = commandOf(pid);
    if (pane) {
      const key = `${pane.session}\t${pane.window}\t${pane.pane}`;
      if (!seenSessions.has(key)) {
        seenSessions.add(key);
        matched.push({ pane, command, pid });
      }
    } else {
      orphans.push({ command, pid });
    }
  }

  if (matched.length === 0 && orphans.length > 0) {
    process.stdout.write(`Port ${port} is in use but not by any tmux pane:\n`);
    for (const o of orphans) {
      process.stdout.write(`  ${o.command} (pid ${o.pid})\n`);
    }
    return;
  }

  for (const { pane, command, pid } of matched) {
    process.stdout.write(
      `Port ${port} → session "${pane.session}"  ` +
        `(window ${pane.window}:${pane.windowName}, pane ${pane.pane})  ` +
        `${command} pid ${pid}\n`,
    );
  }
}

module.exports = { description, run: exec };
