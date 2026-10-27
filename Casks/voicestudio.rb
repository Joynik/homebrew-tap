cask "voicestudio" do
  version "0.5.7"
  sha256 "8db7a16f35af1e4eaca25c389d376acc86b3885f30d1982f5fd6497953f888a0"

  url "https://github.com/debpalash/VoiceStudio/releases/download/v#{version}/VoiceStudio-#{version}-mac-arm64.dmg"
  name "VoiceStudio"
  desc "Open-source voice cloning, voice design, video dubbing, dictation, transcription & audiobook creation in 646 languages."
  homepage "https://github.com/debpalash/VoiceStudio/"

  depends_on :macos

  livecheck do
    url :url
    strategy :github_latest
  end

  app "VoiceStudio.app"
end
