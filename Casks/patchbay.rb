cask "patchbay" do
  version "0.3.1"
  sha256 "686d296e0124087c6c729ae55b641d68b783791dfbc71e9c5532bb821696d257"

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
