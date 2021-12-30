local utils = require "go.utils"
local nvim_go = {}

_NVIM_GO_CFG_ = {
    goaddtags = {
        transform = false,
        skip_unexported = false,
    },
}

function nvim_go.setup(cfg)
    if utils.IsWin() ~= 0 then
        utils.Error("sorry, windows platform is not supported at the moment")
        return
    end
    if cfg == nil then
        cfg = {}
    end
    _NVIM_GO_CFG_ = vim.tbl_extend("force", _NVIM_GO_CFG_, cfg)

    vim.api.nvim_command [[ command! -nargs=* -complete=custom,v:lua.package.loaded.go.tools_complete GoInstallBinaries lua require("go.install").install_all(0) ]]
    vim.api.nvim_command [[ command! -nargs=* -complete=custom,v:lua.package.loaded.go.tools_complete GoUpdateBinaries lua require("go.install").install_all(1) ]]
    vim.api.nvim_command [[ command! -nargs=? -complete=dir GoPath lua require('go.gopath').GoPath({<f-args>}) ]]
    vim.api.nvim_command [[ command! -nargs=* -range GoAddTags lua require("go.gomodifytags").add(<line1>, <line2>, <count>, {<f-args>}) ]]
    vim.api.nvim_command [[ command! -nargs=* -range GoRemoveTags lua require("go.gomodifytags").remove(<line1>, <line2>, <count>, {<f-args>}) ]]

    --vim.api.nvim_command [[ command! -nargs=* -range GoRemoveTags lua require("go.gomodifytags").remove(<line1>, <line2>, <count>, {<f-args>}) ]]
    --vim.api.nvim_command [[ command! -nargs=* -range GoRemoveTags lua require("go.gomodifytags").remove(<line1>, <line2>, <count>, {<f-args>}) ]]
    --vim.api.nvim_command [[ command! -nargs=* -range GoRemoveTags lua require("go.gomodifytags").remove(<line1>, <line2>, <count>, {<f-args>}) ]]
end

nvim_go.tools_complete = function(arglead, cmdline, cursorpos)
    local gotools = require("go-tools.install").tools
    table.sort(gotools)
    return table.concat(gotools, "\n")
end

return nvim_go
