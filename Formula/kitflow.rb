# frozen_string_literal: true

class Kitflow < Formula
  desc "Start projects and maintain configuration standards"
  homepage "https://github.com/Joynik/KitFlow"
  version "0.3.0"

  on_macos do
    depends_on macos: :sequoia
    depends_on arch: :arm64

    url "https://github.com/Joynik/KitFlow/releases/download/0.3.0/kitflow-0.3.0-macos-arm64.tar.gz"
    sha256 "352b5b04b4133d7e52577a6f9af7734d0ecf88fcd52f8d9eb579ed82fe885d92"
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/Joynik/KitFlow/releases/download/0.3.0/kitflow-0.3.0-linux-arm64.tar.gz"
      sha256 "b8f4c04ef94a1ff4d9846378b8ef39539f632b63cc06dad2c396fed5c7b0b7dc"
    else
      url "https://github.com/Joynik/KitFlow/releases/download/0.3.0/kitflow-0.3.0-linux-x86_64.tar.gz"
      sha256 "37096787027d000757f29b58376f8147822186e10b4fa7ec34f28a82e328a446"
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
