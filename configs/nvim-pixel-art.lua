-- Neovim Lazy.nvim Configuration Snippet for Pixel Art Theme & Animated Dashboard
return {
  -- Pixel Art Theme Plugin
  {
    "BJT1698/dms-pixel-art-theme",
    name = "pixel-art.nvim",
    dir = vim.fn.expand("~/.local/share/nvim/site/pack/pixel-art/start/pixel-art.nvim"),
    lazy = false,
    priority = 1000,
    opts = {
      variant = "arcade-neon", -- "arcade-neon" | "pico-8" | "game-boy" | "16bit-rpg"
      transparent = true,
      styles = {
        comments = { italic = false },
        keywords = { bold = true },
        functions = { bold = true },
        sidebars = "transparent",
        floats = "transparent",
      },
    },
    config = function(_, opts)
      require("pixel-art").setup(opts)
      vim.cmd([[colorscheme pixel-art]])
    end,
  },

  -- Alpha-nvim with Animated Synthwave Pixel Art Header
  {
    "goolord/alpha-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      -- Shortcuts
      dashboard.section.buttons.val = {
        dashboard.button("e", "  Nuovo file", "<cmd>ene <BAR> startinsert<CR>"),
        dashboard.button("f", "  Esplora file (Space + e)", "<cmd>NvimTreeToggle<CR>"),
        dashboard.button("t", "  Terminale popup (Space + t)", "<cmd>ToggleTerm direction=float<CR>"),
        dashboard.button("l", "  Gestione plugin (Lazy)", "<cmd>Lazy<CR>"),
        dashboard.button("q", "  Esci da Neovim", "<cmd>qa<CR>"),
      }

      -- Enable Animated Pixel Art Header
      local ok, pixel_dash = pcall(require, "pixel-art.dashboard")
      if ok and pixel_dash then
        pixel_dash.setup_alpha(dashboard, alpha)
      end

      alpha.setup(dashboard.opts)
    end,
  },
}
