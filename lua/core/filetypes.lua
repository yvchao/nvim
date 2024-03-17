vim.filetype.add({
  extension = {},
  pattern = {
    [".*/waybar/config"] = "jsonc",
    [".*/mako/config"] = "dosini",
    [".*/hypr/.*%.conf"] = "hyprlang",
  },
})
