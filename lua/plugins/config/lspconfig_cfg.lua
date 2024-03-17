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
        -- "-pdf",
        "-pdfxe",
        "-dvi-",
        "-ps-",
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

local ltex_options = custom_lsp_options.ltex
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

local lua_runtime_path = vim.split(package.path, ":")
table.insert(lua_runtime_path, "lua/?.lua")
table.insert(lua_runtime_path, "lua/?/init.lua")
settings["lua_ls"] = {
  Lua = {
    runtime = {
      -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
      version = "LuaJIT",
      path = lua_runtime_path,
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
  cmd = { "clangd", "--offset-encoding=utf-16", "--compile-commands-dir=./build", "--log=error" },
}

custom_opts["marksman"] = {
  filetypes = { "markdown", "quarto" },
}

custom_opts["ltex"] = {
  filetypes = { "markdown", "tex" },
  on_attach = function()
    require("ltex_extra").setup({
      load_langs = { "en-US" },
      path = vim.fn.expand("~") .. "/.local/share/ltex",
    })
  end,
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

local show_loclist = function()
  vim.ui.select(vim.diagnostic.severity, {
    prompt = "Select the severity",
    format_item = function(item)
      return item
    end,
  }, function(item)
    vim.diagnostic.setloclist({ severity = { min = vim.diagnostic.severity[item] } })
  end)
end

map("n", "gl", show_loclist, { desc = "open diagnostic list" })
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
    end
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client.server_capabilities.signatureHelpProvider then
      require("lsp-overloads").setup(client, {
        keymaps = {
          next_signature = "<C-j>",
          previous_signature = "<C-k>",
          next_parameter = "<C-l>",
          previous_parameter = "<C-h>",
          close_signature = "<C-q>",
        },
        ui = {
          max_height = 5,
          close_events = {
            "CursorMoved",
            "CursorMovedI",
            "InsertCharPre",
            "BufHidden",
            "InsertLeave",
          },
        },
        display_automatically = true,
      })
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
    opts["desc"] = "show signature help [LSP]"
    vim.keymap.set("n", "gH", vim.lsp.buf.signature_help, opts)
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
    vim.keymap.set(
      "n",
      "<leader>ls",
      [[<cmd>lua require("fzf-lua").lsp_document_symbols()<CR>]],
      opts
    )
  end,
})
