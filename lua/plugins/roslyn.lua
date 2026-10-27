-- Solutions previously loaded by roslyn, so the choice survives restarts
local history_file = vim.fn.stdpath("state") .. "/roslyn-targets.json"

local function read_history()
  local ok, history = pcall(function()
    return vim.json.decode(table.concat(vim.fn.readfile(history_file), "\n"))
  end)
  return ok and type(history) == "table" and history or {}
end

return {
  -- Uses the `roslyn` language server installed by Mason (see mason-roslyn.lua) on both Linux and Windows.
  -- Server settings go through `vim.lsp.config("roslyn", { ... })`.
  "seblyng/roslyn.nvim",
  lazy = false,
  ---@module 'roslyn.config'
  ---@type RoslynNvimConfig
  opts = {
    -- When several solutions contain the current file, reuse the one loaded most recently
    choose_target = function(targets)
      local history = read_history()
      local chosen, last_used = nil, 0
      for _, target in ipairs(targets) do
        if (history[target] or 0) > last_used then
          chosen, last_used = target, history[target]
        end
      end
      return chosen
    end,
  },
  init = function()
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        local target = client and client.name == "roslyn" and require("roslyn.store").get(client.id)
        if target then
          local history = read_history()
          history[target] = os.time()
          vim.fn.writefile({ vim.json.encode(history) }, history_file)
        end
      end,
    })
  end,
  keys = {
    { "<leader>cT", "<cmd>Roslyn target<cr>", desc = "Select Solution (Roslyn)", ft = { "cs", "razor" } },
  },
}
