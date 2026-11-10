# frozen_string_literal: true

class Kitflow < Formula
  desc "Start projects and maintain configuration standards"
  homepage "https://github.com/Joynik/KitFlow"
  version "0.1.0"

  on_macos do
    depends_on macos: :sequoia
    depends_on arch: :arm64

    url "https://github.com/Joynik/KitFlow/releases/download/0.1.0/kitflow-0.1.0-macos-arm64.tar.gz"
    sha256 "c3225a7dc7be384695c4abf366404b87e681eed6fd7d5fce149877fe303d58a6"
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/Joynik/KitFlow/releases/download/0.1.0/kitflow-0.1.0-linux-arm64.tar.gz"
      sha256 "47e5ff0658e615255f02ec5aaf01a79c5f5b0f153dbe09664a23cca4ea272f8f"
    else
      url "https://github.com/Joynik/KitFlow/releases/download/0.1.0/kitflow-0.1.0-linux-x86_64.tar.gz"
      sha256 "dd17f7e31f9b44f2506b759a3b52fa7488fe0d7238c12d5e8730bed39680ec91"
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
