local map = require("utils").map
local utils = require("utils")

--{{{Common Mappings

map("n", ";", ":", { noremap = true })
map("x", ";", ":", { noremap = true })
map("n", "q;", "q:", { noremap = true }, "open command window")
map("i", "<A-;>", "<ESC>miA;<ESC>`ii", {}, "Insert semicolon at the end of the line")

-- Tab-complete, see https://vi.stackexchange.com/q/19675/15292.
map("i", "<Tab>", function() return vim.fn.pumvisible() == 1 and "<C-n>" or "<Tab>" end, { expr = true })
map("i", "<s-tab>", function() return vim.fn.pumvisible() == 1 and "<C-p>" or "<s-tab>" end, { expr = true })

-- Yanking{{{
-- Retain cursor position after yank
map("n", "y", "mmy", {})
map("x", "y", "mmy", {})
map("n", "<leader>y", "<Cmd>%y<CR>", { silent = true }, "copy the entire buffer")
-- Replace visual selection with text in register, but not contaminate the
-- register, see also https://stackoverflow.com/q/10723700/6064933.
map("x", "p", '"_c<ESC>p', {}, "replace visual selection with text in register without contaminating the register")
map("n", "J", "mzJ`z", {}, "dont move cursor when joining lines")
-- }}}

-- Use Esc to quit builtin terminal
map("t", "<ESC>", "<C-\\><C-n>", {})

-- Deleting words {{{
-- delete word and put in blackhole register
-- Change text without putting it into the vim register,
-- see https://stackoverflow.com/q/54255/6064933

map("n", "c", '"_c<ESC>', {}, "delete the word under cursor")
map("n", "C", '"_C<ESC>', {}, "delete from cursor to end of line")
map("n", "cc", '"_cc<ESC>', {}, "delete entire line")
map("x", "c", '"_c<ESC>', {}, "delete selected text") -- }}}

-- Spellcheck{{{
-- Toggle spell checking (autosave does not play well with z=, so we disable it
-- when we are doing spell checking)

map("n", "<F11>", ":set spell!<CR>", { silent = true })
map("i", "<F11>", "<C-O>:set spell!<CR>", { silent = true }) -- }}}

map("i", "<C-U>", "<Esc>viwUea", { noremap = true }, "Turn the word under cursor to upper case")
map("i", "<C-T>", "<Esc>b~lea", { noremap = true }, "Turn the current word into title case")

-- Paste non-linewise text above or below current cursor
-- see https://stackoverflow.com/a/1346777/6064933
map("n", "<leader>p", "m`o<ESC>p``", { silent = true }, "Paste text below cursor")
map("n", "<leader>P", "m`O<ESC>p``", { noremap = true }, "Paste text above the cursor")

-- Shortcut for faster save and quit
map("n", "<leader>w", ":<C-U>update<CR>", { noremap = true, silent = true, desc = "Save file" })

-- Saves the file if modified and quit
map("n", "<leader>q", ":<C-U>x<CR>", { noremap = true, silent = true, desc = "Save and quit" })

-- Close location list or quickfix list if they are present
-- see https://superuser.com/q/355325/736190
map(
  "n",
  "\\x",
  ":<C-U>windo lclose <bar> cclose<CR>",
  { noremap = true, silent = true },
  "Close location list or quickfix list"
)
--Whitespace {{{

-- Do not include whitespace characters when using $ in visual mode
map("x", "$", "g_", { desc = "Go to the last non-blank character of the line in visual mode" })

-- see https://stackoverflow.com/a/16136133/6064933
map(
  "n",
  "<expr> <Space>o",
  "printf('m`%so<ESC>``', v:count1)",
  { noremap = true },
  "Insert blankline after current line"
)
map(
  "n",
  "<expr> <Space>O",
  "printf('m`%sO<ESC>``', v:count1)",
  { noremap = true },
  "Insert blankline before current line"
)
map("n", "<Space><Space>", "a<Space><ESC>h", { noremap = true }, "insert space after current character")

-- Remove trailing whitespace characters
map("n", "<Leader><Space>", "<cmd>StripTrailingWhitespace<CR>", { silent = true }, "strip trailing whitespace")
-- Do not include whitespace characters when using $ in visual mode,
-- see https://vi.stackexchange.com/q/12607/15292
map("x", "$", "g_")
map("n", "<Tab>", "%", {}, "jump to matching pairs")

-- }}}

-- Move the cursor based on physical lines, not the actual lines.
map("n", "^", "g^", { noremap = true })
map("n", "0", "g0", { noremap = true })

map("n", "H", "^", { noremap = true }, "Move to the first non-blank character of the line")
map("x", "H", "^", { noremap = true }, "Move to the first non-blank character of the line")
map("n", "L", "g_", { noremap = true }, "Move to the last non-blank character of the line")
map("x", "L", "g_", { noremap = true }, "Move to the last non-blank character of the line")

-- Move the cursor based on physical lines, not the actual lines
map("n", "j", 'v:count == 0 ? "gj" : "j"', { expr = true, desc = "Move the cursor down based on physical lines" })
map("n", "k", 'v:count == 0 ? "gk" : "k"', { expr = true, desc = "Move the cursor up based on physical lines" })
map("n", "^", "g^", { desc = "Move the cursor to the first non-blank character of the line" })
map("n", "0", "g0", { desc = "Move the cursor to the first character of the line" })

-- Continuous visual shifting (does not exit Visual mode), `gv` means
-- to reselect previous visual area, see https://superuser.com/q/310417/736190
map("x", "<", "<gv", {}, "decrease indent in visual mode")
map("x", ">", ">gv", {}, "increase indent in visual mode")

-- Line switching{{{

map("n", "<A-k>", '<Cmd>call utils#SwitchLine(line("."), "up")<CR>', { silent = true }, "Move current line up")
map("n", "<A-j>", '<Cmd>call utils#SwitchLine(line("."), "down")<CR>', { silent = true }, "Move current line down")
map("x", "<A-k>", ':<C-U>call utils#MoveSelection("up")<CR>', { silent = true }, "Move selection up")
map("x", "<A-j>", ':<C-U>call utils#MoveSelection("down")<CR>', { silent = true }, "Move selection down")
-- }}}

-- Change current working directory locally and print cwd after that,
-- see https://vim.fandom.com/wiki/Set_working_directory_to_the_current_file
map("n", "<leader>cd", "<Cmd>lcd %:p:h<CR>:pwd<CR>", { silent = true })

--}}}

