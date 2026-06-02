cask "atoll" do
  version "2.2.0"
  sha256 "30e532e69650a7183769dff222bca7106de7dfe4936e9bd9c2096e20f58a4cb2"

  url "https://github.com/Ebullioscopic/Atoll/releases/download/v#{version}/Atoll.#{version}.dmg"
  name "Atoll"
  desc "Dynamic Island"
  homepage "https://github.com/Ebullioscopic/Atoll"

  depends_on :macos

  livecheck do
    url :url
    strategy :github_latest
  end

  app "Atoll.app"
end