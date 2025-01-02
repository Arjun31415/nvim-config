local configFunctions = require("config.lsp.handlers")
local lspconfig = require("lspconfig")
local servers = {
    "pyright",
    "clangd",
    "ts_ls",
    "cmake",
    "nil_ls",
    -- "nixd",
}
for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup({
        capabilities = configFunctions.capabilities,
        on_attach = configFunctions.on_attach,
    })
end
require("config.lsp.settings.rust")

local jsonls_opts = require("config.lsp.settings.jsonls")
local opts = {}
opts = vim.tbl_deep_extend("force", jsonls_opts, opts)
opts.on_attach = configFunctions.on_attach
lspconfig.jsonls.setup(opts)
lspconfig.lua_ls.setup({
    capabilities = configFunctions.capabilities,
    on_attach = configFunctions.on_attach,
    settings = {
        Lua = {
            workspace = { checkThirdParty = false },
        },
    },
})
