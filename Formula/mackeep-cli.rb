# typed: strict
# frozen_string_literal: true

# Homebrew formula for Mackeep, the terminal version of the backup tool.
# It installs the standalone binary, no Python is needed.
class MackeepCli < Formula
  desc "Backup and keep your application settings in sync"
  homepage "https://github.com/Joynik/mackeep"
  version "0.26.2"
  license "GPL-3.0-or-later"

  on_macos do
    url "https://github.com/Joynik/mackeep/releases/download/0.26.2/mackeep-cli-0.26.2-macos-arm64.tar.gz"
    sha256 "941f9b3c3d67befd5853421c86ffad633aa17bc6325026e6a0e6040b89be88e5"
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/Joynik/mackeep/releases/download/0.26.2/mackeep-cli-0.26.2-linux-arm64.tar.gz"
      sha256 "f4426f6ce14dcc6aabadc7d1150db856d50656bcd3bfd1c569348de408ee0a04"
    else
      url "https://github.com/Joynik/mackeep/releases/download/0.26.2/mackeep-cli-0.26.2-linux-x86_64.tar.gz"
      sha256 "9af19a94ab8dcee90338fd803c8e77d78bf972d30c31be7a87527897b7d35c3d"
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
