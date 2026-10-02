cask "magnitude" do
  version "0.2.4"
  sha256 "669118bb9c415e11d57187961975c069ed23eb991a2c290b70886b61dd223351"

  url "https://github.com/magnitudedev/magnitude/releases/download/%40magnitudedev%2Fcli%40#{version}/magnitude-desktop-darwin-arm64.dmg"
  name "Magnitude"
  desc "Run open models as fast as your hardware allows"
  homepage "https://github.com/magnitudedev/magnitude/"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :monterey

  app "Magnitude.app"
end
