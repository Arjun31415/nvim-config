-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })

-- vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

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

local function cmp_config()
    require("config.lsp")
    local lspkind = require("lspkind")
    local present2, copilot = pcall(require, "copilot")
    if present2 then
        copilot.setup()
        require("copilot_cmp").setup({
            method = "getCompletionsCycling",
            formatters = {
                insert_text = require("copilot_cmp.format").remove_existing,
            },
        })
    end
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    require("luasnip.loaders.from_vscode").lazy_load()
    luasnip.config.setup({})
    cmp.setup({
        snippet = {
            expand = function(args)
                luasnip.lsp_expand(args.body)
            end,
        },
        style = { winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder" },
        formatting = {
            format = lspkind.cmp_format({ with_text = false, maxwidth = 50 }),
        },
        window = {
            completion = {
                border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
                scrollbar = "║",
                autocomplete = {
                    require("cmp.types").cmp.TriggerEvent.InsertEnter,
                    require("cmp.types").cmp.TriggerEvent.TextChanged,
                },
            },

            documentation = {
                border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
                winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
                scrollbar = "║",
            },
        },
        mapping = cmp.mapping.preset.insert({
            ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
            ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
            ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
            ["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
            ["<C-e>"] = cmp.mapping({
                i = cmp.mapping.abort(),
                c = cmp.mapping.close(),
            }),
            -- ['<CR>'] = cmp.mapping.confirm({select = false}), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
            ["<CR>"] = cmp.mapping.confirm({
                behavior = cmp.ConfirmBehavior.Replace,
                select = false,
            }),
            ["<Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
                -- they way you will only jump inside the snippet region
                elseif luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                elseif has_words_before() then
                    cmp.complete()
                else
                    fallback()
                end
            end, { "i", "s" }),
            ["<S-Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                else
                    fallback()
                end
            end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
            { name = "cmp_tabnine" },
            { name = "copilot", group_index = 2 },
            { name = "nvim_lsp" },
            { name = "luasnip" }, -- For luasnip users
        }, { { name = "buffer" } }),
        sorting = {
            priority_weight = 2,
            comparators = {
                require("copilot_cmp.comparators").prioritize,
                require("copilot_cmp.comparators").score,
                cmp.config.compare.group_index,
                cmp.config.compare.recently_used,
                cmp.config.compare.offset,
                cmp.config.compare.score,
                cmp.config.compare.sort_text,
                cmp.config.compare.length,
                cmp.config.compare.order,
            },
        },
    })
    vim.cmd([[ set pumheight=10 ]])
    cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
    })
    cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = { { name = "buffer" } },
    })
    -- local highlights = {
    --     CmpItemKindText = { fg = "Grey" },
    --     CmpItemKindFunction = { fg = "#C586C0" },
    --     CmpItemKindClass = { fg = "Orange" },
    --     CmpItemKindKeyword = { fg = "#f90c71" },
    --     CmpItemKindSnippet = { fg = "#565c64" },
    --     CmpItemKindConstructor = { fg = "#ae43f0" },
    --     CmpItemKindVariable = { fg = "#9CDCFE", bg = "NONE" },
    --     CmpItemKindInterface = { fg = "#f90c71", bg = "NONE" },
    --     CmpItemKindFolder = { fg = "#2986cc" },
    --     CmpItemKindReference = { fg = "#922b21" },
    --     CmpItemKindMethod = { fg = "#C586C0" },
    --     CmpItemMenu = { fg = "#C586C0", bg = "#C586C0" },
    --     CmpItemAbbr = { fg = "#565c64", bg = "NONE" },
    --     CmpItemAbbrMatch = { fg = "#569CD6", bg = "NONE" },
    --     CmpItemAbbrMatchFuzzy = { fg = "#569CD6", bg = "NONE" },
    -- }
    -- vim.api.nvim_set_hl(0, "CmpBorderedWindow_FloatBorder", { fg = "#565c64" })
    -- for group, hl in pairs(highlights) do
    --     vim.api.nvim_set_hl(0, group, hl)
    -- end
end

return {
    -- Autocompletion
    "hrsh7th/nvim-cmp",
    dependencies = {
        -- Snippet Engine & its associated nvim-cmp source
        {
            "L3MON4D3/LuaSnip",
            config = function()
                require("luasnip.loaders.from_snipmate").lazy_load({ paths = { "./luasnip_snippets" } })
            end,
        },
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        { "onsails/lspkind.nvim", config = lspkind_config },
        -- Adds LSP completion capabilities
        "hrsh7th/cmp-nvim-lsp",

        -- Adds a number of user-friendly snippets
        "rafamadriz/friendly-snippets",
        "tamago324/nlsp-settings.nvim",
        "zbirenbaum/copilot.lua",
        "zbirenbaum/copilot-cmp",
    },
    config = cmp_config,
}
