local M = {}

M.feedkeys = function(key, mode)
  vim.fn.feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode)
end

-- map create a new mapping
-- @param mode specify vim mode
-- @param lhs specify the new keymap
-- @param rhs specify the keymap or commands
-- @param opts setting options. Default: { noremap = true, silent = true, expr = false }
M.map = function(mode, lhs, rhs, opts)
  local options = {
    noremap = true,
    silent = true,
    expr = false,
  }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

-- nmap create a new mapping in normal mode
-- @param lhs specify the new keymap
-- @param rhs specify the keymap or commands
-- @param opts setting options. Default: { noremap = true, silent = true, eval = false }
M.nmap = function(lhs, rhs, opts)
  M.map("n", lhs, rhs, opts)
end

-- xmap create a new mapping in selection mode
-- @param lhs specify the new keymap
-- @param rhs specify the keymap or commands
-- @param opts setting options. Default: { noremap = true, silent = true, eval = false }
M.xmap = function(lhs, rhs, opts)
  M.map("x", lhs, rhs, opts)
end

return M
