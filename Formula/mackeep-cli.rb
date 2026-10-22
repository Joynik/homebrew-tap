# typed: strict
# frozen_string_literal: true

# Homebrew formula for Mackeep, the terminal version of the backup tool.
# It installs the standalone binary, no Python is needed.
class MackeepCli < Formula
  desc "Backup and keep your application settings in sync"
  homepage "https://github.com/Joynik/mackeep"
  version "0.22.1"
  license "GPL-3.0-or-later"

  on_macos do
    url "https://github.com/Joynik/mackeep/releases/download/0.22.1/mackeep-cli-0.22.1-macos-arm64.tar.gz"
    sha256 "d917912acb5b102303dc763e00d915fcaac389419c108f7339da4ec67d71761b"
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/Joynik/mackeep/releases/download/0.22.1/mackeep-cli-0.22.1-linux-arm64.tar.gz"
      sha256 "7ed17626240f29d9b71f7dbe41dc86a047cf5d8426bb807a925263f6367d0365"
    else
      url "https://github.com/Joynik/mackeep/releases/download/0.22.1/mackeep-cli-0.22.1-linux-x86_64.tar.gz"
      sha256 "1a5c42568d6375ae81d35391f399c510167d8869e7c760148d45fb7d2bd72195"
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
