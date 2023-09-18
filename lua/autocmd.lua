local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Do not use smart case in command line mode, extracted from
-- https://vi.stackexchange.com/a/16511/15292.
-- You can dynamically toggle smartcase using autocmds,
-- so when in a : command line, it is off
-- and when in a <Leader> command line it is on
local _id = augroup("dynamic_smartcase", { clear = true })
autocmd({ "CmdLineEnter" }, {
    command = "set nosmartcase",
    group = _id,
    desc = "nosmartcase when entering the commandLine",
})
autocmd({ "CmdLineLeave" }, {
    command = "set smartcase",
    group = _id,
    desc = "set smartcase when leaving the commandLine",
})
-- terminal settings
_id = augroup("term_settings", { clear = true })
autocmd({ "TermOpen" }, {
    pattern = { "*" },
    callback = function()
        vim.api.nvim_command("setlocal norelativenumber nonumber")
    end,
    desc = "terminal has no line numbering in the buffer cause that looks weird",
    group = _id,
})
autocmd({ "TermOpen" }, {
    pattern = { "*" },
    command = "startinsert",
    group = _id,
    desc = "go to insert mode by default and start writing the command",
})
-- More accurate syntax highlighting
_id = augroup("accurate_syn_highlight", { clear = true })
autocmd({ "BufEnter" }, { command = "syntax sync fromstart", group = _id })

-- TODO: Return to last cursor position when opening a file
autocmd({ "BufWritePre" }, {
    pattern = { "*" },
    callback = function(ctx)
        local dir = vim.fn.fnamemodify(ctx.file, ":p:h")
        require("utils").may_create_dir(dir)
    end,
    group = augroup("auto_create_dir", { clear = true }),
})
autocmd({
    "CursorMoved",
    "BufWinEnter",
    "BufFilePost",
    "InsertEnter",
    "BufWritePost",
}, {
    callback = function()
        require("config.winbar").get_winbar()
    end,
})

-- highlight yanked region, see `:h lua-highlight`
autocmd({ "TextYankPost" }, {
    pattern = "*",
    group = augroup("highlight_yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank({ higroup = "IncSearch", timeout = 400 })
    end,
})

-- Automatically reload the file if it is changed outside of Nvim, see
-- https://unix.stackexchange.com/a/383044/221410. It seems that `checktime`
-- command does not work in command line. We need to check if we are in command
-- line before executing this command. See also
-- https://vi.stackexchange.com/a/20397/15292.
augroup("auto_read", { clear = true })

autocmd({ "FileChangedShellPost" }, {
    pattern = "*",
    group = "auto_read",
    callback = function()
        vim.notify("File changed on disk. Buffer reloaded!", vim.log.levels.WARN, { title = "nvim-config" })
    end,
})

autocmd({ "FocusGained", "CursorHold" }, {
    pattern = "*",
    group = "auto_read",
    callback = function()
        if vim.fn.getcmdwintype() == "" then
            vim.cmd("checktime")
        end
    end,
})

-- Display a message when the current file is not in utf-8 format.
-- Note that we need to use `unsilent` command here because of this issue:
-- https://github.com/vim/vim/issues/4379
autocmd({ "BufRead" }, {
    pattern = "*",
    group = augroup("non_utf8_file", { clear = true }),
    callback = function()
        if vim.bo.fileencoding ~= "utf-8" then
            vim.notify("File not in UTF-8 format!", vim.log.levels.WARN, { title = "nvim-config" })
        end
    end,
})
