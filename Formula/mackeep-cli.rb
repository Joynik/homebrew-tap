# typed: strict
# frozen_string_literal: true

# Homebrew formula for Mackeep, the terminal version of the backup tool.
# It installs the standalone binary, no Python is needed.
class MackeepCli < Formula
  desc "Backup and keep your application settings in sync"
  homepage "https://github.com/Joynik/mackeep"
  version "0.26.3"
  license "GPL-3.0-or-later"

  on_macos do
    url "https://github.com/Joynik/mackeep/releases/download/0.26.3/mackeep-cli-0.26.3-macos-arm64.tar.gz"
    sha256 "2b35c32b11e50f19aa8defc6a19f5c626546e517eb684cc3b7365a4e1fc5d2ee"
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/Joynik/mackeep/releases/download/0.26.3/mackeep-cli-0.26.3-linux-arm64.tar.gz"
      sha256 "f68591ad9a3466e056e1abf2b3bc9c4ba7ba26ab64478aa433fdb34deba4e66d"
    else
      url "https://github.com/Joynik/mackeep/releases/download/0.26.3/mackeep-cli-0.26.3-linux-x86_64.tar.gz"
      sha256 "36d51b91b3ca7e9942936f70f47dc6427c138c419d48c5e0f13afbdf7968733e"
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
