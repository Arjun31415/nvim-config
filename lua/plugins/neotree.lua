-- Unless you are still migrating, remove the deprecated commands from v1.x
vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])
local function copy_path(state)
    print("Hiiii")
    -- NeoTree is based on [NuiTree](https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/tree)
    -- The node is based on [NuiNode](https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/tree#nuitreenode)
    local node = state.tree:get_node()
    local filepath = node:get_id()
    local filename = node.name
    local modify = vim.fn.fnamemodify

    local results = {
        filepath,
        modify(filepath, ":."),
        modify(filepath, ":~"),
        filename,
        modify(filename, ":r"),
        modify(filename, ":e"),
    }

    vim.ui.select({
        "1. Absolute path: " .. results[1],
        "2. Path relative to CWD: " .. results[2],
        "3. Path relative to HOME: " .. results[3],
        "4. Filename: " .. results[4],
        "5. Filename without extension: " .. results[5],
        "6. Extension of the filename: " .. results[6],
    }, { prompt = "Choose to copy to clipboard:" }, function(choice)
        if choice then
            local i = tonumber(choice:sub(1, 1))
            if i then
                local result = results[i]
                vim.fn.setreg("+", result, "c")

                vim.notify("Copied: " .. result)
            else
                vim.notify("Invalid selection")
            end
        else
            vim.notify("Selection cancelled")
        end
    end)
end

return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "main",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "kyazdani42/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
    },
    opts = {
        use_libuv_file_watcher = true,
        enable_git_status = true,
        enable_diagnostics = true,
        disable_netrw = true,

        follow_current_file = { enabled = true },
        window = {
            -- position = "float",
            mapping_options = {
                noremap = true,
                nowait = true,
            },
            mappings = {
                ["<2-LeftMouse>"] = "open",
                ["<cr>"] = "open",
                ["A"] = "git_add_all",
                ["gu"] = "git_unstage_file",
                ["ga"] = "git_add_file",
                ["gr"] = "git_revert_file",
                ["gc"] = "git_commit",
                ["gp"] = "git_push",
                ["gg"] = "git_commit_and_push",
                ["Y"] = {
                    copy_path,
                    desc = "Copy the path of the file under the cursor",
                },
            },
        },
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
        },
    },
    keys = {
        { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "NeoTree toggle", silent = true },
    },
    lazy = false,
}
