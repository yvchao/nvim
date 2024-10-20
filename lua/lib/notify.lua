local M = {}

-- errorL notify a message in error level
-- @msg: logging message
-- @title: the logging title
M.errorL = function(msg, title)
  vim.notify(msg, vim.log.levels.ERROR, {
    title = title,
  })
end

-- infoL notify a message in info level
-- @msg: logging message
-- @title: the logging title
M.infoL = function(msg, title)
  vim.notify(msg, vim.log.levels.INFO, {
    title = title,
  })
end

--Collection of notification system implementations.
local log_level_to_urgency = {
  [vim.log.levels.TRACE] = "low",
  [vim.log.levels.DEBUG] = "low",
  [vim.log.levels.INFO] = "low",
  [vim.log.levels.WARN] = "normal",
  [vim.log.levels.ERROR] = "critical",
}

--Send notifications through the `notify-send` command line application.
M.notify_send = function(msg, log_level, opts)
  log_level = log_level or 3
  opts = opts or {}
  local title = opts.title
  local timeout = opts.timeout
  local urgency = log_level_to_urgency[log_level] or "normal"

  local command = { "notify-send", "--urgency", urgency, "--icon", "nvim", "--app-name", "Neovim" }
  if timeout then
    vim.list_extend(command, { "-t", string.format("%d", timeout * 1000) })
  end
  if title then
    vim.list_extend(command, { title, msg })
  else
    vim.list_extend(command, { msg })
  end

  vim.fn.system(command)
end

-- TODO: popup message for warning and error, silent for info
M.notify_message = function(msg, level, opts) -- luacheck: no unused args
  opts = opts or {}
  local title = opts.title or "message"
  local top = "-------- " .. title .. " --------\n"
  local bottom = "\n" .. string.rep("-", 18 + vim.fn.strdisplaywidth(title))
  if level == vim.log.levels.ERROR then
    vim.api.nvim_echo(
      { { top, "ErrorMsg" }, { msg, "ErrorMsg" }, { bottom, "ErrorMsg" } },
      true,
      {}
    )
  elseif level == vim.log.levels.WARN then
    vim.api.nvim_echo(
      { { top, "WarningMsg" }, { msg, "WarningMsg" }, { bottom, "WarningMsg" } },
      true,
      {}
    )
  else
    -- vim.api.nvim_echo({ { top }, { msg }, { bottom } }, true, {})
    vim.api.nvim_echo({ { msg } }, true, {})
  end
end

return M
