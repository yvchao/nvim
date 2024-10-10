vim.filetype.add({
  extension = {
    typst = "typst",
    typ = "typst",
  },
  pattern = {
    [".*/waybar/config"] = "jsonc",
    [".*/mako/config"] = "dosini",
    [".*/hypr/.*%.conf"] = "hyprlang",
  },
})
