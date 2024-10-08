-- use relativenumber when editing
vim.api.nvim_create_autocmd("InsertEnter", { pattern = "*", command = [[set norelativenumber]] })
vim.api.nvim_create_autocmd("InsertLeave", { pattern = "*", command = [[set relativenumber]] })

-- hide command line
-- vim.api.nvim_create_autocmd("RecordingEnter", { pattern = "*", command = [[set cmdheight=1]] })
-- vim.api.nvim_create_autocmd("RecordingLeave", { pattern = "*", command = [[set cmdheight=0]] })

-- start insert when enter the terminal
vim.api.nvim_create_autocmd("TermOpen", { pattern = "term://*", command = "startinsert" })

-- auto config font with remote ui
vim.api.nvim_create_autocmd("UIEnter", {
  callback = function()
    if vim.v.event.chan > 1 then
      local ok, custom = pcall(require, "custom")
      if ok then
        vim.o.guifont = custom.guifont or nil
      end
      vim.notify = require("lib.notify").notify_message
    end
  end,
})

-- automatically update color palette
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = require("lib.palette").update_palette,
})

-- sync terminal background color
-- https://www.reddit.com/r/neovim/comments/1ehidxy/you_can_remove_padding_around_neovim_instance/
vim.api.nvim_create_autocmd({ "UIEnter", "ColorScheme" }, {
  callback = function()
    local normal = vim.api.nvim_get_hl(0, { name = "Normal" })
    if not normal.bg then
      return
    end
    io.write(string.format("\027]11;#%06x\027\\", normal.bg))
  end,
})

vim.api.nvim_create_autocmd("UILeave", {
  callback = function()
    io.write("\027]111\027\\")
  end,
})

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

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    local buftype = vim.bo.buftype
    local filetype = vim.bo.filetype
    -- Ignore special buffers and quarto files
    -- TODO: directly use otter.nvim to setup lsp for quarto file
    if buftype ~= "" or filetype == "quarto" then
      return
    end

    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

    local map = require("lib.keymap").map
    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    -- the default keymap <C-]> for vim.lsp.tagfunc is already good enough
    -- opts["desc"] = "Goto definition [LSP]"
    -- map("n", "<gD>", vim.lsp.buf.definition, opts)
    opts["desc"] = "Hover documentation [LSP]"
    map("n", "K", vim.lsp.buf.hover, opts)
    opts["desc"] = "Show signature help [LSP]"
    map("n", "gh", vim.lsp.buf.signature_help, opts)
    map("i", "<C-s>", vim.lsp.buf.signature_help, opts)
    opts["desc"] = "Rename [LSP]"
    map("n", "gr", vim.lsp.buf.rename, opts)
    opts["desc"] = "Code action [LSP]"
    map({ "n", "v" }, "ga", vim.lsp.buf.code_action, opts)
    opts["desc"] = "Show references [LSP]"
    map("n", "gR", vim.lsp.buf.references, opts)
  end,
})
