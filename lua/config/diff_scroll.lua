-- Horizontal wheel steps over a diff window redraw both sides and queue up on a
-- trackpad, so they are summed and replayed once per frame.
local M = {}

local FRAME_MS = 16

local pending = { win = 0, cols = 0 }
local scheduled = false

local function flush()
    scheduled = false
    local batch = pending
    pending = { win = 0, cols = 0 }
    -- Replayed steps land wherever the mouse is now.
    if batch.cols == 0 or vim.fn.getmousepos().winid ~= batch.win then
        return
    end
    local saved = vim.o.mousescroll
    vim.o.mousescroll = (saved:match("ver:%d+") or "ver:3") .. ",hor:" .. math.abs(batch.cols)
    local key = batch.cols > 0 and "<ScrollWheelRight>" or "<ScrollWheelLeft>"
    vim.api.nvim_feedkeys(vim.keycode(key), "nx", false)
    vim.o.mousescroll = saved
end

local function wheel(key, sign)
    return function()
        local win = vim.fn.getmousepos().winid
        local step = tonumber(vim.o.mousescroll:match("hor:(%d+)")) or 6
        if win == 0 or step == 0 or not vim.wo[win].diff then
            return key
        end
        if pending.win ~= win then
            pending = { win = win, cols = 0 }
        end
        pending.cols = pending.cols + sign * step
        if not scheduled then
            scheduled = true
            vim.defer_fn(flush, FRAME_MS)
        end
        return ""
    end
end

function M.setup()
    for key, sign in pairs({ ["<ScrollWheelRight>"] = 1, ["<ScrollWheelLeft>"] = -1 }) do
        vim.keymap.set("n", key, wheel(key, sign), { expr = true, desc = "Batched horizontal scroll in diff windows" })
    end
end

return M
