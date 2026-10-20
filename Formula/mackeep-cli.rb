# typed: strict
# frozen_string_literal: true

# Homebrew formula for Mackeep, the terminal version of the backup tool.
# It installs the standalone binary, no Python is needed.
class MackeepCli < Formula
  desc "Backup and keep your application settings in sync"
  homepage "https://github.com/Joynik/mackeep"
  url "https://github.com/Joynik/mackeep/releases/download/0.15.1/mackeep-cli-0.15.1-macos-arm64.tar.gz"
  version "0.15.1"
  sha256 "f23458af59dff21a4a314a98490be5b9fd39efb815c2521a504e85967b98ea16"
  license "GPL-3.0-or-later"

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
