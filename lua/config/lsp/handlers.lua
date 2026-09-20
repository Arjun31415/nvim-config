local M = {}

M.setup = function()
    vim.diagnostic.config({
        virtual_text = false,
        virtual_lines = true,
        signs = true,
        update_in_insert = false,
        underline = true,
        severity_sort = true,
        float = {
            focusable = false,
            style = "minimal",
            source = true,
            header = "",
            prefix = "",
        },
    })
end

local function lsp_highlight_document(client, bufnr)
    if not client:supports_method("textDocument/documentHighlight") then
        return
    end
    local group = vim.api.nvim_create_augroup("lsp_document_highlight_" .. bufnr, { clear = true })
    vim.api.nvim_create_autocmd("CursorHold", {
        group = group,
        buffer = bufnr,
        callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd("CursorMoved", {
        group = group,
        buffer = bufnr,
        callback = vim.lsp.buf.clear_references,
    })
end

local function lsp_keymaps(bufnr)
    -- Core already provides K, grn, gra, grr, gri, gO. Only additions here.
    local nmap = function(keys, func, desc)
        vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
    end

    nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
    nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
    nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
    nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
    nmap("gl", vim.diagnostic.open_float, "Show diagnostics")

    nmap("gI", function()
        require("fzf-lua").lsp_implementations()
    end, "[G]oto [I]mplementation")
    nmap("gR", function()
        require("fzf-lua").lsp_references()
    end, "[G]oto [R]eferences")

    nmap("<leader>bf", function()
        require("conform").format({ bufnr = bufnr })
    end, "Format buffer")
end

M.on_attach = function(client, bufnr)
    if client.name == "ts_ls" then
        client.server_capabilities.documentHighlightProvider = false
    end

    if client:supports_method("textDocument/inlayHint") then
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end

    lsp_keymaps(bufnr)
    lsp_highlight_document(client, bufnr)
end

-- blink.cmp registers its own capabilities via vim.lsp.config("*").
M.capabilities = vim.lsp.protocol.make_client_capabilities()

return M
