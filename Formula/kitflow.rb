# frozen_string_literal: true

class Kitflow < Formula
  desc "Start projects and maintain configuration standards"
  homepage "https://github.com/Joynik/KitFlow"
  version "0.12.0"

  on_macos do
    depends_on macos: :sequoia
    depends_on arch: :arm64

    url "https://github.com/Joynik/KitFlow/releases/download/0.12.0/kitflow-0.12.0-macos-arm64.tar.gz"
    sha256 "9fd6c5d38c64b9404a6629ebc13f6d81d7473a70fa43171000d05e620b40b17c"
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/Joynik/KitFlow/releases/download/0.12.0/kitflow-0.12.0-linux-arm64.tar.gz"
      sha256 "01cf52cf7be0a29d7bf5fe6beb3575e4c5df6129db7a3424f490ca3ad491a0e3"
    else
      url "https://github.com/Joynik/KitFlow/releases/download/0.12.0/kitflow-0.12.0-linux-x86_64.tar.gz"
      sha256 "f907e3fe6d1d2f0befa7620ac4b6e94e50c6ae3f9e9958da13ecd0ef3ce14217"
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
