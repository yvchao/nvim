local M = {}

M.rg = function(args)
  local cmd = vim.fn.split(vim.o.grepprg)
  local empty_args = true
  for _, arg in ipairs(args.fargs) do
    table.insert(cmd, vim.fn.expand(arg))
    empty_args = false
  end

  if empty_args then
    local keyword = nil

    if args.bang then
      -- get the contents of the search register
      local search_pattern = vim.fn.getreg("/")

      -- remove the special characters \V, \c, \C, \m, \M, \v
      keyword = search_pattern
        :gsub("\\V", "")
        :gsub("\\c", "")
        :gsub("\\C", "")
        :gsub("\\m", "")
        :gsub("\\M", "")
        :gsub("\\v", "")
    else
      -- use WORD under cursor as search pattern
      local pattern = [[([^%[%]%(%)%{%}"]+)]]
      local non_empty_text = vim.fn.expand("<cWORD>")
      for part in non_empty_text:gmatch(pattern) do
        -- we only care about the text other than (), [], and {}
        keyword = part
        break
      end
    end

    if keyword == "" then
      -- ignore empty keyword
      return
    end
    table.insert(cmd, keyword)
  end

  local populate_qflist = function(obj)
    local stdout = obj.stdout
    -- fill qf list
    vim.fn.setqflist({}, " ", {
      title = "Grep",
      lines = vim.fn.split(stdout, "\n"),
    })
    -- show the results
    vim.cmd.cwindow()
  end

  vim.system(cmd, { text = true }, vim.schedule_wrap(populate_qflist))
end

return M
