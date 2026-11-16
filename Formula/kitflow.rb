# frozen_string_literal: true

class Kitflow < Formula
  desc "Start projects and maintain configuration standards"
  homepage "https://github.com/Joynik/KitFlow"
  version "0.8.0"

  on_macos do
    depends_on macos: :sequoia
    depends_on arch: :arm64

    url "https://github.com/Joynik/KitFlow/releases/download/0.8.0/kitflow-0.8.0-macos-arm64.tar.gz"
    sha256 "54949bca304b2d16121f77112c6a713f4fc4e8d905ce5ef16cded7330e6ec2cb"
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/Joynik/KitFlow/releases/download/0.8.0/kitflow-0.8.0-linux-arm64.tar.gz"
      sha256 "5b4336325c75ef0ed33958c9120b5cd5290364b36eebc2137a83c6ae3d889fde"
    else
      url "https://github.com/Joynik/KitFlow/releases/download/0.8.0/kitflow-0.8.0-linux-x86_64.tar.gz"
      sha256 "a27ce367c80e76c1a7d5535e5e176b6537d0bb9835574ecf03d1a289ff081bbd"
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
