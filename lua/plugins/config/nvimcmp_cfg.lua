local cmp = require("cmp")
local compare = require("cmp.config.compare")
local luasnip = require("luasnip")
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
local feedkey = require("lib.keymap").feedkeys

cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
-- to work with copilot
cmp.event:on("menu_opened", function()
  vim.b.copilot_suggestion_hidden = true
end)

cmp.event:on("menu_closed", function()
  vim.b.copilot_suggestion_hidden = false
end)

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0
    and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local has_trigger_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0
    and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("[.\\/]")
      ~= nil
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
  otter = "[󰻀 Otter]",
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
      luasnip.lsp_expand(args.body)
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
    ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), {
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
      behavior = cmp.ConfirmBehavior.Insert, -- Replace will remove chars on the right
      select = true,
    }),
    ["<Space>"] = cmp.mapping(function(fallback)
      if vim.fn.pumvisible() == 0 and cmp.visible() then
        cmp.confirm({
          behavior = cmp.ConfirmBehavior.Insert,
          select = true,
        })
      else
        fallback()
      end
    end, { "i", "c" }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif has_trigger_before() then
        cmp.complete()
      -- elseif vim.fn["vsnip#jumpable"](1) == 1 then
      --   feedkey("<Plug>(vsnip-jump-next)", "")
      elseif luasnip.jumpable(1) then
        luasnip.jump(1)
      elseif luasnip.expandable() then
        luasnip.expand()
      -- elseif luasnip.expand_or_jumpable() then
      --   luasnip.expand_or_jump()
      else
        fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item()
      -- elseif vim.fn["vsnip#jumpable"](-1) == 1 then
      --   feedkey("<Plug>(vsnip-jump-prev)", "")
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      end
    end, { "i", "s" }),
  }),
  sources = cmp.config.sources({
    {
      name = "nvim_lsp",
      group_index = 1,
      priority = 10,
      entry_filter = function(entry)
        return require("cmp.types").lsp.CompletionItemKind[entry:get_kind()] ~= "Text"
      end,
    },
    -- { name = "vsnip", group_index = 1, priority = 3 },
    { name = "luasnip", group_index = 2, priority = 3 },
    { name = "buffer", group_index = 4, priority = 1, max_item_count = 3 },
    { name = "path", group_index = 3, priority = 2, trigger_characters = { "/" } },
    {
      name = "latex_symbols",
      group_index = 3,
      max_item_count = 20,
      priority = 1,
      trigger_characters = { "\\" },
    },
  }),
  sorting = {
    priority_weight = 2,
    comparators = {
      compare.exact,
      -- compare.scopes, -- what?
      compare.score, -- based on :  score = score + ((#sources - (source_index - 1)) * sorting.priority_weight)
      compare.offset,
      compare.recently_used,
      compare.locality,
      -- compare.kind,
      -- compare.sort_text,
      compare.length, -- useless
      compare.order,
    },
  },
  matching = {
    disallow_fuzzy_matching = true,
    disallow_fullfuzzy_matching = true,
    disallow_partial_fuzzy_matching = true,
    disallow_partial_matching = false,
    disallow_prefix_unmatching = true,
  },
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
  mapping = cmp.mapping.preset.cmdline({
    ["<Tab>"] = {
      c = function()
        if cmp.visible() then
          cmp.select_next_item()
        else
          -- cmp.complete()
          feedkey("<C-Tab>", "nt") -- fallback to nvim native completion
        end
      end,
    },
  }),
  sources = cmp.config.sources({
    { name = "path", trigger_characters = { "/" } },
  }, {
    { name = "cmdline", option = {
      ignore_cmds = { "Man", "!" },
    } },
  }),
})

-- for friendly snippets
require("luasnip.loaders.from_vscode").lazy_load()
