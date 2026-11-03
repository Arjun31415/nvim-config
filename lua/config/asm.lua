local M = {}

local ns = vim.api.nvim_create_namespace("asm_view")
local remarks_ns = vim.api.nvim_create_namespace("asm_remarks")

local FILETYPES = { "c", "cpp" }
local MAX_ERROR_LINES = 200

local DROP_FLAG = { ["-c"] = true, ["-S"] = true, ["-E"] = true, ["-MD"] = true, ["-MMD"] = true, ["-MP"] = true }
local DROP_FLAG_WITH_VALUE =
    { ["-o"] = true, ["-MF"] = true, ["-MT"] = true, ["-MQ"] = true, ["--serialize-diagnostics"] = true }

local DATA_DIRECTIVES = {
    ascii = true,
    asciz = true,
    string = true,
    byte = true,
    short = true,
    hword = true,
    word = true,
    long = true,
    int = true,
    quad = true,
    xword = true,
    octa = true,
    zero = true,
    float = true,
    double = true,
}
local SKIPPED_SECTIONS = { "debug", "DWARF", "eh_frame", "llvm_addrsig", "note", "comment", "compact_unwind", "__LD" }

local DEFAULT_FLAGS = {
    c = { "-std=c17", "-O2" },
    cpp = { "-std=c++20", "-O2" },
}

local CLANG_REMARK_FLAGS = {
    "-Rpass=loop-vectorize",
    "-Rpass-missed=loop-vectorize",
    "-Rpass-analysis=loop-vectorize",
    "-Rpass-missed=inline",
}
local GCC_REMARK_FLAGS = { "-fopt-info-vec-optimized-missed" }

local BAZEL_ROOT_MARKERS = { "MODULE.bazel", "WORKSPACE.bazel", "WORKSPACE", "REPO.bazel" }
local BUILD_FILES = { "BUILD.bazel", "BUILD" }
local BAZEL_QUIET = { "--color=no", "--curses=no", "--noshow_progress" }
local NO_CONFIG = "(no --config)"

local is_darwin = vim.fn.has("mac") == 1

---@class asm.Entry
---@field directory string
---@field file_real string
---@field args string[] compiler invocation without output/dependency flags
---@field label? string winbar summary when not from compile_commands.json
---@field env? table<string, string>
---@field rel_path? string workspace-relative, for prefix-mapped `.file` paths

---@class asm.State
---@field src_buf integer
---@field asm_buf integer
---@field win? integer
---@field entry? asm.Entry
---@field extra string[]
---@field job? vim.SystemObj
---@field asm_to_src table<integer, integer>
---@field src_to_asm table<integer, integer[]>

---@type table<string, { mtime: integer, entries: table[] }>
local db_cache = {}
---@type table<string, boolean>
local clang_by_compiler = {}
---@type table<integer, asm.State>
local states = {}
---@type table<string, string[]> bazel flags per workspace, kept for the session
local bazel_flags = {}
---@type table<string, string>
local execroots = {}

local function realpath(path)
    return vim.uv.fs_realpath(path) or vim.fs.normalize(path)
end

local function absolute(dir, path)
    if path:sub(1, 1) == "/" then
        return path
    end
    return vim.fs.joinpath(dir, path)
end

local function find_compile_db(path)
    for dir in vim.fs.parents(path) do
        for _, candidate in ipairs({ "compile_commands.json", "build/compile_commands.json" }) do
            local db = vim.fs.joinpath(dir, candidate)
            if vim.uv.fs_stat(db) then
                return db
            end
        end
    end
end

local function load_db(db_path)
    local stat = assert(vim.uv.fs_stat(db_path))
    local cached = db_cache[db_path]
    if cached and cached.mtime == stat.mtime.sec then
        return cached.entries
    end
    local file = assert(io.open(db_path, "r"))
    local entries = vim.json.decode(file:read("*a"))
    file:close()
    db_cache[db_path] = { mtime = stat.mtime.sec, entries = entries }
    return entries
end

local function shell_split(command)
    local args, current, quote, escaped, has_token = {}, {}, nil, false, false
    for char in command:gmatch(".") do
        if escaped then
            table.insert(current, char)
            escaped, has_token = false, true
        elseif char == "\\" and quote ~= "'" then
            escaped = true
        elseif quote then
            if char == quote then
                quote = nil
            else
                table.insert(current, char)
            end
        elseif char == "'" or char == '"' then
            quote, has_token = char, true
        elseif char:match("%s") then
            if has_token then
                table.insert(args, table.concat(current))
                current, has_token = {}, false
            end
        else
            table.insert(current, char)
            has_token = true
        end
    end
    if has_token then
        table.insert(args, table.concat(current))
    end
    return args
