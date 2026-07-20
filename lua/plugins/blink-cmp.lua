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
    -- optional: provides snippets for the snippet source

    -- use a release tag to download pre-built binaries
    -- version = "*",
    branch = "v1",
    build = "nix run .#build-plugin",
    -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source using latest nightly rust with:
    -- build = 'nix run .#build-plugin',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {

        snippets = { preset = "luasnip" },
        -- 'default' for mappings similar to built-in completion
        -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
        -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
        -- See the full "keymap" documentation for information on defining your own keymap.
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
            -- Sets the fallback highlight groups to nvim-cmp's highlight groups
            -- Useful for when your theme doesn't support blink.cmp
            -- Will be removed in a future release
            use_nvim_cmp_as_default = true,
            -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
            -- Adjusts spacing to ensure icons are aligned
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
                    -- border = "rounded",
                },
            },
            list = { selection = { preselect = false, auto_insert = true } },
        },
        signature = {
            enabled = true,
            window = { border = border_chars },
        },

        -- Default list of enabled providers defined so that you can extend it
        -- elsewhere in your config, without redefining it, due to `opts_extend`
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
                require("luasnip.loaders.from_snipmate").lazy_load({ paths = { "./luasnip_snippets" } })
            end,
        },
        "tamago324/nlsp-settings.nvim",
    },
}
