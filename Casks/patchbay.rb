cask "patchbay" do
  version "0.4.1"
  sha256 "9cd2167c80ac069a2f0fdf8c3ffafc51b1ce7742d3784939db4374e2cae131cf"

  url "https://github.com/Joynik/Patchbay/releases/download/#{version}/Patchbay-#{version}-macos-arm64.zip"
  name "Patchbay"
  desc "Manage MCP server configurations across AI agents"
  homepage "https://github.com/Joynik/Patchbay"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on :macos

  app "Patchbay.app"
end
