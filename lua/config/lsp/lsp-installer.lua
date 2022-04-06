local ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not ok then return end
local servers = {
    "bashls", "asm_lsp", "pyright", "pylsp", "jsonls", "sumneko_lua", "clangd",
    "tsserver", "cmake", "vimls", "tailwindcss", "cssmodules_ls"
}

lsp_installer.on_server_ready(function(server)

    local opts = {
        on_attach = require("config.lsp.handlers").on_attach,
        capabilities = require("config.lsp.handlers").capabilities
    }
    if server.name == "jsonls" then
        local jsonls_opts = require("config.lsp.settings.jsonls")
        opts = vim.tbl_deep_extend("force", jsonls_opts, opts)
    end
    if server.name == "sumneko_lua" then
        local sumneko_opts = require("config.lsp.settings.sumneko_lua")
        vim.pretty_print(sumneko_opts)
        opts = vim.tbl_deep_extend("force", sumneko_opts, opts)
    end
    server:setup(opts)

end)

for _, name in pairs(servers) do
    local server_is_found, server = lsp_installer.get_server(name)
    if server_is_found and not server:is_installed() then
        print("Installing " .. name)
        server:install()
    end
end
