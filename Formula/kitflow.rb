# frozen_string_literal: true

class Kitflow < Formula
  desc "Start projects and maintain configuration standards"
  homepage "https://github.com/Joynik/KitFlow"
  version "0.19.0"

  on_macos do
    depends_on macos: :sequoia
    depends_on arch: :arm64

    url "https://github.com/Joynik/KitFlow/releases/download/0.19.0/kitflow-0.19.0-macos-arm64.tar.gz"
    sha256 "a9d3bd0407010939d8175f1b846cfc8b6920342e6425ee6cc4ad5f32c99d8767"
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/Joynik/KitFlow/releases/download/0.19.0/kitflow-0.19.0-linux-arm64.tar.gz"
      sha256 "2b9e5195efb5a559516f485b173332410beffb4d76c8ae5537bc19d63319b245"
    else
      url "https://github.com/Joynik/KitFlow/releases/download/0.19.0/kitflow-0.19.0-linux-x86_64.tar.gz"
      sha256 "789158325e4fd98eca0a7c2b77ec40261352d21a660c583f79833d77bcc34697"
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
