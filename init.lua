--[[
███╗   ██╗██╗   ██╗██╗███╗   ███╗
████╗  ██║██║   ██║██║████╗ ████║
██╔██╗ ██║██║   ██║██║██╔████╔██║
██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝

Author: Avimitin
Source: https://github.com/Avimitin/nvim
License: MIT License
--]]

-- load basic configuration
local notify = require("lib.notify")

-- Try to call the cache plugin
-- pcall(require, "impatient")

local ok, custom = pcall(require, "custom")
-- if file exist, return table exist and return table has `theme` field
if ok and custom then
  if custom.notify ~= "neovim" and vim.fn.executable("notify-send") == 1 then
    vim.notify = notify.notify_send
  else
    vim.notify = notify.notify_message
  end
end

for _, module_name in ipairs({
  "core.options",
  "mappings",
  "core.autocmd",
  "plugins.options",
}) do
  local success, err = pcall(require, module_name)
  if not success then
    local msg = "calling module: " .. module_name .. " fail: " .. err
    notify.errorL(msg)
  end
end

-- since we have packer compiled, we don't need to load this immediately
-- vim.defer_fn(function()
-- require("plugins").load()
-- end, 0)
require("plugins").load()
