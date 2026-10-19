class SolidcraftCli < Formula
  desc "Headless CLI and MCP server for SolidCraft parametric CAD"
  homepage "https://github.com/tangency-labs/solidcraft"
  version "0.16.2"
  url "https://github.com/tangency-labs/solidcraft/releases/download/v#{version}/solidcraft-cli-#{version}-macos-universal.zip"
  sha256 "7363c756f2de5f57d1c1cae7615b91779bfb1b930600c848a38c92686fbee255"
  license any_of: ["MIT", "Apache-2.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  def install
    # Ищем бинарник, даже если архив содержит вложенную папку
    bin.install Dir["**/solidcraft-cli"].first
  end

  test do
    system bin/"solidcraft-cli", "commands"
  end
end