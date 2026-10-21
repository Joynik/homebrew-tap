# typed: strict
# frozen_string_literal: true

# Homebrew formula for Mackeep, the terminal version of the backup tool.
# It installs the standalone binary, no Python is needed.
class MackeepCli < Formula
  desc "Backup and keep your application settings in sync"
  homepage "https://github.com/Joynik/mackeep"
  version "0.20.0"
  license "GPL-3.0-or-later"

  on_macos do
    url "https://github.com/Joynik/mackeep/releases/download/0.20.0/mackeep-cli-0.20.0-macos-arm64.tar.gz"
    sha256 "84f3421e1a15fb97c1952bf79279b7ba8a28b4d86a5bce00abdf368fa4639446"
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/Joynik/mackeep/releases/download/0.20.0/mackeep-cli-0.20.0-linux-arm64.tar.gz"
      sha256 "978b63a5832bc627dbe24a4b0f4c7a2a1ef26d37980675393111e71007ac3b40"
    else
      url "https://github.com/Joynik/mackeep/releases/download/0.20.0/mackeep-cli-0.20.0-linux-x86_64.tar.gz"
      sha256 "9f1f3193fad1a0c82fe8f30756a67425f5d6675ce1e0f947155462873d3599f7"
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
