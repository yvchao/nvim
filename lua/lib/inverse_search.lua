-- function TexlabInverseSearch(filename, line)
--   local serverlists =
--     vim.fn.system([[ bash -c "find ${XDG_RUNTIME_DIR:-${TMPDIR}nvim.${USER}}/nvim* -type s" ]])
--   local servers = vim.split(serverlists, "\n")
--   local cmd = string.format(':lua TexlabPerformInverseSearch("%s", %d)', filename, line)
--   for _, server in ipairs(servers) do
--     local ok, socket = pcall(vim.fn.sockconnect, "pipe", server, { rpc = true })
--     if ok then
--       vim.rpcrequest(socket, "nvim_command", cmd)
--       vim.fn.chanclose(socket)
--     end
--   end
-- end

-- Helper function to find a window that contains the target buffer in a given tabpage.
local function find_window_in_tab(tab, buffer)
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
    if vim.api.nvim_win_get_buf(win) == buffer then
      return win
    end
  end
  return nil
end

local function texlab_running()
  local active_clients = vim.lsp.get_active_clients()
  for _, client in pairs(active_clients) do
    if client and client.name == "texlab" then
      return true
    end
  end
  return false
end

-- Note that the function has to be public.
local function texlab_perform_inversesearch(filename, line)
  -- Check if Texlab is running in this instance.
  if not texlab_running() then
    return
  end
  filename = vim.fn.resolve(filename)
  local buf = vim.fn.bufnr(filename)

  local target_win = vim.api.nvim_get_current_win()
  local target_tab = vim.api.nvim_get_current_tabpage()

  -- If the buffer is not loaded, load it and open it in the current window.
  if not vim.api.nvim_buf_is_loaded(buf) then
    buf = vim.fn.bufadd(filename)
    vim.fn.bufload(buf)
  else
    -- Search buffer, starting from the current tab.
    target_win = find_window_in_tab(target_tab, buf)

    if target_win == nil then
      -- Search all tabs and use the first one.
      for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
        target_win = find_window_in_tab(tab, buf)
        if target_win ~= nil then
          target_tab = tab
          break
        end
      end
    end
  end

  target_win = target_win or vim.api.nvim_get_current_win()
  target_tab = target_tab or vim.api.nvim_get_current_tabpage()

  -- Switch to target tab, window, and set cursor.
  vim.api.nvim_set_current_tabpage(target_tab)
  vim.api.nvim_set_current_win(target_win)
  vim.api.nvim_win_set_buf(target_win, buf)

  local last_line = vim.fn.line("$")
  if line <= last_line then
    vim.api.nvim_win_set_cursor(target_win, { line, 0 })
  end
end

return {
  inverse_search = texlab_perform_inversesearch,
}
