# frozen_string_literal: true

class Kitflow < Formula
  desc "Start projects and maintain configuration standards"
  homepage "https://github.com/Joynik/KitFlow"
  version "0.15.0"

  on_macos do
    depends_on macos: :sequoia
    depends_on arch: :arm64

    url "https://github.com/Joynik/KitFlow/releases/download/0.15.0/kitflow-0.15.0-macos-arm64.tar.gz"
    sha256 "59c10df6e91467d52176e82250249aef17025a8302abb42bdfddad01278ac4f5"
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/Joynik/KitFlow/releases/download/0.15.0/kitflow-0.15.0-linux-arm64.tar.gz"
      sha256 "b641440eb4177ca0e63892f5d46d5bd2c051a1fb58b1e7f029dab6034a5ff09b"
    else
      url "https://github.com/Joynik/KitFlow/releases/download/0.15.0/kitflow-0.15.0-linux-x86_64.tar.gz"
      sha256 "316cebc1d84c74f761bc145cdabb64700c1b18d84cee20c8b1b321449eb91154"
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
