local ok, lspconfig = pcall(require, "lspconfig")
if not ok then
  vim.notify("Fail to setup LSP", vim.log.levels.ERROR, {
    title = "plugins",
  })
  return
end

local lsp_status = require("lsp-status")
lsp_status.config({
  kind_labels = {},
  current_function = false,
  show_filename = false,
  diagnostics = false,
  indicator_separator = " ",
  component_separator = " ",
  indicator_errors = "",
  indicator_warnings = "",
  indicator_info = "🛈",
  indicator_hint = "",
  indicator_ok = "",
  spinner_frames = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" },
  status_symbol = "",
  select_symbol = nil,
  update_interval = 10,
})
-- Register the progress handler
lsp_status.register_progress()

local on_attach = function(client, bufnr)
  -- Register client for messages and set up buffer autocommands to update
  lsp_status.on_attach(client)

  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

  -- Mappings.
  local opts = {
    noremap = true,
    silent = true,
    buffer = bufnr,
  }
  -- vim.keymap.set("n", "gd", "<Cmd>Lspsaga preview_definition<CR>", opts)
  vim.keymap.set("n", "gh", ":lua vim.lsp.buf.hover()<CR>", opts)
  -- buf_set_keymap(
  --   "n",
  --   "<C-u>",
  --   "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<cr>",
  --   opts
  -- )
  -- buf_set_keymap(
  --   "n",
  --   "<C-d>",
  --   "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<cr>",
  --   opts
  -- )
  vim.keymap.set("n", "gs", ":lua vim.lsp.buf.signature_help()<CR>", opts)
  -- vim.keymap.set("n", "go", "<cmd>Lspsaga show_line_diagnostics<CR>", opts)
  -- vim.keymap.set("n", "gj", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts)
  vim.keymap.set("n", "gj", function()
    vim.diagnostic.goto_next()
    vim.diagnostic.open_float()
  end, opts)
  -- vim.keymap.set("n", "gk", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts)
  vim.keymap.set("n", "gk", function()
    vim.diagnostic.goto_prev()
    vim.diagnostic.open_float()
  end, opts)
  vim.keymap.set("n", "gr", ":lua vim.lsp.buf.rename()<CR>", opts)
  -- vim.keymap.set("n", "gR", "<cmd>Lspsaga lsp_finder<CR>", opts)
  vim.keymap.set("n", "gR", ":lua vim.lsp.buf.references()<CR>", opts)
  -- vim.keymap.set("n", "gx", "<cmd>Lspsaga code_action<CR>", opts)
  vim.keymap.set("n", "gx", ":lua vim.lsp.buf.code_action()<CR>", opts)

  vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  vim.keymap.set("n", "gm", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  vim.keymap.set("n", "gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
  vim.keymap.set("n", "gq", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
  -- vim.keymap.set("n", "gq", function()
  --   vim.diagnostic.setloclist({ open = false })
  --   local window = vim.api.nvim_get_current_win()
  --   vim.cmd.lwindow()
  --   vim.api.nvim_set_current_win(window)
  -- end, { buffer = bufnr, remap = false, silent = true })

  -- Set some keybinds conditional on server capabilities
  if client.server_capabilities.documentFormattingProvider then
    vim.keymap.set("n", "gf", "<cmd>lua vim.lsp.buf.format({async=true})<CR>", opts)
  elseif client.server_capabilities.documentRangeFormattingProvider then
    vim.keymap.set("x", "gf", "<cmd>lua vim.lsp.buf.range_format({async=true})<CR>", opts)
  end
  -- vim.keymap.set("n", "gf", "<cmd>lua vim.lsp.buf.format({async=true})<CR>", opts)
  -- vim.keymap.set("x", "gf", "<cmd>lua vim.lsp.buf.range_format({async=true})<CR>", opts)
end

-- Gets a new ClientCapabilities object describing the LSP client
-- capabilities.
local function setup_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem = {
    documentationFormat = {
      "markdown",
      "plaintext",
    },
    snippetSupport = true,
    preselectSupport = true,
    insertReplaceSupport = true,
    labelDetailsSupport = true,
    deprecatedSupport = true,
    commitCharactersSupport = true,
    tagSupport = {
      valueSet = { 1 },
    },
    resolveSupport = {
      properties = {
        "documentation",
        "detail",
        "additionalTextEdits",
      },
    },
  }

  return capabilities
end

-- setup lsp servers
-- Set default client capabilities plus window/workDoneProgress
local default_capabilities =
  vim.tbl_extend("keep", setup_capabilities() or {}, lsp_status.capabilities)
local configured_lsp_list = { "lua_ls", "texlab", "pyright", "ltex", "ruff_lsp", "clangd" }
local settings = {}

settings["texlab"] = {
  texlab = {
    build = {
      executable = "latexmk",
      args = {
        "-pdf",
        "-interaction=nonstopmode",
        "-synctex=1",
        "-outdir=output",
        "%f",
      },
      onSave = true,
      forwardSearchAfter = false,
    },
    rootDirectory = ".",
    auxDirectory = "output",
    forwardSearch = {
      executable = "zathura",
      args = {
        "--synctex-forward",
        "%l:1:%f",
        "%p",
      },
    },
  },
}

settings["ltex"] = {
  ltex = {
    ["ltex-ls"] = {
      logLevel = "severe",
    },
    dictionary = {},
    disabledRules = {},
    hiddenFalsePositives = {},
    additionalRules = {
      word2VecModel = "~/.config/LanguageTool/spell/en",
    },
  },
}

settings["lua_ls"] = {
  Lua = {
    runtime = {
      -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
      version = "LuaJIT",
    },
    diagnostics = {
      globals = {
        "vim",
      },
    },
    workspace = {
      library = {
        [vim.fn.expand("$VIMRUNTIME/lua")] = true,
        [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
      },
      maxPreload = 100000,
      preloadFileSize = 10000,
    },
    telemetry = {
      enable = false,
    },
  },
}

settings["pyright"] = {
  pyright = {
    disableLanguageServices = false,
    disableOrganizeImports = true,
  },
  python = {
    analysis = {
      logLevel = "Error",
      autoSearchPath = false,
      autoImportCompletion = true,
      diagnosticMode = "openFilesOnly",
      useLibraryCodeForTypes = true,
      diagnosticSeverityOverrides = {
        reportGeneralTypeIssues = "none",
        reportOptionalMemberAccess = "none",
        reportOptionalSubscript = "none",
        reportPrivateImportUsage = "none",
      },
    },
  },
}

for _, server_name in pairs(configured_lsp_list) do
  local server_setting = settings[server_name]
  local opts = {
    on_attach = on_attach,
    capabilities = default_capabilities,
    settings = server_setting,
  }
  if server_name == "clangd" then
    opts.cmd = { "clangd", "--offset-encoding=utf-16" }
    opts.handlers = lsp_status.extensions.clangd.setup()
    opts.init_options = { clangdFileStatus = true }
  elseif server_name == "ltex" then
    opts.on_attach = function(client, bufnr)
      on_attach(client, bufnr)
      require("ltex_extra").setup()
    end
  else
    opts = opts
  end
  lspconfig[server_name].setup(opts)
end

local signs = {
  Error = "󰅙 ",
  Warn = " ",
  Hint = "󰌵 ",
  Info = " ",
}

for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, {
    text = icon,
    texthl = hl,
    numhl = "",
  })
end

-- local lsp_publish_diagnostics_options = {
--   virtual_text = {
--     prefix = "󰎟",
--     spacing = 4,
--   },
--   signs = true,
--   underline = true,
--   update_in_insert = false, -- update diagnostics insert mode
-- }

-- vim.lsp.handlers["textDocument/publishDiagnostics"] =
--   vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, lsp_publish_diagnostics_options)

-- Disable virtual_text since it's redundant due to lsp_lines.
vim.diagnostic.config({
  virtual_text = false,
})

-- vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
--   border = "single",
-- })

vim.lsp.handlers["textDocument/hover"] = function(_, result, ctx, config)
  config = config or {}
  config.focus_id = ctx.method
  if not (result and result.contents) then
    return
  end
  return vim.lsp.with(vim.lsp.handlers.hover(_, result, ctx, config), { border = "single" })
end

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = "single",
})

return {
  on_attach = on_attach,
}
