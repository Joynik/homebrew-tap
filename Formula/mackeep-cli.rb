# typed: strict
# frozen_string_literal: true

# Homebrew formula for Mackeep, the terminal version of the backup tool.
# It installs the standalone binary, no Python is needed.
class MackeepCli < Formula
  desc "Backup and keep your application settings in sync"
  homepage "https://github.com/Joynik/mackeep"
  version "0.25.1"
  license "GPL-3.0-or-later"

  on_macos do
    url "https://github.com/Joynik/mackeep/releases/download/0.25.1/mackeep-cli-0.25.1-macos-arm64.tar.gz"
    sha256 "8ef96cded8be31e4efbbb3a3d1e4a25a1124890cb4be6d4d81975939cbd4439f"
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/Joynik/mackeep/releases/download/0.25.1/mackeep-cli-0.25.1-linux-arm64.tar.gz"
      sha256 "b011755373f6a721e76aa5cd64a4babe7d58567cfd695789c1078251f331102d"
    else
      url "https://github.com/Joynik/mackeep/releases/download/0.25.1/mackeep-cli-0.25.1-linux-x86_64.tar.gz"
      sha256 "3667c9d505dc875d1a91e7319bf194f8f8a285953095bb87d1b6ff86be824000"
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
