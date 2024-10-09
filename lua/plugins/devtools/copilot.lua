-- filetypes to enable copilot
vim.g.copilot_filetypes = {
  ["*"] = false,
  python = true,
  c = true,
  cpp = true,
  cmake = true,
  lua = true,
}

return {
  {
    "github/copilot.vim",
    enabled = true,
    init = function()
      vim.g.copilot_no_tab_map = true

      -- setup the copilot keymap
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local filetype = vim.api.nvim_get_option_value("filetype", { buf = ev.buf })
          local copilot_enabled = vim.g.copilot_filetypes[filetype] or false

          if not copilot_enabled then
            return
          end

          vim.keymap.set("i", "<C-/>", function()
            return vim.fn["copilot#Accept"]("")
          end, {
            buffer = ev.buf,
            noremap = true,
            expr = true,
            replace_keycodes = false,
            nowait = true,
          })
        end,
      })
    end,
  },

  {
    url = "git@git.woa.com:yuchaoqin/gongfeng-vim.sh.git",
    build = "./install.sh",
    enabled = false,
    init = function()
      vim.g.copilot_no_tab_map = true

      -- setup the copilot keymap
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local filetype = vim.api.nvim_get_option_value("filetype", { buf = ev.buf })
          local copilot_enabled = vim.g.copilot_filetypes[filetype] or false

          if not copilot_enabled then
            return
          end

          vim.keymap.set("i", "<C-/>", function()
            return vim.fn["copilot#Accept"]("")
          end, {
            buffer = ev.buf,
            noremap = true,
            expr = true,
            replace_keycodes = false,
            nowait = true,
          })
        end,
      })
    end,
  },
}
