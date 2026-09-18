-- Pixel Art Neovim Colorscheme Plugin
local M = {}

M.options = {
  variant = "arcade-neon", -- "arcade-neon" | "pico-8" | "game-boy" | "16bit-rpg"
  transparent = true,
  terminal_colors = true,
  styles = {
    comments = { italic = false },
    keywords = { bold = true },
    functions = { bold = true },
    sidebars = "transparent",
    floats = "transparent",
  },
}

function M.setup(opts)
  M.options = vim.tbl_deep_extend("force", M.options, opts or {})
end

function M.load(variant)
  local active_variant = variant or M.options.variant or "arcade-neon"
  local palette = require("pixel-art.palette").get(active_variant)

  if vim.g.colors_name then
    vim.cmd("hi clear")
  end
  vim.g.colors_name = "pixel-art"
  vim.o.termguicolors = true

  -- Terminal Colors
  if M.options.terminal_colors then
    vim.g.terminal_color_0 = palette.bg
    vim.g.terminal_color_1 = palette.red
    vim.g.terminal_color_2 = palette.green
    vim.g.terminal_color_3 = palette.yellow
    vim.g.terminal_color_4 = palette.cyan
    vim.g.terminal_color_5 = palette.pink
    vim.g.terminal_color_6 = palette.cyan
    vim.g.terminal_color_7 = palette.fg
    vim.g.terminal_color_8 = palette.fg_gutter
    vim.g.terminal_color_9 = palette.red
    vim.g.terminal_color_10 = palette.green
    vim.g.terminal_color_11 = palette.yellow
    vim.g.terminal_color_12 = palette.cyan
    vim.g.terminal_color_13 = palette.pink
    vim.g.terminal_color_14 = palette.cyan
    vim.g.terminal_color_15 = palette.fg
  end

  require("pixel-art.highlights").setup(palette, M.options)
end

return M
