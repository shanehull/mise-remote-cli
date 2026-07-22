--- Returns download information for a specific version
--- Documentation: https://mise.jdx.dev/tool-plugin-development.html#preinstall-hook

--- Maps the current OS/arch to a published remotecli asset suffix.
--- remotecli publishes darwin-arm64 and linux-amd64 only.
--- @return string
local function get_platform()
    local os_name = RUNTIME.osType:lower()
    local arch = RUNTIME.archType:lower()

    local supported = {
        ["darwin"] = { ["arm64"] = "darwin-arm64" },
        ["linux"] = { ["amd64"] = "linux-amd64" },
    }

    local arch_map = supported[os_name]
    local platform = arch_map and arch_map[arch]
    if not platform then
        error(
            "no published remotecli binary for " .. os_name .. "-" .. arch .. " (published: darwin-arm64, linux-amd64)"
        )
    end

    return platform
end

--- Fetches the sha256 checksum for an asset from the release's SHA256SUMS file.
--- @param http table The http module
--- @param base string Release download base URL
--- @param asset string Asset filename to look up
--- @return string|nil sha256 checksum, or nil if it could not be determined
local function fetch_checksum(http, base, asset)
    local resp, err = http.get({ url = base .. "/SHA256SUMS" })
    if err ~= nil or resp.status_code ~= 200 then
        -- Checksum is best-effort; installation can still proceed without it.
        return nil
    end

    -- Each line is "<sha256>  <asset-name>".
    for line in resp.body:gmatch("[^\r\n]+") do
        local sum, name = line:match("^(%x+)%s+(%S+)$")
        if name == asset then
            return sum
        end
    end

    return nil
end

--- @param ctx {version: string, runtimeVersion: string} Context
--- @return table Version and download information
function PLUGIN:PreInstall(ctx)
    local version = ctx.version
    local http = require("http")

    local asset = "remotecli-" .. get_platform()
    local base = "https://github.com/remoteoss/remote-cli/releases/download/v" .. version

    return {
        version = version,
        url = base .. "/" .. asset,
        sha256 = fetch_checksum(http, base, asset),
        note = "Downloading remotecli " .. version,
    }
end
