cask "magnitude" do
  version "0.2.8"
  sha256 "4be04aa4451ff1e28b7af7d894feefc4941e687265eaabd18e629502e02c8d03"

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