# Homebrew Tap

Коллекция приложений для macOS, устанавливаемых через Homebrew Cask.

## Требования

- macOS;
- [Homebrew](https://brew.sh/) установленный на Mac.

Если Homebrew ещё не установлен, выполните в Terminal:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## Установка

Подключите tap с GitHub. Замените `<owner>` на имя владельца репозитория:

```bash
brew tap <owner>/tap
```

После этого установите нужное приложение по имени cask:

Доступные приложения:

| Приложение | Команда |
| --- | --- |
| Atoll | `brew install --cask <owner>/tap/atoll` |
| MachStruct | `brew install --cask <owner>/tap/machstruct` |
| mTarsier | `brew install --cask <owner>/tap/mtarsier` |
| ScreenTranslate | `brew install --cask <owner>/tap/screentranslate` |
| VirusTotal | `brew install --cask <owner>/tap/virustotal` |
| Voicebox | `brew install --cask <owner>/tap/voicebox` |

После установки приложение появится в папке `Applications` и будет доступно через Launchpad или Spotlight.

## Обновление

Для обновления приложения повторите команду установки с ключом `--greedy`:

```bash
brew upgrade --cask <owner>/tap/atoll --greedy
```

## Удаление

```bash
brew uninstall --cask atoll
```

Замените `atoll` на имя нужного cask.

## Примечания

- При первом запуске macOS может запросить подтверждение в `System Settings → Privacy & Security`.
- `Voicebox` в текущей версии распространяется для Apple Silicon (`aarch64`).
- `mTarsier` в текущей версии распространяется как Intel (`x64`) приложение и на Apple Silicon запускается через Rosetta 2.
