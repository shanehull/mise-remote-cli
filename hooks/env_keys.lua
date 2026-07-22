--- Configures environment variables for the installed tool
--- Documentation: https://mise.jdx.dev/tool-plugin-development.html#envkeys-hook
--- @param ctx {path: string, runtimeVersion: string, sdkInfo: table} Context
--- @return table[] List of environment variable definitions
function PLUGIN:EnvKeys(ctx)
    local mainPath = ctx.path

    -- Add the bin directory to PATH so "remotecli" resolves on the shell.
    return {
        {
            key = "PATH",
            value = mainPath .. "/bin",
        },
    }
end