--{{{ Window Mappings
map("n", "<Left>", "<C-W>h", { noremap = true }, "Focus left pane")
map("n", "<Right>", "<C-W>l", { noremap = true }, "Focus right pane")
map("n", "<Up>", "<C-W>k", { noremap = true }, "Focus top pane")
map("n", "<Down>", "<C-W>j", { noremap = true }, "Focus bottom pane")
--}}}

--Quickfix List and Location List mappings{{{
map("n", "[l", ":<C-U>lprevious<CR>zv", { silent = true }, "prev location list item ")
map("n", "]l", ":<C-U>lnext<CR>zv", { silent = true }, "next location list item open in vsplt")
map("n", "[L", ":<C-U>lfirst<CR>zv", { silent = true }, "first location list item ")
map("n", "]L", ":<C-U>llast<CR>zv", { silent = true }, "last location list item ")
map("n", "[q", ":<C-U>cprevious<CR>zv", { silent = true }, "prev Quickfix item ")
map("n", "]q", ":<C-U>cnext<CR>zv", { silent = true }, "next Quickfix item ")
map("n", "[Q", ":<C-U>cfirst<CR>zv", { silent = true }, "first Quickfix item ")
map("n", "]Q", ":<C-U>clast<CR>zv", { silent = true }, "last Quickfix item ")
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
-- Quit all opened buffers
map("n", "<leader>Q", ":<C-U>qa!<CR>", { noremap = true, silent = true, desc = "Quit all buffers" })

-- }}}

-- {{{ Harpoon keymaps
map("n", "<leader>'", ':lua require("harpoon.mark").add_file()<CR>', { silent = true }, "Harpoon add file")
map("n", "<leader>hq", ':lua require("harpoon.ui").toggle_quick_menu()<CR>', { silent = true }, "Harpoon menu")
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
