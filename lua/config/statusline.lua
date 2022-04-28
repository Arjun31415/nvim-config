local function spell()
    if vim.o.spell then return string.format("[SPELL]") end

    return ""
end
local colors = {
    red = '#ca1243',
    grey = '#a0a1a7',
    black = '#383a42',
    white = '#f3f3f3',
    light_green = '#83a598',
    orange = '#fe8019',
    green = '#8ec07c'
}

local function ime_state()
    if vim.g.is_mac then
        -- ref: https://github.com/vim-airline/vim-airline/blob/master/autoload/airline/extensions/xkblayout.vim#L11
        local layout = vim.fn.libcall(vim.g.XkbSwitchLib,
                                      'Xkb_Switch_getXkbLayout', '')
        if layout == '0' then return '[CN]' end
    end

    return ""
end

local function trailing_space()
    -- Get the positions of trailing whitespaces from plugin 'jdhao/whitespace.nvim'.
    local trailing_space_pos = vim.b.trailing_whitespace_pos

    local msg = ""
    if #trailing_space_pos > 0 then
        -- Note that lua index is 1-based, not zero based!!!
        local line = trailing_space_pos[1][1]
        msg = string.format("[%d]trailing", line)
    end

    return msg
end

local function mixed_indent()
    local space_pat = [[\v^ +]]
    local tab_pat = [[\v^\t+]]
    local space_indent = vim.fn.search(space_pat, 'nwc')
    local tab_indent = vim.fn.search(tab_pat, 'nwc')
    local mixed = (space_indent > 0 and tab_indent > 0)
    local mixed_same_line
    if not mixed then
        mixed_same_line = vim.fn.search([[\v^(\t+ | +\t)]], 'nwc')
        mixed = mixed_same_line > 0
    end
    if not mixed then return '' end
    if mixed_same_line ~= nil and mixed_same_line > 0 then
        return 'MI:' .. mixed_same_line
    end
    local space_indent_cnt = vim.fn.searchcount({
        pattern = space_pat,
        max_count = 1e3
    }).total
    local tab_indent_cnt = vim.fn.searchcount({
        pattern = tab_pat,
        max_count = 1e3
    }).total
    if space_indent_cnt > tab_indent_cnt then
        return 'MI:' .. tab_indent
    else
        return 'MI:' .. space_indent
    end
end
local empty = require('lualine.component'):extend()

-- Put proper separators and gaps between components in sections
---@diagnostic disable-next-line: unused-function, unused-local
local function process_sections(sections)
    for name, section in pairs(sections) do
        local left = name:sub(9, 10) < 'x'
        for pos = 1, name ~= 'lualine_z' and #section or #section - 1 do
            table.insert(section, pos * 2, {
                empty,
                color = {fg = colors.white, bg = colors.white}
            })
        end
        for id, comp in ipairs(section) do
            if type(comp) ~= 'table' then
                comp = {comp}
                section[id] = comp
            end
            comp.separator = left and {right = ''} or {left = ''}
        end
    end
    return sections
end
require("lualine").setup({
    options = {
        icons_enabled = true,
        theme = "dracula",
        component_separators = {left = "", right = ""},
        section_separators = {left = "", right = ""},
        -- section_separators = {left = '', right = ''},
        -- component_separators = "",
        disabled_filetypes = {},
        always_divide_middle = true,
        globalstatus = true
    },
    sections = {
        lualine_a = {"mode"},
        lualine_b = {
            "branch", "diff", {
                'diagnostics',
                source = {'nvim', 'nvim_lsp'},
                sections = {'error'},
                diagnostics_color = {
                    error = {bg = colors.red, fg = colors.white}
                }
            }, {
                'diagnostics',
                source = {'nvim', "nvim_lsp"},
                sections = {'warn'},
                diagnostics_color = {
                    warn = {bg = colors.orange, fg = colors.white}
                }
            }
        },
        lualine_c = {
            "filename", {ime_state, color = {fg = 'black', bg = '#f46868'}},
            {spell, color = {fg = 'black', bg = '#a7c080'}}
        },
        lualine_x = {
            "encoding",
            {"fileformat", symbols = {unix = "unix", dos = "win", mac = "mac"}},
            "filetype"
        },
        lualine_y = {"progress"},
        lualine_z = {
            "location", {trailing_space, color = "WarningMsg"},
            {mixed_indent, color = "WarningMsg"}
        }
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {"filename"},
        lualine_x = {"location"},
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {},
    extensions = {'quickfix', 'fugitive'}
})

