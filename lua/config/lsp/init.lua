local lsp = require("lsp-zero").preset({})
lsp.extend_lspconfig()
local configFunctions = require("config.lsp.handlers")
local lspconfig = require("lspconfig")
local servers = {
    "pyright",
    "jsonls",
    "clangd",
    "tsserver",
    "cmake",
    "rust_analyzer",
    "lua_ls",
    "nil_ls",
    "nixd",
}
lsp.setup_servers(servers)
lsp.on_attach = configFunctions.on_attach
require("config.lsp.settings.rust")
local clangd_capabilities = configFunctions.capabilities

lspconfig.clangd.setup({
    capabilities = clangd_capabilities,
    on_attach = configFunctions.on_attach,
})
lspconfig.pyright.setup({
    capabilities = configFunctions.capabilities,
    on_attach = configFunctions.on_attach,
})

local jsonls_opts = require("config.lsp.settings.jsonls")
local opts = {}
opts = vim.tbl_deep_extend("force", jsonls_opts, opts)
opts.on_attach = configFunctions.on_attach
lspconfig.jsonls.setup(opts)
local lua_ls_opts = lsp.nvim_lua_ls({ on_attach = configFunctions.on_attach })
lspconfig.lua_ls.setup(lua_ls_opts)
lspconfig.nil_ls.setup({ on_attach = configFunctions.on_attach })
lspconfig.nixd.setup({ on_attach = configFunctions.on_attach })
