return {
  {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      fzf_colors = {
        ["gutter"] = { "bg", "Normal" },
      },
    },
    keys = {
      { "<leader>ff", [[<cmd>lua require('fzf-lua').files()<CR>]], { desc = "File grep" } },
      { "<leader>fg", [[<cmd>lua require('fzf-lua').live_grep()<CR>]], { desc = "Live grep" } },
    },
    cmd = { "FzfLua" },
    enabled = false,
  },

  {
    "junegunn/fzf",
    build = "./install --bin",
    cmd = { "FZF" },
  },
}
