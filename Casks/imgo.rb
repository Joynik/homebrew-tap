cask "imgo" do
  version "1.1.0"
  sha256 "6d624750680972a09d07ff49a680f5dd45af2b9b518b2be09016d1f260f466c5"

  url "https://github.com/meowtec/imgo/releases/download/v#{version}/imgo_#{version}_aarch64.dmg"
  name "IMGo"
  desc "Image optimization app for macOS."
  homepage "https://github.com/meowtec/imgo"

  depends_on :macos

  livecheck do
    url :url
    strategy :github_latest
  end

  app "imgo.app"
end