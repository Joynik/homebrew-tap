# Homebrew Tap

Коллекция приложений для macOS, устанавливаемых через Homebrew Cask.

## Требования

- macOS;
- [Homebrew](https://brew.sh/) установленный на Mac.

Если Homebrew ещё не установлен, выполните в Terminal:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## Установка tap

Подключите tap с GitHub. Замените `<owner>` на имя владельца репозитория:

```bash
brew tap <owner>/tap
```

## Установка

```bash
brew install --cask <owner>/tap/<cask>
```

```bash
brew install --cask joynik/tap/<cask>
```

## Обновление

Если приложение уже установлено, обновите его командой:

```bash
brew upgrade --cask <owner>/tap/atoll --greedy
```

При первой установке используйте `brew install`, как указано в таблице выше.

## Удаление

```bash
brew uninstall --cask atoll
```

Замените `atoll` на имя нужного cask.

## Примечания

- При первом запуске macOS может запросить подтверждение в `System Settings → Privacy & Security`.
- `Voicebox` в текущей версии распространяется для Apple Silicon (`aarch64`).
- `mTarsier` в текущей версии распространяется как Intel (`x64`) приложение и на Apple Silicon запускается через Rosetta 2.
