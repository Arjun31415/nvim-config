return {
    {
        "neovim/nvim-lspconfig",
    },
    { "microsoft/python-type-stubs" },
    -- Teaches lua_ls the nvim API and plugin types; without it every
    -- vim.* call in this config is an "undefined field" warning.
    { "folke/lazydev.nvim", ft = "lua", opts = {} },
    {
        "folke/trouble.nvim",
        dependencies = "kyazdani42/nvim-web-devicons",
        cmd = "Trouble",
        opts = {},
        keys = {
            {
                "<leader>xx",
                "<cmd>Trouble diagnostics toggle<cr>",
                desc = "Diagnostics (Trouble)",
            },
        },
    },
    {
        "mrcjkb/rustaceanvim",
        version = "^9",
        ft = { "rust" },
        dependencies = {
            "mfussenegger/nvim-dap",
            {
                "rcarriga/nvim-dap-ui",
                dependencies = { "nvim-neotest/nvim-nio" },
                opts = {},
                config = function(_, opts)
                    local dap = require("dap")
                    local dapui = require("dapui")
                    dapui.setup(opts)
                    dap.listeners.after.event_initialized["dapui_config"] = function()
                        dapui.open()
                    end
                    dap.listeners.before.event_terminated["dapui_config"] = function()
                        dapui.close()
                    end
                    dap.listeners.before.event_exited["dapui_config"] = function()
                        dapui.close()
                    end
                end,
            },
            {
                "theHamsta/nvim-dap-virtual-text",
                opts = {},
            },
        },
    },
    {
        "chomosuke/typst-preview.nvim",
        ft = "typst",
        version = "1.*",
        opts = {
            open_cmd = "open %s",
            dependencies_bin = { ["tinymist"] = "tinymist" },
        },
    },
}
