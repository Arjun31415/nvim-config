local lsp = require("lsp-zero").preset({})
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
}
lsp.setup_servers(servers)
lsp.on_attach = configFunctions.on_attach
require("config.lsp.settings.rust")
local clangd_capabilities = configFunctions.capabilities
clangd_capabilities.offsetEncoding = "utf-16"

require("lspconfig").clangd.setup({
    capabilities = clangd_capabilities,
    on_attach = configFunctions.on_attach,
})
require("lspconfig").pyright.setup({
    capabilities = configFunctions.capabilities,
    on_attach = configFunctions.on_attach,
})
local jsonls_opts = require("config.lsp.settings.jsonls")
local opts = {}
opts = vim.tbl_deep_extend("force", jsonls_opts, opts)
opts.on_attach = configFunctions.on_attach
require("lspconfig").jsonls.setup(opts)
local sumneko_opts = require("config.lsp.settings.lua_ls")
opts = {}
opts = vim.tbl_deep_extend("force", sumneko_opts, opts)
opts.on_attach = configFunctions.on_attach

require("lspconfig").lua_ls.setup(opts)
require("lspconfig").nil_ls.setup({ on_attach = configFunctions.on_attach })
