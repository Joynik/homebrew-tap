# frozen_string_literal: true

class Kitflow < Formula
  desc "Start projects and maintain configuration standards"
  homepage "https://github.com/Joynik/KitFlow"
  version "0.7.1"

  on_macos do
    depends_on macos: :sequoia
    depends_on arch: :arm64

    url "https://github.com/Joynik/KitFlow/releases/download/0.7.1/kitflow-0.7.1-macos-arm64.tar.gz"
    sha256 "c60c3f65d5479b64184034d84f073c22faa61a778e5b88b1efa3950924f7be0c"
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/Joynik/KitFlow/releases/download/0.7.1/kitflow-0.7.1-linux-arm64.tar.gz"
      sha256 "9b0132c8d1271271a2abcf9ce070c02eac67e4b5b74010f2e70b53ea2000a1d6"
    else
      url "https://github.com/Joynik/KitFlow/releases/download/0.7.1/kitflow-0.7.1-linux-x86_64.tar.gz"
      sha256 "00e241ed065e2645efbb0b1fb1856af4b2a55848b680773a716f4d4b3826584a"
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
