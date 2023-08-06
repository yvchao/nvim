-- originally authored by @AdamWhittingham

local path_ok, plenary_path = pcall(require, "plenary.path")
if not path_ok then
    return
end

local cdir = vim.fn.getcwd()
local if_nil = vim.F.if_nil

local nvim_web_devicons = {
    enabled = true,
    highlight = true,
}

local function get_extension(fn)
    local match = fn:match("^.+(%..+)$")
    local ext = ""
    if match ~= nil then
        ext = match:sub(2)
    end
    return ext
end

local function icon(fn)
    local nwd = require("nvim-web-devicons")
    local ext = get_extension(fn)
    return nwd.get_icon(fn, ext, { default = true })
end

local function button(sc, txt, keybind, keybind_opts)
    local sc_ = sc:gsub("%s", "")

    local opts = {
        position = "center",
        shortcut = sc,
        cursor = 3,
        width = 50,
        align_shortcut = "right",
        hl_shortcut = "Keyword",
    }
    if keybind then
        keybind_opts = vim.F.if_nil(keybind_opts, { noremap = true, silent = true, nowait = true })
        opts.keymap = { "n", sc_, keybind, keybind_opts }
    end

    local function on_press()
        local key = vim.api.nvim_replace_termcodes(keybind or sc_ .. "<Ignore>", true, false, true)
        vim.api.nvim_feedkeys(key, "t", false)
    end

    return {
        type = "button",
        val = txt,
        on_press = on_press,
        opts = opts,
    }
end

local function file_button(fn, sc, short_fn,autocd)
    short_fn = short_fn or fn
    local ico_txt
    local fb_hl = {}

    if nvim_web_devicons.enabled then
        local ico, hl = icon(fn)
        local hl_option_type = type(nvim_web_devicons.highlight)
        if hl_option_type == "boolean" then
            if hl and nvim_web_devicons.highlight then
                table.insert(fb_hl, { hl, 0, #ico })
            end
        end
        if hl_option_type == "string" then
            table.insert(fb_hl, { nvim_web_devicons.highlight, 0, #ico })
        end
        ico_txt = ico .. "  "
    else
        ico_txt = ""
    end
    local cd_cmd = (autocd and " | cd %:p:h" or "")
    local file_button_el = button(sc, ico_txt .. short_fn, "<cmd>e " .. fn .. cd_cmd .." <CR>")
    local fn_start = short_fn:match(".*[/\\]")
    if fn_start ~= nil then
        table.insert(fb_hl, { "Comment", #ico_txt - 2, #fn_start + #ico_txt })
    end
    file_button_el.opts.hl = fb_hl
    return file_button_el
end

local default_mru_ignore = { "gitcommit" }

local mru_opts = {
    ignore = function(path, ext)
        return (string.find(path, "COMMIT_EDITMSG")) or (vim.tbl_contains(default_mru_ignore, ext))
    end,
    autocd = false
}

--- @param start number
--- @param cwd string? optional
--- @param items_number number? optional number of items to generate, default = 10
local function mru(start, cwd, items_number, opts)
    opts = opts or mru_opts
    items_number = if_nil(items_number, 10)

    local oldfiles = {}
    for _, v in pairs(vim.v.oldfiles) do
        if #oldfiles == items_number then
            break
        end
        local cwd_cond
        if not cwd then
            cwd_cond = true
        else
            cwd_cond = vim.startswith(v, cwd)
        end
        local ignore = (opts.ignore and opts.ignore(v, get_extension(v))) or false
        if (vim.fn.filereadable(v) == 1) and cwd_cond and not ignore then
            oldfiles[#oldfiles + 1] = v
        end
    end
    local target_width = 35

    local tbl = {}
    for i, fn in ipairs(oldfiles) do
        local short_fn
        if cwd then
            short_fn = vim.fn.fnamemodify(fn, ":.")
        else
            short_fn = vim.fn.fnamemodify(fn, ":~")
        end

        if #short_fn > target_width then
            short_fn = plenary_path.new(short_fn):shorten(1, { -2, -1 })
            if #short_fn > target_width then
                short_fn = plenary_path.new(short_fn):shorten(1, { -1 })
            end
        end

        local shortcut = tostring(i + start - 1)

        local file_button_el = file_button(fn, shortcut, short_fn,opts.autocd)
        tbl[i] = file_button_el
    end
    return {
        type = "group",
        val = tbl,
        opts = {},
    }
end

local header = {
    type = "text",
    val = {
        [[                                  __]],
        [[     ___     ___    ___   __  __ /\_\    ___ ___]],
        [[    / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\]],
        [[   /\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \]],
        [[   \ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
        [[    \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
    },
    opts = {
        position = "center",
        hl = "Type",
        -- wrap = "overflow";
    },
}

local section_mru = {
    type = "group",
    val = {
        {
            type = "text",
            val = "Recent files",
            opts = {
                hl = "SpecialComment",
                shrink_margin = false,
                position = "center",
            },
        },
        { type = "padding", val = 1 },
        {
            type = "group",
            val = function()
                return { mru(0, cdir) }
            end,
            opts = { shrink_margin = false },
        },
    },
}

local buttons = {
    type = "group",
    val = {
        { type = "text", val = "Quick links", opts = { hl = "SpecialComment", position = "center" } },
        { type = "padding", val = 1 },
        button("e", "  New file", "<cmd>ene<CR>"),
        button("<leader> f f", "󰈞  Find file", "<cmd>Telescope find_files hidden=true no_ignore=true<CR>"),
        button("<leader> f g", "󰊄  Live grep", "<cmd>Telescope live_grep<CR>"),
        button("c", "  Configuration", "<cmd>cd ~/.config/nvim/ | e init.lua<CR>"),
        button("u", "  Update plugins", "<cmd>PackerSync<CR>"),
        button("q", "󰅚  Quit", "<cmd>qa<CR>"),
        { type = "text", val = "<leader> = space", opts = { hl = "SpecialComment", position = "center" } },
    },
    position = "center",
}

local config = {
    layout = {
        { type = "padding", val = 2 },
        header,
        { type = "padding", val = 2 },
        section_mru,
        { type = "padding", val = 2 },
        buttons,
    },
    opts = {
        margin = 5,
        setup = function()
            vim.api.nvim_create_autocmd('DirChanged', {
                pattern = '*',
                group = "alpha_temp",
                callback = function () require('alpha').redraw() end,
            })
        end,
    },
}

local mix = {
    header = header,
    buttons = buttons,
    mru = mru,
    config = config,
    -- theme specific config
    mru_opts = mru_opts,
    leader = vim.g.mapleader,
    nvim_web_devicons = nvim_web_devicons,
}



local is_status_ok, alpha = pcall(require, "alpha")

if not is_status_ok then
  vim.notify("Failed to find alpha-nvim", vim.log.levels.ERROR, {
    title = "plugins",
  })
  return
end

alpha.setup(mix.config)
