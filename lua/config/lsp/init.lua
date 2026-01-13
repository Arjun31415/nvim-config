local configFunctions = require("config.lsp.handlers")
local lspconfig = vim.lsp.config
local servers = {
    "clangd",
    "ts_ls",
    "cmake",
    "nil_ls",
    -- "nixd",
}
for _, lsp in ipairs(servers) do
    lspconfig(lsp, {
        capabilities = configFunctions.capabilities,
        on_attach = configFunctions.on_attach,
    })
    vim.lsp.enable(lsp)
end
require("config.lsp.settings.rust")

lspconfig("basedpyright", {
    capabilities = configFunctions.capabilities,
    on_attach = configFunctions.on_attach,
    before_init = function(_, config)
        config.settings.basedpyright.analysis.stubPath =
            vim.fs.joinpath(vim.fn.stdpath("data"), "lazy", "python-type-stubs")
    end,
})
vim.lsp.enable("basedpyright")
local jsonls_opts = require("config.lsp.settings.jsonls")
local opts = {}
opts = vim.tbl_deep_extend("force", jsonls_opts, opts)
opts.on_attach = configFunctions.on_attach
-- lspconfig.jsonls.setup(opts)
lspconfig("jsonls", opts)
vim.lsp.enable("jsonls")
-- lspconfig.lua_ls.setup({
--     capabilities = configFunctions.capabilities,
--     on_attach = configFunctions.on_attach,
--     settings = {
--         Lua = {
--             workspace = { checkThirdParty = false },
--         },
--     },
-- })
lspconfig("lua_ls", {
    capabilities = configFunctions.capabilities,
    on_attach = configFunctions.on_attach,
    settings = {
        Lua = {
            workspace = { checkThirdParty = false },
        },
    },
})
lspconfig("tinymist", {

    capabilities = configFunctions.capabilities,
    on_attach = configFunctions.on_attach,
    settings = {
        formatterMode = "typstyle",
        exportPdf = "onType",
        semanticTokens = "disable",
    },
})
vim.lsp.enable("tinymist")
vim.lsp.enable("lua_ls")
