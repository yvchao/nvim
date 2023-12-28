local ok, lspconfig = pcall(require, "lspconfig")
if not ok then
  vim.notify("Fail to setup LSP", vim.log.levels.ERROR, {
    title = "plugins",
  })
  return
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
  { "lua_ls", "texlab", "pyright", "ltex", "ruff_lsp", "clangd", "marksman", "julials" }
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
        "-silent",
        "-interaction=nonstopmode",
        "-synctex=1",
        "-outdir=build",
        "%f",
      },
      onSave = true,
      forwardSearchAfter = false,
    },
    rootDirectory = ".",
    auxDirectory = "build",
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
    dictionary = {
      -- en = {
      --   vim.fn.expand("~") .. "/.local/share/ltex/ltex.dictionary.en-US.txt",
      -- },
    },
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
  cmd = { "clangd", "--offset-encoding=utf-16", "--compile-commands-dir=build", "--log=error" },
}

custom_opts["marksman"] = {
  filetypes = { "markdown", "quarto" },
}

custom_opts["ltex"] = {
  filetypes = { "markdown", "tex" },
}

for _, server_name in pairs(configured_lsp_list) do
  local server_setting = settings[server_name]
  local opts = {
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

local map = function(mode, lhs, rhs, opts)
  opts = vim.tbl_extend("keep", opts, { noremap = true, silent = true })
  vim.keymap.set(mode, lhs, rhs, opts)
end
map("n", "gl", vim.diagnostic.setloclist, { desc = "open diagnostic list" })
map("n", "gj", vim.diagnostic.goto_next, { desc = "goto next diagnostic" })
map("n", "gk", vim.diagnostic.goto_prev, { desc = "goto previous diagnostic" })

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
    local ft = vim.fn.getbufvar(ev.buf, "&filetype")
    if ft == "quarto" then
      return
    elseif ft == "tex" or ft == "markdown" then
      vim.defer_fn(function()
        require("ltex_extra").setup({
          load_langs = { "en-US" },
          path = vim.fn.expand("~") .. "/.local/share/ltex",
        })
      end, 5000)
    end

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    opts["desc"] = "goto declaration [LSP]"
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    opts["desc"] = "goto definition [LSP]"
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    opts["desc"] = "hover documentation [LSP]"
    vim.keymap.set("n", "gh", vim.lsp.buf.hover, opts)
    opts["desc"] = "goto implementation [LSP]"
    vim.keymap.set("n", "gm", vim.lsp.buf.implementation, opts)
    opts["desc"] = "signature_help [LSP]"
    vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, opts)
    opts["desc"] = "goto type definition [LSP]"
    vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)
    opts["desc"] = "rename [LSP]"
    vim.keymap.set("n", "gr", vim.lsp.buf.rename, opts)
    opts["desc"] = "code action [LSP]"
    vim.keymap.set({ "n", "v" }, "ga", vim.lsp.buf.code_action, opts)
    opts["desc"] = "show references [LSP]"
    vim.keymap.set("n", "gR", vim.lsp.buf.references, opts)
    opts["desc"] = "format code [LSP]"
    vim.keymap.set("n", "<leader>f", function()
      vim.lsp.buf.format({ async = true })
    end, opts)
    opts["desc"] = "add workspace folder [LSP]"
    vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
    opts["desc"] = "remove workspace folder [LSP]"
    vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
    opts["desc"] = "list workspace folders [LSP]"
    vim.keymap.set("n", "<leader>wl", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    opts["desc"] = "view document symbols [LSP]"
    vim.keymap.set("n", "<leader>ls", "<cmd>Telescope lsp_document_symbols<CR>", opts)
  end,
})
