local map = require("utils").map
vim.g.spotify_show_status = 1
vim.g.spotify_status_format = ' {status} {song} - {artists} {decorator}'
vim.g.spotify_wait_time = 0.5
map("n", [[\sn]], "<cmd>Spotify next<CR>")
map("n", [[\sp]], ":Spotify prev<CR>")
map("n", [[\ss]], ":Spotify play/pause<CR>")
map("n", [[\so]], ":Spotify show<CR>")
map("n", [[\sc]], ":Spotify status<CR>")
