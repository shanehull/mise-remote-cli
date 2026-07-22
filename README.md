# mise-remote-cli

A [mise](https://mise.jdx.dev) tool plugin for [`remotecli`](https://github.com/remoteoss/remote-cli) — interact with the Remote.com API to manage your company and employees directly from your terminal.

It installs the official release binaries from
[remoteoss/remote-cli](https://github.com/remoteoss/remote-cli/releases) and puts
`remotecli` on your `PATH`, with sha256 checksum verification.

## Requirements

`remotecli` publishes binaries for these platforms only:

- macOS Apple Silicon (`darwin-arm64`)
- Linux x86_64 (`linux-amd64`)

Installing on any other OS/arch fails fast with a clear message.

## Usage

Install the plugin, then a version of the tool:

```bash
# Register the plugin
mise plugin install remotecli https://github.com/remoteoss/mise-remote-cli

# Install and activate the latest version
mise use -g remotecli@latest

# ...or pin a specific version
mise use -g remotecli@0.1.3

# Verify
remotecli --version
```

List available versions:

```bash
mise ls-remote remotecli
```

## How it works

- **`hooks/available.lua`** – lists versions from the GitHub Releases API
  (`remoteoss/remote-cli`), stripping the leading `v` from each tag.
- **`hooks/pre_install.lua`** – resolves the platform, builds the release asset
  URL (`remotecli-<os>-<arch>`), and looks up the matching sha256 from the
  release's `SHA256SUMS` file for verification.
- **`hooks/post_install.lua`** – moves the downloaded binary to `bin/remotecli`
  and makes it executable.
- **`hooks/env_keys.lua`** – adds the install `bin/` directory to `PATH`.

## Development

This repo uses [`hk`](https://hk.jdx.dev) for linting and pre-commit hooks. The
dev tools (`lua`, `stylua`, `lua-language-server`, `actionlint`, `pkl`, `hk`) are
declared in `mise.toml`.

```bash
# Install dev tools
mise install

# Link this checkout as the "remotecli" plugin for local testing
mise plugin link --force remotecli .

# Run the end-to-end test (installs remotecli and checks --version)
mise run test

# Lint (stylua + lua-language-server + actionlint via hk)
mise run lint
mise run lint-fix   # auto-fix

# Everything CI runs
mise run ci
```

> `hk` requires the checkout to be a git repository. Run `git init` first if you
> cloned the files without git history.

Enable debug output while installing:

```bash
MISE_DEBUG=1 mise install remotecli@latest
```

## Files

- `metadata.lua` – plugin metadata (name, version, author, update URL)
- `hooks/available.lua` – available versions from upstream
- `hooks/pre_install.lua` – download URL + checksum resolution
- `hooks/post_install.lua` – install the binary into `bin/`
- `hooks/env_keys.lua` – environment variables to export (`PATH`)
- `mise.toml` – dev tools and tasks
- `mise-tasks/test` – install-and-run smoke test
- `hk.pkl`, `stylua.toml`, `.luarc.json` – lint/format configuration
- `.github/workflows/ci.yml` – CI pipeline (Linux + macOS)

## License

MIT
