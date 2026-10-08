local configFunctions = require("config.lsp.handlers")

return {
    on_attach = function(client, bufnr)
        configFunctions.on_attach(client, bufnr)
        local map = function(mode, keys, cmd, desc)
            vim.keymap.set(mode, keys, cmd, { buffer = bufnr, desc = "Clangd: " .. desc })
        end
        map("n", "<leader>ch", "<cmd>ClangdSwitchSourceHeader<cr>", "Switch source/header")
        map("n", "<leader>cm", "<cmd>ClangdMemoryUsage<cr>", "Memory usage")
        map("n", "<leader>cM", "<cmd>ClangdMemoryUsage expand_preamble<cr>", "Memory usage (expand preamble)")
        map("n", "<leader>cs", "<cmd>ClangdSymbolInfo<cr>", "Symbol info")
        map("n", "<leader>ct", "<cmd>ClangdTypeHierarchy<cr>", "Type hierarchy")
        -- :ClangdAST takes a line range: the current line, or the selection.
        map({ "n", "x" }, "<leader>cA", ":ClangdAST<cr>", "AST")
    end,
}
