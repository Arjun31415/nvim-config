---Protected `require` function
---@param module_name string
---@return table | function | Void module
---@return boolean loaded if module was loaded or not
function prequire(module_name)
    local available, module = pcall(require, module_name)
    if available then
        return module, true
    else
        -- local home = os.getenv('HOME') --[[@as string]]
        -- local source = debug.getinfo(2, "S").source:sub(2) :gsub(home, '~')
        -- local msg = string.format('"%s" requested in "%s" not available', module_name, source)
        -- vim.schedule(function() vim.notify_once(msg, vim.log.levels.WARN) end)

        return Void, false
    end
end
-- }}}

return {}
