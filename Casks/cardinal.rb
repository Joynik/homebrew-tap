cask "cardinal" do
  version "0.5.2"
  sha256 "83691f6022ffdf5f79718d94ad6983924743f18fb4e634b64ce576af1da9d188"

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