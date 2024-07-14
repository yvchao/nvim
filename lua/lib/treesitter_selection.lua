local ts_utils = require("nvim-treesitter.ts_utils")
local feedkeys = require("lib.keymap").feedkeys

local M = {
  node_list = {},
  current_index = nil,
}

local function update_visual_area(node)
  local start_row, start_col, end_row, end_col = node:range()
  feedkeys("<ESC>", "nx") -- enter normal mode, mode n: nomap
  vim.fn.setpos(".", { 0, start_row + 1, start_col + 1, 0 })
  vim.cmd("normal! v")
  local last_line = vim.fn.line("$")
  if end_row + 1 > last_line then
    end_col = vim.fn.col({ last_line, "$" }) - 1
  end
  vim.fn.setpos(".", { 0, end_row + 1, end_col + 1, 0 })
end

local function find_expand_node(node)
  local start_row, start_col, end_row, end_col = node:range()
  local parent = node:parent()
  if parent == nil then
    return nil
  end
  local parent_start_row, parent_start_col, parent_end_row, parent_end_col = parent:range()
  if
    start_row == parent_start_row
    and start_col == parent_start_col
    and end_row == parent_end_row
    and end_col == parent_end_col
  then
    return find_expand_node(parent)
  end
  return parent
end

function M:start_select()
  self.node_list = {}
  self.current_index = 0
  vim.cmd("normal! v")
end

function M:select_parent_node()
  if self.current_index == nil then
    return
  end

  self.current_index = self.current_index + 1
  local parent = self.node_list[self.current_index]

  -- find parent node if it is not saved in node_list
  if parent == nil then
    local node = self.node_list[self.current_index - 1]
    if node == nil then
      parent = ts_utils.get_node_at_cursor()
    else
      parent = find_expand_node(node)
    end
    -- cannot find parent, fallback to last selection
    if not parent then
      self.current_index = self.current_index - 1
      vim.notify("Cannot expand the selection anymore!", vim.log.levels.WARN)
      -- we don't need to do anything here
      -- feedkeys("<ESC>", "nx") -- enter normal mode, mode n: nomap
      -- vim.cmd("normal! gv")
      return
    end
    -- add the new node
    table.insert(self.node_list, parent)
  end

  update_visual_area(parent)
end

function M:restore_last_selection()
  if not self.current_index or self.current_index <= 1 then
    return
  end

  self.current_index = self.current_index - 1
  local node = self.node_list[self.current_index]
  update_visual_area(node)
end

return M
