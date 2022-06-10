vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
    pattern = {"*.c", "*.gsl"},
    command = "set filetype=c",
    desc = "set filetype for gsl file"
})

