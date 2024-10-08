--[[
███╗   ██╗██╗   ██╗██╗███╗   ███╗
████╗  ██║██║   ██║██║████╗ ████║
██╔██╗ ██║██║   ██║██║██╔████╔██║
██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝

Author: Yuchao
Source: https://github.com/yvchao/nvim
License: MIT License
--]]

if vim.fn.has("nvim-0.9") then
  -- use the new loader with byte-compilation cache
  vim.loader.enable()
end

-- setup notification backend
local notify = require("lib.notify")
vim.notify = notify.notify_message

-- load basic configuration
for _, module_name in ipairs({
  "core.filetypes",
  "core.options",
  "core.autocmd",
}) do
  local success, err = pcall(require, module_name)
  if not success then
    local msg = "calling module: " .. module_name .. "\nfailure: " .. err
    notify.errorL(msg)
  end
end

-- load plugin settings
require("plugins")

-- setup mappings after plugins are loaded
require("mappings")
