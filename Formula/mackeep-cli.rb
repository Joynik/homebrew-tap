# typed: strict
# frozen_string_literal: true

# Homebrew formula for Mackeep, the terminal version of the backup tool.
# It installs the standalone binary, no Python is needed.
class MackeepCli < Formula
  desc "Backup and keep your application settings in sync"
  homepage "https://github.com/Joynik/mackeep"
  version "0.26.0"
  license "GPL-3.0-or-later"

  on_macos do
    url "https://github.com/Joynik/mackeep/releases/download/0.26.0/mackeep-cli-0.26.0-macos-arm64.tar.gz"
    sha256 "f4fcc88141376290b89c5ab5a2b2e43f9faea4985823d00985da4f1394ed6e12"
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/Joynik/mackeep/releases/download/0.26.0/mackeep-cli-0.26.0-linux-arm64.tar.gz"
      sha256 "bf9459b50153d6de1e0d532e8bb7f1154324dd3a16b640c583859ffb0ce7cdb4"
    else
      url "https://github.com/Joynik/mackeep/releases/download/0.26.0/mackeep-cli-0.26.0-linux-x86_64.tar.gz"
      sha256 "4228ce718a25ea0ad30d10dc1ea24ed788f3107a9555509fae70a5380d71e4cf"
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
