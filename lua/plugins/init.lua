---Protected `require`
---@param module_name string
---@return table|function|nil module
---@return boolean loaded
local function prequire(module_name)
    local available, module = pcall(require, module_name)
    if available then
        return module, true
    end
    return nil, false
end

_G.prequire = prequire

return {}
