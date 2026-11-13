# frozen_string_literal: true

class Kitflow < Formula
  desc "Start projects and maintain configuration standards"
  homepage "https://github.com/Joynik/KitFlow"
  version "0.2.0"

  on_macos do
    depends_on macos: :sequoia
    depends_on arch: :arm64

    url "https://github.com/Joynik/KitFlow/releases/download/0.2.0/kitflow-0.2.0-macos-arm64.tar.gz"
    sha256 "37f3f8e5f9737b3a1ee3ee4e1434aaab5f8e3391b05e618c4e44e63060e5b32d"
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/Joynik/KitFlow/releases/download/0.2.0/kitflow-0.2.0-linux-arm64.tar.gz"
      sha256 "1587713dd88f96f49afbb89bc565cb6881f49d917a0da518541498d51235b7be"
    else
      url "https://github.com/Joynik/KitFlow/releases/download/0.2.0/kitflow-0.2.0-linux-x86_64.tar.gz"
      sha256 "48f935baf9325760129b52365c4ed11ad881a251915a53a47acea6513913e445"
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
