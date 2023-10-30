local setup_done = vim.g["quarto_setup"] or false
-- make sure single exection of the setup
if not setup_done then
  local nmap = require("lib.keymap").nmap
  local utils = require("lib.repl")
  local notify = require("lib.notify")

  -- append otter source to nvim-cmp
  local cmp = require("cmp")
  local config = cmp.get_config()
  table.insert(config.sources, { name = "otter", group_index = 1, priority = 10 })

  cmp.setup(config)

  local luasnip = require("luasnip")
  luasnip.filetype_extend("quarto", { "markdown" })
  luasnip.filetype_extend("quarto", { "python" })

  local otter_keeper = require("otter.keeper")
  local fmt_util = require("formatter.util")
  local fmt_config = require("formatter.config")
  local fmt_format = require("formatter.format")
  local fmt_log = require("formatter.log")

  local function range_format(filetype, start_line, end_line, opts)
    local modifiable = vim.bo.modifiable
    if not modifiable then
      notify.infoL("Buffer is not modifiable", "formatter")
      return
    end
    start_line = start_line - 1
    fmt_log.current_format_mods = opts and opts.smods or "verbose"
    local formatters = fmt_config.formatters_for_filetype(filetype)

    local configs_to_run = {}
    -- No formatters defined for the given file type
    if fmt_util.is_empty(formatters) then
      notify.infoL(string.format("No formatter defined for %s files", filetype), "formatter")
      return
    end
    for _, formatter_config in ipairs(formatters) do
      local formatter
      if type(formatter_config) == "table" then
        formatter = formatter_config
      else
        formatter = formatter_config()
      end
      if formatter and formatter.exe then
        table.insert(configs_to_run, { config = formatter, name = formatter.exe })
      end
    end
    fmt_format.start_task(configs_to_run, start_line, end_line, opts)
  end

  vim.api.nvim_buf_create_user_command(0, "Format", function(args)
    local filetype = args.args
    local start_line = args.line1
    local end_line = args.line2
    range_format(filetype, start_line, end_line)
  end, { range = "%", nargs = 1 })

  nmap("<leader>bf", function()
    local lang, row1, _, row2, _ = otter_keeper.get_current_language_context()
    if lang ~= nil then
      range_format(lang, row1 + 1, row2, { smods = "verbose" })
    end
  end)

  local function run_cell()
    local repl = utils.repls["Python"]
    local valid_buf = repl ~= nil and repl.bufh ~= nil and vim.api.nvim_buf_is_valid(repl.bufh)
    if not valid_buf then
      vim.notify("Python REPL doesn't exist, please launch a new REPL.", vim.log.levels.INFO)
      utils.launch_python()
    else
      vim.cmd("QuartoSend")
    end
  end
  -- cell executuon
  nmap("<S-CR>", run_cell)

  vim.g["quarto_setup"] = true
end
