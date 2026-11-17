# frozen_string_literal: true

class Kitflow < Formula
  desc "Start projects and maintain configuration standards"
  homepage "https://github.com/Joynik/KitFlow"
  version "0.9.0"

  on_macos do
    depends_on macos: :sequoia
    depends_on arch: :arm64

    url "https://github.com/Joynik/KitFlow/releases/download/0.9.0/kitflow-0.9.0-macos-arm64.tar.gz"
    sha256 "dbee9d768c45342b054dda1b4c29e7085929be9a974125749617ad79e5c203e1"
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/Joynik/KitFlow/releases/download/0.9.0/kitflow-0.9.0-linux-arm64.tar.gz"
      sha256 "4d2cf9da954594375545a7372aa4f37e48bab23f4f7e631012b13e1a8499d3af"
    else
      url "https://github.com/Joynik/KitFlow/releases/download/0.9.0/kitflow-0.9.0-linux-x86_64.tar.gz"
      sha256 "a92868cbeda0d8c47f71ea30023b299978b2cc4f48c2ba0c424d20e93df1bab4"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  def install
    libexec.install Dir["*"]
    bin.install_symlink libexec/"kitflow"
  end

  test do
    assert_match "KitFlow #{version}", shell_output("#{bin}/kitflow --version")
  end
end
