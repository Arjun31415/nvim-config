local ft = require("guard.filetype")

ft("lua"):fmt("stylua"):lint("selene") -- Call setup() LAST!
ft("c"):fmt("clang-format"):lint("clang-tidy")
ft("cpp"):fmt("clang-format"):lint("clang-tidy")
ft("nix"):fmt({ cmd = "alejandra", stdin = true })

require("guard").setup({
    -- the only options for the setup function
    fmt_on_save = false,
    -- Use lsp if no formatter was defined for this filetype
    lsp_as_default_formatter = false,
})
