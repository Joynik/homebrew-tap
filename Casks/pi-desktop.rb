cask "Pi Desktop" do
  version "0.2.1-alpha"
  sha256 "23f6b38a9c63a11bbdcdabe3269bb2aa4c0668073fbfd8b43ac3e361758788e7"

  url "https://github.com/FaqFirebase/pi-desktop/releases/download/v#{version}/Pi-Desktop-#{version}-mac-arm64.dmg"
  name "Pi Desktop"
  desc "Pi Desktop: a free, open source desktop GUI for the Pi coding agent and oh-my-pi. Chat, edit files, run a terminal, and review diffs in one window."
  homepage "https://github.com/FaqFirebase/pi-desktop/"

  depends_on :macos

  livecheck do
    url :url
    strategy :github_latest
  end

  app "Pi Desktop.app"
end