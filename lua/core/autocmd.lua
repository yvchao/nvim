-- use relativenumber when editing
vim.api.nvim_create_autocmd("InsertEnter", { pattern = "*", command = [[set norelativenumber]] })
vim.api.nvim_create_autocmd("InsertLeave", { pattern = "*", command = [[set relativenumber]] })

-- hide command line
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
    end
  end,
})

-- automatically update color palette
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = require("lib.palette").update_palette,
})

-- sync terminal background color
-- https://www.reddit.com/r/neovim/comments/1ehidxy/you_can_remove_padding_around_neovim_instance/
vim.api.nvim_create_autocmd({ "UIEnter", "ColorScheme" }, {
  callback = function()
    local normal = vim.api.nvim_get_hl(0, { name = "Normal" })
    if not normal.bg then
      return
    end
    io.write(string.format("\027]11;#%06x\027\\", normal.bg))
  end,
})

vim.api.nvim_create_autocmd("UILeave", {
  callback = function()
    io.write("\027]111\027\\")
  end,
})
