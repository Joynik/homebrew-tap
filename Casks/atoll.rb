cask "atoll" do
  version "2.3.3"
  sha256 "bda40abaf9f5f8a69ede7bd838d5c1cc865e40dc5c8135bc1149413840003634"

  url "https://github.com/Ebullioscopic/Atoll/releases/download/v#{version}/Atoll-#{version}.dmg"
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