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
    -- {
    --     "nvimdev/guard.nvim",
    --     -- Builtin configuration, optional
    --     dependencies = {
    --         "nvimdev/guard-collection",
    --     },
    --     config = function()
    --         local ft = require("guard.filetype")
    --         ft("typescript,javascript,typescriptreact"):fmt("prettier")
    --         ft("*"):lint("codespell")
    --         -- ft("tex"):fmt("latexindent")
    --         vim.g.guard_config = {
    --             -- the only options for the setup function
    --             fmt_on_save = false,
    --             -- Use lsp if no formatter was defined for this filetype
    --             lsp_as_default_formatter = false,
    --         }
    --     end,
    -- },
    --
    {
        "stevearc/conform.nvim",
        opts = {
            formatters_by_ft = {
                lua = { "stylua" },
                -- Conform will run multiple formatters sequentially
                python = { "ruff_format", "ruff_fix" },
                -- You can customize some of the format options for the filetype (:help conform.format)
                rust = { "rustfmt", lsp_format = "fallback" },
                c = { "clang-format" },
                cpp = { "clang-format" },
                nix = { "alejandra" },
                typst = { lsp_format = "first" },
            },
        },
    },
    {
        "mfussenegger/nvim-lint",
        event = "VimEnter",
        opts = {
            -- Event to trigger linters
            events = { "BufWritePost", "BufReadPost", "InsertLeave" },
            linters_by_ft = {
                fish = { "fish" },
                -- Use the "*" filetype to run linters on all filetypes.
                -- ['*'] = { 'global linter' },
                -- Use the "_" filetype to run linters on filetypes that don't have other linters configured.
                -- ['_'] = { 'fallback linter' },
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
                    -- try_lint without arguments runs the linters defined in `linters_by_ft`
                    -- for the current filetype
                    require("lint").try_lint()

                    -- You can call `try_lint` with a linter name or a list of names to always
                    -- run specific linters, independent of the `linters_by_ft` configuration
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
        -- lazy = false, -- Recommended
        ft = "markdown", -- If you decide to lazy-load anyway
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },
    },
    -- {
    --     "tris203/precognition.nvim",
    --     config = {
    --         startVisible = true,
    --         showBlankVirtLine = true,
    --     },
    -- },
}
