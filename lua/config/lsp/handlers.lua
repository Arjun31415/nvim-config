local M = {}
-- local navic_attach = require("config.lsp.settings.nvim-navic").navic_attach
M.setup = function()
    local signs = {
        { name = "DiagnosticSignError", text = "" },
        { name = "DiagnosticSignWarn", text = "" },
        { name = "DiagnosticSignHint", text = "" },
        { name = "DiagnosticSignInfo", text = "" },
    }

    for _, sign in ipairs(signs) do
        vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
    end

    local config = {
        -- disable virtual text
        virtual_text = false,
        virtual_lines = true,
        -- show signs
        signs = { active = signs },
        update_in_insert = false,
        underline = true,
        severity_sort = true,
        float = {
            focusable = false,
            style = "minimal",
            border = "rounded",
            source = "always",
            header = "",
            prefix = "",
        },
    }

    vim.diagnostic.config(config)

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })

    vim.lsp.handlers["textDocument/signatureHelp"] =
        vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
end

local function lsp_highlight_document(client)
    -- Set autocommands conditional on server_capabilities
    if client.server_capabilities.documentHighlightProvider then
        vim.api.nvim_exec2(
            [[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]],
            { output = false }
        )
    end
end

local function lsp_keymaps(bufnr)
    local nmap = function(keys, func, desc)
        if desc then
            desc = "LSP: " .. desc
        end

        vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc, silent = true, noremap = true })
    end
    nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
    nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

    nmap("K", vim.lsp.buf.hover(), "Hover Documentation")
    -- nmap("gi", vim.lsp.buf.implementation()("[G]oto [I]mplementation"))
    nmap("gi", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
    nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")
    nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
    nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

    nmap("gr", vim.lsp.buf.references(), "[G]oto [R]eferences")
    nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

    nmap("gl", vim.diagnostic.open_float({ border = "rounded" }), "open diagnostics")
    -- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
    -- vim.keymap.set("n", "<space>fb", function()
    --     vim.lsp.buf.format({ async = true })
    -- end, opts)
end

M.on_attach = function(client, bufnr)
    -- vim.pretty_print(client.server_capabilities)
    if client.name == "tsserver" then
        client.server_capabilities.documentHighlightProvider = false
    end
    lsp_keymaps(bufnr)
    lsp_highlight_document(client)
    -- if client.server_capabilities.documentSymbolProvider and client.name ~= "html" then
    --     navic_attach(client, bufnr)
    -- end
end

M.capabilities = {}
local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_ok then
    return M
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities.textDocument.completion.completionItem.snippetSupport = true
-- M.capabilities.textDocument.foldingRange = {
--     dynamicRegistration = false,
--     lineFoldingOnly = true,
-- }
M.capabilities = cmp_nvim_lsp.default_capabilities(M.capabilities)

return M
