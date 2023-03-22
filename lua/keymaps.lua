local map = require("utils").map
local utils = require("utils")
-- Telescope keymaps
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { silent = true })
map("n", "<leader>/", utils.telescope("live_grep"), { silent = true })

-- Bufferline keymaps
map("n", "[b", ":BufferLineCycleNext<CR>", { silent = true })
map("n", "]b", ":BufferLineCyclePrev<CR>", { silent = true })
map("n", "<Leader>bse", ":BufferLineSortByExtension<CR>", { silent = true })
map("n", "<Leader>bsd", ":BufferLineSortByDirectory<CR>", { silent = true })
map("n", "<Leader>bq", "<Cmd>lua require('bufdelete').bufdelete(0, true)<CR>", { silent = true })

-- Harpoon keymaps
map("n", "<leader>'", ':lua require("harpoon.mark").add_file()<CR>', { silent = true })
map("n", "<leader>hq", ':lua require("harpoon.ui").toggle_quick_menu()<CR>')
map("n", "<A-1>", ':lua require("harpoon.ui").nav_file(1)<CR>', { silent = true })
map("n", "<A-2>", ':lua require("harpoon.ui").nav_file(2)<CR>', { silent = true })
map("n", "<A-3>", ':lua require("harpoon.ui").nav_file(3)<CR>', { silent = true })
map("n", "<A-4>", ':lua require("harpoon.ui").nav_file(4)<CR>', { silent = true })
map("n", "<A-5>", ':lua require("harpoon.ui").nav_file(5)<CR>', { silent = true })
map("n", "<A-6>", ':lua require("harpoon.ui").nav_file(6)<CR>', { silent = true })
map("n", "<A-7>", ':lua require("harpoon.ui").nav_file(7)<CR>', { silent = true })
map("n", "<A-8>", ':lua require("harpoon.ui").nav_file(8)<CR>', { silent = true })

-- hlslens
map("n", "*", "<Plug>(asterisk-z*)<Cmd>lua require('hlslens').start()<CR>", { silent = true })
map("n", "#", "<Plug>(asterisk-z#)<Cmd>lua require('hlslens').start()<CR>", { silent = true })

-- Neotree
map(
  "n",
  "<leader>e",
  [[<ESC><Cmd> lua require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd() })<CR>]],
  { silent = true }
)

-- Refactoring
map(
  "v",
  "<leader>re",
  [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function')<CR>]],
  { silent = true, expr = false }
)
map(
  "v",
  "<leader>rf",
  [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function To File')<CR>]],
  { silent = true, expr = false }
)
map(
  "v",
  "<leader>rv",
  [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Variable')<CR>]],
  { silent = true, expr = false }
)
map(
  "v",
  "<leader>ri",
  [[ <Esc><Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]],
  { silent = true, expr = false }
)

-- Extract block doesn't need visual mode
map(
  "n",
  "<leader>rb",
  [[ <Cmd>lua require('refactoring').refactor('Extract Block')<CR>]],
  { silent = true, expr = false }
)
map(
  "n",
  "<leader>rbf",
  [[ <Cmd>lua require('refactoring').refactor('Extract Block To File')<CR>]],
  { silent = true, expr = false }
)

-- Inline variable can also pick up the identifier currently under the cursor without visual mode
map(
  "n",
  "<leader>ri",
  [[ <Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]],
  { silent = true, expr = false }
)

-- Renamer
map("i", "<F2>", '<cmd>lua require("renamer").rename()<cr>', { noremap = true, silent = true })
map("n", "<leader>rn", '<cmd>lua require("renamer").rename()<cr>', { noremap = true, silent = true })
map("v", "<leader>rn", '<cmd>lua require("renamer").rename()<cr>', { noremap = true, silent = true })
