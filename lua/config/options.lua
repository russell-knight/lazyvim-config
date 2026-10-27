-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Disable Snacks animations for instant Ctrl+U/Ctrl+D scrolling
vim.g.snacks_animate = false

-- Disable unused remote plugin providers (silences :checkhealth warnings)
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

-- Keep 10 lines of context above/below the cursor (scrollEOF extends this past end of file)
vim.opt.scrolloff = 10
