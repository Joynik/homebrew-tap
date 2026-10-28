# typed: strict
# frozen_string_literal: true

# Homebrew formula for Mackeep, the terminal version of the backup tool.
# It installs the standalone binary, no Python is needed.
class MackeepCli < Formula
  desc "Backup and keep your application settings in sync"
  homepage "https://github.com/Joynik/mackeep"
  version "0.25.2"
  license "GPL-3.0-or-later"

  on_macos do
    url "https://github.com/Joynik/mackeep/releases/download/0.25.2/mackeep-cli-0.25.2-macos-arm64.tar.gz"
    sha256 "ef0158bdf22508e23cdc231944dc49c8747c8fffff6d54e41229679cc88ede6f"
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/Joynik/mackeep/releases/download/0.25.2/mackeep-cli-0.25.2-linux-arm64.tar.gz"
      sha256 "8cbcdd65ee67f835a6cf060e91593f33088554eb3055998e163ae8109960f4ce"
    else
      url "https://github.com/Joynik/mackeep/releases/download/0.25.2/mackeep-cli-0.25.2-linux-x86_64.tar.gz"
      sha256 "0a04c406cac71e6ce573cc82e37b7250e665b62e39687ca419d029c12eeee4f9"
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
