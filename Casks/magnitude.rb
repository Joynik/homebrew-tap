cask "magnitude" do
  version "0.3.2"
  sha256 "186532551b93d8f62d4e872d7a9e721b2c230e106aa84f2d4e930244081ab5b4"

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