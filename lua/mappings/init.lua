local keymap = require("lib.keymap")
local map = keymap.map
local nmap = keymap.nmap
local xmap = keymap.xmap

-- not needed since we use [d and ]d for diagnostics now
-- nmap("glj", "g<Down>")
-- nmap("glk", "g<Up>")

nmap("W", "5w")
nmap("B", "5b")

-- no more background key
-- nmap("<C-z>", "u")

-- move block easily
nmap("<", "<<")
nmap(">", ">>")
xmap("<", "<gv")
xmap(">", ">gv")

-- create tab like window
nmap("<C-t>h", "<cmd>tabprevious<CR>")
nmap("<C-t>l", "<cmd>tabnext<CR>")
nmap("<C-t>n", "<cmd>tabnew<CR>")

-- move between qf items
nmap("]q", function()
  return "<cmd>" .. vim.v.count .. "cnext<CR>"
end, { expr = true })
nmap("[q", function()
  return "<cmd>" .. vim.v.count .. "cprev<CR>"
end, { expr = true })

-- save quickly
nmap(";w", ":w<CR>", { desc = "save buffer" })

-- do thing like ctrl c and ctrl v
xmap("<C-y>", [["+y]])
nmap("<C-p>", [["+p]])
map("i", "<C-p>", [[<ESC>"+pa]])

-- shut down the search highlight
nmap("<ESC>", "<cmd>nohlsearch<CR>")

-- no more finger expansion
map("i", "<A-;>", "<ESC>")

-- move around the window
nmap(";k", "<C-w>k")
nmap(";j", "<C-w>j")
nmap(";l", "<C-w>l")
nmap(";h", "<C-w>h")

-- resize the window
nmap("<C-S-up>", "<cmd>res +5<CR>")
nmap("<C-S-down>", "<cmd>res -5<CR>")
nmap("<C-S-right>", "<cmd>vertical resize+5<CR>")
nmap("<C-S-left>", "<cmd>vertical resize-5<CR>")

-- use very magic mode for searching
-- nmap("/", [[/\v]], { silent = false })

-- search selected text in visual mode
map("x", "<leader>/", [[y/\v<C-r>"<CR>]], { desc = "Search selected text" })
map(
  "x",
  "<leader>s",
  [[y<cmd>let @/=substitute(escape(@", '/'), '\n','\\n','g')<cr>"_cgn]],
  { desc = "Search&replace selected text" }
)

-- emacs-like cursor movement in insert mode
map("i", "<C-a>", "<Home>")
map("i", "<C-e>", "<End>")
map("i", "<A-f>", "<C-Right>")
map("i", "<A-b>", "<C-Left>")
map("c", "<C-a>", "<Home>")

-- reasonable pasting experience
map({ "n", "x" }, "<leader>p", [["0p]], { desc = "paste from yank register" })

-- load plugin's keymapping
require("mappings.plugins")

-- load plugin's command mapping
require("mappings.commands")
