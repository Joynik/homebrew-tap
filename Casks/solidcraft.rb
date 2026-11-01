cask "solidcraft" do
  version "0.29.0"
  sha256 "98f19aecbd59eb6ce8bcd83e1af94b127118a121538ee68445f42ad665b53c23"

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