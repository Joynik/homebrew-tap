# typed: strict
# frozen_string_literal: true

# Homebrew formula for Mackeep, the terminal version of the backup tool.
# It installs the standalone binary, no Python is needed.
class MackeepCli < Formula
  desc "Backup and keep your application settings in sync"
  homepage "https://github.com/Joynik/mackeep"
  version "0.23.2"
  license "GPL-3.0-or-later"

  on_macos do
    url "https://github.com/Joynik/mackeep/releases/download/0.23.2/mackeep-cli-0.23.2-macos-arm64.tar.gz"
    sha256 "bd431308084127ba4b3d6cb47b6d656fe70d01d650f54dee6f3a6b6a2bba3953"
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/Joynik/mackeep/releases/download/0.23.2/mackeep-cli-0.23.2-linux-arm64.tar.gz"
      sha256 "fd9ee690b100609aa4344e6bcec8bee46e54addf38e8e0fd05ff942d2267a685"
    else
      url "https://github.com/Joynik/mackeep/releases/download/0.23.2/mackeep-cli-0.23.2-linux-x86_64.tar.gz"
      sha256 "99e8818a92134a01bd76e63c785bf92eaa2b55a3bdea7966b17b674a00ab303e"
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
