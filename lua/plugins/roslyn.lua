return {
  "seblyng/roslyn.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("roslyn").setup({
      cmd = {
        "dotnet",
        "C:\\Users\\Russell\\.roslyn\\Microsoft.CodeAnalysis.LanguageServer.win-x64.5.3.0-2.25553.7\\lib\\net9.0\\Microsoft.CodeAnalysis.LanguageServer.dll",
        "--logLevel",
        "Information",
        "--extensionLogDirectory",
        "C:/Users/Russell/AppData/Local/nvim-data",
        "--stdio",
      },
      enable_editorconfig_support = true,
      root_dir = require("lspconfig.util").root_pattern("*.sln", "*.csproj"),
    })
  end,
}
