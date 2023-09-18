local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

-- Set header
dashboard.section.header.val = {
    "                                                     ",
    "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
    "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
    "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
    "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
    "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
    "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
    "                                                     ",
}

-- Set menu
dashboard.section.buttons.val = {
    dashboard.button("Leader f f", "  > Find file", ":Telescope find_files <CR>"),
    dashboard.button("Leader f r", "  > Recent files", ":Telescope oldfiles <CR>"),
    dashboard.button("Leader f g", "  > Project grep", ":Leaderf rg --popup<CR>"),
    dashboard.button("c", " " .. " Config", ":e $MYVIMRC <CR>"),
    dashboard.button("l", "󰒲 " .. " Lazy", ":Lazy<CR>"),
    dashboard.button("u", "  > Update plugins", ":Lazy sync<CR>"),
    dashboard.button("e", "  > New file", ":enew <CR>"),
    dashboard.button("q", "  > Quit NVIM", ":qa<CR>"),
}
for _, button in ipairs(dashboard.section.buttons.val) do
    button.opts.hl = "AlphaButtons"
    button.opts.hl_shortcut = "AlphaShortcut"
end

local fortune = require("alpha.fortune")
dashboard.section.footer.val = fortune()
dashboard.section.header.opts.hl = "AlphaHeader"
dashboard.section.buttons.opts.hl = "AlphaButtons"
dashboard.section.footer.opts.hl = "AlphaFooter"
dashboard.opts.layout[1].val = 8

-- Send config to alpha
alpha.setup(dashboard.opts)
