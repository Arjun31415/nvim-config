vim.cmd[[ hi HopNextKey cterm=bold ctermfg=176 gui=bold guibg=#ff00ff guifg=#ffffff ]]
vim.cmd[[ hi HopNextKey1 cterm=bold ctermfg=176 gui=bold guibg=#ff00ff guifg=#ffffff ]]
vim.cmd[[ hi HopNextKey2 cterm=bold ctermfg=176 gui=bold guibg=#ff00ff guifg=#ffffff ]]

require('hop').setup({
  case_insensitive = true,
  char2_fallback_key = '<CR>',
})

vim.api.nvim_set_keymap('n', '<leader>hw', "<cmd>lua require'hop'.hint_words()<cr>", {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>hc1', "<cmd>lua require'hop'.hint_char1()<cr>", {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>hc2', "<cmd>lua require'hop'.hint_char2()<cr>", {noremap = true})
