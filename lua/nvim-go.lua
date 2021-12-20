local utils = require "utils.utils"
local nvim_go = {}
local cmd = vim.cmd

function nvim_go.setup(cfg)
    if utils.IsWin() ~= 0 then
        utils.Error("sorry, windows platform is not supported at the moment")
        return
    end

    cmd [[ command! -nargs=* -complete=custom,v:lua.package.loaded.go.tools_complete GoInstallBinaries lua require("go-tools.install").install_all(0) ]]
    cmd [[ command! -nargs=* -complete=custom,v:lua.package.loaded.go.tools_complete GoUpdateBinaries lua require("go-tools.install").install_all(1) ]]
end

nvim_go.tools_complete = function(arglead, cmdline, cursorpos)
    local gotools = require("go-tools.install").tools
    table.sort(gotools)
    return table.concat(gotools, "\n")
end

return nvim_go
