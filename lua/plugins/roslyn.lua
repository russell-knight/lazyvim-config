return {
  "seblyng/roslyn.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    -- Detect OS for cross-platform compatibility
    local is_windows = vim.uv.os_uname().sysname == "Windows_NT"

    -- Platform-specific Roslyn DLL path
    local roslyn_dll
    if is_windows then
      -- Windows: Manual installation
      roslyn_dll =
        "C:\\Users\\Russell\\.roslyn\\Microsoft.CodeAnalysis.LanguageServer.win-x64.5.3.0-2.25553.7\\lib\\net9.0\\Microsoft.CodeAnalysis.LanguageServer.dll"
    else
      -- Linux/WSL: Mason installation
      roslyn_dll = vim.fn.stdpath("data") .. "/mason/packages/roslyn/libexec/Microsoft.CodeAnalysis.LanguageServer.dll"
    end

    -- Cross-platform log directory (uses nvim's data directory)
    local log_dir = vim.fn.stdpath("data")

    require("roslyn").setup({
      cmd = {
        "dotnet",
        roslyn_dll,
        "--logLevel",
        "Information",
        "--extensionLogDirectory",
        log_dir,
        "--stdio",
      },
      enable_editorconfig_support = true,
      root_dir = require("lspconfig.util").root_pattern("*.sln", "*.csproj"),
    })
  end,
}
