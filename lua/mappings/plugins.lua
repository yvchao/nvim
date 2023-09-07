local map = require("lib.keymap").map
local nmap = require("lib.keymap").nmap
local is_cmdline = require("lib.misc").is_cmdline

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
nmap("<LEADER>ff", [[:lua require('telescope.builtin').find_files{previewer = false}<CR>]])
nmap("<LEADER>fg", [[:lua require('telescope.builtin').live_grep{}<CR>]])
nmap("<A-p>", [[<CMD>lua require("telescope.builtin").buffers({previewer = false})<CR>]])

-- fugitive
nmap("<LEADER>g", [[<CMD>Git<CR>]])

-- move between buffers
nmap(";n", [[<Cmd>bnext<CR>]])
nmap(";p", [[<Cmd>bprevious<CR>]])

-- kill buffer with ;q , quit window with :q . This make sense.
nmap(";q", function()
  if is_cmdline() then
    vim.notify(
      "Cannot execute wincmd in commandline, close the window to exit.",
      vim.log.levels.INFO
    )
  else
    require("bufdel").delete_buffer_expr()
  end
end)

-- close window
nmap(";c", [[<Cmd>close<CR>]])

-- dispatch
nmap(";d", ":Dispatch ", { noremap = true, silent = false })

-- repl
nmap("<leader>rl", function()
  require("lib.repl").launch()
end)

nmap("<leader>rt", function()
  require("lib.repl").toggle()
end)

nmap("<leader>rk", function()
  require("lib.repl").kill_all()
end)

-- undo tree
nmap("<leader>u", vim.cmd.UndotreeToggle)

-- neogen
nmap("<leader>doc", [[:lua require("neogen").generate()<CR>]])

-- fugitive
-- keep the same prefix as the git sign
-- See git-sign keymap in lua/plugins/config/gitsign_cfg.lua
nmap("gic", ":Git commit -sS<CR>")
nmap("giP", ":Git! push ", { silent = false })
