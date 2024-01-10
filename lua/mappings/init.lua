local keymap = require("lib.keymap")
local map = keymap.map
local nmap = keymap.nmap
local xmap = keymap.xmap

-- quicker motion
nmap("J", "5j")
xmap("J", "5j")

nmap("K", "5k")
xmap("K", "5k")

nmap("L", "g_")
nmap("H", "^")

xmap("L", "g_")
xmap("H", "^")

nmap("W", "5w")
nmap("B", "5b")

-- no more background key
nmap("<C-z>", "u")

-- move block easily
nmap("<", "<<")
nmap(">", ">>")
xmap("<", "<gv")
xmap(">", ">gv")

-- create tab like window
nmap("<C-T>h", ":tabprevious<CR>")
nmap("<C-T>l", ":tabnext<CR>")
nmap("<C-T>n", ":tabnew<CR>")

-- save quickly
nmap(";w", ":w<CR>")

-- do thing like ctrl c and ctrl v
xmap("<C-y>", [["+y]])
nmap("<C-p>", [["+p]])
map("i", "<C-p>", [[<ESC>"+pa]])

-- shut down the search high light
nmap("<ESC>", ":nohlsearch<CR>")
-- no more finger expansion
map("i", "<A-;>", "<ESC>")

-- move around the window
nmap(";k", "<C-w>k")
nmap(";j", "<C-w>j")
nmap(";l", "<C-w>l")
nmap(";h", "<C-w>h")

-- resize the window
nmap("<C-S-up>", ":res +5<CR>")
nmap("<C-S-down>", ":res -5<CR>")
nmap("<C-S-right>", ":vertical resize+5<CR>")
nmap("<C-S-left>", ":vertical resize-5<CR>")

-- center editing line
map("i", "<C-c>", "<ESC>zzi")

-- use very magic mode for searching
nmap("/", [[/\v]], { silent = false })

-- search and replace in visual mode
map("v", "<leader>/", [[y/\v<C-r>"<CR>]], { desc = "Search selected text" })
map("v", "<leader>s", [[y:s/\v<C-r>"//g<Left><Left>]], { desc = "Replace selected text" })

-- emacs-like cursor movement in insert mode
map("i", "<C-a>", "<Home>")
map("i", "<C-e>", "<End>")
map("i", "<A-f>", "<C-Right>")
map("i", "<A-b>", "<C-Left>")
map("c", "<C-a>", "<C-B>")

-- load plugin's keymapping
require("mappings.plugins")

-- load plugin's command mapping
require("mappings.commands")
