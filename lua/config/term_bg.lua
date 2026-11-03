-- Lets a :terminal job recolour its own window with OSC 11 / OSC 111
local M = {}

local BUILTIN_QUERY_DESC = "Handles OSC foreground/background color requests"

local function refresh(win)
    local buf = vim.api.nvim_win_get_buf(win)
    local tint = vim.b[buf].term_bg
    if tint then
        local group = "TermBg" .. buf
        local normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
        vim.api.nvim_set_hl(0, group, { fg = normal.fg, bg = tint })
        vim.wo[win].winhighlight = ("Normal:%s,NormalNC:%s"):format(group, group)
    -- A split copies winhighlight, so ours is recognised by value.
    elseif vim.wo[win].winhighlight:match("^Normal:TermBg%d+,NormalNC:TermBg%d+$") then
        vim.wo[win].winhighlight = ""
    end
end

local function reply_to_query(buf, which, terminator)
    local normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
    local color = which == "10" and normal.fg or normal.bg
    if not color then
        local want_white = (which == "10") == (vim.o.background == "dark")
        color = want_white and 0xffffff or 0
    end
    local r, g, b = bit.rshift(color, 16), bit.band(bit.rshift(color, 8), 0xff), bit.band(color, 0xff)
    local reply = ("\027]%s;rgb:%04x/%04x/%04x%s"):format(which, r * 257, g * 257, b * 257, terminator)
    vim.api.nvim_chan_send(vim.bo[buf].channel, reply)
end

function M.setup()
    local group = vim.api.nvim_create_augroup("TermBg", { clear = true })

    local own_queries = false
    for _, au in ipairs(vim.api.nvim_get_autocmds({ group = "nvim.terminal", event = "TermRequest" })) do
        if au.desc == BUILTIN_QUERY_DESC then
            vim.api.nvim_del_autocmd(au.id)
            own_queries = true
        end
    end

    vim.api.nvim_create_autocmd("TermRequest", {
        group = group,
        callback = function(ev)
            local seq = ev.data.sequence
            local query = own_queries and seq:match("^\027%](1[01]);%?$")
            if query then
                if vim.bo[ev.buf].channel ~= 0 then
                    reply_to_query(ev.buf, query, ev.data.terminator)
                end
                return
            end

            local tint = seq:match("^\027%]11;(#%x%x%x%x%x%x)$")
            if tint or seq == "\027]111" then
                vim.b[ev.buf].term_bg = tint
                for _, win in ipairs(vim.fn.win_findbuf(ev.buf)) do
                    refresh(win)
                end
            end
        end,
    })

    -- winhighlight belongs to the window, so it has to follow the buffer
    -- around; :colorscheme also clears the TermBg* groups.
    vim.api.nvim_create_autocmd({ "BufWinEnter", "ColorScheme" }, {
        group = group,
        callback = function()
            for _, win in ipairs(vim.api.nvim_list_wins()) do
                refresh(win)
            end
        end,
    })
end

return M
