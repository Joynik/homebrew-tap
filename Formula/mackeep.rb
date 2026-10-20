# typed: strict
# frozen_string_literal: true

# Homebrew formula for Mackeep, the backup tool for the application settings.
class Mackeep < PythonFormula
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

  depends_on "python@3.14"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Mackeep", shell_output("#{bin}/mackeep --version")
  end
end
