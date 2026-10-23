# typed: strict
# frozen_string_literal: true

# Homebrew formula for Mackeep, the terminal version of the backup tool.
# It installs the standalone binary, no Python is needed.
class MackeepCli < Formula
  desc "Backup and keep your application settings in sync"
  homepage "https://github.com/Joynik/mackeep"
  version "0.24.0"
  license "GPL-3.0-or-later"

  on_macos do
    url "https://github.com/Joynik/mackeep/releases/download/0.24.0/mackeep-cli-0.24.0-macos-arm64.tar.gz"
    sha256 "5d235d8451a0813e5386955a82f79979c3fe0debb69f1fc7ea20151463f34204"
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/Joynik/mackeep/releases/download/0.24.0/mackeep-cli-0.24.0-linux-arm64.tar.gz"
      sha256 "e4a76c41fb5446dba00451d9156e50acc099b9fa3ec2d7cbe18174d5e056b39b"
    else
      url "https://github.com/Joynik/mackeep/releases/download/0.24.0/mackeep-cli-0.24.0-linux-x86_64.tar.gz"
      sha256 "3d5ed050ea0c9785b4b35a449103635ab5723febae5a9b53cae23899b2c90bab"
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
