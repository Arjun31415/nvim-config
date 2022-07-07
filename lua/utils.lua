-- inspect something
-- Taken from https://github.com/jamestthompson3/vimConfig/blob/eeef4a8eeb5a24938f8a0969a35f69c78643fb66/lua/tt/nvim_utils.lua#L106
local M = {}
function M.inspect(item) print(vim.inspect(item)) end

function M.executable(name)
    if vim.fn.executable(name) > 0 then return true end

    return false
end

function M.may_create_dir()
    local fpath = vim.fn.expand('<afile>')
    local parent_dir = vim.fn.fnamemodify(fpath, ":p:h")
    local res = vim.fn.isdirectory(parent_dir)

    if res == 0 then vim.fn.mkdir(parent_dir, 'p') end
end
function M.map(mode, lhs, rhs, opts)
    local options = {noremap = true}
    if opts then options = vim.tbl_extend("force", options, opts) end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end
-- checks if a given table has a value
function M.has_value(tab, val)
    for _, value in ipairs(tab) do if value == val then return true end end
    return false
end
function M.isempty(s)
    return s == nil or s == ""
  end
  function M.get_buf_option(opt)
    local status_ok, buf_option = pcall(vim.api.nvim_buf_get_option, 0, opt)
    if not status_ok then
      return nil
    else
      return buf_option
    end
  end
return M
