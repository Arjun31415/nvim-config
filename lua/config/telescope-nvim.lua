local present, telescope = pcall(require, "telescope")
if not present then return end
vim.g.theme_switcher_loaded = true
local options = {
  extensions = {
    ["ui-select"] = { require("telescope.themes").get_dropdown({}) },
    fzf = {
      fuzzy = true, -- false will only do exact matching
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true, -- override the file sorter
      case_mode = "smart_case", -- or "ignore_case" or "respect_case"
      -- the default case_mode is "smart_case"
    },
  },
  extensions_list = { "ui-select", "fzf", "harpoon" },
  pickers = { colorscheme = { enable_preview = true } },
  defaults = {
    initial_mode = "insert",
    prompt_prefix = "   ",
    selection_caret = "  ",
    entry_prefix = "  ",
    borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
    file_sorter = require("telescope.sorters").get_fuzzy_file,
    file_ignore_patterns = { "node_modules" },
    qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
    buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
    color_devicons = true,
    mappings = { n = { ["q"] = require("telescope.actions").close } },
  },
}
telescope.setup(options)
pcall(function()
  for _, ext in ipairs(options.extensions_list) do
    telescope.load_extension(ext)
  end
end)
