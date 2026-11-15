# frozen_string_literal: true

class Kitflow < Formula
  desc "Start projects and maintain configuration standards"
  homepage "https://github.com/Joynik/KitFlow"
  version "0.6.0"

  on_macos do
    depends_on macos: :sequoia
    depends_on arch: :arm64

    url "https://github.com/Joynik/KitFlow/releases/download/0.6.0/kitflow-0.6.0-macos-arm64.tar.gz"
    sha256 "174f17a0de027b5827e10c407484f82fa17c30c1289b4aa8a658a681eb959d94"
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/Joynik/KitFlow/releases/download/0.6.0/kitflow-0.6.0-linux-arm64.tar.gz"
      sha256 "63e3c889cd047d55d574ae33113e26e4d427676b0b6d4de1b83687d658c90c78"
    else
      url "https://github.com/Joynik/KitFlow/releases/download/0.6.0/kitflow-0.6.0-linux-x86_64.tar.gz"
      sha256 "7dfe211d527cb745cb20b99e583063bd4cf258fb3936c7def90a930581936f32"
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
