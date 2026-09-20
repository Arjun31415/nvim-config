local heirline = require("heirline.utils")
local get_hl = heirline.get_highlight

local M = {}
local colors = require("tokyonight.colors").setup()
local onedark = {
    blue = "#8ab7d8",
    green = "#98c369",
    yellow = "#ffff70",
    orange = "#ea9d70",
    purple = "#c475c1",
    red = "#971717",
}
M.colors = colors
local StatusLine = get_hl("Statusline")

local hl = {
    StatusLine = StatusLine,

    ReadOnly = { fg = colors.red },

    WorkDir = { fg = get_hl("Comment").fg, bold = true },

    CurrentPath = { fg = get_hl("Directory").fg, bold = true },

    FileName = { fg = get_hl("Statusline").fg, bold = true },

    FileProperties = {
        dos = { fg = colors.black, bg = colors.red },
        mac = { fg = colors.black, bg = colors.red },
        unix = { fg = colors.black, bg = colors.green },
    },

    DapMessages = { fg = get_hl("Debug").fg },

    Git = {
        branch = { bg = colors.purple, bold = true, fg = StatusLine.bg },
        added = { bg = colors.green, bold = true, fg = StatusLine.bg },
        changed = { bg = colors.yellow, bold = true, fg = StatusLine.bg },
        removed = { bg = colors.red, bold = true, fg = StatusLine.bg },
        dirty = { fg = colors.comment, bold = true },
    },

    LspIndicator = { bg = colors.blue, fg = colors.black },
    LspServer = { bg = onedark.blue, bold = true, fg = colors.black },

    Diagnostic = {
        error = { fg = get_hl("DiagnosticSignError").fg },
        warn = { fg = get_hl("DiagnosticSignWarn").fg },
        info = { fg = get_hl("DiagnosticSignInfo").fg },
        hint = { fg = get_hl("DiagnosticSignHint").fg },
    },

    Ruler = { bg = colors.yellow, fg = colors.black, bold = true },
    ScrollBar = { bg = colors.comment, fg = colors.black },

    SearchResults = { fg = colors.black, bg = colors.cyan },

    WinBar = get_hl("WinBar"),

    Navic = {
        Separator = { fg = colors.comment },
    },
}
M.highlight = hl

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

    hl.Mode = setmetatable({}, {
        __index = function(_, mode)
            return {
                fg = hl.StatusLine.bg,
                bg = mode_colors[mode],
                bold = true,
            }
        end,
    })
end

M.hydra = {
    red = "#f36c62",
    amaranth = "#ff5170",
    teal = "#00aeae",
    pink = "#f173b7",
}

M.lsp_colors = {
    lua_ls = "#5EBCF6",
    nil_ls = "#5EBCF6",
    vimls = "#43BF6C",
    ["rust-analyzer"] = colors.red,
}

return M
