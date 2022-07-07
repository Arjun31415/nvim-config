local npairs = require("nvim-autopairs")
local Rule = require('nvim-autopairs.rule')
local ts_conds = require('nvim-autopairs.ts-conds')

require('nvim-autopairs').setup({
    check_ts = true,
    ts_config = {lua = {'string'}, javascript = {'template_string'}},
    fast_wrap = {
        map = '<C-e>',
        chars = {'{', '[', '(', '"', "'"},
        pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], '%s+', ''),
        end_key = '$',
        keys = 'qwertyuiopzxcvbnmasdfghjkl',
        check_comma = true,
        highlight = 'Search',
        highlight_grey = 'Comment'
    }
})