end

local function strip_output_flags(raw_args)
    local args, skip_next = {}, false
    for _, arg in ipairs(raw_args) do
        if skip_next then
            skip_next = false
        elseif DROP_FLAG_WITH_VALUE[arg] then
            skip_next = true
        elseif not DROP_FLAG[arg] and not arg:match("^%-o.") then
            table.insert(args, arg)
        end
    end
    return args
end

local function read_compile_flags(src_path)
    local flags_path = vim.fs.find("compile_flags.txt", { path = vim.fs.dirname(src_path), upward = true })[1]
    if not flags_path then
        return nil
    end
    local flags = {}
    for line in io.lines(flags_path) do
        line = vim.trim(line)
        if line ~= "" then
            table.insert(flags, line)
        end
    end
    return flags, flags_path
end

---@return asm.Entry
local function standalone_entry(src_path, filetype)
    local target = realpath(src_path)
    local compiler = filetype == "c" and (vim.env.CC or "cc") or (vim.env.CXX or "c++")
    local flags, flags_path = read_compile_flags(src_path)
    local label
    if flags then
        label = ("%s (%s)"):format(compiler, vim.fn.fnamemodify(flags_path, ":~:."))
    else
        flags = DEFAULT_FLAGS[filetype] or DEFAULT_FLAGS.cpp
        label = compiler .. " " .. table.concat(flags, " ")
    end
    local args = vim.list_extend({ compiler }, strip_output_flags(flags))
    table.insert(args, target)
    return { directory = vim.fs.dirname(target), file_real = target, args = args, label = label }
end

---@return asm.Entry?, string? error
local function resolve_entry(src_path, filetype)
    local db_path = find_compile_db(src_path)
    if not db_path then
        return standalone_entry(src_path, filetype)
    end
    local target = realpath(src_path)
    local name = vim.fs.basename(target)
    for _, entry in ipairs(load_db(db_path)) do
        if vim.fs.basename(entry.file) == name and realpath(absolute(entry.directory, entry.file)) == target then
            return {
                directory = entry.directory,
                file_real = target,
                args = strip_output_flags(entry.arguments or shell_split(entry.command)),
            }
        end
    end
    return nil,
        ("No compile command for %s in %s (headers have none; use a .cpp that includes it)"):format(
            vim.fn.fnamemodify(src_path, ":~:."),
            vim.fn.fnamemodify(db_path, ":~:.")
        )
end

-- Checks the type so a `build/` or `workspace/` directory on a case-insensitive
-- filesystem doesn't count as a BUILD or WORKSPACE file.
local function find_upward(path, names, stop)
    for dir in vim.fs.parents(path) do
        for _, name in ipairs(names) do
            local stat = vim.uv.fs_stat(vim.fs.joinpath(dir, name))
            if stat and stat.type == "file" then
                return dir
            end
        end
        if dir == stop then
            return nil
        end
    end
end

local function bazelrc_configs(root)
    local names, seen = {}, {}
    local function read(path)
        if seen[path] then
            return
        end
        seen[path] = true
        local file = io.open(path, "r")
        if not file then
            return
        end
        for line in file:lines() do
            local import = line:match("^%s*try%-import%s+(%S+)") or line:match("^%s*import%s+(%S+)")
            if import then
                read((import:gsub("%%workspace%%", root)))
            else
                local command, name = line:match("^%s*(%a+):([%w_.%-]+)")
                if (command == "build" or command == "common") and not vim.list_contains(names, name) then
                    table.insert(names, name)
                end
            end
        end
        file:close()
    end
    read(vim.fs.joinpath(root, ".bazelrc"))
    read(vim.fs.normalize("~/.bazelrc"))
    table.sort(names)
    return names
end

