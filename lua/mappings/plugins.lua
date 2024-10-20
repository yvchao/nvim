local map = require("lib.keymap").map
local nmap = require("lib.keymap").nmap
local is_cmdline = require("lib.misc").is_cmdline
local get_next_buf = require("lib.misc").get_next_buf
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

-- fterm
nmap("<C-\\>", [[<cmd>ToggleTerm direction=float<CR>]])
nmap("<C-`>", [[<cmd>ToggleTerm direction=horizontal<CR>]])
map("t", "<C-\\>", [[<C-\><C-n><cmd>ToggleTerm<CR>]])
map("t", "<C-n>", [[<C-\><C-n>]])

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
  if (vim.fn.tabpagenr("$") == 1) and (#vim.fn.getbufinfo({ buflisted = 1 }) < 2) then
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
nmap(";c", function()
  -- close floating window directly
  local winid = vim.api.nvim_get_current_win()
  if vim.api.nvim_win_get_config(winid).zindex ~= nil then
    vim.cmd.close()
    return
  end

  local bufnr = vim.api.nvim_get_current_buf()
  -- close window if there are more than one tab
  local close = vim.fn.tabpagenr("$") > 1
  -- close window if the buffer is not listed
  close = close or not vim.api.nvim_get_option_value("buflisted", { buf = bufnr })
  -- close window if the next buf exists
  close = close or get_next_buf(bufnr) ~= nil

  if close then
    vim.cmd.close()
  else
    vim.notify("Cannot close the last window of normal buffer!", vim.log.levels.WARN)
  end
end, { desc = "close current window" })

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
