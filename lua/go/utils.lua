local utils     = {}
local uv        = vim.loop
local api       = vim.api
local fn        = vim.fn
local o         = vim.o
local v         = vim.v
local gopath    = nil
local env_cache = {}

function utils.Warn(msg)
    api.nvim_echo({ { "WRN: " .. msg, "WarningMsg" } }, true, {})
end

function utils.Error(msg)
    api.nvim_echo({ { "ERR: " .. msg, "ErrorMsg" } }, true, {})
end

function utils.Info(msg)
    api.nvim_echo({ { "Info: " .. msg } }, true, {})
end

function utils.Gopath()
    if gopath == nil then
       gopath = os.getenv('GOPATH')
    end
    return gopath
end

function utils.IsWin()
    return fn.has('win32')
end

function utils.CheckBinPath(bin)
    local go_bin_path = fn.join({utils.Gopath(), "bin", bin}, '/')
    if not uv.fs_stat(go_bin_path) then
        return ""
    end
    return go_bin_path
end

function utils.GetLines()
    local buf = fn.getline(1, '$')
    if o.encoding ~= 'utf-8' then
        buf = fn.map(buf, 'iconv(v:val, &encoding, "utf-8")')
    end
    if o.fileformat == 'dos' then
        buf = fn.map(buf, 'v:val."\r"')
    end
    return buf
end

function utils.LineEnding()
    if o.fileformat == 'dos' then
        return "\r\n"
    elseif o.fileformat == 'mac' then
        return "\r"
    end
    return "\n"
end

function utils.Offset(line, col)
    if o.encoding ~= 'utf-8' then
        local sep = utils.LineEnding()
        local buf = line == 1 and '' or (fn.join(fn.getline(1, line - 1), sep) .. sep)
        buf = buf .. (col == 1 and '' or string.sub(fn.getline('.'), 0, col - 3))
        return fn.len(fn.iconv(buf, o.encoding, 'utf-8'))
    end
    return fn.line2byte(line) + (col-2)
end

function utils.OffsetCursor()
    return utils.Offset(fn.line('.'), fn.col('.'))
end

function utils.StringSplit(str, p)
    local ret = {}
    _ = string.gsub(str, '[^'..p..']+', function(w) table.insert(ret, w) end)
    return ret
end

function utils.Exec(cmd, ...)
    if #cmd == 0 then
       utils.Error("utils.Exec() called with empty cmd")
       return "", 1
    end
    if #{...} ~= 0 then
        table.insert(cmd, ...)
    end
    return fn.system(cmd), v.shell_error
end

function utils.Env(key)
    if fn.has_key(env_cache, key) then
        return env_cache[key]
    end
    local ret = ""
    if fn.executable('go') then
       ret = fn.system({'go', 'env', key})
       if v.shell_error ~= 0 then
           utils.Error(ret)
           return ""
       end
    else
        ret = fn.eval("$"..key)
    end
    env_cache[key] = ret
    return ret
end

return utils
