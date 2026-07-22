--- Performs additional setup after installation
--- Documentation: https://mise.jdx.dev/tool-plugin-development.html#postinstall-hook
--- @param ctx {rootPath: string, runtimeVersion: string, sdkInfo: table} Context
function PLUGIN:PostInstall(ctx)
    local sdkInfo = ctx.sdkInfo[PLUGIN.name]
    local path = sdkInfo.path

    -- The release asset is a single binary downloaded as-is (e.g.
    -- "remotecli-darwin-arm64"). Move it to bin/remotecli and make it
    -- executable so it can be invoked simply as "remotecli".
    local cmd = string.format(
        [[set -e
cd %q
mkdir -p bin
bin_file=$(find . -maxdepth 1 -type f -name 'remotecli*' | head -n1)
if [ -z "$bin_file" ]; then
    echo "no remotecli binary found in install dir" >&2
    exit 1
fi
mv "$bin_file" bin/remotecli
chmod +x bin/remotecli
]],
        path
    )

    local result = os.execute(cmd)
    if result ~= 0 and result ~= true then
        error("Failed to install remotecli binary")
    end

    -- Verify the installed binary runs.
    local testResult = os.execute(path .. "/bin/remotecli --version > /dev/null 2>&1")
    if testResult ~= 0 and testResult ~= true then
        error("remotecli installation appears to be broken")
    end
end
