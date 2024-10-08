local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- install lazy.nvim if not exists
---@diagnostic disable-next-line: undefined-field
if vim.uv.fs_stat(lazypath) == nil then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

-- configure plugins
require("lazy").setup({
  { import = "plugins.styles" },
  { import = "plugins.editor" },
  { import = "plugins.gittools" },
  { import = "plugins.devtools" },
}, {
  change_detection = {
    enabled = false, -- disable change detection since there are bug reports about it causing memory leaking
    notify = false,
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
