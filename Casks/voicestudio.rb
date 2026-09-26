cask "voicestudio" do
  version "0.5.6"
  sha256 "821d011faf255cd6315dba969ce1572ef850ae6159fcc55d94dcb9fe86259834"

  url "https://github.com/debpalash/VoiceStudio/releases/download/v#{version}/VoiceStudio-Electron-#{version}-mac-arm64.dmg"
  name "VoiceStudio"
  desc "Open-source voice cloning, voice design, video dubbing, dictation, transcription & audiobook creation in 646 languages."
  homepage "https://github.com/debpalash/VoiceStudio/"

  depends_on :macos

  livecheck do
    url :url
    strategy :github_latest
  end

  app "voicestudio.app"
end