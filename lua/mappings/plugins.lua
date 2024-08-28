local map = require("lib.keymap").map
local nmap = require("lib.keymap").nmap
local is_cmdline = require("lib.misc").is_cmdline
local create_menu = require("lib.utility").create_menu

-- filter diagnostics by severity levels
local show_loclist = function()
  vim.ui.select(vim.diagnostic.severity, {
    prompt = "Select the severity",
    format_item = function(item)
      return item
    end,
  }, function(item)
    -- vim.diagnostic.setloclist({ severity = { min = vim.diagnostic.severity[item] } })
    vim.diagnostic.setloclist({ severity = vim.diagnostic.severity[item] })
  end)
end

local lsp_methods = {
  ["Goto declaration"] = vim.lsp.buf.declaration,
  ["Goto definition"] = vim.lsp.buf.definition,
  ["Goto type definition"] = vim.lsp.buf.type_definition,
  ["Goto implementation"] = vim.lsp.buf.implementation,
  ["Hover documentation"] = vim.lsp.buf.hover,
  ["Show signature help"] = vim.lsp.buf.signature_help,
  ["Rename symbol"] = vim.lsp.buf.rename,
  ["Code action"] = vim.lsp.buf.code_action,
  ["Show references"] = vim.lsp.buf.references,
  ["Format code"] = function()
    vim.lsp.buf.format({ async = true })
  end,
  ["Add workspace folder"] = vim.lsp.buf.add_workspace_folder,
  ["Remove workspace folder"] = vim.lsp.buf.remove_workspace_folder,
  ["List workspace folders"] = function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end,
  ["View document symbols"] = [[lua require("fzf-lua").lsp_document_symbols()]],
}

-- lsp menus
map("n", "<leader>l", create_menu(lsp_methods, "Select an LSP call"), { desc = "make LSP calls" })

-- diagnostics
map("n", "gd", show_loclist, { desc = "open diagnostic list" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "goto next diagnostic" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "goto previous diagnostic" })

-- EasyAlign
map("v", "<leader>e", "<cmd>EasyAlign<CR>")

-- oil file management
nmap(";t", "<cmd>Oil %:p:h<CR>")

-- oil is easier to use compared to mini.files
-- nmap(
--   ";t",
--   [[<cmd>lua MiniFiles.open(vim.fn.expand("%:p"), {use_latest = false})<CR>]],
--   { desc = "MiniFiles" }
-- )

-- fterm
nmap("<C-\\>", [[<cmd>ToggleTerm direction=float<CR>]])
nmap("<C-`>", [[<cmd>ToggleTerm direction=horizontal<CR>]])
map("t", "<C-\\>", [[<C-\><C-n><cmd>ToggleTerm<CR>]])
map("t", "<C-n>", [[<C-\><C-n>]])

-- telescope
-- nmap(
--   "<leader>ff",
--   [[<cmd>lua require("telescope.builtin").find_files({ previewer = false })<CR>]],
--   { desc = "find files" }
-- )
-- nmap(
--   "<leader>fg",
--   [[<cmd>lua require("telescope.builtin").live_grep({})<CR>]],
--   { desc = "live grep" }
-- )

-- fzf
nmap("<leader>ff", [[<cmd>lua require('fzf-lua').files()<CR>]], { desc = "File grep" })
nmap("<leader>fg", [[<cmd>lua require('fzf-lua').live_grep()<CR>]], { desc = "Live grep" })

-- pick buffers
nmap("<A-p>", [[<cmd>lua MiniPick.builtin.buffers()<CR>]])

-- fugitive
nmap("<leader>g", [[<cmd>Git<CR>]], { desc = "Git" })

nmap(";n", function()
  require("lib.misc").buffer_jump(1)
end, { desc = "next buf" })

nmap(";p", function()
  require("lib.misc").buffer_jump(-1)
end, { desc = "prev buf" })

-- kill buffer with ;q , quit window with :q . This make sense.
nmap(";q", function()
  if #vim.fn.getbufinfo({ buflisted = 1 }) < 2 then
    -- exit when there is only one buffer left
    vim.cmd("confirm qall")
    return
  end

  if is_cmdline() then
    vim.cmd.close() -- wincmd cannot be executed in commandline window.
  else
    -- delete current buffer and switch to next valid buffer
    require("lib.misc").buffer_delete()
  end
end, { desc = "delete current buf" })

-- incremental selection based on treesitter
nmap("v", [[<cmd>lua require("lib.treesitter_selection"):start_select()<CR>]])
map("v", "v", [[<cmd>lua require("lib.treesitter_selection"):select_parent_node()<CR>]])
map("v", "<BS>", [[<cmd>lua require("lib.treesitter_selection"):restore_last_selection()<CR>]])

-- close window
nmap(";c", [[<cmd>close<CR>]], { desc = "close current window" })

-- dispatch
nmap(";d", "<cmd>Dispatch ", { noremap = true, silent = false })

-- undo tree
nmap("<leader>u", vim.cmd.UndotreeToggle, { desc = "toggle undo tree" })

-- neogen
nmap("<leader>doc", [[<cmd>lua require("neogen").generate()<CR>]])

-- aerial
nmap("gO", [[<cmd>lua require("aerial").toggle()<CR>]])

-- Deal with vim surround: just the defaults copied here.
map("n", "xs", "<Plug>Dsurround")
map("n", "cs", "<Plug>Csurround")
map("n", "cS", "<Plug>CSurround")
map("n", "ys", "<Plug>Ysurround")
map("n", "yS", "<Plug>YSurround")
map("n", "yss", "<Plug>Yssurround")
map("n", "ySs", "<Plug>YSsurround")
map("n", "ySS", "<Plug>YSsurround")
