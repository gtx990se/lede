module("luci.model.cbi.passwall.api.kcptun", package.seeall)
local api = require "luci.model.cbi.passwall.api.api"
local fs = api.fs
local sys = api.sys
local util = api.util
local i18n = api.i18n

local pre_release_url = "https://api.github.com/repos/xtaci/kcptun/releases?per_page=1"
local release_url = "https://api.github.com/repos/xtaci/kcptun/releases/latest"
local api_url = release_url
local app_path = api.get_kcptun_path() or ""

function check_path()
    if app_path == "" then
        return {
            code = 1,
            error = i18n.translatef("You did not fill in the %s path. Please save and apply then update manually.", "Kcptun")
        }
    end
    return {
        code = 0
    }
end

function to_check(arch)
    local result = check_path()
    if result.code ~= 0 then
        return result
    end

    if not arch or arch == "" then arch = api.auto_get_arch() end

    local file_tree, sub_version = api.get_file_info(arch)

    if file_tree == "" then
        return {
            code = 1,
            error = i18n.translate("Can't determine ARCH, or ARCH not supported.")
        }
    end

    return api.common_to_check(api_url, api.get_kcptun_version(), "linux%-" .. file_tree .. sub_version)
end

function to_download(url, size)
    local result = check_path()
    if result.code ~= 0 then
        return result
    end

    if not url or url == "" then
        return {code = 1, error = i18n.translate("Download url is required.")}
    end

    sys.call("/bin/rm -f /tmp/kcptun_download.*")

    local tmp_file = util.trim(util.exec("mktemp -u -t kcptun_download.XXXXXX"))

    if size then
        local kb1 = api.get_free_space("/tmp")
        if tonumber(size) > tonumber(kb1) then
            return {code = 1, error = i18n.translatef("%s not enough space.", "/tmp")}
        end
    end

    result = api.exec(api.curl, {api._unpack(api.curl_args), "-o", tmp_file, url}, nil, api.command_timeout) == 0

    if not result then
        api.exec("/bin/rm", {"-f", tmp_file})
        return {
            code = 1,
            error = i18n.translatef("File download failed or timed out: %s", url)
        }
    end

    return {code = 0, file = tmp_file}
end

function to_extract(file, subfix)
    local result = check_path()
    if result.code ~= 0 then
        return result
    end

    if not file or file == "" or not fs.access(file) then
        return {code = 1, error = i18n.translate("File path required.")}
    end

    sys.call("/bin/rm -rf /tmp/kcptun_extract.*")

    local new_file_size = api.get_file_space(file)
    local tmp_free_size = api.get_free_space("/tmp")
    if tmp_free_size <= 0 or tmp_free_size <= new_file_size then
        return {code = 1, error = i18n.translatef("%s not enough space.", "/tmp")}
    end

    local tmp_dir = util.trim(util.exec("mktemp -d -t kcptun_extract.XXXXXX"))

    local output = {}
    api.exec("/bin/tar", {"-C", tmp_dir, "-zxvf", file},
             function(chunk) output[#output + 1] = chunk end)
    local files = util.split(table.concat(output))

    api.exec("/bin/rm", {"-f", file})

    local new_file = nil
    for _, f in pairs(files) do
        if f:match("client_linux_%s" % subfix) then
            new_file = tmp_dir .. "/" .. util.trim(f)
            break
        end
    end

    if not new_file then
        for _, f in pairs(files) do
            if f:match("client_") then
                new_file = tmp_dir .. "/" .. util.trim(f)
                break
            end
        end
    end

    if not new_file then
        api.exec("/bin/rm", {"-rf", tmp_dir})
        return {
            code = 1,
            error = i18n.translatef("Can't find client in file: %s", file)
        }
    end

    return {code = 0, file = new_file}
end

function to_move(file)
    local result = check_path()
    if result.code ~= 0 then
        return result
    end

    if not file or file == "" or not fs.access(file) then
        sys.call("/bin/rm -rf /tmp/kcptun_extract.*")
        return {code = 1, error = i18n.translate("Client file is required.")}
    end

    local new_version = api.get_kcptun_version(file)
    if new_version == "" then
        sys.call("/bin/rm -rf /tmp/kcptun_extract.*")
        return {
            code = 1,
            error = i18n.translate("The client file is not suitable for current device.")
        }
    end

    local flag = sys.call('pgrep -af "passwall/.*kcptun" >/dev/null')
    if flag == 0 then
        sys.call("/etc/init.d/passwall stop")
    end

    local old_app_size = 0
    if fs.access(app_path) then
        old_app_size = api.get_file_space(app_path)
    end
    local new_app_size = api.get_file_space(file)
    local final_dir = api.get_final_dir(app_path)
    local final_dir_free_size = api.get_free_space(final_dir)
    if final_dir_free_size > 0 then
        final_dir_free_size = final_dir_free_size + old_app_size
        if new_app_size > final_dir_free_size then
            sys.call("/bin/rm -rf /tmp/kcptun_extract.*")
            return {code = 1, error = i18n.translatef("%s not enough space.", final_dir)}
        end
    end

    result = api.exec("/bin/mv", {"-f", file, app_path}, nil, api.command_timeout) == 0

    sys.call("/bin/rm -rf /tmp/kcptun_extract.*")
    if flag == 0 then
        sys.call("/etc/init.d/passwall restart >/dev/null 2>&1 &")
    end

    if not result or not fs.access(app_path) then
        return {
            code = 1,
            error = i18n.translatef("Can't move new file to path: %s", app_path)
        }
    end

    return {code = 0}
end
