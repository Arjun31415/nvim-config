local ok, lsp_installer = pcall(require, "mason")
local ok2, mason_lspconfig = pcall(require, "mason-lspconfig")

if not ok or not ok2 then return end
local servers = {
    "bashls", "asm_lsp", "pyright", "pylsp", "jsonls", "clangd", "tsserver",
    "cmake", "vimls", "tailwindcss", "cssmodules_ls"
}
mason_lspconfig.setup({ensure_installed = servers})
local lsp_server_names = {
    "bash-language-server", "asm-lsp", "pyright", "python-lsp-server",
    "json-lsp", "clangd", "typescript-language-server", "cmake-language-server",
    "vim-language-server", "tailwindcss-language-server",
    "cssmodules-language-server", "rust_analyzer"
}

local configFunctions = require("config.lsp.handlers")
local lspconfig = require("lspconfig")
lsp_installer.setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    }
})

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
-- r language server
lspconfig.r_language_server.setup({on_attach = configFunctions.on_attach})
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
-- html server
lspconfig.html.setup({on_attach = configFunctions.on_attach})
-- svelete config
lspconfig.svelte.setup({on_attach = configFunctions.on_attach})
-- css server
lspconfig.cssmodules_ls.setup({on_attach = configFunctions.on_attach})
-- tailwindcss
lspconfig.tailwindcss.setup({on_attach = configFunctions.on_attach})
-- vim
lspconfig.vimls.setup({on_attach = configFunctions.on_attach})
-- rust_analyzer
require("config.lsp.settings.rust")
-- lspconfig.rust_analyzer.setup({on_attach = configFunctions.on_attach})
-- latex server
lspconfig.texlab.setup({on_attach = configFunctions.on_attach})
vim.api.nvim_create_user_command("MasonInstallAll", function()
    for _, name in pairs(lsp_server_names) do
        vim.cmd("MasonInstall " .. name)
    end

end, {})
