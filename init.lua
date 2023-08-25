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
local utils = require("core.utils")

-- Try to call the cache plugin
-- pcall(require, "impatient")

local ok, custom = pcall(require, "custom")
-- if file exist, return table exist and return table has `theme` field
if ok and custom then
  if custom.notify == "system" and vim.fn.executable("notify-send") == 1 then
    vim.notify = utils.notify_send
  else
    vim.notify = utils.notify_message
  end
end

for _, module_name in ipairs({
  "core.options",
  "mappings",
  "core.commands",
  "core.autocmd",
  "plugins.options",
}) do
  local ok, err = pcall(require, module_name)
  if not ok then
    local msg = "calling module: " .. module_name .. " fail: " .. err
    utils.errorL(msg)
  end
end

-- since we have packer compiled, we don't need to load this immediately
-- vim.defer_fn(function()
-- require("plugins").load()
-- end, 0)
require("plugins").load()
