# Homebrew Tap

A collection of macOS applications and command-line tools available through Homebrew.

## Requirements

- macOS
- [Homebrew](https://brew.sh/) installed on your Mac

If Homebrew is not installed yet, run the following command in Terminal:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## Add the tap

```bash
brew tap joynik/tap
```

## Available casks

macOS applications installed through Homebrew Cask.

| Package | Description | Install |
| --- | --- | --- |
| [atoll](https://github.com/Ebullioscopic/Atoll) | Dynamic Island | `brew install --cask joynik/tap/atoll` |
| [cardinal](https://github.com/franciscoxc/cardinal) | Fastest file searching tool for macOS | `brew install --cask joynik/tap/cardinal` |
| [codeburn](https://github.com/getagentseal/codeburn/) | See where your AI spend goes. | `brew install --cask joynik/tap/codeburn` |
| [imgo](https://github.com/meowtec/imgo) | Image optimization app for macOS. | `brew install --cask joynik/tap/imgo` |
| [machstruct](https://github.com/lustech/MachStruct) | Native macOS viewer and editor for JSON, XML, YAML, CSV | `brew install --cask joynik/tap/machstruct` |
| [mackeep](https://github.com/Joynik/mackeep) | Backup and keep your application settings in sync | `brew install --cask joynik/tap/mackeep` |
| [magnitude](https://github.com/magnitudedev/magnitude/) | Run open models as fast as your hardware allows. | `brew install --cask joynik/tap/magnitude` |
| [mtarsier](https://github.com/mcp360/mTarsier) | The Open Source MCP & Skill Manager for Claude, Cursor, VS Code & any AI client | `brew install --cask joynik/tap/mtarsier` |
| [omniroute](https://github.com/diegosouzapw/OmniRoute/) | The Free AI Gateway | `brew install --cask joynik/tap/omniroute` |
| [screentranslate](https://github.com/hcmhcs/screenTranslate) | Translate any text on your Mac screen — capture or select. | `brew install --cask joynik/tap/screentranslate` |
| [solidcraft](https://github.com/tangency-labs/solidcraft/) | Parametric 3D CAD application built in pure Rust. Desktop, web, and automation through MCP. | `brew install --cask joynik/tap/solidcraft` |
| [virustotal](https://github.com/Jerry23011/VirusTotal-macOS/) | An elegant VirusTotal client built with Swift and SwiftUI | `brew install --cask joynik/tap/virustotal` |
| [voicebox](https://github.com/jamiepine/voicebox/) | The open-source AI voice studio. Clone, dictate, create. | `brew install --cask joynik/tap/voicebox` |
| [voicestudio](https://github.com/debpalash/VoiceStudio/) | Open-source voice cloning, voice design, video dubbing, dictation, transcription & audiobook creation in 646 languages. | `brew install --cask joynik/tap/voicestudio` |

## Available formulae

Command-line tools and services installed through Homebrew.

| Package | Description | Install |
| --- | --- | --- |
| [mackeep-cli](https://github.com/Joynik/mackeep) | Backup and keep your application settings in sync | `brew install joynik/tap/mackeep-cli` |
| [osm](https://github.com/Joynik/obsidian-semantic-mcp) | Local MCP server for semantic search in Obsidian vaults | `brew install joynik/tap/osm` |
| [qdrant](https://qdrant.tech) | Vector search engine and database for AI applications | `brew install joynik/tap/qdrant` |
| [solidcraft-cli](https://github.com/tangency-labs/solidcraft) | Headless CLI and MCP server for SolidCraft parametric CAD | `brew install joynik/tap/solidcraft-cli` |

## Installation

Install a cask:

```bash
brew install --cask joynik/tap/<cask>
```

Install a formula:

```bash
brew install joynik/tap/<formula>
```

Replace `<cask>` or `<formula>` with a package name from the tables above.

## Updating

The tap has two bulk workflows:

- **Update All Casks** (`update-all-casks.yml`): daily at 04:00 UTC or manually.
- **Update All Formulae** (`update-all-formulae.yml`): daily at 03:00 UTC or manually.

They discover every `Casks/*.rb` or `Formula/*.rb` automatically, including
Mackeep and OSM. There is no package list to maintain. Both use the reusable
`update-packages.yml` workflow and `update-packages/update.sh`.

Each package is checked with `brew livecheck`. Unchanged packages require no
archive downloads. Updates get a separate PR, followed by a merge/auto-merge
request under the repository's rules. One failed package does not stop checks
for the others; the overall run still fails and names the failures.

The following manual entry points remain available for project release dispatches:

- `update-osm.yml`: OSM only.
- `update-mackeep-cli.yml`: Mackeep CLI only.
- `update-mackeep-desktop.yml`: Mackeep Desktop only.

Their filenames are unchanged. They call the same reusable workflow with a package
name; downloads, checksums and formula editing are implemented once. GitHub release
assets are checked before any archive downloads, and GitHub asset digests are
verified when provided. OSM additionally validates its project version and standalone
archive through `update-packages/osm.py`, including in bulk runs. Their individual schedules are replaced by the daily bulk
checks. All entry points share a concurrency group to avoid concurrent writes.
GitHub concurrency may replace an older pending run when more runs are queued;
the running update is not cancelled.

All updater entry points require the existing `HOMEBREW_TAP_TOKEN`
secret with repository Contents and Pull requests write access. Repository rules
must permit the updater's merge path. The standalone OSM and Mackeep CLI workflows now use the same token and PR/merge
path as the bulk workflows; they no longer publish direct commits to main.

### Adding a formula

Create `Formula/<name>.rb`; no new workflow or Python updater is needed for a
versioned archive formula. For example (replace the repository, version, SHA256,
license, executable and description with real values):

```ruby
class ExampleCli < Formula
  desc "Example command-line tool"
  homepage "https://github.com/owner/example"
  version "1.2.3"
  url "https://github.com/owner/example/releases/download/v#{version}/example-#{version}-macos-arm64.tar.gz"
  sha256 "REPLACE_WITH_THE_REAL_64_CHARACTER_SHA256"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  def install
    bin.install "example"
  end

  test do
    system bin/"example", "--version"
  end
end
```

Use `on_macos` / `on_linux` and `on_arm` / `on_intel` blocks when upstream provides
multiple archives. Each `url` must be immediately followed by its `sha256`
(an intervening `version` line is also supported). Use one explicit top-level
`version`; URLs must contain that version literally or through `#{version}`.
Use `url :stable` in the livecheck block. The example targets a macOS ARM64
archive; add appropriate architecture/OS requirements or other platform archives
for the actual project.

The shared formula updater downloads all declared platform archives over HTTPS,
streams SHA256 calculation with at most three concurrent downloads, and changes
the formula only after every download succeeds. It preserves installation,
service and test code, checks Ruby syntax and the diff, and prepares the update
in a temporary Git worktree. Download requests never include the repository token.
It does not install or execute upstream binaries during updates.

This template covers versioned source or binary archives, including the current
Qdrant and SolidCraft CLI formulae. Complex recipes with resources, patches,
bottles, mirrors, HEAD or explicit stable blocks fail with an explanatory error
and require review rather than guessing how to update them. A release that changes
its asset names or installation layout also requires a formula adjustment.

For casks, add `Casks/<name>.rb` with a working `livecheck` (or working automatic
version detection); Homebrew's `bump-cask-pr` handles the update.

Check a new package before running the bulk workflow:

```bash
brew livecheck --formula --json joynik/tap/<formula>
brew livecheck --cask --json joynik/tap/<cask>
```

Run updater regression checks locally (Python 3.11+ and `bash`, `jq`, `ruby` required):

```bash
python3 -m unittest discover -s update-packages -p 'test_*.py'
```

Fetch the latest tap changes:

```bash
brew update
```

Upgrade an installed cask:

```bash
brew upgrade --cask joynik/tap/<cask> --greedy
```

Upgrade an installed formula:

```bash
brew upgrade joynik/tap/<formula>
```

## Uninstalling

Uninstall a cask:

```bash
brew uninstall --cask <cask>
```

Uninstall a formula:

```bash
brew uninstall <formula>
```
