--- Returns a list of available versions for the tool
--- Documentation: https://mise.jdx.dev/tool-plugin-development.html#available-hook
--- @param ctx {args: string[]} Context (args = user arguments)
--- @return table[] List of available versions
function PLUGIN:Available(ctx)
    local http = require("http")
    local json = require("json")

    -- remotecli publishes GitHub releases tagged vX.Y.Z.
    -- mise automatically handles GitHub authentication - no manual token setup needed.
    local resp, err = http.get({
        url = "https://api.github.com/repos/remoteoss/remote-cli/releases",
    })

    if err ~= nil then
        error("Failed to fetch versions: " .. err)
    end
    if resp.status_code ~= 200 then
        error("GitHub API returned status " .. resp.status_code .. ": " .. resp.body)
    end

    local releases = json.decode(resp.body)
    local result = {}

    for _, release in ipairs(releases) do
        if not release.draft then
            -- Strip the leading 'v' so versions read as 0.1.3, not v0.1.3.
            local version = release.tag_name:gsub("^v", "")

            table.insert(result, {
                version = version,
                note = release.prerelease and "pre-release" or nil,
            })
        end
    end

    return result
end
