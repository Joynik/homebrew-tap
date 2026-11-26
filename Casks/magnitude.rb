cask "magnitude" do
  version "0.3.5"
  sha256 "f020ac3304cad6db9717a385c966d4846279a2dcabe3b470a2018ab2171c7ddc"

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