-- Pixel Art Animated Dashboard for Neovim / Alpha-nvim
local M = {}

local timer = nil
local current_frame = 1
local is_running = false

-- 6 Smooth animated frames of synthwave sun, stars, mountains, and rolling perspective grid
M.frames = {
  {
    "                  .      *          +         .       *       .   ",
    "              *       .        +         *        .       +       ",
    "                        ▄▄██████████▄▄                            ",
    "                     ▄██████████████████▄                         ",
    "                    ██████████████████████                        ",
    "                    ██████████████████████                        ",
    "                    ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀                        ",
    "                    ██████████████████████                        ",
    "                    ──────────────────────                        ",
    "                     ▀██████████████████▀                         ",
    "               ▲      ──████████████──      ▲                     ",
    "              ▲▲▲        ▀▀██████▀▀        ▲▲▲                    ",
    "            ▲▲▲▲▲▲   ▲                  ▲ ▲▲▲▲▲▲                  ",
    "        ══════════════════════════════════════════════════        ",
    "          \\        |         |         |         |       /        ",
    "        ───\\───────|─────────|─────────|─────────|──────/───      ",
    "            \\      |         |         |         |     /          ",
    "        ═════\\═════|═════════|═════════|═════════|════/═════      ",
  },
  {
    "              +          .       *          +         *       .   ",
    "                  *          +        .         +        .        ",
    "                        ▄▄██████████▄▄                            ",
    "                     ▄██████████████████▄                         ",
    "                    ██████████████████████                        ",
    "                    ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀                        ",
    "                    ██████████████████████                        ",
    "                    ──────────────────────                        ",
    "                    ██████████████████████                        ",
    "                     ▀██████████████████▀                         ",
    "               ▲      ──████████████──      ▲                     ",
    "              ▲▲▲        ▀▀██████▀▀        ▲▲▲                    ",
    "            ▲▲▲▲▲▲   ▲                  ▲ ▲▲▲▲▲▲                  ",
    "        ══════════════════════════════════════════════════        ",
    "        ────\\──────|─────────|─────────|─────────|─────/────      ",
    "             \\     |         |         |         |    /           ",
    "              \\    |         |         |         |   /            ",
    "        ═══════\\═══|═════════|═════════|═════════|══/═══════      ",
  },
  {
    "                  *      .          +         *       .       +   ",
    "              .       +        *         .        *       .       ",
    "                        ▄▄██████████▄▄                            ",
    "                     ▄██████████████████▄                         ",
    "                    ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀                        ",
    "                    ██████████████████████                        ",
    "                    ──────────────────────                        ",
    "                    ██████████████████████                        ",
    "                    ──────────────────────                        ",
    "                     ▀██████████████████▀                         ",
    "               ▲      ──████████████──      ▲                     ",
    "              ▲▲▲        ▀▀██████▀▀        ▲▲▲                    ",
    "            ▲▲▲▲▲▲   ▲                  ▲ ▲▲▲▲▲▲                  ",
    "        ══════════════════════════════════════════════════        ",
    "             \\     |         |         |         |    /           ",
    "        ──────\\────|─────────|─────────|─────────|───/──────      ",
    "               \\   |         |         |         |  /             ",
    "        ════════\\══|═════════|═════════|═════════|═/════════      ",
  },
  {
    "              .          *       .          +         .       *   ",
    "                  +          .        *         .        +        ",
    "                        ▄▄██████████▄▄                            ",
    "                     ▄▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▄                         ",
    "                    ██████████████████████                        ",
    "                    ──────────────────────                        ",
    "                    ██████████████████████                        ",
    "                    ──────────────────────                        ",
    "                    ██████████████████████                        ",
    "                     ▀██████████████████▀                         ",
    "               ▲      ──████████████──      ▲                     ",
    "              ▲▲▲        ▀▀██████▀▀        ▲▲▲                    ",
    "            ▲▲▲▲▲▲   ▲                  ▲ ▲▲▲▲▲▲                  ",
    "        ══════════════════════════════════════════════════        ",
    "              \\    |         |         |         |   /            ",
    "               \\   |         |         |         |  /             ",
    "        ────────\\──|─────────|─────────|─────────|─/────────      ",
    "        ═════════\\═|═════════|═════════|═════════|/═════════      ",
  },
  {
    "                  +      .          *         .       +       .   ",
    "              *       *        +         .        *       .       ",
    "                        ▄▄██████████▄▄                            ",
    "                     ▄██████████████████▄                         ",
    "                    ██████████████████████                        ",
    "                    ──────────────────────                        ",
    "                    ██████████████████████                        ",
    "                    ──────────────────────                        ",
    "                    ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀                        ",
    "                     ▀██████████████████▀                         ",
    "               ▲      ──████████████──      ▲                     ",
    "              ▲▲▲        ▀▀██████▀▀        ▲▲▲                    ",
    "            ▲▲▲▲▲▲   ▲                  ▲ ▲▲▲▲▲▲                  ",
    "        ══════════════════════════════════════════════════        ",
    "            \\      |         |         |         |     /          ",
    "          ───\\─────|─────────|─────────|─────────|────/───        ",
    "          \\        |         |         |         |       /        ",
    "        ═══\\═══════|═════════|═════════|═════════|══════/═══      ",
  },
  {
    "              *          +       .          *         .       +   ",
    "                  .          *        +         *        .        ",
    "                        ▄▄██████████▄▄                            ",
    "                     ▄██████████████████▄                         ",
    "                    ██████████████████████                        ",
    "                    ██████████████████████                        ",
    "                    ──────────────────────                        ",
    "                    ██████████████████████                        ",
    "                    ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀                        ",
    "                     ▀██████████████████▀                         ",
    "               ▲      ──████████████──      ▲                     ",
    "              ▲▲▲        ▀▀██████▀▀        ▲▲▲                    ",
    "            ▲▲▲▲▲▲   ▲                  ▲ ▲▲▲▲▲▲                  ",
    "        ══════════════════════════════════════════════════        ",
    "         \\         |         |         |         |        /       ",
    "        ──\\────────|─────────|─────────|─────────|───────/──      ",
    "           \\       |         |         |         |      /         ",
    "        ════\\══════|═════════|═════════|═════════|═════/════      ",
  },
}

