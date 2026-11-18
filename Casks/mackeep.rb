cask "mackeep" do
  version "0.26.1"
  sha256 "7b46dc5a6bb9c718b005acee23002f33ea0f06b78553c6a258bfdba57f1c2fe3"

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