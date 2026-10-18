class Osm < Formula
  desc "Local MCP server for semantic search in Obsidian vaults"
  homepage "https://github.com/Joynik/obsidian-semantic-mcp"
  url "https://github.com/Joynik/obsidian-semantic-mcp/releases/download/v0.48.0/osm-v0.48.0-macos-arm64.tar.gz"
  version "0.48.0"
  sha256 "01850dacb4015ca2ec8c0a18fe49c2cfad2b58044dea898b83995cd0ee0d9e24"
  license "Apache-2.0"

  depends_on macos: :tahoe
  depends_on arch: :arm64

  def install
    bin.install "osm"
  end

  test do
    assert_match "OSM v#{version}", shell_output("#{bin}/osm help")
  end
end
