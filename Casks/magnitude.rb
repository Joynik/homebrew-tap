cask "magnitude" do
  version "0.2.17"
  sha256 "a9f245e71ebc87e14bb7c1b5f3d46a3f17d1a1687a3dc24f8105570fc6ac30c9"

  url "https://github.com/magnitudedev/magnitude/releases/download/%40magnitudedev%2Fcli%40#{version}/magnitude-desktop-darwin-arm64.dmg"
  name "Magnitude"
  desc "Run open models as fast as your hardware allows."
  homepage "https://github.com/magnitudedev/magnitude/"

  depends_on :macos

  livecheck do
    url :url
    strategy :github_latest
  end

  app "magnitude.app"
end