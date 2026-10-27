-- Alt keys shared with WezTerm panes: Alt+h/j/k/l moves (seamlessly into WezTerm panes),
-- Alt+Shift+h/j/k/l resizes, Alt+W closes and Alt+Z zooms the current split.
-- The WezTerm half lives in ~/.wezterm.lua on Windows: it passes these keys through
-- while IS_NVIM is set, and moves to the next pane when WEZTERM_NAV changes.

-- Other terminals ignore these escape sequences, but skip them where we know it's not WezTerm
local term = vim.env.TERM_PROGRAM
local maybe_wezterm = not term or term == "" or term == "WezTerm"

local function set_user_var(name, value)
  if maybe_wezterm then
    vim.api.nvim_ui_send(string.format("\027]1337;SetUserVar=%s=%s\007", name, vim.base64.encode(value)))
  end
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

-- Same direction semantics as LazyVim's Ctrl+arrow resize maps
local resize = {
  H = { cmd = "vertical resize -3", desc = "Decrease Window Width" },
  L = { cmd = "vertical resize +3", desc = "Increase Window Width" },
  K = { cmd = "resize +2", desc = "Increase Window Height" },
  J = { cmd = "resize -2", desc = "Decrease Window Height" },
}

for key, r in pairs(resize) do
  vim.keymap.set({ "n", "i", "t" }, "<A-" .. key .. ">", "<Cmd>" .. r.cmd .. "<CR>", { desc = r.desc })
end

vim.keymap.set({ "n", "i", "t" }, "<A-w>", function()
  local splits = vim.tbl_filter(function(win)
    return vim.api.nvim_win_get_config(win).relative == ""
  end, vim.api.nvim_tabpage_list_wins(0))
  -- Never quit Neovim from here; :q does that
  if #splits > 1 then
    vim.cmd.close()
  else
    vim.notify("Last window: use :q to quit Neovim", vim.log.levels.INFO)
  end
end, { desc = "Close Window" })

vim.keymap.set({ "n", "i", "t" }, "<A-z>", function()
  Snacks.zoom()
end, { desc = "Toggle Zoom Window" })
