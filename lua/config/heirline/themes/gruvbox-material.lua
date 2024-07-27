local heirline = require("heirline.utils")
local get_hl = heirline.get_highlight

local M = {} -- theme
local colors = require("tokyonight.colors").setup()
-- local colors
-- do
--     --                      black             #282828
--     -- fg0        #e2cca9   bg0               #32302f
--     -- fg1        #f0dec2   bg1               #3c3836
--     --                      bg2               #3c3836
--     -- grey0      #7c6f64   bg3               #504945
--     -- grey1      #928374   bg4               #504945
--     -- grey2      #a89984   bg5               #665c54
--     -- grey3      #b0a392   bg_current_word   #45403d
--     -- cyan       #8bba7f   bg_diff_blue      #0f3a42
--     -- blue       #80aa9e   bg_diff_green     #3d4220
--     -- blue2      #64af9c
--     -- green      #b0b846   bg_diff_red       #472322
--     -- orange     #f28534
--     -- purple     #d3869b   bg_statusline1    #3c3836
--     -- red        #f2594b   bg_statusline2    #46413e
--     -- yellow     #e9b143   bg_statusline3    #5b534d
--     --                      bg_visual_blue    #404946
--     -- bg_yellow  #e9b143   bg_visual_green   #424a3e
--     -- bg_green   #b0b846   bg_visual_red     #543937
--     -- bg_red     #db4740   bg_visual_yellow  #574833
--
--     local config = vim.fn["gruvbox_material#get_configuration"]()
--     local get_palette = vim.fn["gruvbox_material#get_palette"]
--     colors = get_palette(config.background, config.foreground, config.colors_override)
--     for key, color in pairs(colors) do
--         colors[key] = color[1]
--     end
--
--     -- Do not delete! It is my addition.
--     colors.fg1 = "#f0dec2"
--     colors.comment = "#b0a392"
--     colors.black = "#282828"
--     colors.blue2 = "#64af9c"
--
-- end

local onedark = {
    blue = "#8ab7d8",
    green = "#98c369",
    yellow = "#ffff70",
    orange = "#ea9d70",
    purple = "#c475c1",
    red = "#971717",
}
M.colors = colors

local hl = {
    StatusLine = get_hl("Statusline"),

    ReadOnly = { fg = colors.red },

    WorkDir = { fg = get_hl("Comment").fg, bold = true },
    -- WorkDir = { fg = colors.comment, bold = true },

    CurrentPath = { fg = get_hl("Directory").fg, bold = true },

    FileName = { fg = get_hl("Statusline").fg, bold = true },

    -- GPS = { fg = colors.comment },

    FileProperties = nil,

    DapMessages = { fg = get_hl("Debug").fg },

    Git = {
        branch = { fg = colors.purple, bold = true },
        added = { fg = colors.green, bold = true },
        changed = { fg = colors.yellow, bold = true },
        removed = { fg = colors.red, bold = true },
        dirty = { fg = colors.comment, bold = true },
    },

    LspIndicator = { fg = colors.blue },
    LspServer = { fg = onedark.blue, bold = true },

    Diagnostic = {
        error = { fg = get_hl("DiagnosticSignError").fg },
        warn = { fg = get_hl("DiagnosticSignWarn").fg },
        info = { fg = get_hl("DiagnosticSignInfo").fg },
        hint = { fg = get_hl("DiagnosticSignHint").fg },
    },

    ScrollBar = { bg = colors.comment, fg = colors.fg_dark },

    SearchResults = { fg = colors.black, bg = colors.cyan },

    WinBar = get_hl("WinBar"),

    -- WinBar = {
    --    -- fg = get_highlight('Statusline').fg,
    --    bg = get_highlight('SignColumn').bg,
    --    -- bg = colors.bg_statusline2,
    -- },

    Navic = {
        -- Lable = { fg = colors.comment },
        Separator = { fg = colors.comment },
    },
}
M.highlight = hl

-- Mode colors
do
    local mode_colors = {
        normal = colors.green,
        op = colors.blue,
        insert = colors.blue,
        visual = colors.yellow,
        visual_lines = colors.yellow,
        visual_block = colors.yellow,
        replace = colors.red,
        v_replace = colors.red,
        enter = colors.cyan,
        more = colors.cyan,
        select = colors.purple,
        command = colors.cyan,
        shell = colors.orange,
        term = colors.orange,
        none = colors.red,
    }

    hl.Mode = setmetatable({
        -- normal = { fg = mode_colors.normal },
    }, {
        __index = function(_, mode)
            return {
                -- fg = colors.black,
                fg = hl.StatusLine.bg,
                bg = mode_colors[mode],
                bold = true,
            }
        end,
    })
end

-- hydra
do
    -- #008080
    -- #00a4a4
    -- #00aeae

    -- #f2594b
    -- #f36c62

    -- #ff1757
    -- #ff476b
    -- #ff5170

    -- #f063b2
    -- #f173b7

    M.hydra = {
        red = "#f36c62",
        amaranth = "#ff5170",
        teal = "#00aeae",
        pink = "#f173b7",
    }
end

M.lsp_colors = {
    lua_ls = "#5EBCF6",
    vimls = "#43BF6C",
    ansiblels = "#ffffff",
}

return M
