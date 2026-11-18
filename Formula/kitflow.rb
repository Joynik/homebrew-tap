# frozen_string_literal: true

class Kitflow < Formula
  desc "Start projects and maintain configuration standards"
  homepage "https://github.com/Joynik/KitFlow"
  version "0.13.1"

  on_macos do
    depends_on macos: :sequoia
    depends_on arch: :arm64

    url "https://github.com/Joynik/KitFlow/releases/download/0.13.1/kitflow-0.13.1-macos-arm64.tar.gz"
    sha256 "69dda6553ad641cabead481669a08142c03c0e7a7c68085d202431a9ad774106"
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/Joynik/KitFlow/releases/download/0.13.1/kitflow-0.13.1-linux-arm64.tar.gz"
      sha256 "583bfc825ee06a60dcd4a898f2bbec1b03bc1aff6c6a12063d4d8176d2115c2c"
    else
      url "https://github.com/Joynik/KitFlow/releases/download/0.13.1/kitflow-0.13.1-linux-x86_64.tar.gz"
      sha256 "f3f4678fcd47d22a71e2f4bec3924c85f14b0a13b17a45a55876819f9e5ba97e"
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
