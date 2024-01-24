local setup_done = vim.b["quarto_setup"]
-- make sure single exection of the setup
if not setup_done then
  -- append otter source to nvim-cmp
  local cmp = require("cmp")
  local config = cmp.get_config()
  table.insert(config.sources, { name = "otter", group_index = 1, priority = 10 })
  cmp.setup(config)

  local luasnip = require("luasnip")
  luasnip.filetype_extend("quarto", { "markdown" })
  luasnip.filetype_extend("quarto", { "python" })

  local otterkeeper = require("otter.keeper")

  local function run_cell()
    local buf = vim.api.nvim_get_current_buf()
    otterkeeper.sync_raft(buf)
    local lang, row1, _, row2, _ = otterkeeper.get_current_language_context()
    if lang ~= "python" then
      vim.print("[Quarto] Not a Python code cell.")
      return
    end
    if require("molten.status").initialized() ~= "Molten" then
      vim.notify("Jupyter kernel is not initialized.", vim.log.levels.INFO)
    end
    vim.fn.MoltenEvaluateRange(row1 + 1, row2)
  end

  local opts = {
    buffer = true,
    noremap = true,
    silent = true,
  }
  -- cell executuon
  opts["desc"] = "run cell [Jupyter]"
  vim.keymap.set("n", "<S-CR>", run_cell, opts)
  opts["desc"] = "next cell [Jupyter]"
  vim.keymap.set("n", "]c", "<cmd>MoltenNext<CR>", opts)
  opts["desc"] = "prev cell [Jupyter]"
  vim.keymap.set("n", "[c", "<cmd>MoltenPrev<CR>", opts)

  -- disable lsp-overloads
  local settings = require("lsp-overloads.settings")
  settings.set({ display_automatically = false })

  vim.b["quarto_setup"] = true
end
