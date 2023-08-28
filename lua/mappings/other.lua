local map = require("mappings.utils").map
local nmap = require("mappings.utils").nmap

-- EasyAlign
map("v", "<leader>e", ":EasyAlign<CR>")

-- oil file management
nmap(";t", ":Oil %:p:h<CR>")

-- formatter
-- map({ "n", "x" }, "gf", ":Format<CR>")

-- fterm
nmap("<C-\\>", [[:ToggleTerm direction=float<CR>]])
nmap("<M-`>", [[:ToggleTerm direction=horizontal<CR>]])
map("t", "<C-\\>", [[<C-\><C-n>:ToggleTerm<CR>]])
map("t", "<C-n>", [[<C-\><C-n>]])
-- This for horizontal terminal
map("t", ";k", [[<C-\><C-n><C-w>k]])
-- This for vertical terminal
map("t", ";h", [[<C-\><C-n><C-w>h]])

-- telescope
nmap("<LEADER>ff", [[:lua require('telescope.builtin').find_files{}<CR>]])
nmap("<LEADER>fg", [[:lua require('telescope.builtin').live_grep{}<CR>]])

-- fugitive
nmap("<LEADER>g", [[<CMD>Git<CR>]])

-- bufferline tab stuff
nmap("<C-c>", ":BufferLinePickClose<CR>") -- close tab

-- move between tabs
-- nmap(";n", [[<Cmd>BufferLineCycleNext<CR>]])
-- nmap(";p", [[<Cmd>BufferLineCyclePrev<CR>]])
nmap(";n", [[<Cmd>bnext<CR>]])
nmap(";p", [[<Cmd>bprevious<CR>]])

-- close window
nmap(";c", [[<Cmd>close<CR>]])

-- move tabs
-- nmap("<A->>", [[<CMD>BufferLineMoveNext<CR>]])
-- nmap("<A-<>", [[<CMD>BufferLineMovePrev<CR>]])
-- nmap("<A-p>", [[<CMD>BufferLinePick<CR>]])
nmap("<A-p>", [[<CMD>Telescope buffers<CR>]])

-- dispatch
nmap(";d", ":Dispatch ", { noremap = true, silent = false })

-- neogen
nmap("<leader>doc", [[:lua require("neogen").generate()<CR>]])

-- rust-tools.nvim
-- nmap("<Leader>ra", ':lua require("rust-tools.hover_actions").hover_actions()<CR>')

-- fugitive
-- keep the same prefix as the git sign
-- See git-sign keymap in lua/plugins/config/gitsign_cfg.lua
nmap("gic", ":Git commit -sS<CR>")
nmap("giP", ":Git! push ", { silent = false })
