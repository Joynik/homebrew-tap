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
| [cardinal](https://github.com/franciscoxc/cardinal) | Fastest file searching tool for macOS | `brew install --cask joynik/tap/cardinal` |
| [imgo](https://github.com/meowtec/imgo) | Image optimization app for macOS. | `brew install --cask joynik/tap/imgo` |
| [machstruct](https://github.com/lustech/MachStruct) | Native macOS viewer and editor for JSON, XML, YAML, CSV | `brew install --cask joynik/tap/machstruct` |
| [mackeep](https://github.com/Joynik/mackeep) | Backup and keep your application settings in sync | `brew install --cask joynik/tap/mackeep` |
| [magnitude](https://github.com/magnitudedev/magnitude/) | Run open models as fast as your hardware allows. | `brew install --cask joynik/tap/magnitude` |
| [ohmyhf](https://github.com/fzlzjerry/ohmyhf/) | Unofficial cross-platform desktop client for the Hugging Face Hub | `brew install --cask joynik/tap/ohmyhf` |
| [omniroute](https://github.com/diegosouzapw/OmniRoute/) | The Free AI Gateway | `brew install --cask joynik/tap/omniroute` |
| [patchbay](https://github.com/Joynik/Patchbay) | Manage MCP server configurations across AI agents | `brew install --cask joynik/tap/patchbay` |
| [pi-desktop](https://github.com/FaqFirebase/pi-desktop/) | Pi Desktop: a free, open source desktop GUI for the Pi coding agent and oh-my-pi. Chat, edit files, run a terminal, and review diffs in one window. | `brew install --cask joynik/tap/pi-desktop` |
| [pi-desktop-2](https://github.com/vastsa/PI-Desktop/) | Local-first AI coding agent desktop: Electron + Rust host core + pi Agent Harness + user-installable plugins | `brew install --cask joynik/tap/pi-desktop-2` |
| [virustotal](https://github.com/Jerry23011/VirusTotal-macOS/) | An elegant VirusTotal client built with Swift and SwiftUI | `brew install --cask joynik/tap/virustotal` |

## Available formulae

Command-line tools and services installed through Homebrew.

| Package | Description | Install |
| --- | --- | --- |
| [KitFlow](https://github.com/Joynik/KitFlow) | Start projects and maintain configuration standards | `brew install joynik/tap/kitflow` |
| [mackeep-cli](https://github.com/Joynik/mackeep) | Backup and keep your application settings in sync | `brew install joynik/tap/mackeep-cli` |
| [osm](https://github.com/Joynik/obsidian-semantic-mcp) | Local MCP server for semantic search in Obsidian vaults | `brew install joynik/tap/osm` |
| [qdrant](https://qdrant.tech) | Vector search engine and database for AI applications | `brew install joynik/tap/qdrant` |
| [xerj](https://xerj.org) | Local-first search engine and MCP server for AI agents | `brew install joynik/tap/xerj` |

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
