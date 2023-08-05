local g = vim.g

g.loaded_netrw = 1
g.loaded_netrwPlugin = 1

-- for vsnip
g.vsnip_snippet_dir = vim.fn.expand("~/.config/nvim/vsnip")

-- for wildfire
g.wildfire_objects = { "i'", 'i"', "i)", "i]", "i}", "ip", "it", "i`" }

g.rooter_manual_only = 1
g.rooter_change_directory_for_non_project_files = "current"
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
