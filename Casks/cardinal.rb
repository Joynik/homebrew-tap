cask "cardinal" do
  version "0.5.1"
  sha256 "0aec374ebf36fe46b1931b7414323596865cd0543482359aac361e7004b3f17c"

  url "https://github.com/franciscoxc/cardinal/releases/download/v#{version}/Cardinal_#{version}_aarch64.dmg"
  name "Cardinal"
  desc "Fastest file searching tool for macOS"
  homepage "https://github.com/franciscoxc/cardinal"

  depends_on :macos

  livecheck do
    url :url
    strategy :github_latest
  end

  app "cardinal.app"
end