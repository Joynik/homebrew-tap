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

class MackeepCli < Formula
  desc "Backup and keep your application settings in sync"
  homepage "https://github.com/Joynik/mackeep"
  version "0.12.1"
  license "GPL-3.0-or-later"

  on_macos do
    url "https://github.com/Joynik/mackeep/releases/download/0.12.1/mackeep-cli-0.12.1-macos-arm64.tar.gz"
    sha256 "e342ca7954482f510f8de66112791496ff52a8faa6e39591a20506bb0716cf7e"
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/Joynik/mackeep/releases/download/0.12.1/mackeep-cli-0.12.1-linux-arm64.tar.gz"
      sha256 "2340b5805594a9829e782f829585abde82d9a06f2eb9bcb964c916dfc200ac67"
    else
      url "https://github.com/Joynik/mackeep/releases/download/0.12.1/mackeep-cli-0.12.1-linux-x86_64.tar.gz"
      sha256 "a814cca37cf478eee4a0c36619cf19570328b746e3a4c2f136658a21e07edf95"
    end
  end

  def install
    bin.install "mackeep-cli"
  end
end
"""


class UpdateMackeepTest(unittest.TestCase):
    def setUp(self):
        self.directory = tempfile.TemporaryDirectory()
        self.addCleanup(self.directory.cleanup)
        self.formula = Path(self.directory.name) / "mackeep-cli.rb"
        self.formula.write_text(ORIGINAL)
        self.formula_patch = patch.object(updater, "FORMULA", self.formula)
        self.formula_patch.start()
        self.addCleanup(self.formula_patch.stop)

    def fixture(self, version="0.13.0", missing=False, wrong_digest=False):
        downloads = {}
        assets = []
        for platform in updater.PLATFORMS:
            data = f"binary of {version} for {platform}".encode()
            checksum = hashlib.sha256(data).hexdigest()
            url = f"https://assets.example/{version}/{platform}"
            downloads[url] = data
            assets.append(
                {
                    "name": f"mackeep-cli-{version}-{platform}.tar.gz",
                    "state": "uploaded",
                    "browser_download_url": url,
                    "digest": "sha256:" + ("0" * 64 if wrong_digest else checksum),
                },
            )
        if missing:
            assets = []
        release = {
            "tag_name": version,
            "draft": False,
            "prerelease": False,
            "assets": assets,
        }
        downloads[updater.API_URL] = json.dumps(release).encode()
        return downloads, assets

    def test_updates_the_version_url_and_checksum(self):
        downloads, assets = self.fixture()
        with patch.object(updater, "download", side_effect=downloads.__getitem__):
            updater.main()
        formula = self.formula.read_text()
        self.assertIn('version "0.13.0"', formula)
        for asset in assets:
            self.assertIn(
                f"https://github.com/Joynik/mackeep/releases/download/0.13.0/"
                f"{asset['name']}",
                formula,
            )
            checksum = hashlib.sha256(
                downloads[asset["browser_download_url"]]
            ).hexdigest()
            self.assertIn(checksum, formula)
        # The rest of the formula is untouched
        self.assertIn("on_macos do", formula)
        self.assertIn("on_linux do", formula)
        self.assertIn('bin.install "mackeep-cli"', formula)

    def test_the_urls_of_the_old_version_are_gone(self):
        downloads, _ = self.fixture()
        with patch.object(updater, "download", side_effect=downloads.__getitem__):
            updater.main()
        formula = self.formula.read_text()
        self.assertNotIn("0.12.1/mackeep-cli", formula)

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

    def test_missing_one_artifact_keeps_the_previous_formula(self):
        downloads, assets = self.fixture()
        # The artifact of one platform is missing
        downloads2 = dict(downloads)
        release = json.loads(downloads[updater.API_URL])
        release["assets"] = assets[:-1]
        downloads2[updater.API_URL] = json.dumps(release).encode()
        with patch.object(updater, "download", side_effect=downloads2.__getitem__):
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
