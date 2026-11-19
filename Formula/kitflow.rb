# frozen_string_literal: true

class Kitflow < Formula
  desc "Start projects and maintain configuration standards"
  homepage "https://github.com/Joynik/KitFlow"
  version "0.19.1"

  on_macos do
    depends_on macos: :sequoia
    depends_on arch: :arm64

    url "https://github.com/Joynik/KitFlow/releases/download/0.19.1/kitflow-0.19.1-macos-arm64.tar.gz"
    sha256 "5429b1e333dfcae6e5fd3deb450ab527888ddd0dee0202665b7bcb12d481a523"
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/Joynik/KitFlow/releases/download/0.19.1/kitflow-0.19.1-linux-arm64.tar.gz"
      sha256 "d083e53cd125be2a128257fe021b464193bd3fbcfcc32ea613c8fbec5b2ff305"
    else
      url "https://github.com/Joynik/KitFlow/releases/download/0.19.1/kitflow-0.19.1-linux-x86_64.tar.gz"
      sha256 "5e07d81508d81b3123c2c0eb6c171f35f75883146ff37df0eee803eeb88b0afb"
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
