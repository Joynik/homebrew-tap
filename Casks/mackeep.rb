cask "mackeep" do
  version "0.26.4"
  sha256 "a91bfcdf4a51988e3a7990706c635d6f508a29e9ad75071753dbbda4351a607c"

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