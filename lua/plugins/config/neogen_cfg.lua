local config = {
  snippet_engine = "luasnip",
  languages = {
    python = {
      template = { annotation_convention = "numpydoc" },
    },
    lua = {
      template = { annotation_convention = "emmylua" },
    },
  },
}

require("neogen").setup(config)
