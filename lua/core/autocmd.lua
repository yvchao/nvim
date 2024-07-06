-- use relativenumber when editing
vim.api.nvim_create_autocmd("InsertEnter", { pattern = "*", command = [[set norelativenumber]] })
vim.api.nvim_create_autocmd("InsertLeave", { pattern = "*", command = [[set relativenumber]] })
-- vim.api.nvim_create_autocmd("RecordingEnter", { pattern = "*", command = [[set cmdheight=1]] })
-- vim.api.nvim_create_autocmd("RecordingLeave", { pattern = "*", command = [[set cmdheight=0]] })

-- start insert when enter the terminal
vim.api.nvim_create_autocmd("TermOpen", { pattern = "term://*", command = "startinsert" })

-- auto config font with remote ui
vim.api.nvim_create_autocmd("UIEnter", {
  callback = function()
    if vim.v.event.chan > 1 then
      local ok, custom = pcall(require, "custom")
      if ok then
        vim.o.guifont = custom.guifont or nil
      end
      vim.notify = require("lib.notify").notify_message
      -- if vim.g.loaded_clipboard_provider then
      --   vim.g.loaded_clipboard_provider = nil
      --   vim.api.nvim_cmd({ cmd = "runtime", args = { "autoload/provider/clipboard.vim" } }, {})
      -- end
    end
  end,
})

-- automatically update color palette
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = require("lib.palette").update_palette,
})
