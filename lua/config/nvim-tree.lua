local utils = require("utils")
require'nvim-tree'.setup {
    disable_netrw = true,
    hijack_netrw = true,
    open_on_setup = true,
    diagnostics = {
        enable = true,
        icons = {hint = "", info = "", warning = "", error = ""}
    },
    hijack_cursor = true,

    hijack_unnamed_buffer_when_opening = true,
    update_focused_file = {enable = true, update_cwd = false, ignore_list = {}},
    system_open = {cmd = nil, args = {}},
    filters = {dotfiles = true, custom = {}},
    git = {enable = true, ignore = false, timeout = 500},
    view = {
        width = 35,
        height = 30,
        hide_root_folder = false,
        side = 'left',
        mappings = {
            custom_only = false,
            list = {
                {
                    mode = "n",
                    key = "<C-t>",
                    cb = "<cmd>lua require'telescope.builtin'.live_grep()<cr>"
                }
            }
        },
        number = false,
        relativenumber = false,
        signcolumn = "yes"
    },
    actions = {
        change_dir = {enable = true, global = false},
        open_file = {
            quit_on_open = false,
            resize_window = false,
            window_picker = {
                enable = true,
                chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
                exclude = {
                    filetype = {
                        "notify", "packer", "qf", "diff", "fugitive",
                        "fugitiveblame"
                    },
                    buftype = {"nofile", "terminal", "help"}
                }
            }
        }
    },
    log = {enable = false, types = {all = false, config = false, git = false}}
}
utils.map("n", "<leader>b", ":NvimTreeToggle<CR>", {silent = true})
vim.g.nvim_tree_indent_markers = 1
