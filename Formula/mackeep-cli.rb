# typed: strict
# frozen_string_literal: true

# Homebrew formula for Mackeep, the terminal version of the backup tool.
# It installs the standalone binary, no Python is needed.
class MackeepCli < Formula
  desc "Backup and keep your application settings in sync"
  homepage "https://github.com/Joynik/mackeep"
  version "0.18.0"
  license "GPL-3.0-or-later"

  on_macos do
    url "https://github.com/Joynik/mackeep/releases/download/0.18.0/mackeep-cli-0.18.0-macos-arm64.tar.gz"
    sha256 "7c7b3dcbea6d51a9bd3fe9697bb2c856fe6800e7f2a6087472484b7fcbacf0be"
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/Joynik/mackeep/releases/download/0.18.0/mackeep-cli-0.18.0-linux-arm64.tar.gz"
      sha256 "f0c41976a9b79b97ccb08e85e4eac9ae5edfa9b88947bc85fd63a43bf2b9d172"
    else
      url "https://github.com/Joynik/mackeep/releases/download/0.18.0/mackeep-cli-0.18.0-linux-x86_64.tar.gz"
      sha256 "9e952471266d364aff82f6b290146b5803ad0e9a1101489fa4fd82184a0029d0"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  def install
    # The package is a folder: the binary needs the runtime next to it
    libexec.install "mackeep-cli"
    bin.install_symlink libexec/"mackeep-cli/mackeep-cli" => "mackeep-cli"
    # The alias, kept until the desktop version takes the name
    bin.install_symlink libexec/"mackeep-cli/mackeep-cli" => "mackeep"
  end

  test do
    assert_match "Mackeep", shell_output("#{bin}/mackeep-cli --version")
  end
end
