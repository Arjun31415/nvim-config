vim.o.background = "dark" -- to load onedark
local onedarkpro = require("onedarkpro")
onedarkpro.setup({
    -- Theme can be overwritten with 'onedark' or 'onelight' as a string
    --    theme = function()
    --      if vim.o.background == "dark" then
    --        return config.dark_theme
    --  else
    --    return config.light_theme
    --      end
    --  end,
    colors = { onedark_vivid = { bg = "#27292d" } }, -- Override default colors by specifying colors for 'onelight' or 'onedark' themes
    -- hlgroups = {}, -- Override default highlight groups
    highlights = {
        -- Use the filetype as per the `set filetype?` command
        ["@field.yaml"] = { TSField = { fg = "${red}" } },
        ["@field.python"] = { TSConstructor = { fg = "${bg}", bg = "${red}" } },
    },
    options = {
        bold = false, -- Use the themes opinionated bold styles?
        italic = true, -- Use the themes opinionated italic styles?
        underline = false, -- Use the themes opinionated underline styles?
        undercurl = false, -- Use the themes opinionated undercurl styles?
        cursorline = true, -- Use cursorline highlighting?
        transparency = true, -- Use a transparent background?
        terminal_colors = true, -- Use the theme's colors for Neovim's :terminal?
        window_unfocussed_color = false, -- When the window is out of focus, change the normal background?
    },
    styles = {
        comments = "italic",
        functions = "NONE",
        keywords = "bold,italic",
        strings = "NONE",
        variables = "NONE",
        virtual_text = "NONE",
    },
})
vim.cmd("colorscheme onedark")
-- require('onedarkpro').load()
