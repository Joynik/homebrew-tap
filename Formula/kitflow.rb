# frozen_string_literal: true

class Kitflow < Formula
  desc "Start projects and maintain configuration standards"
  homepage "https://github.com/Joynik/KitFlow"
  version "0.13.0"

  on_macos do
    depends_on macos: :sequoia
    depends_on arch: :arm64

    url "https://github.com/Joynik/KitFlow/releases/download/0.13.0/kitflow-0.13.0-macos-arm64.tar.gz"
    sha256 "ea4274cb03e3d67a96baac8b30f0d7f3726f9e44b2cdf5e4cae09d95173e0561"
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/Joynik/KitFlow/releases/download/0.13.0/kitflow-0.13.0-linux-arm64.tar.gz"
      sha256 "e40ff666a1c549646a7d9e9f5ef04bfce1493dc95dc660489365bc1ff4b48c1a"
    else
      url "https://github.com/Joynik/KitFlow/releases/download/0.13.0/kitflow-0.13.0-linux-x86_64.tar.gz"
      sha256 "1afe08904d1607d36b37447b67b3afae2543922f1c8d1cec1e4458dd75bb0974"
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
