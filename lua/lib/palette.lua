local colors = {
  bg = "#2F3445",
  fg = "#F5DBDB",
  fg_alt = "#592147",
  bg_alt = "#16161D",
  fg_status = "#202020",
  bg_status = "#FFBB00",
  active_buffer = "#aaaaaa",
  inactive_buffer = "#666666",
  black = "#16161D",
  grey = "#303030",
  yellow = "#E5C07B",
  cyan = "#00DD88",
  dimblue = "#112277",
  green = "#98C379",
  orange = "#FF8800",
  purple = "#8800DD",
  magenta = "#C858E9",
  blue = "#1289EF",
  red = "#D54E53",
}

local M = {
  current_scheme = "default",
  colors = colors,
}

M.update_palette = function()
  M.current_scheme = vim.g.colors_name

  if M.current_scheme == "kanagawa" then
    M.colors.yellow = "#CC6600"
    M.colors.green = "#008800"
    M.colors.cyan = "#00BBCC"
    M.colors.blue = "#1289EF"
    if vim.o.background == "light" then
      M.colors.bg = "#C8C093"
      M.colors.fg = "#1F1F1F"
      M.colors.fg_alt = "#7F7F7F"
      M.colors.bg_alt = "#f2ecbc"
    else
      M.colors.bg = "#223249"
      M.colors.fg = "#F1F1F1"
      M.colors.fg_alt = "#A1A1A1"
      M.colors.bg_alt = "#1F1F28"
    end
  elseif M.current_scheme == "rose-pine" then
    M.colors.yellow = "#CC6600"
    M.colors.green = "#008800"
    M.colors.cyan = "#11AACC"
    M.colors.blue = "#1289EF"
    if vim.o.background == "light" then
      M.colors.bg = "#DDDDDD"
      M.colors.fg = "#1F1F1F"
      M.colors.fg_alt = "#7F7F7F"
      M.colors.bg_alt = "#faf4ed"
    else
      M.colors.bg = "#111122"
      M.colors.fg = "#F1F1F1"
      M.colors.fg_alt = "#A1A1A1"
      M.colors.bg_alt = "#191724"
    end
  else
    -- do nothing
  end
end

M.get_color = function(name)
  return M.colors[name]
end

M.bg = function()
  return M.colors.bg
end

M.bg_alt = function()
  return M.colors.bg_alt
end
M.fg = function()
  return M.colors.fg
end
return M
