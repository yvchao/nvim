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

if vim.fn.has("nvim-0.9") then
  -- use the new loader with byte-compilation cache
  vim.loader.enable()
end

-- setup notification backend
local notify = require("lib.notify")

local ok, custom = pcall(require, "custom")
if ok and custom then
  if custom.notify ~= "neovim" and vim.fn.executable("notify-send") == 1 then
    vim.notify = notify.notify_send
  else
    vim.notify = notify.notify_message
  end
end

-- load basic configuration
for _, module_name in ipairs({
  "core.autocmd",
  "core.filetypes",
  "core.options",
  "core.plugin_options",
}) do
  local success, err = pcall(require, module_name)
  if not success then
    local msg = "calling module: " .. module_name .. " fail: " .. err
    notify.errorL(msg)
  end
end

-- load plugin settings
require("plugins").load()

-- setup mappings after plugins are loaded
require("mappings")
