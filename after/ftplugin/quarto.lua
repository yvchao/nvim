local setup_done = vim.g["quarto_setup"] or false
-- make sure single exection of the setup
if not setup_done then
  local nmap = require("lib.keymap").nmap
  local utils = require("lib.repl")

  -- append otter source to nvim-cmp
  local cmp = require("cmp")
  local config = cmp.get_config()
  table.insert(config.sources, { name = "otter", group_index = 1, priority = 10 })

  cmp.setup(config)

  local luasnip = require("luasnip")
  luasnip.filetype_extend("quarto", { "markdown" })
  luasnip.filetype_extend("quarto", { "python" })

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
