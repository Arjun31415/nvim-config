local configFunctions = require("config.lsp.handlers")

vim.g.rustaceanvim = {
    server = {
        on_attach = function(client, bufnr)
            configFunctions.on_attach(client, bufnr)
            -- Was <leader>dr, which shadowed dap.lua's "Toggle REPL" in
            -- exactly the buffers where you want a REPL.
            vim.keymap.set("n", "<leader>dR", function()
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
                -- checkOnSave is a boolean now; the old table form makes the
                -- server refuse to start ("invalid type: map, expected a boolean").
                checkOnSave = true,
                check = {
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
}
