# frozen_string_literal: true

class Kitflow < Formula
  desc "Start projects and maintain configuration standards"
  homepage "https://github.com/Joynik/KitFlow"
  version "0.4.0"

  on_macos do
    depends_on macos: :sequoia
    depends_on arch: :arm64

    url "https://github.com/Joynik/KitFlow/releases/download/0.4.0/kitflow-0.4.0-macos-arm64.tar.gz"
    sha256 "220f4f878957efa83d0272392fac1a6c1dc1483de8f65a3b057a0486156441a8"
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/Joynik/KitFlow/releases/download/0.4.0/kitflow-0.4.0-linux-arm64.tar.gz"
      sha256 "1a7b86180d77b47b49886322190e4ca878d73309f86f723875c86cb5cdbdb247"
    else
      url "https://github.com/Joynik/KitFlow/releases/download/0.4.0/kitflow-0.4.0-linux-x86_64.tar.gz"
      sha256 "ed9ce449b56435ee6955221658f710951b34c94735888b30023c5022a93c07e5"
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
