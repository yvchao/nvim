local ok, tree_c = pcall(require, "nvim-tree.config")
if not ok then
	vim.notify(tree_c, vim.log.levels.ERROR)
	return
end

local tree_cb = tree_c.nvim_tree_callback

-- following options are the default
require("nvim-tree").setup({
	disable_netrw = true,
	hijack_netrw = true,
	open_on_tab = false,
	hijack_cursor = true,
	update_cwd = true,
	hijack_directories = { enable = true, auto_open = true },
	renderer = {
		highlight_git = true,
		highlight_opened_files = "icon",
		add_trailing = false,
		root_folder_modifier = ":t",
		indent_markers = {
			enable = false,
			icons = {
				corner = "└ ",
				edge = "│ ",
				none = "  ",
			},
		},
		icons = {
			webdev_colors = true,
			git_placement = "before",
			show = {
				git = true,
				folder = true,
				file = true,
				folder_arrow = true,
			},
			glyphs = {
				default = "",
				symlink = "",
				git = {
					unstaged = "󱇧",
					staged = "󱪙",
					unmerged = "",
					renamed = "󰑕",
					untracked = "",
					deleted = "",
					ignored = "",
				},
				folder = {
					-- arrow_open = "",
					-- arrow_closed = "",
					default = "",
					open = "",
					empty = "", -- 
					empty_open = "",
					symlink = "",
					symlink_open = "",
				},
			},
		},
	},
	diagnostics = {
		enable = false,
		icons = { hint = "", info = "", warning = "", error = "" },
	},
	update_focused_file = { enable = false, update_cwd = false, ignore_list = {} },
	system_open = { cmd = nil, args = {} },
	git = {
		ignore = false,
	},
	filters = {
		dotfiles = true,
		custom = {
			".git",
			"node_modules",
			".cache",
		},
	},
	actions = {
		change_dir = {
			enable = true,
			global = false,
		},
		open_file = {
			quit_on_open = false,
			resize_window = true,
			window_picker = {
				enable = true,
				chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
				exclude = {
					filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
					buftype = { "nofile", "terminal", "help" },
				},
			},
		},
	},
	view = {
		width = 25,
		-- height = 30,
		side = "left",
	},
})
