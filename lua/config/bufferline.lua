---@diagnostic disable: unused-local
local map = require("utils").map
require("bufferline").setup({
    options = {
        numbers = "buffer_id",
        close_command = "bdelete! %d",
        right_mouse_command = nil,
        left_mouse_command = "buffer %d",
        middle_mouse_command = nil,
        indicator_icon = "▎",
        buffer_close_icon = "",
        modified_icon = "●",
        close_icon = "",
        left_trunc_marker = "",
        right_trunc_marker = "",
        max_name_length = 18,
        max_prefix_length = 15,
        tab_size = 10,
        diagnostics = "coc",
        diagnostics_indicator = function(count, level, diagnostics_dict, context)
            local icon = level:match("error") and " " or " "
            return " " .. icon .. count
        end,
        custom_filter = function(bufnr)
            -- if the result is false, this buffer will be shown, otherwise, this
            -- buffer will be hidden.

            -- filter out filetypes you don't want to see
            local exclude_ft = {"qf", "fugitive", "git"}
            local cur_ft = vim.bo[bufnr].filetype
            local should_filter = vim.tbl_contains(exclude_ft, cur_ft)

            if should_filter then return false end

            return true
        end,
        show_buffer_icons = true,
        show_buffer_close_icons = true,
        show_close_icon = true,
        show_tab_indicators = true,
        persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
        separator_style = "bar",
        enforce_regular_tabs = false,
        always_show_bufferline = true,
        sort_by = "id"
    }
})
map("n", "[b", ":BufferLineCycleNext<CR>", {silent = true})
map("n", "]b", ":BufferLineCyclePrev<CR>", {silent = true})
map("n", "<Leader>bse", ":BufferLineSortByExtension<CR>", {silent = true})
map("n", "<Leader>bsd", ":BufferLineSortByDirectory<CR>", {silent = true})
