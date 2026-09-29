return {
  {
    "mfussenegger/nvim-dap",
    dependencies = { "rcarriga/nvim-dap-ui" },
    opts = function()
      local dap = require("dap")
      dap.adapters.coreclr = {
        type = "executable",
        command = vim.fn.exepath("netcoredbg"),
        args = { "--interpreter=vscode" },
      }
      dap.configurations.cs = {
        {
          type = "coreclr",
          name = "Launch .NET project",
          request = "launch",
          program = function()
            -- Default to the project DLL in the current directory
            local cwd = vim.fn.getcwd()
            local proj = vim.fn.fnamemodify(cwd, ":t")
            return vim.fn.input("Path to dll: ", cwd .. "/bin/Debug/net9.0/" .. proj .. ".dll", "file")
          end,
          cwd = function()
            return vim.fn.getcwd()
          end,
          env = {
            ASPNETCORE_ENVIRONMENT = "Development",
          },
          stopAtEntry = false,
        },
        {
          type = "coreclr",
          name = "Attach to process",
          request = "attach",
          processId = function()
            -- Filter to only show dotnet app processes (excludes the dotnet run wrapper)
            local proj = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
            return require("dap.utils").pick_process({ filter = proj })
          end,
        },
      }
    end,
  },
}
