local configFunctions = require("config.lsp.handlers")
-- local extension_path = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/adapter"
-- local codelldb_path = extension_path .. "/codelldb"
-- local liblldb_path = extension_path .. "/libcodelldb.so"

vim.g.rustaceanvim = {
    server = {
        on_attach = configFunctions.on_attach,
    },
}
