# typed: strict
# frozen_string_literal: true

# Homebrew formula for Mackeep, the backup tool for the application settings.
class Mackeep < Formula
  include Language::Python::Virtualenv

  desc "Backup and keep your application settings in sync"
  homepage "https://github.com/Joynik/mackeep"
  url "https://github.com/Joynik/mackeep/releases/download/0.12.1/mackeep-0.12.1.tar.gz"
  version "0.12.1"
  sha256 "340524b7e253c5532847f71961885f15fc3891d65c12050c0ca1365cafbaa5c8"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  # The only runtime dependency of Mackeep
  resource "docopt_ng",
           url: "https://files.pythonhosted.org/packages/6c/4a/c3b77fc1a24510b08918b43a473410c0168f6e657118807015f1f1edceea/docopt_ng-0.9.0-py3-none-any.whl",
           sha256: "bfe4c8b03f9fca424c24ee0b4ffa84bf7391cb18c29ce0f6a8227a3b01b81ff9"

  depends_on "python@3.14"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Mackeep", shell_output("#{bin}/mackeep --version")
  end
end
