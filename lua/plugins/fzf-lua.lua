return {
    {
        -- Fuzzy Finder (files, lsp, etc)
        "ibhagwan/fzf-lua",
        -- optional for icon support
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {},
        keys = {
            {
                "<leader>?",
                function()
                    require("fzf-lua").oldfiles()
                end,
                desc = "[?] Find recently opened files",
            },
            {
                "<leader><space>",
                function()
                    require("fzf-lua").buffers()
                end,
                desc = "[ ] Find existing buffers",
            },
            {
                "<leader>/",
                function()
                    require("fzf-lua").grep_curbuf()
                end,
                desc = "[/] Fuzzily search in current buffer",
            },
            {
                "<leader>gf",
                function()
                    require("fzf-lua").git_files()
                end,
                desc = "Search [G]it [F]iles",
            },
            {
                "<leader>sf",
                function()
                    require("fzf-lua").files()
                end,
                desc = "[S]earch [F]iles",
            },
            {
                "<leader>sw",
                function()
                    require("fzf-lua").grep_cword()
                end,
                desc = "[S]earch current [W]ord",
            },
            {
                "<leader>sg",
                function()
                    require("fzf-lua").live_grep()
                end,
                desc = "[S]earch by [G]rep (Live grep)",
            },
            {
                "<leader>sd",
                function()
                    require("fzf-lua").diagnostics_workspace()
                end,
                desc = "[S]earch [D]iagnostics",
            },
            {
                "<leader>sr",
                function()
                    require("fzf-lua").resume()
                end,
                desc = "[S]earch [R]esume",
            },
        },
    },
}
