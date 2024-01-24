require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "isort", "black" },
    rust = { "rustfmt" },
    quarto = { "injected" },
    ["_"] = { "trim_whitespace" },
  },
  formatters = {
    rustfmt = {
      extra_args = { "--edition", "2021" },
    },
  },
  -- format_on_save = { timeout_ms = 600, lsp_fallback = true },
  format_after_save = { lsp_fallback = true },
})
