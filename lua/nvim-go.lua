local utils   = require "go.utils"
local nvim_go = {}
local api     = vim.api

_NVIM_GO_CFG_ = {
    goaddtags = {
        transform = false,
        skip_unexported = false,
    },
    gotests = {
        template_dir = '',
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

    api.nvim_command [[ command! -nargs=* GoInstallBinaries lua require('go.install').install_all(0) ]]
    api.nvim_command [[ command! -nargs=* GoUpdateBinaries lua require('go.install').install_all(1) ]]
    api.nvim_command [[ command! -nargs=? GoPath lua require('go.gopath').GoPath({<f-args>}) ]]
    api.nvim_command [[ command! -nargs=* -range GoAddTags lua require('go.gomodifytags').add(<line1>, <line2>, <count>, {<f-args>}) ]]
    api.nvim_command [[ command! -nargs=* -range GoRemoveTags lua require('go.gomodifytags').remove(<line1>, <line2>, <count>, {<f-args>}) ]]
    api.nvim_command [[ command! -nargs=0 GoFillStruct lua require('go.fillstruct').FillStruct() ]]
    api.nvim_command [[ command! -nargs=* -range GoAddTest lua require('go.gotests').AddTest(<line1>, <line2>) ]]
    api.nvim_command [[ command! -nargs=0 GoAddAllTest lua require('go.gotests').AddAllTest() ]]

    --vim.api.nvim_command [[ command! -nargs=* -range GoRemoveTags lua require("go.gomodifytags").remove(<line1>, <line2>, <count>, {<f-args>}) ]]
    --vim.api.nvim_command [[ command! -nargs=* -range GoRemoveTags lua require("go.gomodifytags").remove(<line1>, <line2>, <count>, {<f-args>}) ]]
    --vim.api.nvim_command [[ command! -nargs=* -range GoRemoveTags lua require("go.gomodifytags").remove(<line1>, <line2>, <count>, {<f-args>}) ]]
end

return nvim_go
