# frozen_string_literal: true

class Kitflow < Formula
  desc "Start projects and maintain configuration standards"
  homepage "https://github.com/Joynik/KitFlow"
  version "0.16.0"

  on_macos do
    depends_on macos: :sequoia
    depends_on arch: :arm64

    url "https://github.com/Joynik/KitFlow/releases/download/0.16.0/kitflow-0.16.0-macos-arm64.tar.gz"
    sha256 "3c216c2312679de5c09e44b1b2d6e3c128809d1b2f53b21d3dae0e27af7e57a4"
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/Joynik/KitFlow/releases/download/0.16.0/kitflow-0.16.0-linux-arm64.tar.gz"
      sha256 "dd52bb1cc1f3e4901d0a65c9e3b83214869a5831d768d4d0c94aae001866ecc8"
    else
      url "https://github.com/Joynik/KitFlow/releases/download/0.16.0/kitflow-0.16.0-linux-x86_64.tar.gz"
      sha256 "7174d9a4496096e0cdb0e4161cf80ec3cc0b3234e94ac48177bb208bbab7ca79"
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
