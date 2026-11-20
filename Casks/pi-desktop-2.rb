cask "pi-desktop-2" do
  version "0.23.0"
  sha256 "839c503362dd74833894337afbd1490db3fd6a2a57ced31069c67130c70be26f"

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