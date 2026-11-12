cask "pi-desktop-2" do
  version "0.22.0"
  sha256 "0c676610f83b6e3871308ad617f9f3c459fc679e5e4e7ab4210f82b61eb8fcb9"

  url "https://github.com/vastsa/PI-Desktop/releases/download/v#{version}/PI-Desktop-#{version}-arm64.dmg"
  name "Pi-Desktop"
  desc "Local-first AI coding agent desktop: Electron + Rust host core + pi Agent Harness + user-installable plugins"
  homepage "https://github.com/vastsa/PI-Desktop/"

  depends_on :macos

  livecheck do
    url :url
    strategy :github_latest
  end

  app "PI-Desktop.app"
end