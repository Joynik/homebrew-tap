cask "atoll" do
  version "2.1.0"
  sha256 "add3a30d4e9bfa5cd180f2538c88d4cda047813dafe574fab5d0660087c3392b"

  url "https://github.com/Ebullioscopic/Atoll/releases/download/v#{version}/Atoll.#{version}.dmg"
  name "Atoll"
  desc "Dynamic Island for macOS"
  homepage "https://github.com/Ebullioscopic/Atoll"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "Atoll.app"
end