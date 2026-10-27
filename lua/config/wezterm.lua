-- Seamless Alt+h/j/k/l navigation between Neovim splits and WezTerm panes.
-- The WezTerm half lives in ~/.wezterm.lua on Windows: it passes Alt+hjkl through
-- while IS_NVIM is set, and moves to the next pane when WEZTERM_NAV changes.

-- Other terminals ignore these escape sequences, but skip them where we know it's not WezTerm
local term = vim.env.TERM_PROGRAM
if term and term ~= "" and term ~= "WezTerm" then
  return
end

local function set_user_var(name, value)
  vim.api.nvim_ui_send(string.format("\027]1337;SetUserVar=%s=%s\007", name, vim.base64.encode(value)))
end

local group = vim.api.nvim_create_augroup("wezterm_nav", { clear = true })
vim.api.nvim_create_autocmd({ "VimEnter", "VimResume" }, {
  group = group,
  callback = function()
    set_user_var("IS_NVIM", "true")
  end,
})
vim.api.nvim_create_autocmd({ "VimLeavePre", "VimSuspend" }, {
  group = group,
  callback = function()
    set_user_var("IS_NVIM", "")
  end,
})
-- Keymaps load after VimEnter, so announce ourselves now as well
set_user_var("IS_NVIM", "true")

local directions = { h = "Left", j = "Down", k = "Up", l = "Right" }

for key, direction in pairs(directions) do
  vim.keymap.set({ "n", "i", "t" }, "<A-" .. key .. ">", function()
    local win = vim.api.nvim_get_current_win()
    vim.cmd.wincmd(key)
    -- Already at the edge of Neovim's splits: ask WezTerm to move to the next pane
    if vim.api.nvim_get_current_win() == win then
      set_user_var("WEZTERM_NAV", direction .. ":" .. vim.uv.hrtime())
    end
  end, { desc = "Go to " .. direction .. " Window or WezTerm Pane" })
end
