return {
  -- Uses the `roslyn` language server installed by Mason (see mason-roslyn.lua) on both Linux and Windows.
  -- Server settings go through `vim.lsp.config("roslyn", { ... })`.
  "seblyng/roslyn.nvim",
  ---@module 'roslyn.config'
  ---@type RoslynNvimConfig
  opts = {},
}
