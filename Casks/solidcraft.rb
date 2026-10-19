cask "solidcraft" do
  version "0.16.2"
  sha256 "ca9344479c805e30fc4fb1618a00e6cc5f5d6d72b60aad3a543752ed1f578f43"

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