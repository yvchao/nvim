-- scroll target buffer to end (set cursor to last line)
local function scroll_to_end(bufnr)
  local cur_win = vim.api.nvim_get_current_win()

  -- switch to buf and set cursor
  vim.api.nvim_buf_call(bufnr, function()
    local target_win = vim.api.nvim_get_current_win()
    vim.api.nvim_set_current_win(target_win)

    -- local target_line = vim.tbl_count(vim.api.nvim_buf_get_lines(0, 0, -1, true))
    local target_line = vim.fn.line("$")
    vim.api.nvim_win_set_cursor(target_win, { target_line, 0 })
  end)

  -- return to original window
  vim.api.nvim_set_current_win(cur_win)
end

local function is_cmdline()
  local cmdwintype = vim.fn.getcmdwintype()
  return cmdwintype ~= ""
end

-- alias can help create new vim command.
-- @param cmd The user command
-- @param repl The actual command or function
-- @param force force create command? boolean
local alias = function(cmd, repl, force)
  vim.api.nvim_create_user_command(cmd, repl, { bang = force })
end

return {
  scroll_to_end = scroll_to_end,
  alias = alias,
  is_cmdline = is_cmdline,
}
