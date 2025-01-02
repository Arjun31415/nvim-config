-- Set ',' as the leader keypresence
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ","
vim.g.maplocalleader = ","
vim.o.cmdheight = 0
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)
if vim.g.neovide then
    -- Put anything you want to happen only in Neovide here
    require("config.neovide")
end

-- Diagnostic Signs
vim.fn.sign_define("DiagnosticSignError", { text = "", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = "", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo", { text = "", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })

-- TODO: Remove unused plugins
require("lazy").setup({
    { import = "plugins" },

    -- Git related plugins
    "tpope/vim-fugitive",
    {
        "folke/todo-comments.nvim",
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        },
        dependencies = { "nvim-lua/plenary.nvim" },
    },
    "tpope/vim-rhubarb",
    {
        "lervag/vimtex",
        init = function()
            vim.g.vimtex_view_method = "zathura"
            -- Use init for configuration, don't use the more common "config".
        end,
    },
    { "APZelos/blamer.nvim", event = "BufEnter" },
    "rhysd/committia.vim",
    "wakatime/vim-wakatime",
    {
        "RRethy/vim-hexokinase",
        build = "cd  ~/.local/share/nvim/lazy/vim-hexokinase && make hexokinase",
        event = "VimEnter",
    },

    -- Detect tabstop and shiftwidth automatically
    "tpope/vim-sleuth",
    {
        "andweeb/presence.nvim",
        config = function()
            require("presence"):setup({
                -- General options
                auto_update = true, -- Update activity based on autocmd events (if `false`, map or manually execute `:lua package.loaded.presence:update()`)
                neovim_image_text = "The Only Editor I need", -- Text displayed when hovered over the Neovim image
                main_image = "neovim", -- Main image display (either "neovim" or "file")
                log_level = nil, -- Log messages at or above this level (one of the following: "debug", "info", "warn", "error")
                debounce_timeout = 10, -- Number of seconds to debounce events (or calls to `:lua package.loaded.presence:update(<filename>, true)`)
                enable_line_number = false, -- Displays the current line number instead of the current project
                blacklist = {}, -- A list of strings or Lua patterns that disable Rich Presence if the current file name, path, or workspace matches
                buttons = true, -- Configure Rich Presence button(s), either a boolean to enable/disable, a static table (`{{ label = "<label>", url = "<url>" }, ...}`, or a function(buffer: string, repo_url: string|nil): table)
                file_assets = {}, -- Custom file asset definitions keyed by file names and extensions (see default config at `lua/presence/file_assets.lua` for reference)

                -- Rich Presence text options
                editing_text = "Editing %s", -- Format string rendered when an editable file is loaded in the buffer (either string or function(filename: string): string)
                file_explorer_text = "Browsing %s", -- Format string rendered when browsing a file explorer (either string or function(file_explorer_name: string): string)
                git_commit_text = "Committing changes", -- Format string rendered when committing changes in git (either string or function(filename: string): string)
                plugin_manager_text = "Managing plugins", -- Format string rendered when managing plugins (either string or function(plugin_manager_name: string): string)
                reading_text = "Reading %s", -- Format string rendered when a read-only or unmodifiable file is loaded in the buffer (either string or function(filename: string): string)
                workspace_text = "Working on %s", -- Format string rendered when in a git repository (either string or function(project_name: string|nil, filename: string): string)
                line_number_text = "Line %s out of %s", -- Format string rendered when `enable_line_number` is set to true (either string or function(line_number: number, line_count: number): string)
            })
        end,
    },
    -- Useful plugin to show you pending keybinds.
    { "folke/which-key.nvim", opts = {}, event = "VeryLazy" },
    {
        -- Adds git related signs to the gutter, as well as utilities for managing changes
        "lewis6991/gitsigns.nvim",
        opts = {
            -- See `:help gitsigns.txt`
            signs = {
                add = { text = "+" },
                untracked = { text = "+" },
                change = { text = "~" },
                delete = { text = "_" },
                topdelete = { text = "‾" },
                changedelete = { text = "~" },
            },
            on_attach = function(bufnr)
                vim.keymap.set(
                    "n",
                    "<leader>hp",
                    require("gitsigns").preview_hunk,
                    { buffer = bufnr, desc = "Preview git hunk" }
                )

                -- don't override the built-in and fugitive keymaps
                local gs = package.loaded.gitsigns
                vim.keymap.set({ "n", "v" }, "]c", function()
                    if vim.wo.diff then
                        return "]c"
                    end
                    vim.schedule(function()
                        gs.next_hunk()
                    end)
                    return "<Ignore>"
                end, { expr = true, buffer = bufnr, desc = "Jump to next hunk" })
                vim.keymap.set({ "n", "v" }, "[c", function()
                    if vim.wo.diff then
                        return "[c"
                    end
                    vim.schedule(function()
                        gs.prev_hunk()
                    end)
                    return "<Ignore>"
                end, { expr = true, buffer = bufnr, desc = "Jump to previous hunk" })
            end,
        },
    },

    -- {
    --     -- Set lualine as statusline
    --     "nvim-lualine/lualine.nvim",
    --     -- See `:help lualine.txt`
    --     opts = {
    --         options = {
    --             icons_enabled = false,
    --             theme = "onedark",
    --             component_separators = "|",
    --             section_separators = "",
    --         },
    --     },
    -- },
    --
    {
        -- Add indentation guides even on blank lines
        "lukas-reineke/indent-blankline.nvim",
        -- Enable `lukas-reineke/indent-blankline.nvim`
        -- See `:help indent_blankline.txt`
        config = function()
            -- U+2502 may also be a good choice, it will be on the middle of cursor.
            -- U+250A is also a good choice
            --  v2 config
            -- char = "|",
            -- show_trailing_blankline_indent = false,
            -- show_current_context = true,
            -- show_current_context_start = true,
            -- v3 config
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
            -- create the highlight groups in the highlight setup hook, so they are reset
            -- every time the colorscheme changes
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
                indent = {
                    smart_indent_cap = true,
                },
                scope = {
                    include = { node_type = { lua = { "return_statement", "table_constructor" } } },
                    enabled = true,
                    priority = 500,
                    highlight = highlight,
                },
            })
        end,
    },
    --
    -- "gc" to comment visual regions/lines
    { "numToStr/Comment.nvim", opts = {} },

    -- Fuzzy Finder (files, lsp, etc)
    {
        "ibhagwan/fzf-lua",
        -- optional for icon support
        dependencies = { "nvim-tree/nvim-web-devicons" },
        -- or if using mini.icons/mini.nvim
        -- dependencies = { "echasnovski/mini.icons" },
        opts = {},
    },

    {
        -- Highlight, edit, and navigate code
        "nvim-treesitter/nvim-treesitter",
        dependencies = {
            "luckasRanarison/tree-sitter-hyprlang",
        },
        build = ":TSUpdate",
    },
    {
        "echasnovski/mini.ai",
        version = false,
        config = function()
            require("mini.ai").setup()
        end,
    },
    {
        "echasnovski/mini.pairs",
        version = false,
        config = function()
            require("mini.pairs").setup({
                -- In which modes mappings from this `config` should be created
                modes = { insert = true, command = false, terminal = false },

                -- Global mappings. Each right hand side should be a pair information, a
                -- table with at least these fields (see more in |MiniPairs.map|):
                -- - <action> - one of 'open', 'close', 'closeopen'.
                -- - <pair> - two character string for pair to be used.
                -- By default pair is not inserted after `\`, quotes are not recognized by
                -- `<CR>`, `'` does not insert pair after a letter.
                -- Only parts of tables can be tweaked (others will use these defaults).
                mappings = {
                    ["("] = { action = "open", pair = "()", neigh_pattern = "[^\\]." },
                    ["["] = { action = "open", pair = "[]", neigh_pattern = "[^\\]." },
                    ["{"] = { action = "open", pair = "{}", neigh_pattern = "[^\\]." },

                    [")"] = { action = "close", pair = "()", neigh_pattern = "[^\\]." },
                    ["]"] = { action = "close", pair = "[]", neigh_pattern = "[^\\]." },
                    ["}"] = { action = "close", pair = "{}", neigh_pattern = "[^\\]." },

                    ['"'] = { action = "closeopen", pair = '""', neigh_pattern = "[^\\].", register = { cr = false } },
                    ["'"] = { action = "closeopen", pair = "''", neigh_pattern = "[^%a\\].", register = { cr = false } },
                    ["`"] = { action = "closeopen", pair = "``", neigh_pattern = "[^\\].", register = { cr = false } },
                },
            })
        end,
    },
    {
        "echasnovski/mini.surround",
        version = false,
        config = function()
            require("mini.surround").setup()
        end,
    },
}, {})

