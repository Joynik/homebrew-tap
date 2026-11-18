cask "mackeep" do
  version "0.26.2"
  sha256 "e4530bfa54d5a6c8d0887b0dbe9fbf094d8d1f946ba05c1bec72d069eef98e8f"

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