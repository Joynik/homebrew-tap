cask "solidcraft" do
  version "0.41.0"
  sha256 "4ca723fb1a7eb5ddbc7d6e3df6a8f568b60a43d87b063e0f6b52135f4bc0a52c"

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