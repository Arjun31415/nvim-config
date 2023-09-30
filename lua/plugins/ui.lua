return {
    {
        "https://github.com/folke/noice.nvim",
        event = "VeryLazy",
        dependencies = {
            { "MunifTanjim/nui.nvim", lazy = true },
            "rcarriga/nvim-notify",
        },
        config = function()
            require("noice").setup({
                routes = {
                    {
                        filter = {
                            event = "msg_show",
                            kind = "search_count",
                        },
                        opts = { skip = true },
                    },
                    {
                        filter = {
                            event = "msg_show",
                            find = "AutoSave",
                        },
                        opts = { skip = true },
                    },
                    {
                        filter = {
                            find = "client offset_encodings",
                        },
                        opts = { skip = true },
                    },
                    {
                        filter = {
                            event = "msg_show",
                            kind = "",
                            find = "written",
                        },
                        opts = { skip = true },
                    },
                    {
                        filter = {
                            find = "Highlight group 'NotifyBackground' has no background highlight",
                        },
                        opts = { skip = true },
                    },
                },
                lsp = {
                    override = {
                        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                        ["vim.lsp.util.stylize_markdown"] = true,
                        ["cmp.entry.get_documentation"] = true,
                    },
                    progress = {
                        enabled = true,
                        format = "lsp_progress",
                        view = "mini",
                    },
                },
                presets = {
                    bottom_search = true,
                    command_palette = true,
                    long_message_to_split = true,
                },
                popupmenu = {
                    enabled = true, -- enables the Noice popupmenu UI
                    ---@type 'nui'|'cmp'
                    backend = "cmp", -- backend to use to show regular cmdline completions
                },
            })
        end,
    },

    {
        "stevearc/dressing.nvim",
        lazy = true,
        init = function()
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.ui.select = function(...)
                require("lazy").load({ plugins = { "dressing.nvim" } })
                return vim.ui.select(...)
            end
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.ui.input = function(...)
                require("lazy").load({ plugins = { "dressing.nvim" } })
                return vim.ui.input(...)
            end
        end,
    },
}
