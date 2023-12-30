return {
    {
        "echasnovski/mini.bufremove",

        keys = {
            {
                "<leader>bd",
                function()
                    local bd = require("mini.bufremove").delete
                    if vim.bo.modified then
                        local choice =
                            vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
                        if choice == 1 then -- Yes
                            vim.cmd.write()
                            bd(0)
                        elseif choice == 2 then -- No
                            bd(0, true)
                        end
                    else
                        bd(0)
                    end
                end,
                desc = "Delete Buffer",
            },
      -- stylua: ignore
      { "<leader>bD", function() require("mini.bufremove").delete(0, true) end, desc = "Delete Buffer (Force)" },
        },
    },
    {
        "nvimdev/guard.nvim",
        -- Builtin configuration, optional
        dependencies = {
            "nvimdev/guard-collection",
        },
        config = function()
            local ft = require("guard.filetype")

            ft("lua"):fmt("stylua"):lint("selene") -- Call setup() LAST!
            ft("c"):fmt("clang-format"):lint("clang-tidy")
            ft("cpp"):fmt("clang-format"):lint("clang-tidy")
            ft("nix"):fmt({ cmd = "alejandra", stdin = true })
            ft("rust"):fmt("rustfmt")
            require("guard").setup({
                -- the only options for the setup function
                fmt_on_save = false,
                -- Use lsp if no formatter was defined for this filetype
                lsp_as_default_formatter = false,
            })
        end,
    },
    {
        "chentoast/marks.nvim",
        config = function()
            require("marks").setup()
        end,
    },
}
