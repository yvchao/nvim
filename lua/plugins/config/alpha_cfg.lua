local is_status_ok, alpha = pcall(require, "alpha")

if not is_status_ok then
  vim.notify("Failed to find alpha-nvim", vim.log.levels.ERROR, {
    title = "plugins",
  })
  return
end

local dashboard = require("alpha.themes.dashboard")

dashboard.section.buttons.val = {
  dashboard.button("e", "  New file", "<cmd>ene<CR>"),
  dashboard.button("SPC f f", "󰈞 Find file", ":Telescope find_files hidden=true no_ignore=true<CR>"),
  dashboard.button("SPC f h", "󰊄  Recently opened files", "<cmd>Telescope oldfiles<CR>"),
  -- dashboard.button("SPC f r", "  Frecency/MRU"),
  dashboard.button("SPC f g", "󰈬  Find word",  "<cmd>Telescope live_grep<cr>"),
  -- dashboard.button("SPC f m", "  Jump to bookmarks"),
  -- dashboard.button("SPC s l", "  Open last session", "<cmd>SessionManager load_last_session<CR>"),
}

alpha.setup(dashboard.config)
