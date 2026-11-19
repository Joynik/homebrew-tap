# frozen_string_literal: true

class Kitflow < Formula
  desc "Start projects and maintain configuration standards"
  homepage "https://github.com/Joynik/KitFlow"
  version "0.18.1"

  on_macos do
    depends_on macos: :sequoia
    depends_on arch: :arm64

    url "https://github.com/Joynik/KitFlow/releases/download/0.18.1/kitflow-0.18.1-macos-arm64.tar.gz"
    sha256 "89eed312dda0c56fb536b421b8f3c9136b21079b06ca457482f8e086b443b9f8"
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/Joynik/KitFlow/releases/download/0.18.1/kitflow-0.18.1-linux-arm64.tar.gz"
      sha256 "ffccd22da45eb8736c948b3956745c2303ee90cea6e53efdd57e87e65db46a55"
    else
      url "https://github.com/Joynik/KitFlow/releases/download/0.18.1/kitflow-0.18.1-linux-x86_64.tar.gz"
      sha256 "3a597eaf6c03f0d6957a88f820695830c001676ff700d375bbabe0e6444bccd0"
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
