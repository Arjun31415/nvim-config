-- Nvim sets 'background' from the terminal's OSC 11 reply before user config,
-- and updates it live when the terminal reports a theme change (mode 2031).
-- That makes the terminal the OS-agnostic source of truth for light/dark, so
-- the scheme follows 'background' instead of querying macOS or Linux directly.
local schemes = { dark = "tokyonight", light = "everforest" }

local function apply_scheme_for_background()
    local scheme = schemes[vim.o.background]
    if vim.g.colors_name ~= scheme then
        vim.cmd.colorscheme(scheme)
    end
end

return {
    {
        "sainnhe/everforest",
        lazy = false,
        priority = 1000,
        init = function()
            vim.g.everforest_background = "medium"
            vim.g.everforest_better_performance = 1
        end,
    },
    {
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
            apply_scheme_for_background()
            vim.api.nvim_create_autocmd("OptionSet", {
                group = vim.api.nvim_create_augroup("background_colorscheme", {}),
                pattern = "background",
                callback = apply_scheme_for_background,
            })
        end,
    },
}
