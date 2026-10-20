# typed: strict
# frozen_string_literal: true

# Homebrew formula for Mackeep, the terminal version of the backup tool.
# It installs the standalone binary, no Python is needed.
class MackeepCli < Formula
  desc "Backup and keep your application settings in sync"
  homepage "https://github.com/Joynik/mackeep"
  version "0.16.0"
  license "GPL-3.0-or-later"

  on_macos do
    url "https://github.com/Joynik/mackeep/releases/download/0.16.0/mackeep-cli-0.16.0-macos-arm64.tar.gz"
    sha256 "a5381a089ab5d7667e443fb36089513820a57f2945e971bdd8fdececd1d59d8b"
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/Joynik/mackeep/releases/download/0.16.0/mackeep-cli-0.16.0-linux-arm64.tar.gz"
      sha256 "644987fa589e506f15c46b5dd27d096612343812a1c4c5414cd007adfb2713ed"
    else
      url "https://github.com/Joynik/mackeep/releases/download/0.16.0/mackeep-cli-0.16.0-linux-x86_64.tar.gz"
      sha256 "67b2d04a024e2a3160f197f32dd1e4b39e12bc53ace66d3d655c992f6071d418"
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
