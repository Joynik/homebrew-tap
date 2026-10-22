# typed: strict
# frozen_string_literal: true

# Homebrew formula for Mackeep, the terminal version of the backup tool.
# It installs the standalone binary, no Python is needed.
class MackeepCli < Formula
  desc "Backup and keep your application settings in sync"
  homepage "https://github.com/Joynik/mackeep"
  version "0.22.0"
  license "GPL-3.0-or-later"

  on_macos do
    url "https://github.com/Joynik/mackeep/releases/download/0.22.0/mackeep-cli-0.22.0-macos-arm64.tar.gz"
    sha256 "cea8d05bc376d2885155e0e972e949a3b1ece326192ccea72ce05aa2739d4139"
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/Joynik/mackeep/releases/download/0.22.0/mackeep-cli-0.22.0-linux-arm64.tar.gz"
      sha256 "587a01db2b027ebcf1ab4dc15e96123f80f2abd569130a165de9a36a9da57a19"
    else
      url "https://github.com/Joynik/mackeep/releases/download/0.22.0/mackeep-cli-0.22.0-linux-x86_64.tar.gz"
      sha256 "8cc8b25218c1161d035646cacb7b232f9636b19c2cf4bad31222e426ceefccea"
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
