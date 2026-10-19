class Osm < Formula
  desc "Local MCP server for semantic search in Obsidian vaults"
  homepage "https://github.com/Joynik/obsidian-semantic-mcp"
  url "https://github.com/Joynik/obsidian-semantic-mcp/releases/download/v0.48.1/osm-v0.48.1-macos-arm64.tar.gz"
  version "0.48.1"
  sha256 "bc196dc3824afd762161eb5b4abc3b29e8c61950da054fddff73b4223cd18bda"
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
