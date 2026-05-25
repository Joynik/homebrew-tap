cask "mtarsier" do
  version "1.2.0"
  sha256 "b9626721f55c42f2099541799bbdd687534aadbdb4df06e4d11d4ec878f79a83"

  url "https://github.com/mcp360/mTarsier/releases/download/v#{version}/mTarsier_#{version}_x64.dmg"
  name "mTarsier"
  desc "The Open Source MCP & Skill Manager for Claude, Cursor, VS Code & any AI client"
  homepage "https://github.com/mcp360/mTarsier"

  livecheck do
    url "https://github.com/mcp360/mTarsier/releases/latest"
    strategy :header_match
  end

  app "mtarsier.app"
end