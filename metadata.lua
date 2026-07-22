-- metadata.lua
-- Plugin metadata and configuration
-- Documentation: https://mise.jdx.dev/tool-plugin-development.html#metadata-lua

PLUGIN = { -- luacheck: ignore
    -- Required: Tool name (lowercase, no spaces)
    name = "remotecli",

    -- Required: Plugin version (not the tool version)
    version = "1.0.0",

    -- Required: Brief description of the tool
    description = "Remote.com API CLI (remotecli)",

    -- Required: Plugin author/maintainer
    author = "remoteoss",

    -- Optional: Repository URL for plugin updates
    updateUrl = "https://github.com/remoteoss/mise-remote-cli",

    -- Optional: Minimum mise runtime version required
    minRuntimeVersion = "0.2.0",
}
