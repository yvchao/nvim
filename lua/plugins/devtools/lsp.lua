local enable_lspconfig_ft = {
  "text",
  "bash",
  "c",
  "cpp",
  "go",
  "html",
  "javascript",
  "json",
  "jsonc",
  "lua",
  "python",
  "sh",
  "toml",
  "tex",
  "markdown",
  "julia",
  "cmake",
}

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

custom_opts["ltex"] = {
  filetypes = { "markdown", "tex" },
}

return {
  -- manage the lsp server
  {
    "neovim/nvim-lspconfig",
    init = function()
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
    end,
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
    ft = enable_lspconfig_ft,
    lazy = true,
  },
}
