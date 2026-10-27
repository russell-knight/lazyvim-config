return {
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000, -- Load before other plugins
    opts = {
      -- Optional: customize kanagawa
      theme = "wave", -- "wave", "dragon", or "lotus"
      background = {
        dark = "wave",
        light = "lotus",
      },
    },
  },

  -- Configure LazyVim to use kanagawa
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "kanagawa",
    },
  },
}
