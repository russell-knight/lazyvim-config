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

  {
    "webhooked/kanso.nvim",
    lazy = false,
    priority = 1000,
  },

  -- Configure LazyVim to use kanagawa
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "kanagawa",
    },
  },
}
