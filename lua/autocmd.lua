local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local utils = require("utils")
-- Do not use smart case in command line mode, extracted from
-- https://vi.stackexchange.com/a/16511/15292.
-- You can dynamically toggle smartcase using autocmds,
-- so when in a : command line, it is off
-- and when in a <Leader> command line it is on
local _id = augroup("dynamic_smartcase", {clear = true})
autocmd({"CmdLineEnter"}, {
    command = "set nosmartcase",
    group = _id,
    desc = "nosmartcase when entering the commandLine"
})
autocmd({"CmdLineLeave"}, {
    command = "set smartcase",
    group = _id,
    desc = "set smartcase when leaving the commandLine"
})
-- terminal settings
_id = augroup("term_settings", {clear = true})
autocmd({"TermOpen"}, {
    pattern = {"*"},
    callback = function()
        vim.api.nvim_command('setlocal norelativenumber nonumber')
    end,
    desc = "terminal has no line numbering in the buffer cause that looks weird",
    group = _id
})
autocmd({"TermOpen"}, {
    pattern = {"*"},
    command = "startinsert",
    group = _id,
    desc = "go to insert mode by default and start writing the command"
})
-- More accurate syntax highlighting
_id = augroup("accurate_syn_highlight", {clear = true})
autocmd({"BufEnter"}, {command = "syntax sync fromstart", group = _id})
-- TODO: Return to last cursor position when opening a file
_id = augroup("auto_create_dir", {clear = true})
autocmd({"BufWritePre"}, {
    pattern = {"*"},
    callback = require('utils').may_create_dir,
    group = _id
})
autocmd({
    "CursorMoved", "BufWinEnter", "BufFilePost", "InsertEnter", "BufWritePost"
}, {callback = function() require("config.winbar").get_winbar() end})
-- FIXME: this does not work
-- _id = augroup("open_neotree_after_session_load", {clear = true})
-- autocmd({"SessionLoadPost"}, {
--     group = _id,
--     callback = function() vim.cmd([[Neotree position=left]]) end
-- })
