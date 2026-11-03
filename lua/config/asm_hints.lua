-- In-process language server for :Asm results. It compiles only on :AsmHints;
-- results sit on extmarks so they follow edits until the next run.
local asm = require("config.asm")

local M = {}

local NAME = "asm-hints"
local OPEN_COMMAND = "asm-hints.open"
local MAX_HOVER_LINES = 30
local LSP_SEVERITY = { [vim.diagnostic.severity.INFO] = 3, [vim.diagnostic.severity.WARN] = 2 }

local ns = vim.api.nvim_create_namespace("asm_hints")

---@class asm_hints.LineInfo
---@field instrs integer
---@field asm string[]
---@field fn? asm.Function

---@class asm_hints.Result
---@field fargs string[]
---@field by_mark table<integer, asm_hints.LineInfo>

---@type table<integer, asm_hints.Result>
local results = {}
---@type table<integer, integer>
local generations = {}
---@type vim.lsp.rpc.Dispatchers?
local dispatchers
local client_id

---@return { row: integer, info: asm_hints.LineInfo }[]
local function infos_between(buf, first_row, last_row)
    local result = results[buf]
    if not result then
        return {}
    end
    local found = {}
    local marks = vim.api.nvim_buf_get_extmarks(buf, ns, { first_row, 0 }, { last_row, -1 }, { details = true })
    for _, mark in ipairs(marks) do
        local info = result.by_mark[mark[1]]
        if info and not mark[4].invalid then
            table.insert(found, { row = mark[2], info = info })
        end
    end
    return found
end

local function buf_of(params)
    return vim.uri_to_bufnr(params.textDocument.uri)
end

local function open_command(row)
    return { title = "Open assembly at this line", command = OPEN_COMMAND, arguments = { row + 1 } }
end

---@type table<string, fun(params: table): any>
local handlers = {}

function handlers.initialize()
    return {
        capabilities = {
            positionEncoding = "utf-8",
            inlayHintProvider = true,
            codeLensProvider = { resolveProvider = false },
            hoverProvider = true,
            codeActionProvider = true,
        },
        serverInfo = { name = NAME },
    }
end

