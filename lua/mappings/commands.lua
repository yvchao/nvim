local alias = require("lib.misc").alias
local map = require("lib.keymap").map

-- debug function
alias("DapBreakpoint", [[lua require("dap").toggle_breakpoint()]])
alias("DapContinue", [[lua require("dap").continue()]])
alias("DapStepOver", [[lua require("dap").step_over()]])

-- Crate.nvim
alias("CrateUpdate", [[lua require("crates").update_crate()]])
alias("CrateUpgrade", [[lua require("crates").upgrade_crate()]])
alias("CrateMenu", [[lua require("crates").show_popup()]])
alias("CrateReload", [[lua require("crates").reload()]])

-- format
alias("Format", [[lua require("conform").format({async = true})]])

alias("LightToggle", function()
  if vim.o.background == "dark" then
    vim.o.background = "light"
  else
    vim.o.background = "dark"
  end
end)

-- Capture command output in a temporary buffer
alias("Nredir", function(args)
  require("lib.nredir").nredir(args.args)
end, { nargs = 1, complete = "command" })

-- Better grep
alias("Grep", function(args)
  require("lib.grep").rg(args)
end, { nargs = "*", complete = "file_in_path", bar = true, bang = true })
-- cmdline abbreviation
map("ca", "grep", function()
  if vim.fn.getcmdtype() == ":" and vim.fn.getcmdline() == "grep" then
    return "Grep"
  else
    return "grep"
  end
end, { expr = true, silent = false }) -- we need the option "silent=false" here to make sure that the change is instantly reflected

-- check plugins that uses lots of memory
alias("DebugMemory", function()
  require("lib.utility").check_memory_usage()
end)

-- Copy text to clipboard using codeblock format ```{ft}{content}```
alias("CopyCodeBlock", function(opts)
  local lines = vim.api.nvim_buf_get_lines(0, opts.line1 - 1, opts.line2, true)
  local content = table.concat(lines, "\n")
  local result = string.format("```%s\n%s\n```", vim.bo.filetype, content)
  vim.fn.setreg("+", result)
  vim.notify("Text copied to clipboard")
end, { range = true })
