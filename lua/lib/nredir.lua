-- copied from https://github.com/sbulav/nredir.nvim/blob/main/lua/nredir.lua

local nmap = require("lib.keymap").nmap
local M = {
  buf = nil,
  win = nil,
  filetype = "nredir",
  command = "Nredir",
}

local function removeAscii(text)
  for k, v in pairs(text) do
    -- Remove all the ansi escape characters
    text[k] = string.gsub(v, "[\27\155][][()#;?%d]*[A-PRZcf-ntqry=><~]", "")
  end
  return text
end

local function starts_with(str, start)
  return str:sub(1, #start) == start
end

M.close = function()
  if M.win and vim.api.nvim_win_is_valid(M.win) then
    vim.api.nvim_win_close(M.win, true)
    M.win = nil
  end
end

M.execute = function(cmd)
  local result = {}

  if starts_with(cmd, "!") then
    -- System command
    result = removeAscii(vim.fn.systemlist(string.sub(cmd, 2)))
  else
    -- Vim EX command
    result = vim.fn.split(vim.fn.execute(cmd), "\n")
  end

  vim.api.nvim_buf_set_option(M.buf, "modifiable", true)

  vim.api.nvim_buf_set_lines(M.buf, 0, -1, false, result)
  vim.api.nvim_buf_set_option(M.buf, "modifiable", false)
end

M.create_win = function()
  vim.api.nvim_command("botright new")
  M.win = vim.api.nvim_get_current_win()
  M.buf = vim.api.nvim_get_current_buf()

  vim.api.nvim_buf_set_name(0, "result #" .. M.buf)

  vim.api.nvim_buf_set_option(0, "buftype", "nofile")
  vim.api.nvim_buf_set_option(0, "swapfile", false)
  vim.api.nvim_buf_set_option(0, "filetype", M.filetype)
  vim.api.nvim_buf_set_option(0, "bufhidden", "wipe")

  vim.api.nvim_command("setlocal wrap")
  vim.api.nvim_command("setlocal cursorline")

  nmap("q", M.close, { buffer = M.buf })
end

M.nredir = function(cmd)
  -- This situation is impossible since we use the `-nargs = 1` option
  -- if cmd == nil or cmd == "" then
  --   vim.notify("Attempt to execute empty command!", vim.log.levels.WARN)
  --   return
  -- end

  if starts_with(cmd, '"') or starts_with(cmd, '!"') then
    vim.notify("Attempt to execute string as a command!", vim.log.levels.WARN)
    return
  end

  if starts_with(cmd, M.command) then
    vim.notify("Recursive call to " .. M.command .. " is not allowed!", vim.log.levels.WARN)
    return
  end

  if M.win and vim.api.nvim_win_is_valid(M.win) then
    vim.api.nvim_set_current_win(M.win)
  else
    M.create_win()
  end

  M.execute(cmd)
end

return M
