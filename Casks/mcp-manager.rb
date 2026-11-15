cask "mcp-manager" do
  version "0.5.0"
  sha256 "23c74ab3d064bde78908c64b598ec911ec73eeddf3199fb81543da2e47274ed5"

  url "https://github.com/xjeway/mcp-manager/releases/download/v#{version}/MCP.Manager_#{version}_aarch64.dmg"
  name "MCP Manager"
  desc "A cross-platform desktop app for managing MCP server configs across Claude Code, Codex, Cursor, VS Code, OpenCode, Gemini CLI, and more."
  homepage "https://github.com/xjeway/mcp-manager/"

  depends_on :macos

  livecheck do
    url :url
    strategy :github_latest
  end

  app "MCP Manager.app"
end
