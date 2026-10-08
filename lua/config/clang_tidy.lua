-- Runs clang-tidy through nvim-lint with a global process cap.
--
-- nvim-lint's try_lint() keeps at most one process per buffer but has no
-- limit across buffers, and spawns them detached so they outlive nvim. Each
-- clang-tidy re-parses the whole translation unit, which in large C++ repos
-- costs a full core and GBs of RAM, so opening a handful of files saturates
-- the machine and starves clangd.
local M = {}

local MAX_PROCS = 16
-- auto-save writes on every TextChanged; wait for edits to settle.
local DEBOUNCE_MS = 1000
local QUEUE_POLL_MS = 250
local FILETYPES = { c = true, cpp = true }

---@type table<lint.LintProc, true> includes cancelled procs still shutting down
local live_procs = {}
---@type table<integer, lint.LintProc>
local proc_by_buf = {}
---@type integer[] most recent request first
local queue = {}
---@type table<integer, uv.uv_timer_t>
local debounce_timers = {}
local queue_timer = assert(vim.uv.new_timer())

local function make_linter()
    local linter = vim.deepcopy(require("lint").linters.clangtidy)
    linter.name = "clangtidy"
    -- Keep nvim and clangd responsive while clang-tidy runs. `nice` execs
    -- clang-tidy in place, so cancelling still signals the right pid.
    if vim.fn.executable("nice") == 1 then
        linter.args = vim.list_extend({ "-n", "10", linter.cmd }, linter.args or {})
        linter.cmd = "nice"
    end
    return linter
end

local linter

local function is_alive(proc)
    return proc.handle ~= nil and not proc.handle:is_closing()
end

local function live_count()
    local count = 0
    for proc in pairs(live_procs) do
        if is_alive(proc) then
            count = count + 1
        else
            live_procs[proc] = nil
        end
    end
    return count
end

local function remove_from_queue(bufnr)
    for i, queued in ipairs(queue) do
        if queued == bufnr then
            table.remove(queue, i)
            return
        end
    end
end

local function cancel(bufnr)
    local proc = proc_by_buf[bufnr]
    if proc and is_alive(proc) then
        proc:cancel()
    end
    proc_by_buf[bufnr] = nil
end

local function start(bufnr)
    cancel(bufnr)
    linter = linter or make_linter()
    vim.api.nvim_buf_call(bufnr, function()
        local proc = require("lint").lint(linter)
        if proc then
            proc_by_buf[bufnr] = proc
            live_procs[proc] = true
        end
    end)
end

local function drain_queue()
    while #queue > 0 and live_count() < MAX_PROCS do
        local bufnr = table.remove(queue, 1)
        if vim.api.nvim_buf_is_loaded(bufnr) then
            start(bufnr)
        end
    end
    if #queue == 0 then
        queue_timer:stop()
    elseif not queue_timer:is_active() then
        queue_timer:start(QUEUE_POLL_MS, QUEUE_POLL_MS, vim.schedule_wrap(drain_queue))
    end
end

local function enqueue(bufnr)
    if not vim.api.nvim_buf_is_loaded(bufnr) then
        return
    end
    local running = proc_by_buf[bufnr]
    if running and is_alive(running) then
        -- Replacing this buffer's own run does not add to the process count.
        start(bufnr)
        return
    end
    remove_from_queue(bufnr)
    table.insert(queue, 1, bufnr)
    drain_queue()
end

local function request(bufnr)
    local timer = debounce_timers[bufnr]
    if not timer then
        timer = assert(vim.uv.new_timer())
        debounce_timers[bufnr] = timer
    end
    timer:start(
        DEBOUNCE_MS,
        0,
        vim.schedule_wrap(function()
            enqueue(bufnr)
        end)
    )
end

local function forget(bufnr)
    local timer = debounce_timers[bufnr]
    if timer then
        timer:stop()
        timer:close()
        debounce_timers[bufnr] = nil
    end
    remove_from_queue(bufnr)
    cancel(bufnr)
end

local function kill_all()
    for _, timer in pairs(debounce_timers) do
        timer:stop()
    end
    queue = {}
    queue_timer:stop()
    for proc in pairs(live_procs) do
        if is_alive(proc) then
            proc.cancelled = true
            proc.handle:kill("sigkill")
        end
    end
    live_procs = {}
    proc_by_buf = {}
end

function M.setup()
    local group = vim.api.nvim_create_augroup("clang_tidy_limited", { clear = true })

    -- clang-tidy reads the file from disk, so linting on InsertLeave without a
    -- write would only repeat the previous result.
    vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost" }, {
        group = group,
        callback = function(args)
            if FILETYPES[vim.bo[args.buf].filetype] then
                request(args.buf)
            end
        end,
    })
    vim.api.nvim_create_autocmd({ "BufDelete", "BufWipeout" }, {
        group = group,
        callback = function(args)
            forget(args.buf)
        end,
    })
    -- Processes are detached; without this they keep running after :qa.
    vim.api.nvim_create_autocmd("VimLeavePre", { group = group, callback = kill_all })

    vim.api.nvim_create_user_command("ClangTidyStatus", function()
        local running = {}
        for bufnr, proc in pairs(proc_by_buf) do
            if is_alive(proc) then
                table.insert(running, vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":~:."))
            end
        end
        local lines = {
            ("clang-tidy: %d/%d processes alive, %d queued"):format(live_count(), MAX_PROCS, #queue),
        }
        vim.list_extend(lines, running)
        vim.notify(table.concat(lines, "\n"))
    end, { desc = "Show running and queued clang-tidy processes" })

    vim.api.nvim_create_user_command("ClangTidyStop", kill_all, {
        desc = "Kill all clang-tidy processes and clear the queue",
    })
end

return M
