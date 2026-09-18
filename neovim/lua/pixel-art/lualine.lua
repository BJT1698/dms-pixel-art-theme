-- Pixel Art Lualine Theme Definition
local M = {}

function M.get(variant)
  local palette = require("pixel-art.palette").get(variant or "arcade-neon")
  local c = palette

  return {
    normal = {
      a = { fg = c.bg, bg = c.cyan, gui = "bold" },
      b = { fg = c.fg, bg = c.bg_highlight },
      c = { fg = c.fg_dark, bg = c.bg_dark },
    },
    insert = {
      a = { fg = c.bg, bg = c.green, gui = "bold" },
      b = { fg = c.fg, bg = c.bg_highlight },
      c = { fg = c.fg_dark, bg = c.bg_dark },
    },
    visual = {
      a = { fg = c.bg, bg = c.pink, gui = "bold" },
      b = { fg = c.fg, bg = c.bg_highlight },
      c = { fg = c.fg_dark, bg = c.bg_dark },
    },
    replace = {
      a = { fg = c.bg, bg = c.red, gui = "bold" },
      b = { fg = c.fg, bg = c.bg_highlight },
      c = { fg = c.fg_dark, bg = c.bg_dark },
    },
    command = {
      a = { fg = c.bg, bg = c.yellow, gui = "bold" },
      b = { fg = c.fg, bg = c.bg_highlight },
      c = { fg = c.fg_dark, bg = c.bg_dark },
    },
    inactive = {
      a = { fg = c.fg_gutter, bg = c.bg_dark },
      b = { fg = c.fg_gutter, bg = c.bg_dark },
      c = { fg = c.fg_gutter, bg = c.bg_dark },
    },
  }
end

return M
