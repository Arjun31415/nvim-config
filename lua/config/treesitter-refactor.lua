require'nvim-treesitter.configs'.setup {
    refactor = {
        highlight_definitions = {
            enable = true,
            -- Set to false if you have an `updatetime` of ~100.
            clear_on_cursor_move = true
        },
        highlight_current_scope = {enable = false},
        navigation = {
            enable = true,
            keymaps = {
                -- goto_definition = "gnd",
                -- list_definitions = "gnD",
                list_definitions_toc = "gO",
                goto_next_usage = "<a-*>",
                goto_previous_usage = "<a-#>"
            }
        }
    }
}
