return {
    {
        "echasnovski/mini.bufremove",

        keys = {
            {
                "<leader>bd",
                function()
                    local bd = require("mini.bufremove").delete
                    if vim.bo.modified then
                        local choice =
                            vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
                        if choice == 1 then -- Yes
                            vim.cmd.write()
                            bd(0)
                        elseif choice == 2 then -- No
                            bd(0, true)
                        end
                    else
                        bd(0)
                    end
                end,
                desc = "Delete Buffer",
            },
            -- stylua: ignore
            { "<leader>bD", function() require("mini.bufremove").delete(0, true) end, desc = "Delete Buffer (Force)" },
        },
    },
    {
        "stevearc/conform.nvim",
        opts = {
            formatters_by_ft = {
                lua = { "stylua" },
                python = { "ruff_format", "ruff_fix" },
                rust = { "rustfmt", lsp_format = "fallback" },
                c = { "clang-format" },
                cpp = { "clang-format" },
                -- nixfmt, not alejandra: ~/nix-darwin-config is formatted
                -- with nixfmt and alejandra would reflow all of it.
                nix = { "nixfmt" },
                typst = { lsp_format = "first" },
                -- No standalone Java formatter here; jdtls' Eclipse
                -- formatter is the one that knows the project's profile.
                java = { lsp_format = "first" },
            },
        },
    },
    {
        "mfussenegger/nvim-lint",
        event = "VimEnter",
        opts = {
            events = { "BufWritePost", "BufReadPost", "InsertLeave" },
            linters_by_ft = {
                fish = { "fish" },
                ["*"] = { "codespell" },
                python = { "ruff" },
                c = { "clangtidy" },
                cpp = { "clangtidy" },
                lua = { "selene" },
            },
        },
        config = function(_, opts)
            local lint = require("lint")
            lint.linters_by_ft = opts.linters_by_ft
            vim.api.nvim_create_autocmd(opts.events, {
                callback = function()
                    require("lint").try_lint()

                    -- codespell is not in linters_by_ft: run it on every filetype.
                    require("lint").try_lint("codespell")
                end,
            })
            local ns = require("lint").get_namespace("ruff")
            vim.diagnostic.config({ virtual_text = true }, ns)
        end,
    },
    {
        "chentoast/marks.nvim",
        config = function()
            require("marks").setup()
        end,
    },
    {
        "OXY2DEV/markview.nvim",
        ft = "markdown",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },
    },
}
