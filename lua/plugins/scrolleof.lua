return {
  {
    -- Apply scrolloff past the end of the file so the last line isn't pinned to the bottom
    "Aasim-A/scrollEOF.nvim",
    event = { "CursorMoved", "WinScrolled" },
    opts = {},
  },
}
