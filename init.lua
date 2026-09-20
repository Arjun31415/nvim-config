-- Must be set before lazy.setup(), or plugins capture the wrong leader.
vim.g.mapleader = ","
vim.o.cmdheight = 0

-- Unused providers: skips their startup probes and silences :checkhealth.
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0

-- On a remote --remote-ui server the clipboard belongs to the server host,
-- and $SSH_TTY is unset so OSC 52 is not auto-detected. Ghostty defaults to
-- clipboard-write = allow, so copy works; paste prompts (clipboard-read = ask).
if vim.fn.has("mac") == 0 then
    vim.g.clipboard = "osc52"
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

if vim.g.neovide then
    require("config.neovide")
end

vim.fn.sign_define("DiagnosticSignError", { text = "", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = "", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo", { text = "", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })

require("lazy").setup({
    { import = "plugins" },

    "tpope/vim-fugitive",
    {
        -- Commit graph on top of fugitive's buffers. `ri` starts an
        -- interactive rebase at the commit under the cursor, which is the
        -- part fugitive alone has no navigable UI for.
        "rbong/vim-flog",
        dependencies = { "tpope/vim-fugitive" },
        cmd = { "Flog", "Flogsplit", "Floggit" },
        keys = {
            { "<leader>gl", "<cmd>Flog<cr>", desc = "Git log graph" },
            { "<leader>gL", "<cmd>Flog -all<cr>", desc = "Git log graph (all refs)" },
            {
                "<leader>gl",
                ':Flog -raw-args=-L<C-r>=line("v")<cr>,<C-r>=line(".")<cr>:%<cr>',
                mode = "v",
                desc = "Git log for selection",
            },
        },
        init = function()
            vim.g.flog_default_opts = { max_count = 2000 }
            vim.g.flog_permanent_default_opts = { date = "short" }
        end,
    },
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {},
    },
    "rhysd/committia.vim",
    -- vim-hexokinase replaced: it needs a Go toolchain and hardcoded lazy's
    -- install path in its build step. This one is pure Lua.
    {
        "brenoprata10/nvim-highlight-colors",
        -- NOT BufReadPre: lazy loads the plugin from inside that autocmd, and
        -- setting up highlights there changes the current buffer, which Vim
        -- forbids during a read (E201). Neo-tree's :edit made it fire.
        event = { "BufReadPost", "BufNewFile" },
        opts = { render = "background", enable_named_colors = true },
    },

    "tpope/vim-sleuth",
    { "folke/which-key.nvim", opts = {}, event = "VeryLazy" },
    {
        "lewis6991/gitsigns.nvim",
        opts = {
            signs = {
                add = { text = "+" },
                untracked = { text = "+" },
                change = { text = "~" },
                delete = { text = "_" },
                topdelete = { text = "‾" },
                changedelete = { text = "~" },
            },
            on_attach = function(bufnr)
                local gs = require("gitsigns")

                local function map(mode, lhs, rhs, desc, opts)
                    opts = vim.tbl_extend("error", { buffer = bufnr, desc = desc }, opts or {})
                    vim.keymap.set(mode, lhs, rhs, opts)
                end

                -- In diff mode ]c/[c are the builtin change motions; gitsigns
                -- would otherwise navigate the wrong side of the diff.
                local function nav(key, direction)
                    map({ "n", "v" }, key, function()
                        if vim.wo.diff then
                            return key
                        end
                        vim.schedule(function()
                            gs.nav_hunk(direction)
                        end)
                        return "<Ignore>"
                    end, "Jump to " .. direction .. " hunk", { expr = true })
                end
                nav("]c", "next")
                nav("[c", "prev")

                -- Visual range gives partial-hunk staging, i.e. git add -p
                -- without leaving the buffer. stage_hunk toggles on a staged
                -- sign, so there is no separate unstage map.
                local function selected()
                    return { vim.fn.line("."), vim.fn.line("v") }
                end
                map("n", "<leader>hs", gs.stage_hunk, "Stage hunk")
                map("v", "<leader>hs", function()
                    gs.stage_hunk(selected())
                end, "Stage selected lines")
                map("n", "<leader>hr", gs.reset_hunk, "Reset hunk")
                map("v", "<leader>hr", function()
                    gs.reset_hunk(selected())
                end, "Reset selected lines")
                map("n", "<leader>hS", gs.stage_buffer, "Stage buffer")
                map("n", "<leader>hR", gs.reset_buffer, "Reset buffer")

                map("n", "<leader>hp", gs.preview_hunk, "Preview hunk")
                map("n", "<leader>hi", gs.preview_hunk_inline, "Preview hunk inline")
                map("n", "<leader>hd", gs.diffthis, "Diff against index")
                map("n", "<leader>hD", function()
                    gs.diffthis("~")
                end, "Diff against last commit")

                map("n", "<leader>hb", function()
                    gs.blame_line({ full = true })
                end, "Blame line")
                map("n", "<leader>hB", gs.blame, "Blame file")
                map("n", "<leader>hx", gs.toggle_current_line_blame, "Toggle inline blame")

                map("n", "<leader>hq", gs.setqflist, "Hunks to quickfix")
                map("n", "<leader>gd", gs.diff, "Git diff panel")

                map({ "o", "x" }, "ih", gs.select_hunk, "Select hunk")
            end,
        },
    },

    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        config = function()
            local highlight = {
                "RainbowRed",
                "RainbowYellow",
                "RainbowBlue",
                "RainbowOrange",
                "RainbowGreen",
                "RainbowViolet",
                "RainbowCyan",
            }
            local hooks = require("ibl.hooks")
            hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
                vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
                vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
                vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
                vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
                vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
                vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
                vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
            end)

            require("ibl").setup({
                indent = { smart_indent_cap = true },
                scope = {
                    enabled = true,
                    highlight = highlight,
                },
            })
        end,
    },
    { "numToStr/Comment.nvim", opts = {} },
    { "echasnovski/mini.ai", opts = {} },
    { "echasnovski/mini.pairs", opts = {} },
    { "echasnovski/mini.surround", opts = {} },
}, { git = { timeout = 300 } })

require("config.lsp")

vim.o.hlsearch = false
vim.wo.number = true
vim.o.mouse = "a"
vim.o.clipboard = "unnamedplus"
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.wo.signcolumn = "yes"
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.completeopt = "menuone,noselect"
vim.o.termguicolors = true

-- One global border, instead of repeating `border = "rounded"` in every
-- plugin's float config.
vim.o.winborder = "rounded"

vim.o.splitbelow = true
vim.o.splitright = true
vim.o.scrolloff = 4
vim.o.confirm = true
vim.o.inccommand = "split"

vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostics. ]d and [d are core defaults in 0.11+, so only the list map
-- is needed here.
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.hl.on_yank()
    end,
    group = highlight_group,
    pattern = "*",
})

vim.keymap.set("n", "<A-j>", "<cmd>m .+1<CR>==", { noremap = true })
vim.keymap.set("n", "<A-k>", "<cmd>m .-2<CR>==", { noremap = true })
vim.keymap.set("i", "<A-j>", "<Esc>:m .+1<CR>==gi", { noremap = true })
vim.keymap.set("i", "<A-k>", "<Esc>:m .-2<CR>==gi", { noremap = true })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { noremap = true })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { noremap = true })

vim.keymap.set("n", "<leader>tv", "<cmd>vsplit | term<cr>i", { desc = "Terminal in vsplit" })
vim.keymap.set("n", "<leader>ts", "<cmd>split | term<cr>i", { desc = "Terminal in split" })
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Leave terminal mode" })
vim.cmd("highlight LspInlayHint guibg=none")
