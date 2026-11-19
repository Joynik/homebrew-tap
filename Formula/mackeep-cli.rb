# typed: strict
# frozen_string_literal: true

# Homebrew formula for Mackeep, the terminal version of the backup tool.
# It installs the standalone binary, no Python is needed.
class MackeepCli < Formula
  desc "Backup and keep your application settings in sync"
  homepage "https://github.com/Joynik/mackeep"
  version "0.27.0"
  license "GPL-3.0-or-later"

  on_macos do
    url "https://github.com/Joynik/mackeep/releases/download/0.27.0/mackeep-cli-0.27.0-macos-arm64.tar.gz"
    sha256 "60681657379a2481d1898d65249c74d704335c3c64f9b74672a2e34a74164ba4"
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/Joynik/mackeep/releases/download/0.27.0/mackeep-cli-0.27.0-linux-arm64.tar.gz"
      sha256 "2860ed248e98ae3c7f37d80ea1619122ffecf59035a17a2814c4526eb2d99b9d"
    else
      url "https://github.com/Joynik/mackeep/releases/download/0.27.0/mackeep-cli-0.27.0-linux-x86_64.tar.gz"
      sha256 "772cce7bf58e8de8d7b9904fb60f2ddb21801bcd6e2c461a104501dc36b51662"
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
