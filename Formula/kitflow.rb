# frozen_string_literal: true

class Kitflow < Formula
  desc "Start projects and maintain configuration standards"
  homepage "https://github.com/Joynik/KitFlow"
  version "0.11.0"

  on_macos do
    depends_on macos: :sequoia
    depends_on arch: :arm64

    url "https://github.com/Joynik/KitFlow/releases/download/0.11.0/kitflow-0.11.0-macos-arm64.tar.gz"
    sha256 "c1de6966fcafa572bcf96d9ad670763a0cb19be63ad32ed5c73b3fccce859ef4"
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/Joynik/KitFlow/releases/download/0.11.0/kitflow-0.11.0-linux-arm64.tar.gz"
      sha256 "ad76de02f4850dca43cf98d7d460b95e0799aac34de19639d0f4fb255c7df9dc"
    else
      url "https://github.com/Joynik/KitFlow/releases/download/0.11.0/kitflow-0.11.0-linux-x86_64.tar.gz"
      sha256 "1000cdfb190bb0b3bcb2a535d409bcd128a84ec34d8f85579ce73e1b54ac4ef9"
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
