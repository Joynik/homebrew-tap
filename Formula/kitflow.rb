# frozen_string_literal: true

class Kitflow < Formula
  desc "Start projects and maintain configuration standards"
  homepage "https://github.com/Joynik/KitFlow"
  version "0.21.1"

  on_macos do
    depends_on macos: :sequoia
    depends_on arch: :arm64

    url "https://github.com/Joynik/KitFlow/releases/download/0.21.1/kitflow-0.21.1-macos-arm64.tar.gz"
    sha256 "fe7557dbb27dc0ff7c1f47eb4231111c7fc1fc0cb6f2200d68cf7f7267844784"
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/Joynik/KitFlow/releases/download/0.21.1/kitflow-0.21.1-linux-arm64.tar.gz"
      sha256 "41c57704e8910ace42d27841e2bb3a93c73c06889a556a795c7bec43aeb5886d"
    else
      url "https://github.com/Joynik/KitFlow/releases/download/0.21.1/kitflow-0.21.1-linux-x86_64.tar.gz"
      sha256 "19c99ed4f91e05522acd3b1edeec77314c2441363dac6dc1c9996d91892730fa"
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
