# frozen_string_literal: true

class Kitflow < Formula
  desc "Start projects and maintain configuration standards"
  homepage "https://github.com/Joynik/KitFlow"
  version "0.13.3"

  on_macos do
    depends_on macos: :sequoia
    depends_on arch: :arm64

    url "https://github.com/Joynik/KitFlow/releases/download/0.13.3/kitflow-0.13.3-macos-arm64.tar.gz"
    sha256 "f95283b656588f454731945c252d6d97fed9e2f8927a2b3779f27cf4b762043f"
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/Joynik/KitFlow/releases/download/0.13.3/kitflow-0.13.3-linux-arm64.tar.gz"
      sha256 "ba58765ed666a3f7738c1c5bd04d51821f98aa31929f33ebdd2731a7bb22920a"
    else
      url "https://github.com/Joynik/KitFlow/releases/download/0.13.3/kitflow-0.13.3-linux-x86_64.tar.gz"
      sha256 "8a531a14e5422d1918b615dc5cf0a154e52a4743143284faf8a92676216ec9df"
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
