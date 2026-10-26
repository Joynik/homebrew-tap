cask "solidcraft" do
  version "0.23.0"
  sha256 "939da44bd910005d95de16f0bc8132a90eb94f687583da23249d1add0be1d144"

  url "https://github.com/tangency-labs/solidcraft/releases/download/v#{version}/solidcraft-#{version}-macos-universal.dmg"
  name "SolidCraft"
  desc "Parametric 3D CAD application built in pure Rust. Desktop, web, and automation through MCP."
  homepage "https://github.com/tangency-labs/solidcraft/"

  depends_on :macos

  livecheck do
    url :url
    strategy :github_latest
  end

  app "solidcraft.app"
end