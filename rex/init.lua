-- Keymaps ported from ~/dotfiles/tmux/tmux.conf

local prefix = "ctrl+a"
local function pbind(key, action, args)
  rex.bind(prefix .. ">" .. key, action, args)
end

-- ── Prefix ────────────────────────────────────────────────────
pbind("ctrl+a", "pane.send_key", { key = "ctrl+a" })
pbind("r", "client.config.reload")

-- ── Panes ─────────────────────────────────────────────────────
pbind("h", "pane.focus.left")
pbind("j", "pane.focus.down")
pbind("k", "pane.focus.up")
pbind("l", "pane.focus.right")

-- tmux defaults: % splits right, " splits down
pbind("shift+5", "pane.split.right")
pbind("shift+'", "pane.split.down")

pbind("z", "pane.zoom")
pbind("x", "pane.close")

-- ── Tabs (tmux windows) ───────────────────────────────────────
pbind("c", "client.tab.new")
pbind("n", "client.tab.next")
pbind("p", "client.tab.previous")
pbind("shift+7", "client.tab.close")
pbind("w", "client.tab.close")
pbind(",", "client.tab.rename")
-- tmux windows count from 0, Rex tabs from 1
for i = 0, 9 do
  pbind(tostring(i), "client.tab.goto", { index = i + 1 })
end

pbind("shift+u", "pane.move.up")
pbind("shift+d", "pane.move.down")

pbind("shift+t", "client.tab.rename")

-- ── Popups ────────────────────────────────────────────────────
pbind("f", "session.switch")
pbind("shift+4", "session.rename")
pbind("shift+n", "session.new")
pbind("b", "client.sidebar.toggle")

-- ── Smart pane switching (vim-tmux-navigator) ─────────────────
local terminal = "com.superlogical.terminal"
local passthrough = { vim = true, nvim = true, vi = true, view = true, vimdiff = true, fzf = true }

local function in_vim()
  local proc = rex.block.call(terminal, "process", {})
  local fg = proc and proc.foreground
  if not fg then return false end
  local name = (fg.argv0 or fg.name or ""):gsub("^.*/", ""):gsub("^-", "")
  return passthrough[name] == true
end

local nav = {
  { key = "ctrl+h", focus = "pane.focus.left" },
  { key = "ctrl+j", focus = "pane.focus.down" },
  { key = "ctrl+k", focus = "pane.focus.up" },
  { key = "ctrl+l", focus = "pane.focus.right" },
  { key = "ctrl+\\", focus = "pane.focus_previous" },
}

for _, n in ipairs(nav) do
  local name = "smart_" .. n.focus:gsub("%.", "_")
  rex.action {
    name = name,
    title = "Smart " .. n.focus,
    run = function()
      if in_vim() then
        rex.client.queue("pane.send_key", { key = n.key })
      else
        rex.client.queue(n.focus)
      end
    end,
  }
  rex.bind(n.key, name)
end
