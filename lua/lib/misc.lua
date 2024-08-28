local M = {}

local special_buffer_list = vim.g.special_buffer_list or {}

-- speed up the lookup of special buffer type
for _, v in ipairs(special_buffer_list) do
  special_buffer_list[v] = true
end

M.is_special_buffer = function(ft)
  return special_buffer_list[ft] ~= nil
end

-- scroll target buffer to end (set cursor to last line)
M.scroll_to_end = function(bufnr)
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

local function is_floating_win(winid)
  winid = winid or 0
  if vim.api.nvim_win_get_config(winid).zindex ~= nil then
    return true
  else
    return false
  end
end

local function get_next_buf(bufnr)
  -- get all valid buffers
  local buffers = vim.tbl_filter(function(buf)
    return vim.api.nvim_get_option_value("buflisted", { buf = buf })
  end, vim.api.nvim_list_bufs())
  local idx_cur = 1
  local buf_num = 0
  for i, buf in ipairs(buffers) do
    buf_num = buf_num + 1
    if bufnr == buf then
      idx_cur = i
    end
  end

  if buf_num < 2 then
    -- no next buffer
    return nil
  end

  local buf_next = nil
  local idx_next = nil
  for i = 0, buf_num - 2 do
    idx_next = (idx_cur + i) % buf_num + 1
    buf_next = buffers[idx_next]
    local ft = vim.api.nvim_get_option_value("filetype", { buf = buf_next })
    if ft and not M.is_special_buffer(ft) then
      return buf_next
    end
  end
end

local function switch_buffer(windows, bufnr)
  local cur_win = vim.fn.winnr()
  for _, winid in ipairs(windows) do
    vim.cmd(string.format("%d wincmd w", vim.fn.win_id2win(winid)))
    vim.cmd(string.format("buffer %d", bufnr))
  end
  vim.cmd(string.format("%d wincmd w", cur_win))
end

M.buffer_delete = function(force)
  -- save current buffer number
  local bufnr = vim.fn.bufnr()
  local next_buf = nil

  -- ignore unlisted buffer and close the window
  if vim.fn.buflisted(bufnr) == 0 then
    vim.cmd.close()
    return
  end

  -- check if buffer has special filetype
  local ft = vim.api.nvim_get_option_value("filetype", { buf = bufnr })
  if M.is_special_buffer(ft) then
    -- close window for special buffers
    vim.cmd.close()
  else
    -- find next valid buffer
    next_buf = get_next_buf(bufnr)
  end

  -- delete buffer while preserving window layout
  local windows = vim.fn.getbufinfo(bufnr)[1].windows
  if next_buf == nil then
    -- create an empty buffer
    next_buf = vim.api.nvim_create_buf(false, true)
  end

  switch_buffer(windows, next_buf)
  if force or vim.fn.getbufvar(bufnr, "&buftype") == "terminal" then
    -- force deletion of terminal buffers
    vim.cmd(string.format("bd! %d", bufnr))
  else
    -- delete current buffer
    vim.cmd(string.format("silent! confirm bd %d", bufnr))
  end

  -- revert buffer switches if deletion was cancelled
  if vim.fn.buflisted(bufnr) == 1 then
    switch_buffer(windows, bufnr)
  end
end

M.buffer_jump = function(direction)
  -- default to forward jump
  if direction ~= -1 then
    direction = 1
  end

  if is_floating_win() then
    -- don't jump in floating windows
    vim.notify("Cannot switch to other buffers from a floating window!", vim.log.levels.INFO)
    return
  end

  if M.is_special_buffer(vim.bo.ft) then
    -- don't jump from special buffers
    vim.notify("Cannot switch to other buffers from a special buffer!", vim.log.levels.INFO)
    return
  end

  local buf_cur = vim.api.nvim_get_current_buf()

  -- get all valid buffers
  local buffers = vim.tbl_filter(function(buf)
    return vim.api.nvim_buf_is_valid(buf)
      and vim.api.nvim_get_option_value("buflisted", { buf = buf })
  end, vim.api.nvim_list_bufs())

  local buf_num = #buffers
  if buf_num == 1 then
    vim.notify("There is only one buffer!", vim.log.levels.INFO)
  end
  local idx_cur = nil
  for i, buf_id in ipairs(buffers) do
    if buf_id == buf_cur then
      idx_cur = i
      break
    end
  end
  if idx_cur == nil then
    -- vim.notify("Current buffer is invalid!", vim.log.levels.INFO)
    return
  end

  local buf_next = nil
  local buf_idx = nil
  for i = 1, buf_num do
    -- vim.print({ cur = idx_cur, next = idx_cur + i * direction, num = buf_num })
    buf_idx = (idx_cur + i * direction) % buf_num
    if buf_idx == 0 then
      buf_next = buffers[buf_num]
    else
      buf_next = buffers[buf_idx]
    end
    local ft = vim.api.nvim_get_option_value("filetype", { buf = buf_next })
    if ft and not M.is_special_buffer(ft) then
      vim.api.nvim_set_current_buf(buf_next)
      return
    end
  end
end

M.is_cmdline = function()
  local cmdwintype = vim.fn.getcmdwintype()
  return cmdwintype ~= ""
end

-- alias can help create new vim command.
-- @param cmd The user command
-- @param repl The actual command or function
-- @param opts The table of options
M.alias = function(cmd, repl, opts)
  local options = {
    bang = false,
  }
  if opts and type(opts) == "table" then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_create_user_command(cmd, repl, options)
end

-- ---@return string|nil
-- local function get_visual_text()
--   local _, start_row, start_col, _ = vim.fn.getpos("'<")
--   local _, end_row, end_col, _ = vim.fn.getpos("'>")
--   if start_row ~= end_row then
--     vim.notify("Only single line text is valid for grep!", vim.log.levels.INFO)
--     return nil
--   end
--
--   -- or use api.nvim_buf_get_lines
--   ---@cast start_row integer
--   local line = vim.fn.getline(start_row)
--   ---@cast start_col integer
--   return line:sub(start_col, end_col)
-- end

-- local function resolve()
--   local current_file = vim.fn.expand("%:p")
--   local current_dir
--   -- if file is a symlinks
--   if vim.fn.getftype(current_file) == "link" then
--     local real_file = vim.fn.resolve(current_file)
--     current_dir = vim.fn.fnamemodify(real_file, ":h")
--   else
--     current_dir = vim.fn.expand("%:p:h")
--   end
--   return current_dir
-- end

return M
