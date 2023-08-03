local ok, lsp_installer = pcall(require, "mason")
local ok2, mason_lspconfig = pcall(require, "mason-lspconfig")

if not ok or not ok2 then return end
local servers = {
  "bashls",
  "pyright",
  "pylsp",
  "jsonls",
  "clangd",
  "tsserver",
  "cmake",
  "vimls",
  "tailwindcss",
  "cssmodules_ls",
  "rust_analyzer",
  "lua_ls"
}
local lsp_server_names = {
  "bash-language-server",
  "pyright",
  "python-lsp-server",
  "json-lsp",
  "clangd",
  "typescript-language-server",
  "cmake-language-server",
  "vim-language-server",
  "tailwindcss-language-server",
  "cssmodules-language-server",
  "rust-analyzer",
}

lsp_installer.setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗",
    },
  },
})

require("mason-lspconfig").setup {
    ensure_installed = servers,
}

local configFunctions = require("config.lsp.handlers")


mason_lspconfig.setup_handlers({
  function(server_name) require("lspconfig")[server_name].setup({ on_attach = configFunctions.on_attach }) end,
  ["rust_analyzer"] = function() require("config.lsp.settings.rust") end,
  ["clangd"] = function()
    local clangd_capabilities = configFunctions.capabilities
    clangd_capabilities.offsetEncoding = "utf-8"
    require("lspconfig").clangd.setup({
      capabilities = clangd_capabilities,
      on_attach = configFunctions.on_attach,
    })
  end,

  ["jsonls"] = function()
    local jsonls_opts = require("config.lsp.settings.jsonls")
    local opts = {}
    opts = vim.tbl_deep_extend("force", jsonls_opts, opts)
    opts.on_attach = configFunctions.on_attach
    require("lspconfig").jsonls.setup(opts)
  end,
  ["lua_ls"] = function()
    local sumneko_opts = require("config.lsp.settings.sumneko_lua")
    local opts = {}
    opts = vim.tbl_deep_extend("force", sumneko_opts, opts)
    opts.on_attach = configFunctions.on_attach
    require("lspconfig").lua_ls.setup(opts)
  end,
})

require("lspconfig").nil_ls.setup({on_attach=configFunctions.on_attach});
vim.api.nvim_create_user_command("MasonInstallAll", function()
  for _, name in pairs(lsp_server_names) do
    vim.cmd("MasonInstall " .. name)
  end
end, {})
