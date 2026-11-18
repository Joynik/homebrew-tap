# frozen_string_literal: true

class Kitflow < Formula
  desc "Start projects and maintain configuration standards"
  homepage "https://github.com/Joynik/KitFlow"
  version "0.15.1"

  on_macos do
    depends_on macos: :sequoia
    depends_on arch: :arm64

    url "https://github.com/Joynik/KitFlow/releases/download/0.15.1/kitflow-0.15.1-macos-arm64.tar.gz"
    sha256 "c980c846f22ac646887a888f8441926c71944815c626c125aeb8cd3b394eff0e"
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/Joynik/KitFlow/releases/download/0.15.1/kitflow-0.15.1-linux-arm64.tar.gz"
      sha256 "7b9365c8e7c1100625174ccabe8bb198aff85d1fd210aa6de06e293cd160f176"
    else
      url "https://github.com/Joynik/KitFlow/releases/download/0.15.1/kitflow-0.15.1-linux-x86_64.tar.gz"
      sha256 "22d524ef464afca273f658fdb5908aa31d6b6044988a0af29f49d47cbc6a0a6b"
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
