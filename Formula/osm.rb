class Osm < Formula
  desc "Local MCP server for semantic search in Obsidian vaults"
  homepage "https://github.com/Joynik/obsidian-semantic-mcp"
  url "https://github.com/Joynik/obsidian-semantic-mcp/releases/download/v0.49.0/osm-v0.49.0-macos-arm64.tar.gz"
  version "0.49.0"
  sha256 "104d60371903242d300130c9ae9fb6a5f790b8f703bad0c771bfa815052212e8"
  license "Apache-2.0"

  depends_on macos: :tahoe
  depends_on arch: :arm64

  livecheck do
    url :stable
    strategy :github_latest
  end

  def install
    libexec.install "osm.dist"
    bin.install_symlink libexec/"osm.dist/osm"
  end

  test do
    assert_match "OSM v#{version}", shell_output("#{bin}/osm help")
  end
end
