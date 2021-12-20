local utils  = {}
local api    = vim.api
local fn     = vim.fn
local gopath = nil

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

return utils
