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
| [magnitude](https://github.com/magnitudedev/magnitude/) | Run open models as fast as your hardware allows. | `brew install --cask joynik/tap/magnitude` |
| [mtarsier](https://github.com/mcp360/mTarsier) | The Open Source MCP & Skill Manager for Claude, Cursor, VS Code & any AI client | `brew install --cask joynik/tap/mtarsier` |
| [omniroute](https://github.com/diegosouzapw/OmniRoute/) | The Free AI Gateway | `brew install --cask joynik/tap/omniroute` |
| [screentranslate](https://github.com/hcmhcs/screenTranslate) | Translate any text on your Mac screen — capture or select. | `brew install --cask joynik/tap/screentranslate` |
| [virustotal](https://github.com/Jerry23011/VirusTotal-macOS/) | An elegant VirusTotal client built with Swift and SwiftUI | `brew install --cask joynik/tap/virustotal` |
| [voicebox](https://github.com/jamiepine/voicebox/) | The open-source AI voice studio. Clone, dictate, create. | `brew install --cask joynik/tap/voicebox` |
| [voicestudio](https://github.com/debpalash/VoiceStudio/) | Open-source voice cloning, voice design, video dubbing, dictation, transcription & audiobook creation in 646 languages. | `brew install --cask joynik/tap/voicestudio` |

## Available formulae

Command-line tools and services installed through Homebrew.

| Package | Description | Install |
| --- | --- | --- |
| [osm](https://github.com/Joynik/obsidian-semantic-mcp) | Local MCP server for semantic search in Obsidian vaults | `brew install joynik/tap/osm` |
| [qdrant](https://qdrant.tech) | Vector search engine and database for AI applications | `brew install joynik/tap/qdrant` |

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
