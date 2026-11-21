# frozen_string_literal: true

class Kitflow < Formula
  desc "Start projects and maintain configuration standards"
  homepage "https://github.com/Joynik/KitFlow"
  version "0.21.0"

  on_macos do
    depends_on macos: :sequoia
    depends_on arch: :arm64

    url "https://github.com/Joynik/KitFlow/releases/download/0.21.0/kitflow-0.21.0-macos-arm64.tar.gz"
    sha256 "99559412cd0df19471a78bcd081a2847a004271707602e011572e932c457081c"
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/Joynik/KitFlow/releases/download/0.21.0/kitflow-0.21.0-linux-arm64.tar.gz"
      sha256 "bab5f913918c9c79fc50edcd4dd0b7e3614f100f971414a6fde58c01fbbecd4c"
    else
      url "https://github.com/Joynik/KitFlow/releases/download/0.21.0/kitflow-0.21.0-linux-x86_64.tar.gz"
      sha256 "35c3145529801c440b4924fea61232d77e1b855dd69d9f29b76d21b4d96a3806"
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
