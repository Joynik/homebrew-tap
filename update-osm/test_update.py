"""Safety checks for the OSM binary formula updater."""

import hashlib
import importlib.util
import io
import json
import struct
import tarfile
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

MODULE_PATH = Path(__file__).with_name("update.py")
spec = importlib.util.spec_from_file_location("osm_updater", MODULE_PATH)
updater = importlib.util.module_from_spec(spec)
spec.loader.exec_module(updater)


def archive_for(cpu_type: int) -> bytes:
    output = io.BytesIO()
    with tarfile.open(fileobj=output, mode="w:gz") as archive:
        for name, content, mode in (
            ("osm", struct.pack("<II", 0xFEEDFACF, cpu_type) + b"binary", 0o755),
            ("LICENSE", b"license", 0o644),
        ):
            info = tarfile.TarInfo(name)
            info.size = len(content)
            info.mode = mode
            archive.addfile(info, io.BytesIO(content))
    return output.getvalue()


class UpdateOsmTest(unittest.TestCase):
    def setUp(self):
        self.directory = tempfile.TemporaryDirectory()
        self.addCleanup(self.directory.cleanup)
        self.formula = Path(self.directory.name) / "osm.rb"
        self.original = (
            'class Osm < Formula\n'
            '  homepage "https://github.com/Joynik/obsidian-semantic-mcp"\n'
            '  url "https://github.com/Joynik/obsidian-semantic-mcp/archive/refs/tags/v0.45.1.tar.gz"\n'
            '  sha256 "' + 'a' * 64 + '"\nend\n'
        )
        self.formula.write_text(self.original)
        self.formula_patch = patch.object(updater, "FORMULA", self.formula)
        self.formula_patch.start()
        self.addCleanup(self.formula_patch.stop)

    def fixture(self, missing=None, wrong_architecture=False):
        tag = "v0.47.0"
        files = {
            arch: archive_for(
                updater.CPU_TYPES["x86_64"] if wrong_architecture and arch == "arm64"
                else updater.CPU_TYPES[arch]
            )
            for arch in updater.CPU_TYPES
        }
        checksums = {arch: hashlib.sha256(data).hexdigest() for arch, data in files.items()}
        manifest = "".join(
            f"{checksums[arch]}  osm-{tag}-macos-{arch}.tar.gz\n" for arch in files
        ).encode()
        assets = [
            {
                "name": f"osm-{tag}-macos-{arch}.tar.gz",
                "state": "uploaded",
                "browser_download_url": f"https://assets.example/{arch}",
                "digest": f"sha256:{checksums[arch]}",
            }
            for arch in files
        ]
        assets.append(
            {
                "name": "SHA256SUMS",
                "state": "uploaded",
                "browser_download_url": "https://assets.example/SHA256SUMS",
            }
        )
        if missing:
            assets = [asset for asset in assets if asset["name"] != missing]
        release = {"tag_name": tag, "draft": False, "prerelease": False, "assets": assets}
        downloads = {
            updater.API_URL: json.dumps(release).encode(),
            f"https://raw.githubusercontent.com/{updater.REPOSITORY}/{tag}/pyproject.toml": (
                b'[project]\nname = "obsidian-semantic-mcp"\nversion = "0.47.0"\n'
            ),
            "https://assets.example/SHA256SUMS": manifest,
            **{f"https://assets.example/{arch}": data for arch, data in files.items()},
        }
        return downloads, checksums

    def test_updates_both_architectures_without_python_dependencies(self):
        downloads, checksums = self.fixture()
        with patch.object(updater, "download", side_effect=downloads.__getitem__):
            updater.main()
        formula = self.formula.read_text()
        self.assertIn('version "0.47.0"', formula)
        self.assertIn('depends_on :macos', formula)
        self.assertNotIn('depends_on "python@3.14"', formula)
        self.assertNotIn('depends_on "uv"', formula)
        for architecture, checksum in checksums.items():
            self.assertIn(f"osm-v0.47.0-macos-{architecture}.tar.gz", formula)
            self.assertIn(checksum, formula)

    def test_incomplete_release_keeps_previous_formula(self):
        downloads, _ = self.fixture(missing="osm-v0.47.0-macos-x86_64.tar.gz")
        with patch.object(updater, "download", side_effect=downloads.__getitem__):
            updater.main()
        self.assertEqual(self.formula.read_text(), self.original)

    def test_wrong_architecture_keeps_previous_formula(self):
        downloads, _ = self.fixture(wrong_architecture=True)
        with patch.object(updater, "download", side_effect=downloads.__getitem__):
            with self.assertRaisesRegex(ValueError, "not macOS arm64"):
                updater.main()
        self.assertEqual(self.formula.read_text(), self.original)


if __name__ == "__main__":
    unittest.main()
