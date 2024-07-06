local M = {}

M.rg = function(args)
  local cmd_arg = vim.fn.expandcmd(table.concat(args, " "))
  if cmd_arg == "" then
    cmd_arg = vim.fn.expand("<cword>")
  end

  -- parse command
  local cmd = vim.o.grepprg .. cmd_arg

  -- fill qf list
  vim.fn.setqflist({}, " ", {
    title = "Grep",
    lines = vim.fn.systemlist(cmd),
  })
  -- show the results
  vim.cmd.cwindow()
end

return M