-- Matching line-by-line highlight mapping
M.highlight_map = {
  { { "PixelArtStars", 0, -1 } },
  { { "PixelArtStars", 0, -1 } },
  { { "PixelArtSunTop", 0, -1 } },
  { { "PixelArtSunTop", 0, -1 } },
  { { "PixelArtSunTop", 0, -1 } },
  { { "PixelArtSunMid", 0, -1 } },
  { { "PixelArtSunMid", 0, -1 } },
  { { "PixelArtSunBot", 0, -1 } },
  { { "PixelArtSunBot", 0, -1 } },
  { { "PixelArtSunBot", 0, -1 } },
  { { "PixelArtMountains", 0, -1 } },
  { { "PixelArtMountains", 0, -1 } },
  { { "PixelArtMountains", 0, -1 } },
  { { "PixelArtHorizon", 0, -1 } },
  { { "PixelArtGrid", 0, -1 } },
  { { "PixelArtGrid", 0, -1 } },
  { { "PixelArtGrid", 0, -1 } },
  { { "PixelArtGrid", 0, -1 } },
}

function M.get_header()
  return M.frames[current_frame]
end

function M.stop_animation()
  if timer then
    timer:stop()
    if not timer:is_closing() then
      timer:close()
    end
    timer = nil
  end
  is_running = false
end

function M.start_animation(alpha)
  if is_running then return end

  local uv = vim.uv or vim.loop
  timer = uv.new_timer()
  is_running = true

  timer:start(0, 160, vim.schedule_wrap(function()
    if not is_running then return end
    
    -- Check if current buffer is alpha
    local current_buf = vim.api.nvim_get_current_buf()
    local ft = vim.api.nvim_get_option_value("filetype", { buf = current_buf })
    
    if ft ~= "alpha" then
      M.stop_animation()
      return
    end

    current_frame = (current_frame % #M.frames) + 1
    
    local ok, dashboard = pcall(require, "alpha.themes.dashboard")
    if ok and dashboard and dashboard.section and dashboard.section.header then
      dashboard.section.header.val = M.frames[current_frame]
      dashboard.section.header.opts.hl = M.highlight_map
      if alpha and alpha.redraw then
        alpha.redraw()
      end
    end
  end))
end

function M.setup_alpha(dashboard, alpha)
  dashboard.section.header.val = M.frames[1]
  dashboard.section.header.opts.hl = M.highlight_map

  local group = vim.api.nvim_create_augroup("PixelArtAlphaAnimation", { clear = true })

  vim.api.nvim_create_autocmd("User", {
    pattern = "AlphaReady",
    group = group,
    callback = function()
      M.start_animation(alpha)
    end,
  })

  vim.api.nvim_create_autocmd({ "BufLeave", "BufUnload", "WinLeave" }, {
    pattern = "*",
    group = group,
    callback = function()
      local current_buf = vim.api.nvim_get_current_buf()
      local ft = vim.api.nvim_get_option_value("filetype", { buf = current_buf })
      if ft == "alpha" then
        M.stop_animation()
      end
    end,
  })

  vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*",
    group = group,
    callback = function()
      local current_buf = vim.api.nvim_get_current_buf()
      local ft = vim.api.nvim_get_option_value("filetype", { buf = current_buf })
      if ft == "alpha" then
        M.start_animation(alpha)
      end
    end,
  })
end

return M
