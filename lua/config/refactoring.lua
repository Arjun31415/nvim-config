require('refactoring').setup({})
local utils = require("utils")
utils.map("v", "<leader>re",
          [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function')<CR>]],
          {silent = true, expr = false})
utils.map("v", "<leader>rf",
          [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function To File')<CR>]],
          {silent = true, expr = false})
utils.map("v", "<leader>rv",
          [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Variable')<CR>]],
          {silent = true, expr = false})
utils.map("v", "<leader>ri",
          [[ <Esc><Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]],
          {silent = true, expr = false})

-- Extract block doesn't need visual mode
utils.map("n", "<leader>rb",
          [[ <Cmd>lua require('refactoring').refactor('Extract Block')<CR>]],
          {silent = true, expr = false})
utils.map("n", "<leader>rbf",
          [[ <Cmd>lua require('refactoring').refactor('Extract Block To File')<CR>]],
          {silent = true, expr = false})

-- Inline variable can also pick up the identifier currently under the cursor without visual mode
utils.map("n", "<leader>ri",
          [[ <Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]],
          {silent = true, expr = false})