-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = "a"

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = "unnamedplus"

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = "yes"

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = "*",
})

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
-- require("telescope").setup({
--     defaults = {
--         mappings = {
--             i = {
--                 ["<C-u>"] = false,
--                 ["<C-d>"] = false,
--             },
--         },
--     },
-- })

-- See `:help telescope.builtin`
vim.keymap.set("n", "<leader>?", require("fzf-lua").oldfiles, { desc = "[?] Find recently opened files" })
vim.keymap.set("n", "<leader><space>", require("fzf-lua").buffers, { desc = "[ ] Find existing buffers" })
-- vim.keymap.set("n", "<leader>/", function()
--     -- You can pass additional configuration to telescope to change theme, layout, etc.
--     require("telescope.builtin").grep_curbuf(require("telescope.themes").get_dropdown({
--         winblend = 10,
--         previewer = false,
--     }))
-- end, { desc = "[/] Fuzzily search in current buffer" })
vim.keymap.set("n", "<leader>/", require("fzf-lua").grep_curbuf, { desc = "[/] Fuzzily search in current buffer" })
vim.keymap.set("n", "<leader>gf", require("fzf-lua").git_files, { desc = "Search [G]it [F]iles" })
vim.keymap.set("n", "<leader>sf", require("fzf-lua").files, { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>sw", require("fzf-lua").grep_cword, { desc = "[S]earch current [W]ord" })
vim.keymap.set("n", "<leader>sg", require("fzf-lua").live_grep, { desc = "[S]earch by [G]rep (Live grep)" })
vim.keymap.set("n", "<leader>sd", require("fzf-lua").diagnostics_workspace, { desc = "[S]earch [D]iagnostics" })
vim.keymap.set("n", "<leader>sr", require("fzf-lua").resume, { desc = "[S]earch [R]esume" })

-- Mapping to move lines.
-- ref: https://vim.fandom.com/wiki/Moving_lines_up_or_down#Mappings_to_move_lines

vim.keymap.set("n", "<A-j>", "<cmd>m .+1<CR>==", { noremap = true })
vim.keymap.set("n", "<A-k>", "<cmd>m .-2<CR>==", { noremap = true })
vim.keymap.set("i", "<A-j>", "<Esc>:m .+1<CR>==gi", { noremap = true })
vim.keymap.set("i", "<A-k>", "<Esc>:m .-2<CR>==gi", { noremap = true })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { noremap = true })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { noremap = true })

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require("nvim-treesitter.configs").setup({
    -- Add languages to be installed here that you want installed for treesitter
    ensure_installed = {
        "c",
        "cpp",
        "lua",
        "python",
        "rust",
        "vimdoc",
        "vim",
        "regex",
        "markdown",
        "markdown_inline",
    },

    -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
    auto_install = true,

    highlight = { enable = true },
    indent = { enable = true },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "<c-space>",
            node_incremental = "<c-space>",
            scope_incremental = "<c-s>",
            node_decremental = "<M-space>",
        },
    },
    textobjects = {
        select = {
            enable = true,
            lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
            keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ["aa"] = "@parameter.outer",
                ["ia"] = "@parameter.inner",
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner",
            },
        },
        move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
                ["]m"] = "@function.outer",
                ["]]"] = "@class.outer",
            },
            goto_next_end = {
                ["]M"] = "@function.outer",
                ["]["] = "@class.outer",
            },
            goto_previous_start = {
                ["[m"] = "@function.outer",
                ["[["] = "@class.outer",
            },
            goto_previous_end = {
                ["[M"] = "@function.outer",
                ["[]"] = "@class.outer",
            },
        },
        swap = {
            enable = true,
            swap_next = {
                ["<leader>a"] = "@parameter.inner",
            },
            swap_previous = {
                ["<leader>A"] = "@parameter.inner",
            },
        },
    },
})
local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
parser_config.hypr = {
    install_info = {
        url = "https://github.com/luckasRanarison/tree-sitter-hyprlang",
        files = { "src/parser.c" },
        branch = "master",
    },
    filetype = "hypr",
}
vim.cmd("let g:Hexokinase_highlighters = ['backgroundfull']")
vim.cmd("highlight LspInlayHint guibg=none")

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
