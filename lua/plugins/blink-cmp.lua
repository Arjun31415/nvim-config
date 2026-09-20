local function lspkind_config()
    local lspKindConfig = require("lspkind")
    lspKindConfig.init({
        symbol_map = {
            Boolean = "[] Boolean",
            Character = "[] Character",
            Class = "[] Class",
            Color = "[] Color",
            Constant = "[] Constant",
            Constructor = "[] Constructor",
            Enum = "[] Enum",
            EnumMember = "[] EnumMember",
            Event = "[ﳅ] Event",
            Field = "[] Field",
            File = "[] File",
            Folder = "[ﱮ] Folder",
            Function = "[ﬦ] Function",
            Interface = "[] Interface",
            Keyword = "[] Keyword",
            Method = "[] Method",
            Module = "[] Module",
            Number = "[] Number",
            Operator = "[Ψ] Operator",
            Parameter = "[] Parameter",
            Property = "[ﭬ] Property",
            Reference = "[] Reference",
            Snippet = "[] Snippet",
            String = "[] String",
            Struct = "[ﯟ] Struct",
            Text = "[] Text",
            TypeParameter = "[] TypeParameter",
            Unit = "[] Unit",
            Value = "[] Value",
            Variable = "[ﳛ] Variable",
            Copilot = "",
        },
    })
end
local border_chars = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }
return {
    "saghen/blink.cmp",
    -- Prebuilt binary for the Rust matcher, rather than building it locally
    -- through blink's own flake on every version bump.
    version = "1.*",

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {

        snippets = { preset = "luasnip" },
        keymap = {
            ["<Tab>"] = { "select_next", "fallback" },
            ["<S-Tab>"] = { "select_prev", "fallback" },
            ["<Up>"] = { "select_prev", "fallback" },
            ["<Down>"] = { "select_next", "fallback" },
            ["<CR>"] = { "accept", "fallback" },
            ["<C-b>"] = {
                function(cmp)
                    cmp.scroll_documentation_up(4)
                end,
            },
            ["<C-f>"] = {
                function(cmp)
                    cmp.scroll_documentation_down(4)
                end,
            },
        },
        appearance = {
            use_nvim_cmp_as_default = true,
            nerd_font_variant = "mono",
        },

        completion = {
            menu = {
                auto_show = true,
                border = border_chars,
                draw = {
                    components = {
                        kind_icon = {
                            text = function(ctx)
                                return require("lspkind").symbolic(ctx.kind, {
                                    mode = "symbol",
                                    preset = "codicons",
                                })
                            end,
                        },
                    },
                },
            },
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 0,
                window = {
                    border = border_chars,
                },
            },
            list = { selection = { preselect = false, auto_insert = true } },
        },
        signature = {
            enabled = true,
            window = { border = border_chars },
        },

        sources = {
            default = { "lsp", "path", "snippets", "buffer" },
        },
    },
    opts_extend = { "sources.default" },

    dependencies = {
        "rafamadriz/friendly-snippets",
        { "onsails/lspkind.nvim", config = lspkind_config },
        {
            "L3MON4D3/LuaSnip",
            config = function()
                -- Was "./luasnip_snippets", relative to cwd, so the snippets
                -- only loaded when nvim was started from the config dir.
                local snippets = vim.fn.stdpath("config") .. "/luasnip_snippets"
                require("luasnip.loaders.from_snipmate").lazy_load({ paths = { snippets } })
                -- cpp.json/package.json are VSCode-format and were never
                -- being read; the from_vscode loader lived in the deleted
                -- nvim-cmp config.
                require("luasnip.loaders.from_vscode").lazy_load({ paths = { snippets } })
                require("luasnip.loaders.from_vscode").lazy_load()
            end,
        },
        "tamago324/nlsp-settings.nvim",
    },
}
