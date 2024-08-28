-- local utils = require("core.utils")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

local function has_lazy()
  return vim.uv.fs_stat(lazypath) ~= nil
end

local function install_lazy()
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

-- ======================================================
-- public functions
-- ======================================================
local M = {}

-- load will try to detect the packer installation status.
-- It will automatically install packer to the install_path.
-- Then it will called the setup script to setup all the plugins.
M.load = function()
  if not has_lazy() then
    install_lazy()
  end

  vim.opt.rtp:prepend(lazypath)
  require("lazy").setup("plugins.specs", {
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
end

M.load_cfg = function(file)
  local prefix = "plugins.config."
  require(prefix .. file)
end

return M
-- vim: foldmethod=marker
