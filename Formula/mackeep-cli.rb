# typed: strict
# frozen_string_literal: true

# Homebrew formula for Mackeep, the terminal version of the backup tool.
# It installs the standalone binary, no Python is needed.
class MackeepCli < Formula
  desc "Backup and keep your application settings in sync"
  homepage "https://github.com/Joynik/mackeep"
  version "0.19.0"
  license "GPL-3.0-or-later"

  on_macos do
    url "https://github.com/Joynik/mackeep/releases/download/0.19.0/mackeep-cli-0.19.0-macos-arm64.tar.gz"
    sha256 "9147102938ff4e50643c7c7e8e52506ed846edde2e1731fc574132b38c1c5025"
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/Joynik/mackeep/releases/download/0.19.0/mackeep-cli-0.19.0-linux-arm64.tar.gz"
      sha256 "4feed83ae6479fb2e22cec82da34832e719cb00c44cc33859ce7cfe219d12d15"
    else
      url "https://github.com/Joynik/mackeep/releases/download/0.19.0/mackeep-cli-0.19.0-linux-x86_64.tar.gz"
      sha256 "67ee9f2c0237dfbe5de2cbc678309c339d6a3176c7f45b7f0361e174644db8d5"
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
