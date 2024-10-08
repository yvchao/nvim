local function has_words_before()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 1
    and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col - 1, col - 1):match("%s")
      == nil
end

local function has_trigger_before()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 1
    and vim.api
        .nvim_buf_get_lines(0, line - 1, line, true)[1]
        :sub(col - 1, col - 1)
        :match("[\\/]")
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

local ELLIPSIS_CHAR = "…"
local MAX_LABEL_WIDTH = 30
local MIN_LABEL_WIDTH = 30

local function setup_cmp()
  local cmp = require("cmp")
  local compare = require("cmp.config.compare")
  local luasnip = require("luasnip")
  local cmp_autopairs = require("nvim-autopairs.completion.cmp")

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
        local label = item.abbr
        local label_len = string.len(label)
        if label_len >= MAX_LABEL_WIDTH then
          item.abbr = vim.fn.strcharpart(label, 0, MAX_LABEL_WIDTH) .. ELLIPSIS_CHAR
        elseif label_len < MIN_LABEL_WIDTH then
          item.abbr = label .. string.rep(" ", MIN_LABEL_WIDTH - label_len)
        end
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
      }),
      ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), {
        "i",
      }),
      ["<C-q>"] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      ["<BS>"] = cmp.mapping(function(fallback)
        fallback()
        if cmp.visible() and not has_words_before() then
          -- we only close the popup here, the popup appears again when we start typing
          cmp.close()
        end
      end, { "i", "s" }),
      ["<C-w>"] = cmp.mapping(function(fallback)
        -- delete a whole word
        fallback()
        -- if cmp is in completion mode, we close the popup and reset its state
        if cmp.visible() then
          -- Based on the behavior of cmp.confirm, we can call cmp.core:reset() to cancel the current completion
          -- https://github.com/hrsh7th/nvim-cmp/blob/04e0ca376d6abdbfc8b52180f8ea236cbfddf782/lua/cmp/core.lua#L131
          -- https://github.com/hrsh7th/nvim-cmp/blob/97dc716fc914c46577a4f254035ebef1aa72558a/lua/cmp/init.lua#L354
          -- This is equivalent to the behavior on InsertLeave
          cmp.core:reset()
          cmp.core.view:close()
        end
      end, { "i", "s" }),
      ["<CR>"] = cmp.mapping(function(fallback)
        if vim.fn.pumvisible() == 0 and cmp.visible() then
          cmp.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
          })
        else
          fallback()
        end
      end, { "i", "c" }),
      ["<Space>"] = cmp.mapping(function(fallback)
        if vim.fn.pumvisible() == 0 and cmp.visible() then
          cmp.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
          })
        else
          fallback()
        end
      end, { "i" }),
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif has_trigger_before() then
          cmp.complete()
        elseif luasnip.expandable() then
          luasnip.expand()
        elseif luasnip.locally_jumpable(1) then
          luasnip.jump(1)
        else
          -- vim.print("call fallback.")
          fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
        end
      end, { "i", "s" }),
      ["<S-Tab>"] = cmp.mapping(function()
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.locally_jumpable(-1) then
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
        option = {
          markdown_oxide = {
            keyword_pattern = [[\(\k\| \|\/\|#\)\+]],
          },
        },
      },
      { name = "luasnip", group_index = 2, priority = 3 },
      { name = "buffer", group_index = 3, priority = 1, max_item_count = 10 },
      { name = "path", group_index = 3, priority = 2, trigger_characters = { "/" } },
    }),
    sorting = {
      priority_weight = 2,
      -- comparators = {
      --   compare.offset,
      --   compare.exact,
      --   -- compare.scopes, -- what?
      --   compare.score, -- based on :  score = score + ((#sources - (source_index - 1)) * sorting.priority_weight)
      --   compare.recently_used,
      --   compare.locality,
      --   compare.kind,
      --   -- compare.sort_text,
      --   compare.length, -- useless
      --   compare.order,
      -- },
    },
    matching = {
      disallow_fuzzy_matching = true,
      disallow_fullfuzzy_matching = true,
      disallow_partial_fuzzy_matching = true,
      disallow_partial_matching = false,
      disallow_prefix_unmatching = true,
    },
    -- experimental = {
    --   ghost_text = { hl_group = "NonText" },
    -- },
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
      ["<C-n>"] = cmp.config.disable,
      ["<C-p>"] = cmp.config.disable,
      ["<Tab>"] = {
        c = function()
          if cmp.visible() then
            cmp.select_next_item()
          else
            cmp.complete()
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

  -- to work with autopairs
  cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

  -- to work with copilot
  cmp.event:on("menu_opened", function()
    vim.b.copilot_suggestion_hidden = true
  end)

  cmp.event:on("menu_closed", function()
    vim.b.copilot_suggestion_hidden = false
  end)

  -- for friendly snippets
  require("luasnip.loaders.from_vscode").lazy_load({
    paths = {
      -- vim.fn.expand("~") .. "/.local/share/nvim/lazy/friendly-snippets/",
      vim.fn.stdpath("config") .. "/snippets/",
    },
  })
  luasnip.config.set_config({
    region_check_events = "InsertEnter",
    delete_check_events = "InsertLeave",
  })
end

return {
  -- the completion core
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-cmdline",
      -- "kdheepak/cmp-latex-symbols",
    },
    event = {
      "InsertEnter",
      "CmdlineEnter",
    },
    config = setup_cmp,
  },
  {
    "L3MON4D3/LuaSnip",
    -- follow latest release.
    version = "2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    -- install jsregexp (optional!).
    build = "make install_jsregexp",
    dependencies = {
      -- "rafamadriz/friendly-snippets",
    },
    event = "InsertEnter",
  },
}
