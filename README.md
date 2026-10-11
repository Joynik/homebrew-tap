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

Подключите tap с GitHub.

```bash
brew tap joynik/tap
```

## Установка

```bash
brew install --cask joynik/tap/<cask>
```

## Обновление

Если приложение уже установлено, обновите его командой:

```bash
brew upgrade --cask joynik/tap/<cask> --greedy
```

## Удаление

```bash
brew uninstall --cask <cask>
```
