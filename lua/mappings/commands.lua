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

-- nvim-spectre
-- alias("SpectreOpen", "lua require('spectre').open()")

-- lsp_lines
-- alias("LspLineToggle", [[lua require("lsp_lines").toggle()]])

alias("HiCurLine", [[call matchadd('HighlightLineMatches', '\%'.line('.').'l')]])
alias("HiCurLineOff", [[call clearmatches()]])

-- format
alias("Format", [[lua require("conform").format({async = true})]])

-- repl
-- alias("REPLLaunch", function()
--   require("lib.repl").launch()
-- end)
--
-- alias("REPLToggle", function()
--   require("lib.repl").toggle()
-- end)
--
-- alias("REPLKill", function()
--   require("lib.repl").shutdown()
-- end)
--
-- alias("REPLKillAll", function()
--   require("lib.repl").kill_all()
-- end)
