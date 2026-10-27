return {
  {
    "mfussenegger/nvim-dap",
    dependencies = { "rcarriga/nvim-dap-ui" },
    opts = function()
      local dap = require("dap")
      -- The `netcoredbg` adapter is set up by the lang.dotnet extra; this only replaces the C# configurations
      dap.configurations.cs = {
        {
          type = "netcoredbg",
          name = "Launch .NET project",
          request = "launch",
          program = function()
            -- Default to the project DLL for whatever target framework has been built
            local cwd = vim.fn.getcwd()
            local proj = vim.fn.fnamemodify(cwd, ":t")
            local dlls = vim.fn.glob(cwd .. "/bin/Debug/net*/" .. proj .. ".dll", false, true)
            local default = dlls[#dlls] or (cwd .. "/bin/Debug/")
            return vim.fn.input("Path to dll: ", default, "file")
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
          type = "netcoredbg",
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
