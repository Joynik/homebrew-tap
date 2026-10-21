# typed: strict
# frozen_string_literal: true

# Homebrew formula for Mackeep, the terminal version of the backup tool.
# It installs the standalone binary, no Python is needed.
class MackeepCli < Formula
  desc "Backup and keep your application settings in sync"
  homepage "https://github.com/Joynik/mackeep"
  version "0.17.0"
  license "GPL-3.0-or-later"

  on_macos do
    url "https://github.com/Joynik/mackeep/releases/download/0.17.0/mackeep-cli-0.17.0-macos-arm64.tar.gz"
    sha256 "8d4658ddac886081545e1f49c42ecc231ad7598b5ef910bc5cc5a0d4c27a8c5e"
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/Joynik/mackeep/releases/download/0.17.0/mackeep-cli-0.17.0-linux-arm64.tar.gz"
      sha256 "d56f99d197247f34c0d52a155ed1c08b31d56fdd4b6efd6e9b5fca2532fb1f0a"
    else
      url "https://github.com/Joynik/mackeep/releases/download/0.17.0/mackeep-cli-0.17.0-linux-x86_64.tar.gz"
      sha256 "bd971bef5add15200e35a1fdb0a9fa7c71b4038d589882131ac18ed2ad045ab2"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  def install
    bin.install "mackeep-cli"
    # The alias, kept until the desktop version takes the name
    bin.install_symlink "mackeep-cli" => "mackeep"
  end

  test do
    assert_match "Mackeep", shell_output("#{bin}/mackeep-cli --version")
  end
end
