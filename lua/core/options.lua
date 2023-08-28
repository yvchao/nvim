local opt = vim.opt

opt.encoding = "utf-8"
-- When file encoding forcely set to UTF-8, some file with non-Unicode
-- encoding will lose information during the encoding conversion.
-- If you have problem with this encoding, set value to empty string "".
opt.fileencoding = "utf-8"

-- enable number and relative line number
opt.number = true
opt.rnu = true

-- highlight the current line
opt.cursorline = true

-- TAB SETTING
-- Use 2 spaces forcely. But don't worry, vim-sleuth will handle the indent
-- gracefully. See <https://github.com/tpope/vim-sleuth> for more.
--
-- Use the appropriate number of spaces to insert a <Tab>.
opt.expandtab = true
-- Number of spaces that a <Tab> in the file counts for.
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2

-- Copy indent from current line when starting a new line
opt.autoindent = true

-- A List is an ordered sequence of items.
opt.list = true
opt.listchars = "tab:> ,trail:·"

-- Minimal number of screen lines to keep above and below the cursor.
opt.scrolloff = 5

-- Time in milliseconds to wait for a key code sequence to complete
opt.timeoutlen = 200
opt.ttimeoutlen = 0
-- no waiting for key combination
opt.timeout = false

-- remember where to recover cursor
opt.viewoptions = "cursor,folds,slash,unix"

-- lines longer than the width of the window will wrap and displaying continues
-- on the next line.
opt.wrap = true

-- set text width to zero to use the wrap functionality
opt.tw = 0

opt.cindent = true

-- set windows split at bottom-right by default
opt.splitright = true
opt.splitbelow = true

-- don't show the "--VISUAL--" "--INSERT--" text
opt.showmode = false

-- show chars, selected block in visual mode
opt.showcmd = true

-- auto completion on command
opt.wildmenu = true

-- ignore case when searching and only on searching
opt.ignorecase = true
opt.smartcase = true

vim.opt.shortmess:append({ c = true, w = true, m = true })
opt.inccommand = "split"
opt.completeopt = { "menuone", "noselect", "menu" }
opt.ttyfast = true
opt.lazyredraw = true
opt.visualbell = true
opt.updatetime = 100
opt.virtualedit = "block"

-- highlight a column at the 100 chars
opt.colorcolumn = "100"

-- screen will not redraw when exec marcro, register
opt.lazyredraw = true

-- always draw signcolumn, with 1 fixed space to show 2 icon at the same time
opt.signcolumn = "yes:1"

-- enable all the mouse functionality
opt.mouse = "a"
opt.mousemodel = "extend"

-- use indent as the fold method
opt.foldmethod = "indent"
opt.foldlevel = 99
opt.foldenable = true
opt.formatoptions = "qj"

opt.hidden = true

-- conceal the text
opt.conceallevel = 2
-- show hiding character at cursor line
opt.concealcursor = ""

-- set defaul terminal shell
if vim.fn.executable("fish") == 1 then
  opt.shell = "/usr/bin/fish"
elseif vim.fn.executable("zsh") == 1 then
  opt.shell = "/usr/bin/zsh"
else
  opt.shell = "usr/bin/bash"
end

-- enable global status line
opt.laststatus = 3

-- hide cmdline when not used
-- opt.cmdheight = 0

-- disable tabline
opt.showtabline = 0

-- perfer latex ft.
vim.g.tex_flavor = "latex"

-- skip python provider checking
vim.g.python3_host_skip_check = 1

-- Changed home directory here
local backup_dir = vim.fn.stdpath("cache") .. "/backup"
local backup_stat = pcall(os.execute, "mkdir -p " .. backup_dir)
if backup_stat then
  opt.backupdir = backup_dir
  opt.directory = backup_dir
end

local undo_dir = vim.fn.stdpath("cache") .. "/undo"
local undo_stat = pcall(os.execute, "mkdir -p " .. undo_dir)
local has_persist = vim.fn.has("persistent_undo")
if undo_stat and has_persist == 1 then
  opt.undofile = true
  opt.undodir = undo_dir
end

if vim.g.neovide then
  -- neovide specific settings
  vim.o.guifont = "Iosevka Fixed SS14:h12"
  vim.g.neovide_cursor_vfx_mode = "railgun"
  vim.g.neovide_remember_window_size = true
  -- vim.g.neovide_no_custom_clipboard = true
  vim.g.neovide_input_ime = true
  vim.g.neovide_cursor_animation_length = 0
end
