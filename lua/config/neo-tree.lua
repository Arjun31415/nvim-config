vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])
vim.fn.sign_define("DiagnosticSignError",
                   {text = " ", texthl = "DiagnosticSignError"})
vim.fn.sign_define("DiagnosticSignWarn",
                   {text = " ", texthl = "DiagnosticSignWarn"})
vim.fn.sign_define("DiagnosticSignInfo",
                   {text = " ", texthl = "DiagnosticSignInfo"})
vim.fn.sign_define("DiagnosticSignHint",
                   {text = "", texthl = "DiagnosticSignHint"})
require("neo-tree").setup({
    close_if_last_window = true,
    popup_border_style = "rounded",
    enable_git_status = true,
    enable_diagnostics = true,
    git_status = {
        symbols = {
            -- Change type
            added = "✚",
            deleted = "✖",
            modified = "",
            renamed = "",
            -- Status type
            untracked = "",
            ignored = "",
            unstaged = "",
            staged = "",
            conflict = ""
        },
        filesystem = {
            commands = {
                -- Override delete to use trash instead of rm
                delete = function(state)
                    local path = state.tree:get_node().path
                    vim.fn.system({"trash", vim.fn.fnameescape(path)})
                    require("neo-tree.sources.manager").refresh(state.name)
                end
            }
        },
        window = {
            position = "float",
            mappings = {
                ["A"] = "git_add_all",
                ["gu"] = "git_unstage_file",
                ["ga"] = "git_add_file",
                ["gr"] = "git_revert_file",
                ["gc"] = "git_commit",
                ["gp"] = "git_push",
                ["gg"] = "git_commit_and_push"
            }
        }

    },
    hijack_netrw_behavior = "open_current",
    filesystem = {
        filtered_items = {
            visible = false, -- when true, they will just be displayed differently than normal items
            hide_dotfiles = false,
            hide_gitignored = false,
            hide_by_name = {
                ".DS_Store", "thumbs.db"
                -- "node_modules"
            },
            never_show = { -- remains hidden even if visible is toggled to true
                -- ".DS_Store",
                -- "thumbs.db"
            }
        }
    }

})
