-- Copied from: https://github.com/folke/tokyonight.nvim/blob/main/lua/tokyonight/util.lua
local M = {}

M.bg = "#000000"
M.fg = "#ffffff"

---@param c  string
local function rgb(c)
  c = string.lower(c)
  return { tonumber(c:sub(2, 3), 16), tonumber(c:sub(4, 5), 16), tonumber(c:sub(6, 7), 16) }
end

---@param foreground string foreground color
---@param background string background color
---@param alpha number|string number between 0 and 1. 0 results in bg, 1 results in fg
function M.blend(foreground, alpha, background)
  alpha = type(alpha) == "string" and (tonumber(alpha, 16) / 0xff) or alpha
  local bg = rgb(background)
  local fg = rgb(foreground)

  local blendChannel = function(i)
    local ret = (alpha * fg[i] + ((1 - alpha) * bg[i]))
    return math.floor(math.min(math.max(0, ret), 255) + 0.5)
  end

  return string.format("#%02x%02x%02x", blendChannel(1), blendChannel(2), blendChannel(3))
end

function M.blend_bg(hex, amount, bg)
  return M.blend(hex, amount, bg or M.bg)
end

function M.darken_hex_color(hex, percentage, alpha)
  -- Remove '#' if present
  hex = hex:gsub("#", "")

  -- Convert hex to RGB
  local r = tonumber(hex:sub(1, 2), 16)
  local g = tonumber(hex:sub(3, 4), 16)
  local b = tonumber(hex:sub(5, 6), 16)

  -- Decrease brightness
  percentage = percentage or 20 -- Default to 20% darker if not specified
  r = math.max(0, r - (r * percentage / 100))
  g = math.max(0, g - (g * percentage / 100))
  b = math.max(0, b - (b * percentage / 100))

  -- Round RGB values
  r, g, b = math.floor(r + 0.5), math.floor(g + 0.5), math.floor(b + 0.5)

  -- Convert back to hex
  local darkened_hex = string.format("#%02X%02X%02X", r, g, b)

  -- Apply alpha if provided
  if alpha then
    -- Ensure alpha is between 0 and 1
    alpha = math.max(0, math.min(1, alpha))
    local alpha_hex = string.format("%02X", math.floor(alpha * 255 + 0.5))
    darkened_hex = darkened_hex .. alpha_hex
  end

  return darkened_hex
end

return M
