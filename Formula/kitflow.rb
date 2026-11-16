# frozen_string_literal: true

class Kitflow < Formula
  desc "Start projects and maintain configuration standards"
  homepage "https://github.com/Joynik/KitFlow"
  version "0.8.1"

  on_macos do
    depends_on macos: :sequoia
    depends_on arch: :arm64

    url "https://github.com/Joynik/KitFlow/releases/download/0.8.1/kitflow-0.8.1-macos-arm64.tar.gz"
    sha256 "d2c9054f8cd4c184eaf9b677c387dd918cc63a749be05cc1e9a6e4503622cb5f"
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/Joynik/KitFlow/releases/download/0.8.1/kitflow-0.8.1-linux-arm64.tar.gz"
      sha256 "84f7f54191a940123700b1549d4d9f0c5878a010b27541036321368d851f8fb6"
    else
      url "https://github.com/Joynik/KitFlow/releases/download/0.8.1/kitflow-0.8.1-linux-x86_64.tar.gz"
      sha256 "40757db882bdcbb50bccaaa4cd9f5b013465ca3e0a20eead1f76a2a885e310d5"
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
