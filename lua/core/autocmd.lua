-- use relativenumber when editing
-- vim.cmd([[ au InsertEnter * set norelativenumber ]])
-- vim.cmd([[ au InsertLeave * set relativenumber ]])
vim.api.nvim_create_autocmd("InsertEnter", { pattern = "*", command = [[set norelativenumber]] })
vim.api.nvim_create_autocmd("InsertLeave", { pattern = "*", command = [[set relativenumber]] })

-- auto compile when editing the load.lua file
-- vim.cmd([[autocmd BufWritePost load.lua source <afile> | PackerCompile]])
-- vim.api.nvim_create_autocmd(
--   "BufWritePost",
--   { pattern = "load.lua", command = [[source <afile> | PackerCompile]] }
-- )

-- start insert when enter the terminal
-- vim.cmd("autocmd TermOpen term://* startinsert")
vim.api.nvim_create_autocmd("TermOpen", { pattern = "term://*", command = "startinsert" })

local utils = require("core.utils")
-- auto config font with remote ui
vim.api.nvim_create_autocmd("UIEnter", {
  callback = function()
    if vim.v.event.chan > 1 then
      vim.o.guifont = "Iosevka Fixed SS14:h12"
      vim.notify = utils.notify_message
      -- if vim.g.loaded_clipboard_provider then
      --   vim.g.neovide_no_custom_clipboard = false
      --   vim.g.loaded_clipboard_provider = nil
      --   vim.api.nvim_cmd( { cmd = 'runtime', args = { 'autoload/provider/clipboard.vim' } }, {} )
      -- end
    end
  end,
})
