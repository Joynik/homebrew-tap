# frozen_string_literal: true

class Kitflow < Formula
  desc "Start projects and maintain configuration standards"
  homepage "https://github.com/Joynik/KitFlow"
  version "0.17.0"

  on_macos do
    depends_on macos: :sequoia
    depends_on arch: :arm64

    url "https://github.com/Joynik/KitFlow/releases/download/0.17.0/kitflow-0.17.0-macos-arm64.tar.gz"
    sha256 "1f417b0d3b97b113c1c13b2b2760f970cd5e040364b7b918e4daccf5fd2b7542"
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/Joynik/KitFlow/releases/download/0.17.0/kitflow-0.17.0-linux-arm64.tar.gz"
      sha256 "38b04b007751c709260331b859a172731dcaf4df92bad91acc2b7efa68ff2d36"
    else
      url "https://github.com/Joynik/KitFlow/releases/download/0.17.0/kitflow-0.17.0-linux-x86_64.tar.gz"
      sha256 "c5fbbfdedfb184968fdd83dfca236dbea63512a465a483013d97355ddb0a308e"
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
