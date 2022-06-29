vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
    pattern = {"*.lisp", "*.yuck"},
    command = "set filetype=lisp",
    desc = "set lisp filetype for eww files"
})

