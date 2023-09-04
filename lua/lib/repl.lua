-- management of terminals inside neovim
-- adapted from https://github.com/itmecho/neoterm.nvim
local M = {}

-- repl for different languages
M.repls = {}
M.winh = nil

--- create a new vsplit window
local create_window = function()
  vim.cmd("vsplit")
  M.winh = vim.api.nvim_get_current_win()
end

local create_buffer = function(lang, cmd)
  local repl = M.repls[lang] or {}
  cmd = cmd or repl.cmd

  local name = cmd or "terminal"
  name = vim.fn.fnamemodify(name, ":t:r")
  name = lang .. "#" .. name

  local winh = M.winh
  local bufh = vim.api.nvim_create_buf(false, true)

  vim.api.nvim_win_set_buf(winh, bufh)
  vim.api.nvim_set_current_win(winh)
  if cmd ~= nil then
    vim.cmd("term" .. " " .. cmd)
  else
    vim.cmd("term")
  end
  vim.cmd("norm G") -- always focus on the last line
  vim.cmd("stopinsert") -- stop insert mode
  vim.api.nvim_buf_set_name(bufh, name)
  repl.chan = vim.b.terminal_job_id
  repl.bufh = bufh
  repl.name = name
  repl.cmd = cmd
  M.repls[lang] = repl
end

local toggle = function(lang, cmd)
  local repl = M.repls[lang] or {}
  local curr = vim.api.nvim_get_current_win()

  local close_win = false
  local link_buf = false
  local create_buf = false

  local winh = M.winh
  local target_bufh = repl.bufh

  local valid_buf = target_bufh ~= nil and vim.api.nvim_buf_is_valid(target_bufh)
  local valid_win = winh ~= nil and vim.api.nvim_win_is_valid(winh) and winh ~= curr

  if winh ~= nil and valid_win then
    local curr_bufh = vim.api.nvim_win_get_buf(winh)

    if not valid_buf then
      create_buf = true
    else
      if curr_bufh == target_bufh then
        close_win = true
      else
        link_buf = true
      end
    end
  else
    if not valid_buf then
      create_buf = true
    else
      link_buf = true
    end
  end

  -- close current window and return
  if close_win then
    vim.api.nvim_win_close(M.winh, true)
    return
  end

  if not valid_win then
    create_window()
  end

  if link_buf then
    vim.api.nvim_win_set_buf(M.winh, target_bufh)
    vim.api.nvim_set_current_win(curr)
  end

  if create_buf then
    create_buffer(lang, cmd)
    vim.api.nvim_set_current_win(curr)
  end
end

local shutdown = function(lang)
  local repl = M.repls[lang] or {}
  local bufh = repl.bufh

  if bufh ~= nil and vim.api.nvim_buf_is_valid(bufh) then
    vim.api.nvim_buf_delete(bufh, { force = true })
  end
  M.repls[lang] = nil
end

M.kill_all = function()
  for lang, _ in pairs(M.repls) do
    shutdown(lang)
  end
end

local toggle_select = function(callback)
  local repl_list = {}
  for lang, _ in pairs(M.repls) do
    table.insert(repl_list, lang)
  end

  if #repl_list < 1 then
    vim.notify("No REPL exists.", vim.log.levels.INFO)
    return
  end

  vim.ui.select(repl_list, {
    prompt = "Select a REPL to toggle",
    format_item = function(item)
      return M.repls[item].name
    end,
  }, function(item)
    if item ~= nil then
      callback(item)
    end
  end)
end

local function read_lines_from_file(filename)
  local lines = {}
  for line in io.lines(filename) do
    table.insert(lines, line)
  end
  return lines
end

local function get_python_path()
  local env_list = {}

  -- system
  if vim.fn.executable("python") == 1 then
    env_list["system"] = ""
  end

  -- conda
  local file_path = vim.env.HOME .. "/.conda/environments.txt"
  local paths = read_lines_from_file(file_path)

  for _, path in ipairs(paths) do
    local name = vim.fn.fnamemodify(path, ":t")
    env_list[name] = path
  end

  -- local venv
  if vim.fn.finddir("venv") ~= "" then
    env_list["local venv"] = vim.fn.getcwd() .. "venv"
  elseif vim.fn.finddir(".venv") ~= "" then
    env_list["local venv"] = vim.fn.getcwd() .. ".venv"
  end
  return env_list
end

M.launch_python = function(callback)
  local python_path = "/bin/python"
  local ipython_path = "/bin/ipython"
  local env_table = get_python_path()

  local env_list = {}
  local exe_list = {}
  for env, path in pairs(env_table) do
    local exe_path = path .. python_path
    if vim.fn.executable(exe_path) == 1 then
      table.insert(env_list, env)
      exe_list[env] = exe_path
    end

    exe_path = path .. ipython_path
    if vim.fn.executable(exe_path) == 1 then
      local env_name = env .. " (IPython)"
      table.insert(env_list, env_name)
      exe_list[env_name] = exe_path
    end
  end

  vim.ui.select(env_list, {
    prompt = "Select a Python interpretor",
    format_item = function(item)
      return item .. " (" .. exe_list[item] .. ")"
    end,
  }, function(item)
    if item ~= nil then
      if M.repls["Python"] ~= nil then
        shutdown("Python")
      end
      toggle("Python", exe_list[item])
      -- setup vim-slime options
      vim.b.slime_config = { jobid = M.repls["Python"].chan }
      vim.b.slime_cell_delimiter = "# %%"
      if callback ~= nil then
        callback()
      end
    end
  end)
end

M.toggle = function()
  toggle_select(toggle)
end

M.shutdown = function()
  toggle_select(shutdown)
end

local default_opts = {
  cmd = vim.o.shell or "bash",
}

M.launch = function()
  local lang_list = { "Python", "Julia", "Shell" }
  local cmd = default_opts.cmd
  vim.ui.select(lang_list, {
    prompt = "Select language of the REPL",
  }, function(lang)
    if lang == "Python" then
      M.launch_python()
    elseif lang == "Julia" then
      cmd = "julia"
      toggle("Julia", cmd)
    else
      toggle("Terminal", cmd)
    end
  end)
end

return M
