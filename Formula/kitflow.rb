# frozen_string_literal: true

class Kitflow < Formula
  desc "Start projects and maintain configuration standards"
  homepage "https://github.com/Joynik/KitFlow"
  version "0.13.2"

  on_macos do
    depends_on macos: :sequoia
    depends_on arch: :arm64

    url "https://github.com/Joynik/KitFlow/releases/download/0.13.2/kitflow-0.13.2-macos-arm64.tar.gz"
    sha256 "ea80dd7a4445764d566190be05fae2b934b5dc2e025158ab1e111981a1ea3845"
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/Joynik/KitFlow/releases/download/0.13.2/kitflow-0.13.2-linux-arm64.tar.gz"
      sha256 "5793e658b5ebd7c119acf1a59f4954948e672aa9e720b12affb12e38d2161c7e"
    else
      url "https://github.com/Joynik/KitFlow/releases/download/0.13.2/kitflow-0.13.2-linux-x86_64.tar.gz"
      sha256 "d880c2999b7ab7b8404415abc8a77f9860b62198fb6e9546c38c6f5fd43a2e4e"
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
