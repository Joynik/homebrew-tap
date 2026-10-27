# typed: strict
# frozen_string_literal: true

# Homebrew formula for Mackeep, the terminal version of the backup tool.
# It installs the standalone binary, no Python is needed.
class MackeepCli < Formula
  desc "Backup and keep your application settings in sync"
  homepage "https://github.com/Joynik/mackeep"
  version "0.25.0"
  license "GPL-3.0-or-later"

  on_macos do
    url "https://github.com/Joynik/mackeep/releases/download/0.25.0/mackeep-cli-0.25.0-macos-arm64.tar.gz"
    sha256 "a0107f5b20e2d5e5c633965bdf00afbfbc265ee793d3535b574e0bdfcbedfc34"
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/Joynik/mackeep/releases/download/0.25.0/mackeep-cli-0.25.0-linux-arm64.tar.gz"
      sha256 "4872985ceebd719713cb298dcdbd602d80701ec2f6ef9b177eb6a382a3fe1f86"
    else
      url "https://github.com/Joynik/mackeep/releases/download/0.25.0/mackeep-cli-0.25.0-linux-x86_64.tar.gz"
      sha256 "c4dc0111bdab145f2db37aa5e819650d54a248db397a750862f1086573ac23e9"
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
