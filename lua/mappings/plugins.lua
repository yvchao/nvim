local map = require("lib.keymap").map
local nmap = require("lib.keymap").nmap
local is_cmdline = require("lib.misc").is_cmdline

local wk = require("which-key")
wk.register({
  ["<leader>"] = {
    -- g = {
    --   name = "Git",
    -- },
    f = {
      name = "Grep",
    },
    d = {
      name = "Docstring",
    },
    w = {
      name = "Workspace",
    },
  },
})

-- EasyAlign
map("v", "<leader>e", "<cmd>EasyAlign<CR>")

-- oil file management
-- nmap(";t", "<cmd>Oil %:p:h<CR>")
nmap(
  ";t",
  [[<cmd>lua MiniFiles.open(vim.fn.expand("%:p"), {use_latest = false})<CR>]],
  { desc = "MiniFiles" }
)
nmap("gx", [[<cmd>execute 'silent! !xdg-open ' . shellescape(expand('<cfile>'), 1)<CR>]])

-- formatter
-- map({ "n", "x" }, "gf", "<cmd>Format<CR>")

-- fterm
nmap("<C-\\>", [[<cmd>ToggleTerm direction=float<CR>]])
-- nmap("<M-`>", [[<cmd>ToggleTerm direction=horizontal<CR>]])
map("t", "<C-\\>", [[<C-\><C-n><cmd>ToggleTerm<CR>]])
map("t", "<C-n>", [[<C-\><C-n>]])
-- This for horizontal terminal
map("t", ";k", [[<C-\><C-n><C-w>k]])
-- This for vertical terminal
map("t", ";h", [[<C-\><C-n><C-w>h]])

-- telescope
-- nmap(
--   "<LEADER>ff",
--   [[<cmd>lua require('telescope.builtin').find_files{previewer = false}<CR>]],
--   { desc = "File grep" }
-- )
-- nmap(
--   "<LEADER>fg",
--   [[<cmd>lua require('telescope.builtin').live_grep{}<CR>]],
--   { desc = "Live grep" }
-- )

-- fzf
nmap("<leader>ff", [[<cmd>lua require('fzf-lua').files()<CR>]], { desc = "File grep" })
nmap("<leader>fg", [[<cmd>lua require('fzf-lua').live_grep()<CR>]], { desc = "Live grep" })
-- nmap("<A-p>", [[<CMD>lua require("telescope.builtin").buffers({previewer = false})<CR>]])
nmap("<A-p>", [[<cmd>lua MiniPick.builtin.buffers()<CR>]])

-- fugitive
nmap("<leader>g", [[<cmd>Git<CR>]], { desc = "Git" })

-- move between buffers
-- nmap(";n", [[<Cmd>bnext<CR>]])
-- nmap(";p", [[<Cmd>bprevious<CR>]])

nmap(";n", function()
  require("lib.misc").buffer_jump(1)
end, { desc = "Next Buf" })

nmap(";p", function()
  require("lib.misc").buffer_jump(-1)
end, { desc = "Prev Buf" })

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
end, { desc = "Del Buf" })

-- close window
nmap(";c", [[<cmd>close<CR>]], { desc = "Close Win" })

-- dispatch
nmap(";d", "<cmd>Dispatch ", { noremap = true, silent = false })

-- repl
-- nmap("<leader>rl", function()
--   require("lib.repl").launch()
-- end)
--
-- nmap("<leader>rt", function()
--   require("lib.repl").toggle()
-- end)
--
-- nmap("<leader>rk", function()
--   require("lib.repl").kill_all()
-- end)

-- undo tree
nmap("<leader>u", vim.cmd.UndotreeToggle, { desc = "Undo tree toggle" })

-- neogen
nmap("<leader>doc", [[<cmd>lua require("neogen").generate()<CR>]])

-- fugitive
-- keep the same prefix as the git sign
-- See git-sign keymap in lua/plugins/config/gitsign_cfg.lua
-- nmap("gic", "<cmd>Git commit -sS<CR>")
-- nmap("giP", "<cmd>Git! push ", { silent = false })

-- deal with vim surround
-- Just the defaults copied here.
vim.keymap.set("n", "xs", "<Plug>Dsurround")
vim.keymap.set("n", "cs", "<Plug>Csurround")
vim.keymap.set("n", "cS", "<Plug>CSurround")
vim.keymap.set("n", "ys", "<Plug>Ysurround")
vim.keymap.set("n", "yS", "<Plug>YSurround")
vim.keymap.set("n", "yss", "<Plug>Yssurround")
vim.keymap.set("n", "ySs", "<Plug>YSsurround")
vim.keymap.set("n", "ySS", "<Plug>YSsurround")
