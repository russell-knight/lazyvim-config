return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      omnisharp = false, -- disable omnisharp
      vtsls = false, -- disable vtsls in favor of tsgo
      tsgo = {}, -- enable tsgo TypeScript language server
    },
  },
}
