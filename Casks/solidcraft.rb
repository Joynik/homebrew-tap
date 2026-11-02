cask "solidcraft" do
  version "0.30.0"
  sha256 "b05751f79e503f9c52914ca87f295e2a84760b1b22a695bc94714ddd543ced97"

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