"""Safety checks for the Mackeep formula updater."""

import hashlib
import importlib.util
import json
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

MODULE_PATH = Path(__file__).with_name("update.py")
spec = importlib.util.spec_from_file_location("mackeep_updater", MODULE_PATH)
updater = importlib.util.module_from_spec(spec)
spec.loader.exec_module(updater)

ORIGINAL = """# typed: strict
# frozen_string_literal: true

class Mackeep < Formula
  include Language::Python::Virtualenv

  desc "Backup and keep your application settings in sync"
  homepage "https://github.com/Joynik/mackeep"
  url "https://github.com/Joynik/mackeep/releases/download/0.12.1/mackeep-0.12.1.tar.gz"
  version "0.12.1"
  sha256 "340524b7e253c5532847f71961885f15fc3891d65c12050c0ca1365cafbaa5c8"
  license "GPL-3.0-or-later"

  resource "docopt_ng" do
    url "https://files.pythonhosted.org/packages/6c/4a/docopt_ng-0.9.0-py3-none-any.whl"
    sha256 "bfe4c8b03f9fca424c24ee0b4ffa84bf7391cb18c29ce0f6a8227a3b01b81ff9"
  end

  depends_on "python@3.14"

  def install
    virtualenv_install_with_resources
  end
end
"""


class UpdateMackeepTest(unittest.TestCase):
    def setUp(self):
        self.directory = tempfile.TemporaryDirectory()
        self.addCleanup(self.directory.cleanup)
        self.formula = Path(self.directory.name) / "mackeep.rb"
        self.formula.write_text(ORIGINAL)
        self.formula_patch = patch.object(updater, "FORMULA", self.formula)
        self.formula_patch.start()
        self.addCleanup(self.formula_patch.stop)

    def fixture(self, version="0.13.0", missing=False, wrong_digest=False):
        data = f"sdist of {version}".encode()
        checksum = hashlib.sha256(data).hexdigest()
        assets = [
            {
                "name": f"mackeep-cli-{version}-macos-arm64.tar.gz",
                "state": "uploaded",
                "browser_download_url": f"https://assets.example/{version}",
                "digest": "sha256:" + ("0" * 64 if wrong_digest else checksum),
            }
        ]
        if missing:
            assets = []
        release = {
            "tag_name": version,
            "draft": False,
            "prerelease": False,
            "assets": assets,
        }
        downloads = {
            updater.API_URL: json.dumps(release).encode(),
            f"https://assets.example/{version}": data,
        }
        return downloads, checksum

    def test_updates_the_version_url_and_checksum(self):
        downloads, checksum = self.fixture()
        with patch.object(updater, "download", side_effect=downloads.__getitem__):
            updater.main()
        formula = self.formula.read_text()
        self.assertIn('version "0.13.0"', formula)
        self.assertIn(
            "https://github.com/Joynik/mackeep/releases/download/0.13.0/"
            "mackeep-cli-0.13.0-macos-arm64.tar.gz",
            formula,
        )
        self.assertIn(checksum, formula)
        # The rest of the formula is untouched
        self.assertIn('depends_on "python@3.14"', formula)
        self.assertIn('resource "docopt_ng" do', formula)
        self.assertIn("virtualenv_install_with_resources", formula)

    def test_older_release_keeps_the_previous_formula(self):
        downloads, _ = self.fixture(version="0.11.0")
        with patch.object(updater, "download", side_effect=downloads.__getitem__):
            updater.main()
        self.assertEqual(self.formula.read_text(), ORIGINAL)

    def test_missing_artifact_keeps_the_previous_formula(self):
        downloads, _ = self.fixture(missing=True)
        with patch.object(updater, "download", side_effect=downloads.__getitem__):
            updater.main()
        self.assertEqual(self.formula.read_text(), ORIGINAL)

    def test_wrong_digest_keeps_the_previous_formula(self):
        downloads, _ = self.fixture(wrong_digest=True)
        with patch.object(updater, "download", side_effect=downloads.__getitem__):
            with self.assertRaisesRegex(ValueError, "digest mismatch"):
                updater.main()
        self.assertEqual(self.formula.read_text(), ORIGINAL)


if __name__ == "__main__":
    unittest.main()
