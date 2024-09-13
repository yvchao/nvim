local opt = vim.opt

-- set color options
opt.termguicolors = true
opt.background = "dark"

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
opt.scrolloff = 3

-- Time in milliseconds to wait for a key code sequence to complete
opt.timeoutlen = 200
opt.ttimeoutlen = 0
-- no waiting for key combination
opt.timeout = false

-- remember where to recover cursor
opt.viewoptions = "cursor,folds"

-- lines longer than the width of the window will wrap and displaying continues
-- on the next line.
opt.wrap = true

-- set text width to zero to use the wrap functionality
opt.textwidth = 0

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

-- set space as the leader key
vim.keymap.set("n", " ", "<Nop>", { silent = true, remap = false })
vim.g.mapleader = " "

vim.opt.shortmess:append({ c = true, w = true, m = true })
opt.inccommand = "split"
opt.completeopt = { "menuone", "noselect", "menu" }
opt.ttyfast = true
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
opt.foldmethod = "marker"
opt.foldlevel = 99
opt.foldenable = true
opt.foldmarker = "{{{,}}}"

opt.formatoptions = "qj"

opt.hidden = true

-- conceal the text
opt.conceallevel = 0
-- show hiding character at cursor line
opt.concealcursor = ""

-- enable global status line
opt.laststatus = 3

-- show cmdline
opt.cmdheight = 1

-- disable tabline
opt.showtabline = 0

-- perfer latex ft.
vim.g.tex_flavor = "latex"
vim.g.tex_indent_items = ""

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
-- NOTE: we modify the default behavior since nvim 0.10
if vim.fn.executable("rg") == 1 then
  opt.grepprg = "rg --vimgrep --smart-case --hidden --ignore-vcs "
  opt.grepformat = "%f:%l:%c:%m"
end

local success, custom = pcall(require, "custom")
vim.o.guifont = success and custom.guifont or nil

-- skip python provider checking
vim.g.python3_host_skip_check = 1
vim.g.python3_host_prog = success and custom.pythonPath or nil

if vim.g.neovide then
  -- neovide specific settings
  vim.g.neovide_scroll_animation_length = 0.2 -- temporary fix for winbar glitch
  vim.g.neovide_cursor_vfx_mode = "railgun"
  vim.g.neovide_remember_window_size = true
  vim.g.neovide_input_ime = true
  vim.g.neovide_cursor_animation_length = 0.03
  vim.g.neovide_floating_blur_amount_x = 1.0
  vim.g.neovide_floating_blur_amount_y = 1.0
  vim.g.neovide_floating_shadow = false
  vim.g.neovide_floating_z_height = 10
  vim.g.neovide_light_angle_degrees = 45
  vim.g.neovide_light_radius = 5
end
