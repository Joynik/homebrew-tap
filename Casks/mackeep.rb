cask "mackeep" do
  version "0.27.0"
  sha256 "2e4da1f3727dc2367f04fd33c4a70a14ecdbbba7d178f9000708fed6de661b61"

  url "https://github.com/Joynik/mackeep/releases/download/#{version}/Mackeep-#{version}-macos-arm64.dmg"
  name "Mackeep"
  desc "Backup and keep your application settings in sync"
  homepage "https://github.com/Joynik/mackeep"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on :macos

  app "Mackeep.app"
end