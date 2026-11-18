# frozen_string_literal: true

class Kitflow < Formula
  desc "Start projects and maintain configuration standards"
  homepage "https://github.com/Joynik/KitFlow"
  version "0.14.1"

  on_macos do
    depends_on macos: :sequoia
    depends_on arch: :arm64

    url "https://github.com/Joynik/KitFlow/releases/download/0.14.1/kitflow-0.14.1-macos-arm64.tar.gz"
    sha256 "893fd9f705c82645c7c850c4623ce29b611bb3861b72e742e4e80ad22ea6ab57"
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/Joynik/KitFlow/releases/download/0.14.1/kitflow-0.14.1-linux-arm64.tar.gz"
      sha256 "7922a1ee88c03f9dfa264acf327073f8090166f320c49d2f2de1bd453fa57feb"
    else
      url "https://github.com/Joynik/KitFlow/releases/download/0.14.1/kitflow-0.14.1-linux-x86_64.tar.gz"
      sha256 "67498aac4be61ae1de4f416f0883757351631654ee034fc582e26e81249ed7bb"
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
