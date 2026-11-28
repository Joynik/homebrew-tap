cask "patchbay" do
  version "0.4.0"
  sha256 "9aeb0206118d6ecdb5f1e28512259d0fafa7efe0c3c56dfaaf6ccabaecc6a38b"

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
