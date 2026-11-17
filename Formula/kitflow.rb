# frozen_string_literal: true

class Kitflow < Formula
  desc "Start projects and maintain configuration standards"
  homepage "https://github.com/Joynik/KitFlow"
  version "0.10.0"

  on_macos do
    depends_on macos: :sequoia
    depends_on arch: :arm64

    url "https://github.com/Joynik/KitFlow/releases/download/0.10.0/kitflow-0.10.0-macos-arm64.tar.gz"
    sha256 "a1b431d24cf84ea1227a78309cdfdd0e99df9650fecf6e7481353f0d13ff47df"
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/Joynik/KitFlow/releases/download/0.10.0/kitflow-0.10.0-linux-arm64.tar.gz"
      sha256 "c4ccae423d5cf90759e6e68fc72642e0a024c2aa7ec6b3709cd4ca65e9323647"
    else
      url "https://github.com/Joynik/KitFlow/releases/download/0.10.0/kitflow-0.10.0-linux-x86_64.tar.gz"
      sha256 "f7e5a0b8fd26e44acd935cbdfd6c6e59fcbb978d7207b6b2e7df9976e9d0384c"
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
