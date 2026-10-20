# typed: strict
# frozen_string_literal: true

# Homebrew formula for Mackeep, the terminal version of the backup tool.
class MackeepCli < Formula
  include Language::Python::Virtualenv

  desc "Backup and keep your application settings in sync"
  homepage "https://github.com/Joynik/mackeep"
  url "https://github.com/Joynik/mackeep/releases/download/0.14.0/mackeep-cli-0.14.0-macos-arm64.tar.gz"
  version "0.14.0"
  sha256 "7702ec48cacac85208e8ebd0d8e6ea58ee8088e5fe0320e964ee578f38406ac0"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "python@3.14"

  # The only runtime dependency of Mackeep
  resource "docopt_ng" do
    url "https://files.pythonhosted.org/packages/6c/4a/c3b77fc1a24510b08918b43a473410c0168f6e657118807015f1f1edceea/docopt_ng-0.9.0-py3-none-any.whl"
    sha256 "bfe4c8b03f9fca424c24ee0b4ffa84bf7391cb18c29ce0f6a8227a3b01b81ff9"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Mackeep", shell_output("#{bin}/mackeep-cli --version")
  end
end
