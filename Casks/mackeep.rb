cask "mackeep" do
  version "0.22.1"
  sha256 "cf34a8661b11b7f6758b2d2347dc22be8cb89ebde9ed736c2a863d871af131c5"

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