-- Neovim Lazy.nvim Configuration Snippet for Pixel Art Theme
return {
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
}
