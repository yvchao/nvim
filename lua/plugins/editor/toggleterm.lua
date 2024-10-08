-- set defaul terminal shell
local shell = vim.o.shell

local shell_path = vim.fn.exepath("fish")
if shell_path == "" then
  shell_path = vim.fn.exepath("zsh")
end

if shell_path ~= "" then
  shell = shell_path
end

return {
  {
    "akinsho/toggleterm.nvim",
    opts = {
      -- size can be a number or function which is passed the current terminal
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        end
      end,
      hide_numbers = true, -- hide the number column in toggleterm buffers
      shade_filetypes = {},
      shade_terminals = true,
      start_in_insert = true,
      insert_mappings = true, -- whether or not the open mapping applies in insert mode
      terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
      persist_size = true,
      direction = "horizontal", -- 'window' | 'float' | 'vertical' ,
      close_on_exit = true, -- close the terminal window when the process exits
      shell = shell, -- change the default shell

      -- This field is only relevant if direction is set to 'float'
      float_opts = {
        border = "shadow", -- | 'double' | 'shadow' | 'curved' | ... other options supported by win open
        -- width = 300,
        -- height = 90,
        winblend = 3,
        highlights = {
          border = "Normal",
          background = "Normal",
        },
      },
    },
    cmd = "ToggleTerm",
    branch = "main",
  },
}
