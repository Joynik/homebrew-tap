# frozen_string_literal: true

class Kitflow < Formula
  desc "Start projects and maintain configuration standards"
  homepage "https://github.com/Joynik/KitFlow"
  version "0.7.0"

  on_macos do
    depends_on macos: :sequoia
    depends_on arch: :arm64

    url "https://github.com/Joynik/KitFlow/releases/download/0.7.0/kitflow-0.7.0-macos-arm64.tar.gz"
    sha256 "7b11fa4c56cd7fcecee471f4f63f84b822cd111e3811058d06095d606d11d542"
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/Joynik/KitFlow/releases/download/0.7.0/kitflow-0.7.0-linux-arm64.tar.gz"
      sha256 "de2c98cdcc40cfb76243b91b49ee63362c3fc1348aa10087d0c65cade4868858"
    else
      url "https://github.com/Joynik/KitFlow/releases/download/0.7.0/kitflow-0.7.0-linux-x86_64.tar.gz"
      sha256 "75c138779428fa5b9fe4a2765df6f3edafd708cd6724cef19b9bb731ec6b4bc5"
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
