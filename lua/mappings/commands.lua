local alias = require("lib.misc").alias

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

alias("Nredir", function(args)
  require("lib.nredir").nredir(args.args)
end, { nargs = 1, complete = "command" })

alias("Grep", function(args)
  require("lib.grep").rg(args.fargs)
end, { nargs = "*", complete = "file_in_path", bar = true })

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
