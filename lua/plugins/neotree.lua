-- Unless you are still migrating, remove the deprecated commands from v1.x
vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "main",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
    },
    config = function()
        require("neo-tree").setup({
            use_libuv_file_watcher = true,
            enable_git_status = true,
            enable_diagnostics = true,
            disable_netrw = true,

            follow_current_file = { enabled = true },
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
                    conflict = "",
                },
                filesystem = {
                    disable_netrw = true,

                    hijack_netrw_behavior = "open_current",
                    commands = {
                        -- Override delete to use trash instead of rm
                        delete = function(state)
                            local path = state.tree:get_node().path
                            vim.fn.system({ "trash", vim.fn.fnameescape(path) })
                            require("neo-tree.sources.manager").refresh(state.name)
                        end,
                    },
                },
                window = {
                    position = "float",
                    mapping_options = {
                        noremap = true,
                        nowait = true,
                    },
                    mappings = {
                        ["<2-LeftMouse>"] = "open",
                        ["A"] = "git_add_all",
                        ["gu"] = "git_unstage_file",
                        ["ga"] = "git_add_file",
                        ["gr"] = "git_revert_file",
                        ["gc"] = "git_commit",
                        ["gp"] = "git_push",
                        ["gg"] = "git_commit_and_push",
                    },
                },
            },
        })
    end,
    keys = {
        { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "NeoTree toggle", silent = true },
    },
    lazy = false,
}
