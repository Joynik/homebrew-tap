# typed: strict
# frozen_string_literal: true

# Homebrew formula for Mackeep, the terminal version of the backup tool.
# It installs the standalone binary, no Python is needed.
class MackeepCli < Formula
  desc "Backup and keep your application settings in sync"
  homepage "https://github.com/Joynik/mackeep"
  version "0.23.0"
  license "GPL-3.0-or-later"

  on_macos do
    url "https://github.com/Joynik/mackeep/releases/download/0.23.0/mackeep-cli-0.23.0-macos-arm64.tar.gz"
    sha256 "ec06d640c7ef6b8f646ddddb970d2faf9a736ca078d945def09c2e5c42783cd2"
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/Joynik/mackeep/releases/download/0.23.0/mackeep-cli-0.23.0-linux-arm64.tar.gz"
      sha256 "6a3eb784194fbdb9bd22665376b54799b31852c56aab9c587165bb96acd7556f"
    else
      url "https://github.com/Joynik/mackeep/releases/download/0.23.0/mackeep-cli-0.23.0-linux-x86_64.tar.gz"
      sha256 "ce6bc7fb917a42e44cb1e6e1ff2475d40f090e4937c612a90febfeef22954bb6"
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
