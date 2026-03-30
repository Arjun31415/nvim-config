local configFunctions = require("config.lsp.handlers")

-- Assuming codelldb is in the path (common on Nix)
-- Otherwise, you might need to provide the full path to the codelldb binary and liblldb.
-- On NixOS, you can use:
-- local codelldb_path = "/run/current-system/sw/bin/codelldb"
-- local liblldb_path = "/run/current-system/sw/lib/libcodelldb.so"

vim.g.rustaceanvim = {
    server = {
        on_attach = function(client, bufnr)
            configFunctions.on_attach(client, bufnr)
            -- Add rust-specific keybindings here if needed
            vim.keymap.set("n", "<leader>dr", function()
                vim.cmd.RustLsp("debuggables")
            end, { buffer = bufnr, desc = "Rust Debuggables" })
            vim.keymap.set("n", "<leader>ca", function()
                vim.cmd.RustLsp("codeAction")
            end, { buffer = bufnr, desc = "Rust Code Action" })
        end,
        default_settings = {
            ["rust-analyzer"] = {
                cargo = {
                    allFeatures = true,
                    loadOutDirsFromCheck = true,
                    runBuildScripts = true,
                },
                -- Add clippy lints for Rust if you want
                checkOnSave = {
                    allFeatures = true,
                    command = "clippy",
                    extraArgs = { "--no-deps" },
                },
                procMacro = {
                    enable = true,
                    ignored = {
                        ["async-trait"] = { "async_trait" },
                        ["async-recursion"] = { "async_recursion" },
                    },
                },
            },
        },
    },
    -- DAP configuration
    dap = {
        -- If codelldb is in your path, rustaceanvim should find it automatically.
        -- If not, uncomment and set the paths below:
        -- adapter = require('rustaceanvim.config').get_codelldb_adapter(codelldb_path, liblldb_path)
    },
}
