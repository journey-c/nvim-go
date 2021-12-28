local install = {}
local utils   = require("go.utils")
local fn      = vim.fn
local uv      = vim.loop
local tools   = {}

local packages = {
      asmfmt        = 'github.com/klauspost/asmfmt/cmd/asmfmt@latest',
      dlv           = 'github.com/go-delve/delve/cmd/dlv@latest',
      errcheck      = 'github.com/kisielk/errcheck@latest',
      fillstruct    = 'github.com/davidrjenni/reftools/cmd/fillstruct@master',
      godef         = 'github.com/rogpeppe/godef@latest',
      goimports     = 'golang.org/x/tools/cmd/goimports@master',
      golint        = 'golang.org/x/lint/golint@master',
      revive        = 'github.com/mgechev/revive@latest',
      golangci_lint = 'github.com/golangci/golangci-lint/cmd/golangci-lint@latest',
      staticcheck   = 'honnef.co/go/tools/cmd/staticcheck@latest',
      gomodifytags  = 'github.com/fatih/gomodifytags@latest',
      gorename      = 'golang.org/x/tools/cmd/gorename@master',
      gotags        = 'github.com/jstemmer/gotags@master',
      guru          = 'golang.org/x/tools/cmd/guru@master',
      impl          = 'github.com/josharian/impl@master',
      keyify        = 'honnef.co/go/tools/cmd/keyify@master',
      motion        = 'github.com/fatih/motion@latest',
      iferr         = 'github.com/koron/iferr@master',
}

for pkg, _ in pairs(packages) do
    table.insert(tools, pkg)
end

local function checkBinaries()
    if fn.executable('go') ~= 1 then
        utils.Error("go executable not found.")
        return -1
    end
    if fn.executable('git') ~= 1 then
        utils.Error("git executable not found.")
        return -1
    end
    return 0
end

function install.install_all(updateBinaries)
    if (checkBinaries() ~= 0) then
        return
    end
    if utils.Gopath() == "" then
        utils.Error("'$GOPATH is not set and `go env GOPATH` returns empty'")
        return
    end

    local go_bin_path = fn.join({utils.Gopath(), "bin"}, '/')

    local install_cmd = { "go", "install", "-v" }

    local msg_prefix = nil
    if updateBinaries == 1 then
        msg_prefix = "ReInstall "
    else
        msg_prefix = "Install "
    end

    for k, v in pairs(packages) do
        if not uv.fs_stat(fn.join({go_bin_path, fn.tr(k, '_', '-')}, '/')) or updateBinaries == 1 then
            table.insert(install_cmd, v)
            fn.jobstart(install_cmd, {
                on_exit = function(_, data, _)
                    if data == 0 then
                        local msg = msg_prefix .. k .. " finished to folder " .. go_bin_path
                        print(msg)
                    end
                end,
                on_stderr = function(_, data, _)
                    local msg = nil
                    if #data > 1 then
                        msg = msg_prefix .. k .. " failed " .. vim.inspect(data)
                        print(msg)
                    end
                end,
            })
            table.remove(install_cmd)
       end
    end
end

return install
