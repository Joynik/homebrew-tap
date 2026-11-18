# typed: strict
# frozen_string_literal: true

# Homebrew formula for Mackeep, the terminal version of the backup tool.
# It installs the standalone binary, no Python is needed.
class MackeepCli < Formula
  desc "Backup and keep your application settings in sync"
  homepage "https://github.com/Joynik/mackeep"
  version "0.26.4"
  license "GPL-3.0-or-later"

  on_macos do
    url "https://github.com/Joynik/mackeep/releases/download/0.26.4/mackeep-cli-0.26.4-macos-arm64.tar.gz"
    sha256 "5a1db167dc2d27ddf6344c85e1d76c641fe8c9d50016f8676655affaa60537cd"
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/Joynik/mackeep/releases/download/0.26.4/mackeep-cli-0.26.4-linux-arm64.tar.gz"
      sha256 "14600e792857786f833b731c0163245bb28e65a6391dc3fc39bd1d3d746185b0"
    else
      url "https://github.com/Joynik/mackeep/releases/download/0.26.4/mackeep-cli-0.26.4-linux-x86_64.tar.gz"
      sha256 "adc3620b7e810a679f9d86f395e1eb4db4c7349fc1088243ef1b6e1d3b67a9b1"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  def install
    # The package is a folder: the binary needs the runtime next to it.
    # Homebrew unpacks the folder of the package, so its content is here.
    libexec.install Dir["*"]
    bin.install_symlink libexec/"mackeep-cli" => "mackeep-cli"
    # The alias, kept until the desktop version takes the name
    bin.install_symlink libexec/"mackeep-cli" => "mackeep"
  end

  test do
    assert_match "Mackeep", shell_output("#{bin}/mackeep-cli --version")
  end
end
