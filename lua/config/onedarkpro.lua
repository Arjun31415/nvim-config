vim.o.background = "dark" -- to load onedark
local onedarkpro = require("onedarkpro")
local config = {dark_theme = "onedark_vivid", light_theme = "onelight"}

onedarkpro.setup({
    dark_theme = "onedark_vivid", -- The default dark theme
    light_theme = "onelight", -- The default light theme
    -- Theme can be overwritten with 'onedark' or 'onelight' as a string
    --    theme = function()
    --      if vim.o.background == "dark" then
    --        return config.dark_theme
    --  else
    --    return config.light_theme
    --      end
    --  end,
    colors = {onedark_vivid = {bg = '#27292d'}}, -- Override default colors by specifying colors for 'onelight' or 'onedark' themes
    -- hlgroups = {}, -- Override default highlight groups
    -- filetype_hlgroups = {}, -- Override default highlight groups for specific filetypes
    -- styles = {
    --     strings = "NONE", -- Style that is applied to strings
    --     comments = "NONE", -- Style that is applied to comments
    --     keywords = "NONE", -- Style that is applied to keywords
    --     functions = "NONE", -- Style that is applied to functions
    --     variables = "NONE", -- Style that is applied to variables
    --     virtual_text = "NONE" -- Style that is applied to virtual text
    -- },
    options = {
        bold = false, -- Use the themes opinionated bold styles?
        italic = true, -- Use the themes opinionated italic styles?
        underline = false, -- Use the themes opinionated underline styles?
        undercurl = false, -- Use the themes opinionated undercurl styles?
        cursorline = true, -- Use cursorline highlighting?
        transparency = true, -- Use a transparent background?
        terminal_colors = true, -- Use the theme's colors for Neovim's :terminal?
        window_unfocussed_color = false -- When the window is out of focus, change the normal background?
    }
})
require('onedarkpro').load()

