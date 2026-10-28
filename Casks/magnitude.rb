cask "magnitude" do
  version "0.2.13"
  sha256 "2927f143e6c43be94d7a1aa3ff96469665ac3d7ac5961fa46413553f40a7a3c1"

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