handlers["textDocument/inlayHint"] = function(params)
    local buf = buf_of(params)
    local hints = {}
    for _, item in ipairs(infos_between(buf, params.range.start.line, params.range["end"].line)) do
        if item.info.instrs > 0 then
            local text = vim.api.nvim_buf_get_lines(buf, item.row, item.row + 1, false)[1] or ""
            table.insert(hints, {
                position = { line = item.row, character = #text },
                label = ("%d instr%s"):format(item.info.instrs, item.info.instrs == 1 and "" or "s"),
                paddingLeft = true,
            })
        end
    end
    return hints
end

handlers["textDocument/codeLens"] = function(params)
    local lenses = {}
    for _, item in ipairs(infos_between(buf_of(params), 0, -1)) do
        local fn = item.info.fn
        if fn then
            local command = open_command(item.row)
            command.title = ("%d instructions"):format(fn.instrs)
            table.insert(lenses, {
                range = { start = { line = item.row, character = 0 }, ["end"] = { line = item.row, character = 0 } },
                command = command,
            })
        end
    end
    return lenses
end

handlers["textDocument/hover"] = function(params)
    local row = params.position.line
    local item = infos_between(buf_of(params), row, row)[1]
    if not item or #item.info.asm == 0 then
        return nil
    end
    local lines = vim.list_slice(item.info.asm, 1, MAX_HOVER_LINES)
    if #item.info.asm > MAX_HOVER_LINES then
        table.insert(lines, ("… %d more"):format(#item.info.asm - MAX_HOVER_LINES))
    end
    return { contents = { kind = "markdown", value = "```asm\n" .. table.concat(lines, "\n") .. "\n```" } }
end

handlers["textDocument/codeAction"] = function(params)
    local row = params.range.start.line
    local item = infos_between(buf_of(params), row, row)[1]
    if not item then
        return {}
    end
    local command = open_command(row)
    return { { title = command.title, command = command } }
end

local function server(disp)
    dispatchers = disp
    local closing, request_id = false, 0
    return {
        request = function(method, params, callback)
            local handler = handlers[method]
            callback(nil, handler and handler(params) or nil)
            request_id = request_id + 1
            return true, request_id
        end,
        notify = function(method)
            if method == "exit" then
                disp.on_exit(0, 15)
            end
            return false
        end,
        is_closing = function()
            return closing
        end,
        terminate = function()
            closing = true
        end,
    }
end

local function attach(buf)
    client_id = vim.lsp.start({
        name = NAME,
        cmd = server,
        root_dir = vim.uv.cwd(),
        on_exit = function()
            client_id, dispatchers = nil, nil
        end,
    }, {
        bufnr = buf,
        reuse_client = function(client)
            return client.name == NAME
        end,
    })
    if client_id then
        vim.diagnostic.config(
            { virtual_lines = false, virtual_text = true },
            vim.lsp.diagnostic.get_namespace(client_id)
        )
        vim.lsp.inlay_hint.enable(true, { bufnr = buf })
        vim.lsp.codelens.enable(true, { bufnr = buf })
    end
    return client_id
end

local function progress(kind, message)
    if dispatchers then
        dispatchers.notification("$/progress", {
            token = NAME,
            value = { kind = kind, title = NAME, message = message },
        })
    end
end

local function publish(buf, remarks)
    if not dispatchers then
        return
    end
    local diagnostics = vim.tbl_map(function(remark)
        local position = { line = remark.lnum, character = remark.col }
        return {
            range = { start = position, ["end"] = position },
            severity = LSP_SEVERITY[remark.severity] or 3,
            message = remark.message,
            source = remark.source,
        }
    end, remarks)
    dispatchers.notification("textDocument/publishDiagnostics", {
        uri = vim.uri_from_bufnr(buf),
        diagnostics = diagnostics,
    })
end

local function refresh()
    if dispatchers then
        dispatchers.server_request("workspace/inlayHint/refresh", nil)
        dispatchers.server_request("workspace/codeLens/refresh", nil)
    end
end

local function definition_name(node, buf)
    local declarator = node:field("declarator")[1]
    while declarator and declarator:field("declarator")[1] do
        declarator = declarator:field("declarator")[1]
    end
    if declarator then
        return (vim.treesitter.get_node_text(declarator, buf):gsub("%b<>", "")):match("([%w_~]+)$")
    end
end

-- Line tables rarely include the definition line. Matching the name skips
-- same-file callees inlined into the function.
---@param fn asm.Function
local function definition_line(buf, fn)
    local ok, parser = pcall(vim.treesitter.get_parser, buf)
    if not ok or not parser then
        return fn.line
    end
    local root = parser:parse()[1]:root()
    local symbol = fn.name:gsub("%b<>", "")
    local base = symbol:match("([%w_~]+)%s*%(") or symbol:match("^_?([%w_]+)$")
    for _, line in ipairs(vim.list_extend({ fn.line }, fn.lines)) do
        local text = vim.api.nvim_buf_get_lines(buf, line - 1, line, false)[1] or ""
        local col = (text:find("%S") or 1) - 1
        local node = root:named_descendant_for_range(line - 1, col, line - 1, col)
        while node and node:type() ~= "function_definition" do
            node = node:parent()
        end
        if node and (not base or definition_name(node, buf) == base) then
            return node:start() + 1
        end
    end
    return fn.line
end

---@param analysis asm.Analysis
local function store(buf, fargs, analysis)
    vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
    local line_count = vim.api.nvim_buf_line_count(buf)
    local by_line = {}
    local function info_at(line)
        if line > line_count then
            return nil
        end
        by_line[line] = by_line[line] or { instrs = 0, asm = {} }
        return by_line[line]
    end
    for line, asm_lines in pairs(analysis.src_to_asm) do
        local info = info_at(line)
        if info then
            info.instrs = analysis.instrs[line] or 0
            info.asm = vim.tbl_map(function(i)
                return vim.trim(analysis.lines[i])
            end, asm_lines)
        end
    end
    for _, fn in ipairs(analysis.functions) do
        local info = info_at(definition_line(buf, fn))
        if info then
            info.fn = info.fn or fn
        end
    end
    local result = { fargs = fargs, by_mark = {} }
    for line, info in pairs(by_line) do
        local mark = vim.api.nvim_buf_set_extmark(buf, ns, line - 1, 0, { invalidate = true })
        result.by_mark[mark] = info
    end
    results[buf] = result
end

function M.clear(buf)
    buf = buf == 0 and vim.api.nvim_get_current_buf() or buf
    generations[buf] = (generations[buf] or 0) + 1
    results[buf] = nil
    vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
    publish(buf, {})
    refresh()
    if client_id and vim.lsp.buf_is_attached(buf, client_id) then
        vim.lsp.buf_detach_client(buf, client_id)
    end
end

function M.run(buf, fargs)
    buf = buf == 0 and vim.api.nvim_get_current_buf() or buf
    if not attach(buf) then
        return vim.notify("Could not start " .. NAME, vim.log.levels.ERROR)
    end
    generations[buf] = (generations[buf] or 0) + 1
    local generation = generations[buf]
    progress("begin", "resolving…")
    asm.analyze(buf, fargs, function(status)
        progress("report", status)
    end, function(analysis, err)
        if generations[buf] ~= generation or not vim.api.nvim_buf_is_valid(buf) then
            return progress("end")
        end
        if not analysis then
            progress("end", "failed")
            return vim.notify(NAME .. ": " .. (err or ""):sub(1, 2000), vim.log.levels.ERROR)
        end
        store(buf, fargs, analysis)
        publish(buf, analysis.remarks)
        refresh()
        progress("end", ("%d functions, %d remarks"):format(#analysis.functions, #analysis.remarks))
    end)
end

function M.setup()
    vim.lsp.commands[OPEN_COMMAND] = function(command, ctx)
        local win = vim.fn.bufwinid(ctx.bufnr)
        if win == -1 then
            return
        end
        vim.api.nvim_set_current_win(win)
        vim.api.nvim_win_set_cursor(win, { command.arguments[1], 0 })
        local result = results[ctx.bufnr]
        asm.open(result and result.fargs or {}, false)
    end

    vim.api.nvim_create_user_command("AsmHints", function(opts)
        if opts.bang then
            return M.clear(0)
        end
        M.run(0, opts.fargs)
    end, {
        nargs = "*",
        bang = true,
        complete = asm.complete,
        desc = "Show instruction counts, remarks and asm hover in this buffer; ! clears them",
    })

    vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("asm_hints_keymaps", { clear = true }),
        pattern = { "c", "cpp" },
        callback = function(args)
            vim.keymap.set("n", "<leader>ci", "<cmd>AsmHints<cr>", { buffer = args.buf, desc = "Assembly hints" })
            vim.keymap.set(
                "n",
                "<leader>cI",
                "<cmd>AsmHints!<cr>",
                { buffer = args.buf, desc = "Clear assembly hints" }
            )
        end,
    })
end

return M
