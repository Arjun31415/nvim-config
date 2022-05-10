local ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not ok then return end
local servers = {
    "bashls", "asm_lsp", "pyright", "pylsp", "jsonls", "sumneko_lua", "clangd",
    "tsserver", "cmake", "vimls", "tailwindcss", "cssmodules_ls"
}

local lspconfig = require("lspconfig")
lsp_installer.setup({})

-- lua language server setup

local sumneko_opts = require("config.lsp.settings.sumneko_lua")
local opts = {}
opts = vim.tbl_deep_extend("force", sumneko_opts, opts)
lspconfig.sumneko_lua.setup(opts)

-- jsonls setup

opts = {}
local jsonls_opts = require("config.lsp.settings.jsonls")
opts = vim.tbl_deep_extend("force", jsonls_opts, opts)
lspconfig.jsonls.setup(opts)

for _, name in pairs(servers) do
    local server_is_found, server = lsp_installer.get_server(name)
    if server_is_found and not server:is_installed() then
        print("Installing " .. name)
        server:install()
    end
end
