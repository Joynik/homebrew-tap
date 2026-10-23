cask "mackeep" do
  version "0.23.2"
  sha256 "83ceb5a55de891f3876e1bdb2f1d82dcfe4f9431bd20ebaf1d095cfb83c3f769"

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