vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
    pattern = {"*.lua", "*.conkyrc"},
    command = "set filetype=lua",
    desc = "set lua filetype for conky files"
})

