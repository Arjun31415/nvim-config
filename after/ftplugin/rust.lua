local nmap = function(keys, func, bufnr, desc)
    if desc then
        desc = "LSP: " .. desc
    end

    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc, silent = true })
end

local bufnr = vim.api.nvim_get_current_buf()

nmap("<leader>ca", vim.lsp.buf.code_action, bufnr)

