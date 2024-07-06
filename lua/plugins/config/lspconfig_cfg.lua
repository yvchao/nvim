local ok, lspconfig = pcall(require, "lspconfig")
local map = require("lib.keymap").map

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
  capabilities =
    vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

  return capabilities
end

-- setup lsp servers
-- Set default client capabilities plus window/workDoneProgress
local default_capabilities = vim.tbl_extend("keep", setup_capabilities() or {}, {})
local configured_lsp_list = {
  "lua_ls",
  "texlab",
  "pyright",
  "ltex",
  "ruff_lsp",
  "clangd",
  "marksman",
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
settings["ltex"] = {
  ltex = {
    ["ltex-ls"] = {
      logLevel = "severe",
    },
    language = "en-GB",
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

settings["pyright"] = {
  pyright = {
    disableLanguageServices = false,
    disableOrganizeImports = true,
  },
  python = {
    pythonPath = vim.g.python3_host_prog,
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
        reportIndexIssue = "none",
        reportRedeclaration = "none",
        reportArgumentType = "none",
        reportAssignmentType = "none",
        reportCallIssue = "none",
        reportReturnType = "none",
        reportAttributeAccessIssue = "none",
      },
    },
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
    -- TODO: better handling signature help
    -- local client = vim.lsp.get_client_by_id(ev.data.client_id)
    -- if client and client.server_capabilities.signatureHelpProvider then
    --   require("lsp-overloads").setup(client, {
    --     keymaps = {
    --       next_signature = "<C-j>",
    --       previous_signature = "<C-k>",
    --       next_parameter = "<C-l>",
    --       previous_parameter = "<C-h>",
    --       close_signature = "<C-q>",
    --     },
    --     ui = {
    --       max_height = 5,
    --       max_weidth = 100,
    --       close_events = {
    --         "CursorMovedI",
    --         "BufHidden",
    --         "InsertLeave",
    --       },
    --     },
    --     display_automatically = false,
    --   })
    -- end

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    opts["desc"] = "Goto definition [LSP]"
    vim.keymap.set("n", "<C>-]", vim.lsp.tagfunc, opts)
    opts["desc"] = "Hover documentation [LSP]"
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    opts["desc"] = "Show signature help [LSP]"
    vim.keymap.set("n", "gh", vim.lsp.buf.signature_help, opts)
    opts["desc"] = "Rename [LSP]"
    vim.keymap.set("n", "gr", vim.lsp.buf.rename, opts)
    opts["desc"] = "Code action [LSP]"
    vim.keymap.set({ "n", "v" }, "ga", vim.lsp.buf.code_action, opts)
    opts["desc"] = "Show references [LSP]"
    vim.keymap.set("n", "gR", vim.lsp.buf.references, opts)
  end,
})
