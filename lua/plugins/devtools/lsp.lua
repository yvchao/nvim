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
  capabilities =
    vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

  capabilities.workspace = {
    didChangeWatchedFiles = {
      dynamicRegistration = true,
    },
  }

  return capabilities
end

-- setup lsp servers
-- Set default client capabilities plus window/workDoneProgress
local default_capabilities = vim.tbl_extend("keep", setup_capabilities() or {}, {})
local configured_lsp_list = {
  "lua_ls",
  "texlab",
  "basedpyright",
  "ltex",
  "ruff",
  "clangd",
  "markdown_oxide",
  "julials",
  "taplo",
  "jsonls",
}
local settings = {}

local success, custom = pcall(require, "custom")
local custom_lsp_options = success and custom.lsp_options or {}

settings["texlab"] = {
  texlab = {
    build = {
      executable = "latexmk",
      args = {
        "-pdf",
        -- "-pdfxe",
        -- "-dvi-",
        -- "-ps-",
        "-silent",
        "-interaction=nonstopmode",
        "-synctex=1",
        -- "-outdir=build",
        "%f",
      },
      onSave = true,
      forwardSearchAfter = true,
    },
    -- rootDirectory = ".",
    -- auxDirectory = "build",
    forwardSearch = {
      executable = "okular",
      args = {
        "--unique",
        "%p#src:%l%f",
      },
    },
  },
}

local ltex_options = custom_lsp_options.ltex
local modelPath = ltex_options and ltex_options.modelPath or nil
local dictPath = ltex_options and ltex_options.dictPath or nil
settings["ltex"] = {
  ltex = {
    ["ltex-ls"] = {
      logLevel = "severe",
    },
    -- language = "en-GB",
    language = "en-US",
    dictionary = {
      ["en-US"] = {
        dictPath,
      },
      ["en-GB"] = {
        dictPath,
      },
    },
    disabledRules = {},
    hiddenFalsePositives = {},
    additionalRules = {
      word2VecModel = modelPath,
    },
  },
}

-- local lua_runtime_path = vim.split(package.path, ":")
-- table.insert(lua_runtime_path, "lua/?.lua")
-- table.insert(lua_runtime_path, "lua/?/init.lua")
settings["lua_ls"] = {
  Lua = {
    runtime = {
      -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
      version = "LuaJIT",
      path = vim.env.VIMRUNTIME,
    },
    diagnostics = {
      globals = {
        "vim",
      },
    },
    workspace = {
      checkThirdParty = false,
      library = {
        vim.fn.expand("$VIMRUNTIME/lua"),
        vim.fn.stdpath("config") .. "/lua",
      },
      maxPreload = 100000,
      preloadFileSize = 10000,
    },
    telemetry = {
      enable = false,
    },
  },
}

local python_options = custom_lsp_options.python
local stubPath = python_options and python_options.stubPath or nil

settings["basedpyright"] = {
  basedpyright = {
    disableLanguageServices = false,
    disableOrganizeImports = true,
    analysis = {
      logLevel = "Error",
      autoSearchPath = false,
      autoImportCompletion = true,
      diagnosticMode = "openFilesOnly",
      useLibraryCodeForTypes = true,
      stubPath = stubPath,
      typeCheckingMode = "standard",
      diagnosticSeverityOverrides = {
        reportIndexIssue = "none",
        reportGeneralTypeIssues = "none",
        reportOptionalMemberAccess = "none",
        reportOptionalSubscript = "none",
        reportPrivateImportUsage = "none",
        reportRedeclaration = "none",
        reportArgumentType = "yes",
        reportAssignmentType = "none",
        reportCallIssue = "none",
        reportReturnType = "yes",
        reportAttributeAccessIssue = "none",
        reportAny = "none",
      },
    },
  },
  python = {
    pythonPath = vim.g.python3_host_prog,
  },
}

local custom_opts = {}

custom_opts["clangd"] = {
  cmd = {
    "clangd",
    "--offset-encoding=utf-16",
    "--header-insertion-decorators=false",
    "--clang-tidy",
    "--compile-commands-dir=./build",
    "--log=error",
  },
}

custom_opts["marksman"] = {
  filetypes = { "markdown", "quarto" },
}

custom_opts["ltex"] = {
  filetypes = { "markdown", "tex" },
}

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

-- local border = "rounded"
-- local custom_hover = vim.lsp.with(vim.lsp.handlers.hover, { border = border })
-- vim.lsp.handlers["textDocument/hover"] = function(_, result, ctx, config)
--   config = config or {}
--   config.focus_id = ctx.method
--   if not (result and result.contents) then
--     return
--   end
--   return custom_hover(_, result, ctx, config)
-- end
--
-- vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
--   border = border,
-- })
--

return {
  -- manage the lsp server
  {
    "neovim/nvim-lspconfig",
    config = function()
      local ok, lspconfig = pcall(require, "lspconfig")

      if not ok then
        vim.notify("Fail to setup LSP", vim.log.levels.ERROR, {
          title = "plugins.devtools.lsp",
        })
        return
      end
      for _, server_name in pairs(configured_lsp_list) do
        local server_setting = settings[server_name]
        local opts = {
          capabilities = default_capabilities,
          settings = server_setting,
        }
        opts = vim.tbl_extend("force", opts, custom_opts[server_name] or {})
        lspconfig[server_name].setup(opts)
      end
    end,
    ft = vim.g.enable_lspconfig_ft,
    lazy = true,
  },
}
