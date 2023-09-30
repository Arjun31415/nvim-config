return {
    { "VonHeikemen/lsp-zero.nvim", branch = "v3.x", lazy = true, config = false },
    {
        "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        config = function()
            require("lsp_lines").setup()
        end,
    },
}
