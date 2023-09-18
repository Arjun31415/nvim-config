local configFunctions = require("config.lsp.handlers")
local extension_path = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/adapter"
local codelldb_path = extension_path .. "/codelldb"
local liblldb_path = extension_path .. "/libcodelldb.so"
local opts = {
    tools = { -- rust-tools options
        autoSetHints = true,
        inlay_hints = {
            show_parameter_hints = true,
            parameter_hints_prefix = ":",
            other_hints_prefix = ":",
        },
    },
    server = { on_attach = configFunctions.on_attach },
    --[[ dap = {
    adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
  }, ]]
}
require("rust-tools").setup(opts)
