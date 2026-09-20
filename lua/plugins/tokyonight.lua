return {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
        require("tokyonight").setup({

            cache = true,
            style = "moon", -- storm | moon | night | day
            light_style = "day",
            transparent = true,
            terminal_colors = true,
            styles = {
                comments = { italic = true },
                keywords = { italic = true },
                functions = {},
                variables = {},
                -- "dark" | "transparent" | "normal"
                sidebars = "dark",
                floats = "dark",
            },
            sidebars = { "qf", "help" },
            day_brightness = 0.3, -- 0 = dull, 1 = vibrant
            hide_inactive_statusline = false,
            dim_inactive = false,
            lualine_bold = true,
        })
        vim.cmd([[colorscheme tokyonight]])
    end,
}
