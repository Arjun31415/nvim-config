return {
    {
        -- LSP Configuration & Plugins
        "neovim/nvim-lspconfig",
        dependencies = {
            -- Additional lua configuration, makes nvim stuff amazing!
            "folke/neodev.nvim",
        },
    },
    { "VonHeikemen/lsp-zero.nvim", branch = "v3.x", lazy = true, config = false },
    {
        "folke/trouble.nvim",
        dependencies = "kyazdani42/nvim-web-devicons",
        event = "BufEnter",
    },
    { "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        config = function()
            require("lsp_lines").setup()
        end,
        event = "BufEnter",
    },
}
