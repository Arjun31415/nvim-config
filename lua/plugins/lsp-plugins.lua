return {
    {
        -- LSP Configuration & Plugins
        "neovim/nvim-lspconfig",
    },
    { "microsoft/python-type-stubs" },
    {
        "folke/trouble.nvim",
        dependencies = "kyazdani42/nvim-web-devicons",
        cmd = "Trouble",
        opts = {},
        keys = {
            {
                "<leader>xx",
                "<cmd>Trouble diagnostics toggle<cr>",
                desc = "Diagnostics (Trouble)",
            },
        },
    },
    {
        "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        config = function()
            require("lsp_lines").setup()
        end,
        event = "BufEnter",
    },
    {
        "mrcjkb/rustaceanvim",
        version = "^3", -- Recommended
        ft = { "rust" },
        dependencies = {
            "mfussenegger/nvim-dap",
        },
    },
}
