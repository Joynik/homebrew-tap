# frozen_string_literal: true

class Kitflow < Formula
  desc "Start projects and maintain configuration standards"
  homepage "https://github.com/Joynik/KitFlow"
  version "0.9.1"

  on_macos do
    depends_on macos: :sequoia
    depends_on arch: :arm64

    url "https://github.com/Joynik/KitFlow/releases/download/0.9.1/kitflow-0.9.1-macos-arm64.tar.gz"
    sha256 "7a4ff5354b4d0b30556e7648b516ae2e6ae5ee9f313859a8d1a28521aa9eade5"
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/Joynik/KitFlow/releases/download/0.9.1/kitflow-0.9.1-linux-arm64.tar.gz"
      sha256 "c1c8594ff18a02e5a92de1bd01b00441c622101855b4a33a647311eb0fbf18e6"
    else
      url "https://github.com/Joynik/KitFlow/releases/download/0.9.1/kitflow-0.9.1-linux-x86_64.tar.gz"
      sha256 "aca36df981d7c4d3560ee3af04e68ef13ffa3a7bf06a4fa0c07fdd06ed00a1be"
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
