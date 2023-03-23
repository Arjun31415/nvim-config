local map = require("utils").map
local utils = require("utils")

--{{{ Window Mappings
map("n", "<Left>", "<C-W>h", { noremap = true }, "Focus left pane")
map("n", "<Right>", "<C-W>l", { noremap = true }, "Focus right pane")
map("n", "<Up>", "<C-W>k", { noremap = true }, "Focus top pane")
map("n", "<Down>", "<C-W>j", { noremap = true }, "Focus bottom pane")
--}}}

--{{{ Telescope keymaps
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { silent = true }, "Find files (telescope)")
map("n", "<leader>/", utils.telescope("live_grep"), { silent = true }, "fuzzy search over project directory")
--}}}

--{{{ Bufferline keymaps
map("n", "[b", ":BufferLineCycleNext<CR>", { silent = true }, "Cycle next buffer")
map("n", "]b", ":BufferLineCyclePrev<CR>", { silent = true }, "Cycle prev buffer")
map("n", "<Leader>bse", ":BufferLineSortByExtension<CR>", { silent = true }, "Buffer sort by extension")
map("n", "<Leader>bsd", ":BufferLineSortByDirectory<CR>", { silent = true }, "Buffer sort by dir")
map("n", "<Leader>bq", "<Cmd>lua require('bufdelete').bufdelete(0, true)<CR>", { silent = true }, "Buffer close")
-- }}}

-- {{{ Harpoon keymaps
map("n", "<leader>'", ':lua require("harpoon.mark").add_file()<CR>', { silent = true }, "Harpoon add file")
map("n", "<leader>hq", ':lua require("harpoon.ui").toggle_quick_menu()<CR>', "Harpoon menu")
map("n", "<A-1>", ':lua require("harpoon.ui").nav_file(1)<CR>', { silent = true }, "Go to file 1")
map("n", "<A-2>", ':lua require("harpoon.ui").nav_file(2)<CR>', { silent = true }, "Go to file 2")
map("n", "<A-3>", ':lua require("harpoon.ui").nav_file(3)<CR>', { silent = true }, "Go to file 3")
map("n", "<A-4>", ':lua require("harpoon.ui").nav_file(4)<CR>', { silent = true }, "Go to file 4")
map("n", "<A-5>", ':lua require("harpoon.ui").nav_file(5)<CR>', { silent = true }, "Go to file 5")
map("n", "<A-6>", ':lua require("harpoon.ui").nav_file(6)<CR>', { silent = true }, "Go to file 6")
map("n", "<A-7>", ':lua require("harpoon.ui").nav_file(7)<CR>', { silent = true }, "Go to file 7")
map("n", "<A-8>", ':lua require("harpoon.ui").nav_file(8)<CR>', { silent = true }, "Go to file 8")
--- }}}

--{{{ hlslens
map("n", "*", "<Plug>(asterisk-z*)<Cmd>lua require('hlslens').start()<CR>", { silent = true })
map("n", "#", "<Plug>(asterisk-z#)<Cmd>lua require('hlslens').start()<CR>", { silent = true })
---}}}

--{{{ Neotree
map(
  "n",
  "<leader>e",
  [[<ESC><Cmd> lua require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd() })<CR>]],
  { silent = true },
  "Toggle tree"
)
-- }}}
-- Refactoring {{{
map(
  "v",
  "<leader>re",
  [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function')<CR>]],
  { silent = true, expr = false },
  "Extract function"
)
map(
  "v",
  "<leader>rf",
  [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function To File')<CR>]],
  { silent = true, expr = false },
  "Extract function to file"
)
map(
  "v",
  "<leader>rv",
  [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Variable')<CR>]],
  { silent = true, expr = false },
  "Extract variable"
)
map(
  "v",
  "<leader>ri",
  [[ <Esc><Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]],
  { silent = true, expr = false },
  "Extract variable inline"
)

-- Extract block doesn't need visual mode
map(
  "n",
  "<leader>rb",
  [[ <Cmd>lua require('refactoring').refactor('Extract Block')<CR>]],
  { silent = true, expr = false },
  "Extract block"
)
map(
  "n",
  "<leader>rbf",
  [[ <Cmd>lua require('refactoring').refactor('Extract Block To File')<CR>]],
  { silent = true, expr = false },
  "Extract block to file"
)

-- }}}

-- Renamer{{{
map("i", "<F2>", '<cmd>lua require("renamer").rename()<cr>', { noremap = true, silent = true })
map(
  "n",
  "<leader>rn",
  '<cmd>lua require("renamer").rename()<cr>',
  { noremap = true, silent = true },
  "rename text object"
)
map(
  "v",
  "<leader>rn",
  '<cmd>lua require("renamer").rename()<cr>',
  { noremap = true, silent = true },
  "rename text object"
)
-- }}}
--
-- vim: set foldmethod=marker foldlevel=0:
