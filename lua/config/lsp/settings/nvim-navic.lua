local navic = require("nvim-navic")
local icons = require("config.icons")

navic.setup({
    icons = {
        File = " ",
        Module = icons.kind.Module,
        Namespace = " ",
        Package = " ",
        Class = icons.kind.Class,
        Method = icons.kind.Method,
        Property = " ",
        Field = " ",
        Constructor = " ",
        Enum = "練",
        Interface = "練",
        Function = icons.kind.Function,
        Variable = " ",
        Constant = " ",
        String = icons.type.String,
        Number = " ",
        Boolean = icons.type.Boolean,
        Array = icons.type.Array,
        Object = icons.type.Object,
        Key = " ",
        Null = "ﳠ ",
        EnumMember = " ",
        Struct = " ",
        Event = " ",
        Operator = icons.kind.Operator,
        TypeParameter = " ",
    },
    highlight = true,
})
local function navic_attach(client, bufnr)
    navic.attach(client, bufnr)
end
M = {}
M.navic_attach = navic_attach
return M
