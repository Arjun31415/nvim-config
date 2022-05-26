local ok, lsp_installer = pcall(require, "nvim-lsp-installer")

if not ok then return end
local servers = {
    "bashls", "asm_lsp", "pyright", "pylsp", "jsonls", "clangd", "tsserver",
    "cmake", "vimls", "tailwindcss", "cssmodules_ls"
}
local configFunctions = require("config.lsp.handlers")
local lspconfig = require("lspconfig")
lsp_installer.setup({})

-- lua language server setup
local sumneko_opts = require("config.lsp.settings.sumneko_lua")
local opts = {}
opts = vim.tbl_deep_extend("force", sumneko_opts, opts)
opts.on_attach = configFunctions.on_attach
lspconfig.sumneko_lua.setup(opts)

-- jsonls setup

opts = {}
local jsonls_opts = require("config.lsp.settings.jsonls")
opts = vim.tbl_deep_extend("force", jsonls_opts, opts)
opts.on_attach = configFunctions.on_attach
lspconfig.jsonls.setup(opts)

-- asm_lsp
lspconfig.asm_lsp.setup({on_attach = configFunctions.on_attach})
-- bash
lspconfig.bashls.setup({on_attach = configFunctions.on_attach})
-- cmake setup
lspconfig.cmake.setup({on_attach = configFunctions.on_attach})
-- clangd setup
local clangd_capabilities = configFunctions.capabilities;
clangd_capabilities.offsetEncoding = "utf-8";
lspconfig.clangd.setup({
    capabilities = clangd_capabilities,
    on_attach = configFunctions.on_attach
})
-- pyright setup
lspconfig.pyright.setup({on_attach = configFunctions.on_attach})
-- pylsp
lspconfig.pylsp.setup({on_attach = configFunctions.on_attach})
-- tssserver
lspconfig.tsserver.setup({on_attach = configFunctions.on_attach})
-- eslint server
lspconfig.eslint.setup({on_attach = configFunctions.on_attach})
-- css server
lspconfig.cssmodules_ls.setup({on_attach = configFunctions.on_attach})
-- tailwindcss
lspconfig.tailwindcss.setup({on_attach = configFunctions.on_attach})
-- vim
lspconfig.vimls.setup({on_attach = configFunctions.on_attach})
-- rust_analyzer
lspconfig.rust_analyzer.setup({on_attach = configFunctions.on_attach})
-- latex server
lspconfig.texlab.setup({on_attach = configFunctions.on_attach})
for _, name in pairs(servers) do
    local server_is_found, server = lsp_installer.get_server(name)
    if server_is_found and not server:is_installed() then
        print("Installing " .. name)
        server:install()
    end
end
