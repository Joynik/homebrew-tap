# typed: strict
# frozen_string_literal: true

# Homebrew formula for Mackeep, the terminal version of the backup tool.
# It installs the standalone binary, no Python is needed.
class MackeepCli < Formula
  desc "Backup and keep your application settings in sync"
  homepage "https://github.com/Joynik/mackeep"
  version "0.26.1"
  license "GPL-3.0-or-later"

  on_macos do
    url "https://github.com/Joynik/mackeep/releases/download/0.26.1/mackeep-cli-0.26.1-macos-arm64.tar.gz"
    sha256 "25f2988b7f5438948a61e6bdf4ec96da11550f3ad07965b631594085ace82740"
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/Joynik/mackeep/releases/download/0.26.1/mackeep-cli-0.26.1-linux-arm64.tar.gz"
      sha256 "26d85bb9645a5a66116fa4f9a07459db61ccc01e51ed6ddcc73a23620bd6d7cb"
    else
      url "https://github.com/Joynik/mackeep/releases/download/0.26.1/mackeep-cli-0.26.1-linux-x86_64.tar.gz"
      sha256 "cd8f8c5625452e265daab7bfa9f09ba1b9ac5b905f055fc7a5f1ea4d9012bcf5"
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
