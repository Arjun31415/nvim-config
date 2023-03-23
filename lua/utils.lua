-- inspect something
-- Taken from https://github.com/jamestthompson3/vimConfig/blob/eeef4a8eeb5a24938f8a0969a35f69c78643fb66/lua/tt/nvim_utils.lua#L106

local M = {}
function M.inspect(item) print(vim.inspect(item)) end

function M.executable(name)
  if vim.fn.executable(name) > 0 then return true end

  return false
end

function M.on_very_lazy(fn)
  vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function() fn() end,
  })
end

function M.may_create_dir()
  local fpath = vim.fn.expand("<afile>")
  local parent_dir = vim.fn.fnamemodify(fpath, ":p:h")
  local res = vim.fn.isdirectory(parent_dir)

  if res == 0 then vim.fn.mkdir(parent_dir, "p") end
end
function M.map(mode, lhs, rhs, opts, desc)
  local options = { noremap = true }
  if opts then options = vim.tbl_extend("force", options, opts) end
  -- vim.api.nvim_set_keymap(mode, lhs, rhs, options)
  vim.keymap.set(mode, lhs, rhs, options)
  local ok, wk = pcall(require, "which-key")
  if not ok then return end
  if desc then wk.register({ [lhs] = { rhs, desc } }, { mode = mode }) end
end
-- checks if a given table has a value
function M.has_value(tab, val)
  for _, value in ipairs(tab) do
    if value == val then return true end
  end
  return false
end
function M.isempty(s) return s == nil or s == "" end
function M.get_buf_option(opt)
  local status_ok, buf_option = pcall(vim.api.nvim_buf_get_option, 0, opt)
  if not status_ok then
    return nil
  else
    return buf_option
  end
end
function M.has_plugin(plugin) return require("lazy.core.config").plugins[plugin] ~= nil end

-- returns the root directory based on:
-- * lsp workspace folders
-- * lsp root_dir
-- * root pattern of filename of the current buffer
-- * root pattern of cwd
---@return string
function M.get_root()
  ---@type string?
  local path = vim.api.nvim_buf_get_name(0)
  path = path ~= "" and vim.loop.fs_realpath(path) or nil
  ---@type string[]
  local roots = {}
  if path then
    for _, client in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
      local workspace = client.config.workspace_folders
      local paths = workspace and vim.tbl_map(function(ws) return vim.uri_to_fname(ws.uri) end, workspace)
        or client.config.root_dir and { client.config.root_dir }
        or {}
      for _, p in ipairs(paths) do
        local r = vim.loop.fs_realpath(p)
        if path:find(r, 1, true) then roots[#roots + 1] = r end
      end
    end
  end
  table.sort(roots, function(a, b) return #a > #b end)
  ---@type string?
  local root = roots[1]
  if not root then
    path = path and vim.fs.dirname(path) or vim.loop.cwd()
    ---@type string?
    root = vim.fs.find(M.root_patterns, { path = path, upward = true })[1]
    root = root and vim.fs.dirname(root) or vim.loop.cwd()
  end
  ---@cast root string
  return root
end

-- this will return a function that calls telescope.
-- cwd will default to lazyvim.util.get_root
-- for `files`, git_files or find_files will be chosen depending on .git
function M.telescope(builtin, opts)
  local params = { builtin = builtin, opts = opts }
  return function()
    builtin = params.builtin
    opts = params.opts
    opts = vim.tbl_deep_extend("force", { cwd = M.get_root() }, opts or {})
    if builtin == "files" then
      if vim.loop.fs_stat((opts.cwd or vim.loop.cwd()) .. "/.git") then
        opts.show_untracked = true
        builtin = "git_files"
      else
        builtin = "find_files"
      end
    end
    require("telescope.builtin")[builtin](opts)
  end
end
return M
