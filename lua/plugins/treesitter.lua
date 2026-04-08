return {
    {
        "nvim-treesitter/nvim-treesitter",
        dependencies = {
            {
                "nvim-treesitter/nvim-treesitter-context",
                opts = {
                    max_lines = 4,
                    multiline_threshold = 2,
                },
            },
        },
        lazy = false,
        branch = "main",
        build = ":TSUpdate",
        config = function()
            local ts = require("nvim-treesitter")

            -- State tracking for async parser loading
            local parsers_loaded = {}
            local parsers_pending = {}
            local parsers_failed = {}

            local ns = vim.api.nvim_create_namespace("treesitter.async")

            -- Helper to start highlighting and indentation
            local function start(buf, lang)
                local ok = pcall(vim.treesitter.start, buf, lang)
                if ok then
                    vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end
                return ok
            end

            -- Install core parsers after lazy.nvim finishes loading all plugins
            vim.api.nvim_create_autocmd("User", {
                pattern = "LazyDone",
                once = true,
                callback = function()
                    ts.install({
                        "bash",
                        "comment",
                        "c",
                        "cpp",
                        "diff",
                        "fish",
                        "git_config",
                        "git_rebase",
                        "gitcommit",
                        "gitignore",
                        "json",
                        "latex",
                        "lua",
                        "luadoc",
                        "make",
                        "markdown",
                        "markdown_inline",
                        "python",
                        "query",
                        "regex",
                        "rust",
                        "toml",
                        "typst",
                        "vim",
                        "vimdoc",
                    }, {
                        max_jobs = 8,
                    })
                end,
            })

            -- Decoration provider for async parser loading
            vim.api.nvim_set_decoration_provider(ns, {
                on_start = vim.schedule_wrap(function()
                    if #parsers_pending == 0 then
                        return false
                    end
                    for _, data in ipairs(parsers_pending) do
                        if vim.api.nvim_buf_is_valid(data.buf) then
                            if start(data.buf, data.lang) then
                                parsers_loaded[data.lang] = true
                            else
                                parsers_failed[data.lang] = true
                            end
                        end
                    end
                    parsers_pending = {}
                end),
            })

            local group = vim.api.nvim_create_augroup("TreesitterSetup", { clear = true })

            local ignore_filetypes = {
                "blink-cmp-menu",
                "checkhealth",
                "lazy",
                "mason",
                "snacks_dashboard",
                "snacks_notif",
                "snacks_win",
                "noice",
                "notify",
                "nvim-tree",
                "neo-tree",
                "trouble",
            }

            -- Auto-install parsers and enable highlighting on FileType
            vim.api.nvim_create_autocmd("FileType", {
                group = group,
                desc = "Enable treesitter highlighting and indentation (non-blocking)",
                callback = function(event)
                    if vim.tbl_contains(ignore_filetypes, event.match) then
                        return
                    end

                    local lang = vim.treesitter.language.get_lang(event.match) or event.match
                    local buf = event.buf

                    if parsers_failed[lang] then
                        return
                    end

                    if parsers_loaded[lang] then
                        -- Parser already loaded, start immediately (fast path)
                        start(buf, lang)
                    else
                        -- Queue for async loading
                        table.insert(parsers_pending, { buf = buf, lang = lang })
                    end

                    -- Auto-install missing parsers (async, no-op if already installed)
                    ts.install({ lang })
                end,
            })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main",
        init = function()
            -- Disable entire built-in ftplugin mappings to avoid conflicts.
            -- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
            vim.g.no_plugin_maps = true

            -- Or, disable per filetype (add as you like)
            -- vim.g.no_python_maps = true
            -- vim.g.no_ruby_maps = true
            -- vim.g.no_rust_maps = true
            -- vim.g.no_go_maps = true
        end,
        config = function()
            ---- configuration
            require("nvim-treesitter-textobjects").setup({
                select = {
                    -- Automatically jump forward to textobj, similar to targets.vim
                    lookahead = true,
                    -- You can choose the select mode (default is charwise 'v')
                    --
                    -- Can also be a function which gets passed a table with the keys
                    -- * query_string: eg '@function.inner'
                    -- * method: eg 'v' or 'o'
                    -- and should return the mode ('v', 'V', or '<c-v>') or a table
                    -- mapping query_strings to modes.
                    selection_modes = {
                        ["@parameter.outer"] = "v", -- charwise
                        ["@function.outer"] = "V", -- linewise
                        -- ['@class.outer'] = '<c-v>', -- blockwise
                    },
                    -- If you set this to `true` (default is `false`) then any textobject is
                    -- extended to include preceding or succeeding whitespace. Succeeding
                    -- whitespace has priority in order to act similarly to eg the built-in
                    -- `ap`.
                    --
                    -- Can also be a function which gets passed a table with the keys
                    -- * query_string: eg '@function.inner'
                    -- * selection_mode: eg 'v'
                    -- and should return true of false
                    include_surrounding_whitespace = false,
                },
            })

            -- keymaps
            -- You can use the capture groups defined in `textobjects.scm`
            vim.keymap.set({ "x", "o" }, "am", function()
                require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
            end, { desc = "select function outer" })
            vim.keymap.set({ "x", "o" }, "im", function()
                require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
            end, { desc = "select function inner" })
            vim.keymap.set({ "x", "o" }, "ac", function()
                require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
            end, { desc = "select class outer" })
            vim.keymap.set({ "x", "o" }, "ic", function()
                require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
            end, { desc = "select class inner" })
            -- You can also use captures from other query groups like `locals.scm`
            vim.keymap.set({ "x", "o" }, "as", function()
                require("nvim-treesitter-textobjects.select").select_textobject("@local.scope", "locals")
            end, { desc = "select local scope" })
        end,
    },
}
