# frozen_string_literal: true

class Kitflow < Formula
  desc "Start projects and maintain configuration standards"
  homepage "https://github.com/Joynik/KitFlow"
  version "0.18.0"

  on_macos do
    depends_on macos: :sequoia
    depends_on arch: :arm64

    url "https://github.com/Joynik/KitFlow/releases/download/0.18.0/kitflow-0.18.0-macos-arm64.tar.gz"
    sha256 "4501a9c8276578f476f2495342d4a3218e5e6564528509cb2fd69b0524601bfc"
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/Joynik/KitFlow/releases/download/0.18.0/kitflow-0.18.0-linux-arm64.tar.gz"
      sha256 "8b4651fb212b83208b7947a39501a1baedcea13da8753dacea914795e970cbc7"
    else
      url "https://github.com/Joynik/KitFlow/releases/download/0.18.0/kitflow-0.18.0-linux-x86_64.tar.gz"
      sha256 "9ac9c60f99fbc79f7f89dbb9f17cb6beb0643a3b04e20085d60216d734886c33"
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
