local ok, rt = pcall(require, "rust-tools")
if not ok then
  vim.notify(rt, vim.log.levels.ERROR, {
    title = "rust-tools",
  })
  return
end

local opts = {
  tools = {
    autoSetHints = true,
    executor = require("rust-tools/executors").termopen,
    runnables = {
      use_telescope = true,

      prompt_prefix = "  ",
      selection_caret = "  ",
      entry_prefix = "  ",
      initial_mode = "insert",
      selection_strategy = "reset",
      sorting_strategy = "descending",
      layout_strategy = "vertical",
      layout_config = {
        width = 0.3,
        height = 0.50,
        preview_cutoff = 0,
        prompt_position = "bottom",
      },
    },

    -- These apply to the default RustSetInlayHints command
    inlay_hints = {
      show_parameter_hints = true,
      show_variable_name = true,
      parameter_hints_prefix = "<- ",
      other_hints_prefix = "=> ",
      max_len_align = false,
      max_len_align_padding = 1,
      right_align = false,
      right_align_padding = 7,
    },

    hover_actions = {
      border = {
        { "╭", "FloatBorder" },
        { "─", "FloatBorder" },
        { "╮", "FloatBorder" },
        { "│", "FloatBorder" },
        { "╯", "FloatBorder" },
        { "─", "FloatBorder" },
        { "╰", "FloatBorder" },
        { "│", "FloatBorder" },
      },
      auto_focus = true,
    },
  },
}

rt.setup(opts)

vim.g.rustfmt_options = "--edition=2021"
