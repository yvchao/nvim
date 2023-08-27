local g = vim.g

g.loaded_netrw = 1
g.loaded_netrwPlugin = 1

-- for vsnip
g.vsnip_snippet_dir = vim.fn.expand("~/.config/nvim/vsnip")

g.rooter_manual_only = 0
-- g.rooter_change_directory_for_non_project_files = "current"
g.rooter_buftypes = { "" }
g.rooter_patterns = {
  ".git",
  "Cargo.toml",
  "package.json",
  "tsconfig.json",
}

-- enable treesitter for what filetype?
g.enable_treesitter_ft = {
  "c",
  "comment",
  "cpp",
  "go",
  "javascript",
  "json",
  "lua",
  "rust",
  "toml",
  "python",
  "markdown",
  "latex",
}

-- enable lspconfig for what filetype?
g.enable_lspconfig_ft = {
  "text",
  "bash",
  "c",
  "cpp",
  "go",
  "html",
  "javascript",
  "json",
  "lua",
  "python",
  "sh",
  "toml",
  "tex",
  "markdown",
  "gitcommit",
}
