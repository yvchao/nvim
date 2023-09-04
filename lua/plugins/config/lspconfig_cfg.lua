local ok, lspconfig = pcall(require, "lspconfig")
if not ok then
  vim.notify("Fail to setup LSP", vim.log.levels.ERROR, {
    title = "plugins",
  })
  return
end

--- set keymaps for lsp-enabled buffer
---@param client any
---@param bufnr integer
---@param minimal boolean|nil
local set_keymap = function(client, bufnr, minimal)
  -- whether to use the minimal keymap
  minimal = minimal or false

  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end

  local map = function(mode, lhs, rhs, opts)
    opts = vim.tbl_extend("keep", opts, { noremap = true, silent = true, buffer = bufnr })
    vim.keymap.set(mode, lhs, rhs, opts)
  end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

  -- Mappings.

  if not minimal then
    map("n", "gh", ":lua vim.lsp.buf.hover()<CR>", { desc = "hover information [LSP]" })
    map("n", "gr", ":lua vim.lsp.buf.rename()<CR>", { desc = "rename [LSP]" })
    map("n", "gR", ":lua vim.lsp.buf.references()<CR>", { desc = "find references [LSP]" })
    map("n", "gd", "<cmd>lua vim.lsp.buf.declaration()<CR>", { desc = "goto declaration [LSP]" })
    map(
      "n",
      "gm",
      "<cmd>lua vim.lsp.buf.implementation()<CR>",
      { desc = "goto implementation [LSP]" }
    )
    map(
      "n",
      "gt",
      "<cmd>lua vim.lsp.buf.type_definition()<CR>",
      { desc = "goto type definition [LSP]" }
    )
    map(
      "n",
      "<leader>ls",
      "<cmd>Telescope lsp_document_symbols<CR>",
      { desc = "view symbols in document [LSP]" }
    )

    if client.server_capabilities.signatureHelpProvider then
      map(
        "n",
        "gs",
        ":lua vim.lsp.buf.signature_help()<CR>",
        { desc = "show signature help [LSP]" }
      )
    else
      -- local signature_setup = {
      --   hint_enable = false,
      --   hint_prefix = "󰷼",
      -- }
      -- require("lsp_signature").on_attach(signature_setup, bufnr)
      -- map(
      --   "n",
      --   "gs",
      --   ":lua vim.lsp.buf.signature_help()<CR>",
      --   { desc = "show signature help [LSP]" }
      -- )
    end
    -- Set some keybinds conditional on server capabilities
    if client.server_capabilities.documentFormattingProvider then
      map(
        "n",
        "gf",
        "<cmd>lua vim.lsp.buf.format({async=true})<CR>",
        { desc = "format code [LSP]" }
      )
    elseif client.server_capabilities.documentRangeFormattingProvider then
      map(
        "x",
        "gf",
        "<cmd>lua vim.lsp.buf.range_format({async=true})<CR>",
        { desc = "range format code [LSP]" }
      )
    end
  end
  map("n", "gq", "<cmd>lua vim.diagnostic.setloclist()<CR>", { desc = "open diagnostic list" })
  map("n", "gj", vim.diagnostic.goto_next, { desc = "goto next diagnostic" })
  map("n", "gk", vim.diagnostic.goto_prev, { desc = "goto previous diagnostic" })
  map("n", "gx", ":lua vim.lsp.buf.code_action()<CR>", { desc = "code action [LSP]" })
end

local on_attach = function(client, bufnr)
  set_keymap(client, bufnr, false)
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
local default_capabilities = vim.tbl_extend("keep", setup_capabilities() or {}, {})
local configured_lsp_list =
  { "lua_ls", "texlab", "pyright", "ltex", "ruff_lsp", "clangd", "marksman" }
local settings = {}

local success, custom = pcall(require, "custom")
local custom_options = {}
if success then
  custom_options = custom.lsp_options or {}
end

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

local ltex_options = custom_options.ltex
local modelPath = ltex_options and ltex_options.modelPath or nil
settings["ltex"] = {
  ltex = {
    ["ltex-ls"] = {
      logLevel = "severe",
    },
    dictionary = {},
    disabledRules = {},
    hiddenFalsePositives = {},
    additionalRules = {
      word2VecModel = modelPath,
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

local python_options = custom_options.python
local stubPath = python_options and python_options.stubPath or nil
local pythonPath = python_options and python_options.pythonPath or nil

settings["pyright"] = {
  pyright = {
    disableLanguageServices = false,
    disableOrganizeImports = true,
  },
  python = {
    pythonPath = pythonPath,
    analysis = {
      logLevel = "Error",
      autoSearchPath = false,
      autoImportCompletion = true,
      diagnosticMode = "openFilesOnly",
      useLibraryCodeForTypes = true,
      stubPath = stubPath,
      diagnosticSeverityOverrides = {
        reportGeneralTypeIssues = "none",
        reportOptionalMemberAccess = "none",
        reportOptionalSubscript = "none",
        reportPrivateImportUsage = "none",
      },
    },
  },
}

local custom_opts = {}

custom_opts["clangd"] = {
  cmd = { "clangd", "--offset-encoding=utf-16" },
}

custom_opts["marksman"] = {
  filetypes = { "markdown", "quarto" },
  on_attach = function(client, bufnr)
    local ft = vim.fn.getbufvar(bufnr, "&filetype")
    if ft == "quarto" then
      set_keymap(client, bufnr, true)
    else
      set_keymap(client, bufnr, false)
    end
  end,
}

custom_opts["ltex"] = {
  on_attach = function(client, bufnr)
    on_attach(client, bufnr)
    require("ltex_extra").setup()
  end,
}

for _, server_name in pairs(configured_lsp_list) do
  local server_setting = settings[server_name]
  local opts = {
    on_attach = on_attach,
    capabilities = default_capabilities,
    settings = server_setting,
  }
  opts = vim.tbl_extend("force", opts, custom_opts[server_name] or {})
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

local border = "rounded"
local custom_hover = vim.lsp.with(vim.lsp.handlers.hover, { border = border })
vim.lsp.handlers["textDocument/hover"] = function(_, result, ctx, config)
  config = config or {}
  config.focus_id = ctx.method
  if not (result and result.contents) then
    return
  end
  return custom_hover(_, result, ctx, config)
end

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = border,
})

return {
  on_attach = on_attach,
}
