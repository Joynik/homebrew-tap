cask "voicebox" do
  version "0.5.0"
  sha256 "1ef6d28d17b96e1b331340831bf59ea2dd3c526dbbdcadb3d2b90f186e9b3070"

  url "https://github.com/jamiepine/voicebox/releases/download/v#{version}/Voicebox_#{version}_aarch64.dmg"
  name "Voicebox"
  desc "The open-source AI voice studio. Clone, dictate, create."
  homepage "https://github.com/jamiepine/voicebox/"

  depends_on :macos

  livecheck do
    url :url
    strategy :github_latest
  end

  app "voicebox.app"
end