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

            local parsers_loaded = {}
            local parsers_pending = {}
            local parsers_failed = {}

            local ns = vim.api.nvim_create_namespace("treesitter.async")

            local function start(buf, lang)
                local ok = pcall(vim.treesitter.start, buf, lang)
                if ok then
                    vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end
                return ok
            end

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
                        "hyprlang",
                        "java",
                        "json",
                        "latex",
                        "lua",
                        "luadoc",
                        "make",
                        "markdown",
                        "markdown_inline",
                        "nix",
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
                        start(buf, lang)
                    else
                        table.insert(parsers_pending, { buf = buf, lang = lang })
                    end

                    -- No-op when the parser is already installed.
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
            vim.g.no_plugin_maps = true
        end,
        config = function()
            require("nvim-treesitter-textobjects").setup({
                select = {
                    lookahead = true,
                    selection_modes = {
                        ["@parameter.outer"] = "v", -- charwise
                        ["@function.outer"] = "V", -- linewise
                    },
                    include_surrounding_whitespace = false,
                },
            })

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
            vim.keymap.set({ "x", "o" }, "as", function()
                require("nvim-treesitter-textobjects.select").select_textobject("@local.scope", "locals")
            end, { desc = "select local scope" })
        end,
    },
}
