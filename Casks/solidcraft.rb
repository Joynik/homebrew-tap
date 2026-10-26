cask "solidcraft" do
  version "0.23.1"
  sha256 "0d93b1dda4314c3a5ce9c95e8c10da7b4e2c1b2cad7e5dd3ff40ee810f43d1c6"

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