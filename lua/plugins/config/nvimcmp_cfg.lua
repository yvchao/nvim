local cmp = require("cmp")

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0
    and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local has_trigger_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0
    and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('[."]') ~= nil
end

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

local kind_icons = {
  Text = "",
  Method = "",
  Function = "󰡱",
  Constructor = "",
  Field = "󰽐",
  Variable = "󱄑",
  Class = "󰠱",
  Interface = "",
  Module = "",
  Property = "󰜢",
  Unit = "",
  Value = "󰎠",
  Enum = "",
  Keyword = "󰌋",
  Snippet = "",
  Color = "",
  File = "󰈙",
  Reference = "",
  Folder = "",
  EnumMember = "",
  Constant = "",
  Struct = "",
  Event = "",
  Operator = "󰿉",
  TypeParameter = "󰅲",
  VimCmdLine = "",
}

local source_menu = {
  buffer = "[ Buf]",
  nvim_lsp = "[ LSP]",
  luasnip = "[󰅩 LSnip]",
  snippet = "[󰅩 VSnip]",
  nvim_lua = "[ NvimLua]",
  latex_symbols = "[󰙳 Latex]",
  dictionary = "[ Dict]",
}

cmp.setup({
  completion = {
    autocomplete = false,
  },
  snippet = {
    expand = function(args)
      -- For `vsnip` user.
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  formatting = {
    format = function(entry, item)
      -- return special icon for cmdline completion
      if entry.source.name == "cmdline" then
        item.kind = string.format("%s %s", kind_icons["VimCmdLine"], "Vim")
        return item
      end
      item.kind = string.format("%s %s", kind_icons[item.kind], item.kind)
      item.menu = (source_menu)[entry.source.name]
      return item
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), {
      "i",
      "c",
    }),
    ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), {
      "i",
      "c",
    }),
    ["<C-e>"] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ["<C-Space>"] = cmp.mapping(
      cmp.mapping.complete({ reason = cmp.ContextReason.Auto }),
      { "i", "c" }
    ),
    ["<CR>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif has_trigger_before() then
        cmp.complete()
      elseif vim.fn["vsnip#jumpable"](1) == 1 then
        feedkey("<Plug>(vsnip-jump-next)", "")
      else
        fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item()
      elseif vim.fn["vsnip#jumpable"](-1) == 1 then
        feedkey("<Plug>(vsnip-jump-prev)", "")
      end
    end, { "i", "s" }),
  }),
  sources = cmp.config.sources({
    {
      name = "nvim_lsp",
      group_index = 1,
      priority = 10,
      -- entry_filter = function(entry, ctx)
      --   return require("cmp").lsp.CompletionItemKind.Text ~= entry:get_kind()
      -- end,
    },
    { name = "vsnip", group_index = 1, priority = 3 },
    { name = "buffer", group_index = 4, priority = 1 },
    { name = "path", group_index = 3, priority = 2 },
    -- { name = "nvim_lsp_signature_help", group_index = 1 },
    -- { name = "dictionary", keyword_length = 2, priority = 0},
  }),
  experimental = {
    ghost_text = { hl_group = "NonText" },
  },
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline("/", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    {
      name = "buffer",
    },
  },
})

cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path" },
  }, {
    { name = "cmdline" },
  }),
})
