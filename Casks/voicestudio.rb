cask "voicestudio" do
  version "0.5.8"
  sha256 "378db9d7bf71a69a227b0f442d40acfe957a09d1a8ce17566059b235b8ed209e"

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
