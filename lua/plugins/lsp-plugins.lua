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
    {
        "chomosuke/typst-preview.nvim",
        ft = "typst",
        version = "1.*",
        opts = {
            open_cmd = "firefox %s -P typst-preview --class typst-preview",
            debug = true,
            dependencies_bin = {
                ["tinymist"] = "/etc/profiles/per-user/prometheus/bin/tinymist",
                ["websocat"] = nil,
            },
        },
    },
}