---@param callback fun(stdout?: string, err?: string)
local function run_bazel(root, args, callback)
    local ok, err = pcall(
        vim.system,
        vim.list_extend({ "bazel" }, args),
        { cwd = root, text = true },
        vim.schedule_wrap(function(result)
            if result.code == 0 then
                return callback(result.stdout or "")
            end
            local lines = vim.split(result.stderr or "", "\n", { plain = true })
            callback(nil, table.concat(vim.list_slice(lines, math.max(1, #lines - MAX_ERROR_LINES)), "\n"))
        end)
    )
    if not ok then
        callback(nil, tostring(err))
    end
end

local function java_regex_escape(text)
    return (text:gsub("[%^%$%(%)%.%[%]%*%+%?{}|\\]", "\\%0"))
end

---@return { args: string[], env: table<string, string>, label: string }?
local function pick_compile_action(aquery_json, rel_path)
    local ok, result = pcall(vim.json.decode, aquery_json)
    if not ok or type(result) ~= "table" then
        return nil
    end
    local labels = {}
    for _, target in ipairs(result.targets or {}) do
        labels[target.id] = target.label
    end
    for _, action in ipairs(result.actions or {}) do
        if vim.list_contains(action.arguments or {}, rel_path) then
            local env = {}
            for _, var in ipairs(action.environmentVariables or {}) do
                env[var.key] = var.value
            end
            return { args = action.arguments, env = env, label = labels[action.targetId] }
        end
    end
end

-- Only the target's headers are built; the file itself is compiled directly.
---@param on_status fun(status: string)
---@param callback fun(entry?: asm.Entry, err?: string)
local function bazel_entry(root, file, flags, on_status, callback)
    local rel_path = vim.fs.relpath(root, file)
    local pkg_dir = find_upward(file, BUILD_FILES, root)
    if not rel_path or not pkg_dir then
        return callback(nil, ("No BUILD file for %s under %s"):format(file, root))
    end
    local pkg = vim.fs.relpath(root, pkg_dir)
    pkg = pkg == "." and "" or pkg
    local query = ('mnemonic("CppCompile", inputs("%s", //%s:all))'):format(java_regex_escape(rel_path), pkg)

    local function finish(action)
        local entry = {
            directory = execroots[root],
            file_real = file,
            rel_path = rel_path,
            env = action.env,
            args = strip_output_flags(action.args),
            label = table.concat(vim.list_extend({ "bazel" }, flags), " "),
        }
        callback(entry)
    end

    on_status("bazel aquery…")
    run_bazel(
        root,
        vim.list_extend({ "aquery", query, "--output=jsonproto" }, vim.list_extend(vim.deepcopy(flags), BAZEL_QUIET)),
        function(stdout, err)
            if not stdout then
                return callback(nil, err)
            end
            local action = pick_compile_action(stdout, rel_path)
            if not action then
                return callback(
                    nil,
                    ("No compile action for %s in //%s (headers have none; use a .cc that includes it)"):format(
                        rel_path,
                        pkg
                    )
                )
            end
            on_status(("bazel build %s (headers)…"):format(action.label))
            local build = vim.list_extend({ "build", "--output_groups=compilation_prerequisites_INTERNAL_" }, flags)
            run_bazel(
                root,
                vim.list_extend(vim.list_extend(build, BAZEL_QUIET), { "--", action.label }),
                function(built, build_err)
                    if not built then
                        return callback(nil, build_err)
                    end
                    if execroots[root] then
                        return finish(action)
                    end
                    run_bazel(root, { "info", "execution_root" }, function(info, info_err)
                        if not info then
                            return callback(nil, info_err)
                        end
                        execroots[root] = vim.trim(info)
                        finish(action)
                    end)
                end
            )
        end
    )
end

-- Arguments starting with `--` go to bazel, the rest to the compiler.
---@param callback fun(flags: string[], extra: string[])
local function choose_bazel_flags(root, fargs, reselect, callback)
    local flags, extra = {}, {}
    for _, arg in ipairs(fargs) do
        table.insert(vim.startswith(arg, "--") and flags or extra, arg)
    end
    if #flags > 0 then
        bazel_flags[root] = flags
    end
    if bazel_flags[root] and not reselect then
        return callback(bazel_flags[root], extra)
    end
    local configs = bazelrc_configs(root)
    if #configs == 0 then
        bazel_flags[root] = {}
        return callback({}, extra)
    end
    vim.ui.select(vim.list_extend({ NO_CONFIG }, configs), { prompt = "Bazel config" }, function(choice)
        if not choice then
            return
        end
        bazel_flags[root] = choice == NO_CONFIG and {} or { "--config=" .. choice }
        callback(bazel_flags[root], extra)
    end)
end

---@param on_status fun(status: string) only called for bazel workspaces
---@param callback fun(entry?: asm.Entry, extra?: string[], err?: string)
local function resolve(src_buf, fargs, reselect, on_status, callback)
    local src_path = vim.api.nvim_buf_get_name(src_buf)
    if src_path == "" or not vim.uv.fs_stat(src_path) then
        return callback(nil, nil, "Save the buffer to a file first")
    end
    local file = realpath(src_path)
    local root = find_upward(file, BAZEL_ROOT_MARKERS)
    if not root then
        local entry, err = resolve_entry(src_path, vim.bo[src_buf].filetype)
        return callback(entry, fargs, err)
    end
    choose_bazel_flags(root, fargs, reselect, function(flags, extra)
        bazel_entry(root, file, flags, on_status, function(entry, err)
            callback(entry, extra, err)
        end)
    end)
end

local function is_clang(entry)
    local compiler = entry.args[1]
    local key = entry.directory .. "\0" .. compiler
    if clang_by_compiler[key] == nil then
        local ok, result = pcall(function()
            return vim.system({ compiler, "--version" }, { cwd = entry.directory, text = true }):wait()
        end)
        clang_by_compiler[key] = ok and (result.stdout or ""):find("clang") ~= nil
    end
    return clang_by_compiler[key]
end

local function common_flags(entry)
    -- Line tables give the asm<->source mapping; they don't change codegen.
    return { "-fdiagnostics-color=never", is_clang(entry) and "-gline-tables-only" or "-g1" }
end

local function asm_command(entry, extra)
    local cmd = vim.list_extend(vim.deepcopy(entry.args), { "-S", "-o", "-" })
    vim.list_extend(cmd, common_flags(entry))
    if vim.uv.os_uname().machine == "x86_64" then
        table.insert(cmd, "-masm=intel")
    end
    return vim.list_extend(cmd, extra)
end

local function remark_flags(entry)
    return is_clang(entry) and CLANG_REMARK_FLAGS or GCC_REMARK_FLAGS
end

local function remarks_command(entry, extra)
    local cmd = vim.list_extend(vim.deepcopy(entry.args), { "-S", "-o", "/dev/null" })
    vim.list_extend(cmd, common_flags(entry))
    vim.list_extend(cmd, remark_flags(entry))
    return vim.list_extend(cmd, extra)
end

local function is_local_label(name)
    if is_darwin then
        return name:match("^[Ll]") ~= nil
    end
    return name:match("^%.L") ~= nil
end

local function in_skipped_section(name)
    for _, pattern in ipairs(SKIPPED_SECTIONS) do
        if name:find(pattern, 1, true) then
            return true
        end
    end
    return false
end

local function format_instruction(trimmed)
    local mnemonic, operands = trimmed:match("^(%S+)%s*(.*)$")
    if operands == "" then
        return "        " .. mnemonic
    end
    return ("        %-8s%s"):format(mnemonic, operands)
end

local function mark_references(text, referenced)
    for token in text:gmatch("[%w_.$]+") do
        referenced[token] = true
    end
end

-- Godbolt's default filters; `.loc` directives map instructions to source lines.
local function parse_asm(text, entry)
    local parser = {
        main_file_ids = {},
        file_realpaths = {},
        skipping_section = false,
        rows = {},
        referenced = {},
    }

    local function on_directive(trimmed)
        local directive, rest = trimmed:match("^%.(%S+)%s*(.*)$")
        if directive == "section" then
            parser.skipping_section = in_skipped_section(rest:match("^[^%s]+") or "")
        elseif directive == "text" or directive == "data" or directive == "bss" then
            parser.skipping_section = false
        elseif directive == "file" then
            -- `.file N "name"` or `.file N "dir" "name" [md5 ...]`
            local id, quoted = rest:match("^(%d+)%s+(.*)$")
            local strings = {}
            for str in (quoted or ""):gmatch('"([^"]*)"') do
                table.insert(strings, str)
            end
            if id and #strings > 0 then
                local dir, name = "", strings[1]
                if #strings > 1 then
                    dir, name = strings[1], strings[2]
                end
                local path = absolute(absolute(entry.directory, dir), name)
                parser.file_realpaths[path] = parser.file_realpaths[path] or realpath(path)
                parser.main_file_ids[id] = parser.file_realpaths[path] == entry.file_real
                    or (entry.rel_path ~= nil and vim.endswith(path, "/" .. entry.rel_path))
            end
        elseif directive == "loc" then
            local id, src_line = rest:match("^(%d+)%s+(%d+)")
            src_line = tonumber(src_line)
            parser.current_src = (parser.main_file_ids[id] and src_line ~= 0) and src_line or nil
            -- The first `.loc` after a function label is its definition line.
            if parser.current_src and parser.open_label then
                parser.open_label.entry_src = parser.current_src
                parser.open_label = nil
            end
        elseif DATA_DIRECTIVES[directive] and not parser.skipping_section then
            mark_references(rest, parser.referenced)
            table.insert(parser.rows, { text = format_instruction(trimmed) })
        end
    end

    local function on_line(line)
        local trimmed = vim.trim(line)
        if trimmed == "" or trimmed:match("^#") or trimmed:match("^//") or trimmed:match("^;") then
            return
        end
        local label = line:match("^([^%s:]+):")
        if not label and trimmed:sub(1, 1) == "." then
            return on_directive(trimmed)
        end
        if parser.skipping_section then
            return
        end
        if label then
            parser.open_label = { text = label .. ":", label = label }
            table.insert(parser.rows, parser.open_label)
        else
            parser.open_label = nil
            mark_references(trimmed:match("^%S+%s+(.*)$") or "", parser.referenced)
            table.insert(parser.rows, { text = format_instruction(trimmed), src = parser.current_src })
        end
    end

    for line in vim.gsplit(text, "\n", { plain = true }) do
        on_line(line)
    end

    local rows, referenced = parser.rows, parser.referenced
    local lines, asm_to_src, src_to_asm, label_to_src = {}, {}, {}, {}
    for _, row in ipairs(rows) do
        if not (row.label and is_local_label(row.label) and not referenced[row.label]) then
            table.insert(lines, row.text)
            label_to_src[#lines] = row.entry_src
            if row.src then
                asm_to_src[#lines] = row.src
                src_to_asm[row.src] = src_to_asm[row.src] or {}
                table.insert(src_to_asm[row.src], #lines)
            end
        end
    end
    return lines, asm_to_src, src_to_asm, label_to_src
end

local function demangle(lines, callback)
    if vim.fn.executable("c++filt") == 0 then
        return callback(lines)
    end
    vim.system({ "c++filt" }, { stdin = table.concat(lines, "\n"), text = true }, function(result)
        local demangled = vim.split(result.stdout or "", "\n", { plain = true })
        if demangled[#demangled] == "" then
            table.remove(demangled)
        end
        vim.schedule(function()
            callback((result.code == 0 and #demangled == #lines) and demangled or lines)
        end)
    end)
end

local function set_lines(buf, lines)
    vim.bo[buf].modifiable = true
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.bo[buf].modifiable = false
end

local function set_winbar(state, status)
    if state.win and vim.api.nvim_win_is_valid(state.win) then
        local flags = #state.extra > 0 and (" " .. table.concat(state.extra, " ")) or ""
        local compiler = state.entry and (state.entry.label or vim.fs.basename(state.entry.args[1])) or "bazel"
        vim.wo[state.win].winbar = ("%%#Comment# %s%s  %s"):format(compiler, flags, status)
    end
end

local function highlight(state, src_line, from_asm)
    vim.api.nvim_buf_clear_namespace(state.src_buf, ns, 0, -1)
    vim.api.nvim_buf_clear_namespace(state.asm_buf, ns, 0, -1)
    local asm_lines = src_line and state.src_to_asm[src_line]
    if not asm_lines then
        return
    end
    for _, asm_line in ipairs(asm_lines) do
        vim.api.nvim_buf_set_extmark(state.asm_buf, ns, asm_line - 1, 0, { line_hl_group = "Visual" })
    end
    if from_asm then
        if src_line <= vim.api.nvim_buf_line_count(state.src_buf) then
            vim.api.nvim_buf_set_extmark(state.src_buf, ns, src_line - 1, 0, { line_hl_group = "Visual" })
        end
    elseif state.win and vim.api.nvim_win_is_valid(state.win) then
        local first = asm_lines[1]
        if first < vim.fn.line("w0", state.win) or first > vim.fn.line("w$", state.win) then
            vim.api.nvim_win_set_cursor(state.win, { first, 0 })
            vim.api.nvim_win_call(state.win, function()
                vim.cmd("normal! zz")
            end)
        end
    end
end

local function highlight_from_source(state)
    local win = vim.fn.bufwinid(state.src_buf)
    if win ~= -1 then
        highlight(state, vim.api.nvim_win_get_cursor(win)[1], false)
    end
end

local function show_failure(state, text, status)
    set_lines(state.asm_buf, vim.list_slice(vim.split(text, "\n", { plain = true }), 1, MAX_ERROR_LINES))
    state.asm_to_src, state.src_to_asm = {}, {}
    set_winbar(state, status)
end

local function compile(state)
    if not state.entry then
        return
    end
    if state.job then
        state.job:kill("sigterm")
    end
    set_winbar(state, "compiling…")
    local job
    local ok, err = pcall(function()
        job = vim.system(
            asm_command(state.entry, state.extra),
            { cwd = state.entry.directory, env = state.entry.env, text = true },
            vim.schedule_wrap(function(result)
                if states[state.src_buf] ~= state or state.job ~= job then
                    return
                end
                state.job = nil
                if result.code ~= 0 then
                    return show_failure(state, result.stderr or "", "compile failed")
                end
                local lines, asm_to_src, src_to_asm = parse_asm(result.stdout, state.entry)
                demangle(lines, function(demangled)
                    if states[state.src_buf] ~= state then
                        return
                    end
                    set_lines(state.asm_buf, demangled)
                    state.asm_to_src, state.src_to_asm = asm_to_src, src_to_asm
                    set_winbar(state, ("%d lines"):format(#demangled))
                    highlight_from_source(state)
                end)
            end)
        )
    end)
    if not ok then
        return show_failure(state, tostring(err), "compile failed")
    end
    state.job = job
end

local function teardown(src_buf)
    local state = states[src_buf]
    if not state then
        return
    end
    states[src_buf] = nil
    if state.job then
        state.job:kill("sigterm")
    end
    pcall(vim.api.nvim_del_augroup_by_name, "asm_view_" .. src_buf)
    if vim.api.nvim_buf_is_valid(src_buf) then
        vim.api.nvim_buf_clear_namespace(src_buf, ns, 0, -1)
    end
    if vim.api.nvim_buf_is_valid(state.asm_buf) then
        vim.api.nvim_buf_delete(state.asm_buf, { force = true })
    end
end

local function create_state(src_buf)
    local asm_buf = vim.api.nvim_create_buf(false, true)
    vim.bo[asm_buf].bufhidden = "wipe"
    vim.bo[asm_buf].filetype = "asm"
    vim.bo[asm_buf].modifiable = false
    vim.api.nvim_buf_set_name(
        asm_buf,
        ("asm://%d/%s"):format(src_buf, vim.fs.basename(vim.api.nvim_buf_get_name(src_buf)))
    )

    ---@type asm.State
    local state = { src_buf = src_buf, asm_buf = asm_buf, extra = {}, asm_to_src = {}, src_to_asm = {} }

    local opts = { buffer = asm_buf, nowait = true }
    vim.keymap.set("n", "q", "<cmd>close<cr>", vim.tbl_extend("force", opts, { desc = "Close assembly view" }))
    vim.keymap.set("n", "r", function()
        compile(state)
    end, vim.tbl_extend("force", opts, { desc = "Recompile" }))
    vim.keymap.set("n", "<cr>", function()
        local src_line = state.asm_to_src[vim.api.nvim_win_get_cursor(0)[1]]
        local src_win = vim.fn.bufwinid(src_buf)
        if src_line and src_win ~= -1 then
            vim.api.nvim_set_current_win(src_win)
            vim.api.nvim_win_set_cursor(src_win, { src_line, 0 })
        end
    end, vim.tbl_extend("force", opts, { desc = "Jump to source line" }))

    local group = vim.api.nvim_create_augroup("asm_view_" .. src_buf, { clear = true })
    vim.api.nvim_create_autocmd("CursorMoved", {
        group = group,
        buffer = asm_buf,
        callback = function()
            highlight(state, state.asm_to_src[vim.api.nvim_win_get_cursor(0)[1]], true)
        end,
    })
    vim.api.nvim_create_autocmd("CursorMoved", {
        group = group,
        buffer = src_buf,
        callback = function()
            highlight(state, vim.api.nvim_win_get_cursor(0)[1], false)
        end,
    })
    vim.api.nvim_create_autocmd("BufWipeout", {
        group = group,
        buffer = asm_buf,
        callback = function()
            vim.schedule(function()
                teardown(src_buf)
            end)
        end,
    })
    vim.api.nvim_create_autocmd({ "BufDelete", "BufWipeout" }, {
        group = group,
        buffer = src_buf,
        callback = function()
            teardown(src_buf)
        end,
    })
    return state
end

local function show(src_buf)
    local state = states[src_buf]
    if not state then
        state = create_state(src_buf)
        states[src_buf] = state
    end
    if
        not (
            state.win
            and vim.api.nvim_win_is_valid(state.win)
            and vim.api.nvim_win_get_buf(state.win) == state.asm_buf
        )
    then
        local src_win = vim.fn.bufwinid(src_buf)
        state.win =
            vim.api.nvim_open_win(state.asm_buf, false, { split = "right", win = src_win ~= -1 and src_win or 0 })
        vim.wo[state.win].wrap = false
        vim.wo[state.win].number = false
        vim.wo[state.win].relativenumber = false
        vim.wo[state.win].signcolumn = "no"
        vim.wo[state.win].list = false
    end
    return state
end

---@param reselect boolean ask for the bazel config again
function M.open(fargs, reselect)
    local src_buf = vim.api.nvim_get_current_buf()
    local state
    resolve(src_buf, fargs, reselect, function(status)
        state = show(src_buf)
        set_winbar(state, status)
    end, function(entry, extra, err)
        if state and states[src_buf] ~= state then
            return
        end
        if not entry then
            if state then
                return show_failure(state, err or "", "failed")
            end
            return vim.notify(err or "", vim.log.levels.WARN)
        end
        state = show(src_buf)
        state.entry, state.extra = entry, extra or {}
        compile(state)
    end)
end

---@return vim.Diagnostic.Set[]
local function parse_remarks(stderr, entry)
    local diagnostics, path_cache = {}, {}
    for line in vim.gsplit(stderr, "\n", { plain = true }) do
        local file, lnum, col, kind, message = line:match("^(.-):(%d+):(%d+): (%a+): (.*)$")
        if file and (kind == "remark" or kind == "optimized" or kind == "missed") then
            path_cache[file] = path_cache[file] or realpath(absolute(entry.directory, file))
            if path_cache[file] == entry.file_real then
                local passed = kind == "optimized" or message:find("[-Rpass=", 1, true) ~= nil
                table.insert(diagnostics, {
                    lnum = tonumber(lnum) - 1,
                    col = tonumber(col) - 1,
                    severity = passed and vim.diagnostic.severity.INFO or vim.diagnostic.severity.WARN,
                    message = (message:gsub("%s*%[%-R[^%]]*%]$", "")),
                    source = "opt-remarks",
                })
            end
        end
    end
    return diagnostics
end

local function demangle_messages(diagnostics, callback)
    local messages = vim.tbl_map(function(diagnostic)
        return diagnostic.message
    end, diagnostics)
    demangle(messages, function(demangled)
        for i, diagnostic in ipairs(diagnostics) do
            diagnostic.message = demangled[i]
        end
        callback()
    end)
end

local function run_remarks(src_buf, entry, extra)
    vim.system(
        remarks_command(entry, extra),
        { cwd = entry.directory, env = entry.env, text = true },
        vim.schedule_wrap(function(result)
            if not vim.api.nvim_buf_is_valid(src_buf) then
                return
            end
            local stderr = result.stderr or ""
            if result.code ~= 0 then
                return vim.notify("Compile failed:\n" .. stderr:sub(1, 2000), vim.log.levels.ERROR)
            end
            local diagnostics = parse_remarks(stderr, entry)
            demangle_messages(diagnostics, function()
                if vim.api.nvim_buf_is_valid(src_buf) then
                    vim.diagnostic.set(remarks_ns, src_buf, diagnostics)
                    vim.notify(("%d optimisation remarks"):format(#diagnostics))
                end
            end)
        end)
    )
end

function M.remarks(fargs)
    local src_buf = vim.api.nvim_get_current_buf()
    resolve(src_buf, fargs, false, vim.notify, function(entry, extra, err)
        if not entry then
            return vim.notify(err or "", vim.log.levels.WARN)
        end
        if vim.api.nvim_buf_is_valid(src_buf) then
            run_remarks(src_buf, entry, extra or {})
        end
    end)
end

local function is_instruction(row)
    return row:match("^%s+[^%s.]") ~= nil
end

---@class asm.Function
---@field name string
---@field line integer definition line if the line table has it, else its first mapped line
---@field lines integer[] source lines its instructions map to
---@field instrs integer

---@class asm.Analysis
---@field lines string[] demangled assembly
---@field src_to_asm table<integer, integer[]>
---@field instrs table<integer, integer> instructions per source line
---@field functions asm.Function[]
---@field remarks vim.Diagnostic.Set[]

local function summarize(raw, lines, asm_to_src, src_to_asm, label_to_src, remarks)
    local functions, current = {}, nil
    for i, row in ipairs(raw) do
        local label = row:match("^(%S+):$")
        if label and not is_local_label(label) then
            current = { name = lines[i]:sub(1, -2), instrs = 0, line = label_to_src[i], lines = {} }
            table.insert(functions, current)
        elseif current and is_instruction(row) then
            current.instrs = current.instrs + 1
            local src_line = asm_to_src[i]
            if src_line and not vim.list_contains(current.lines, src_line) then
                table.insert(current.lines, src_line)
            end
        end
    end
    local instrs = {}
    for src_line, asm_lines in pairs(src_to_asm) do
        instrs[src_line] = #vim.tbl_filter(function(i)
            return is_instruction(raw[i])
        end, asm_lines)
    end
    return {
        lines = lines,
        src_to_asm = src_to_asm,
        instrs = instrs,
        functions = vim.tbl_filter(function(fn)
            fn.line = fn.line or fn.lines[1]
            return fn.line ~= nil
        end, functions),
        remarks = remarks,
    }
end

-- One compile gives the assembly on stdout and the remarks on stderr.
---@param on_status fun(status: string)
---@param callback fun(analysis?: asm.Analysis, err?: string)
function M.analyze(src_buf, fargs, on_status, callback)
    resolve(src_buf, fargs, false, on_status, function(entry, extra, err)
        if not entry then
            return callback(nil, err)
        end
        on_status("compiling…")
        local cmd = vim.list_extend(asm_command(entry, extra or {}), remark_flags(entry))
        local ok, spawn_err = pcall(
            vim.system,
            cmd,
            { cwd = entry.directory, env = entry.env, text = true },
            vim.schedule_wrap(function(result)
                if result.code ~= 0 then
                    return callback(nil, result.stderr or "")
                end
                local raw, asm_to_src, src_to_asm, label_to_src = parse_asm(result.stdout, entry)
                local remarks = parse_remarks(result.stderr or "", entry)
                demangle(raw, function(lines)
                    demangle_messages(remarks, function()
                        callback(summarize(raw, lines, asm_to_src, src_to_asm, label_to_src, remarks))
                    end)
                end)
            end)
        )
        if not ok then
            callback(nil, tostring(spawn_err))
        end
    end)
end

function M.complete(arglead)
    if not vim.startswith(arglead, "--") then
        return {}
    end
    local root = find_upward(realpath(vim.api.nvim_buf_get_name(0)), BAZEL_ROOT_MARKERS)
    if not root then
        return {}
    end
    local candidates = vim.tbl_map(function(name)
        return "--config=" .. name
    end, bazelrc_configs(root))
    return vim.tbl_filter(function(candidate)
        return vim.startswith(candidate, arglead)
    end, candidates)
end

function M.setup()
    vim.diagnostic.config({ virtual_lines = false, virtual_text = true }, remarks_ns)

    vim.api.nvim_create_user_command("Asm", function(opts)
        M.open(opts.fargs, opts.bang)
    end, {
        nargs = "*",
        bang = true,
        complete = M.complete,
        desc = "Show assembly for this file (bazel aquery, compile_commands.json, compile_flags.txt, or defaults); ! picks the bazel config again",
    })

    vim.api.nvim_create_user_command("AsmRemarks", function(opts)
        if opts.bang then
            return vim.diagnostic.reset(remarks_ns, 0)
        end
        M.remarks(opts.fargs)
    end, {
        nargs = "*",
        bang = true,
        complete = M.complete,
        desc = "Show optimisation remarks; ! clears them",
    })

    vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("asm_view_keymaps", { clear = true }),
        pattern = FILETYPES,
        callback = function(args)
            vim.keymap.set("n", "<leader>cg", "<cmd>Asm<cr>", { buffer = args.buf, desc = "Assembly view" })
            vim.keymap.set(
                "n",
                "<leader>cr",
                "<cmd>AsmRemarks<cr>",
                { buffer = args.buf, desc = "Optimisation remarks" }
            )
        end,
    })
end

return M
