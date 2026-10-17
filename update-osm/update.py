"""Update the OSM formula from verified macOS binary release assets."""

import hashlib
import io
import json
import os
import re
import struct
import tarfile
import tomllib
from pathlib import Path
from urllib.request import Request, urlopen

FORMULA = Path(__file__).resolve().parents[1] / "Formula" / "osm.rb"
REPOSITORY = "Joynik/obsidian-semantic-mcp"
API_URL = f"https://api.github.com/repos/{REPOSITORY}/releases/latest"
TAG_PATTERN = re.compile(r"v(\d+\.\d+\.\d+)\Z")
BINARY_VERSION_PATTERN = re.compile(r'^  version "(\d+\.\d+\.\d+)"$', re.MULTILINE)
SOURCE_VERSION_PATTERN = re.compile(
    rf'^  url "https://github\.com/{REPOSITORY}/archive/refs/tags/v(\d+\.\d+\.\d+)\.tar\.gz"$',
    re.MULTILINE,
)
CPU_TYPES = {"arm64": 0x0100000C, "x86_64": 0x01000007}


def download(url: str) -> bytes:
    headers = {"User-Agent": "osm-formula-updater"}
    if token := os.environ.get("GITHUB_TOKEN"):
        headers["Authorization"] = f"Bearer {token}"
    with urlopen(Request(url, headers=headers), timeout=180) as response:
        return response.read()


def current_version(formula: str) -> tuple[str, bool]:
    if 'class Osm < Formula' not in formula or f'homepage "https://github.com/{REPOSITORY}"' not in formula:
        raise ValueError("Unexpected OSM formula")
    binary = BINARY_VERSION_PATTERN.search(formula)
    if binary:
        return binary.group(1), True
    source = SOURCE_VERSION_PATTERN.search(formula)
    if source:
        return source.group(1), False
    raise ValueError("Cannot determine current OSM formula version")


def validate_archive(data: bytes, architecture: str) -> None:
    with tarfile.open(fileobj=io.BytesIO(data), mode="r:gz") as archive:
        members = {member.name: member for member in archive.getmembers()}
        if set(members) != {"osm", "LICENSE"} or not all(
            member.isfile() for member in members.values()
        ):
            raise ValueError("OSM release archive has unexpected files")
        if not members["osm"].mode & 0o111:
            raise ValueError("OSM release executable lacks execute permission")
        executable = archive.extractfile(members["osm"])
        if executable is None:
            raise ValueError("OSM release executable is missing")
        magic, cpu_type = struct.unpack("<II", executable.read(8))
        if magic != 0xFEEDFACF or cpu_type != CPU_TYPES[architecture]:
            raise ValueError(f"OSM release archive is not macOS {architecture}")


def render_formula(version: str, checksums: dict[str, str]) -> str:
    urls = {
        architecture: (
            f"https://github.com/{REPOSITORY}/releases/download/v{version}/"
            f"osm-v{version}-macos-{architecture}.tar.gz"
        )
        for architecture in CPU_TYPES
    }
    return f'''class Osm < Formula
  desc "Local MCP server for semantic search in Obsidian vaults"
  homepage "https://github.com/{REPOSITORY}"
  version "{version}"
  license "Apache-2.0"

  depends_on :macos

  on_arm do
    url "{urls["arm64"]}"
    sha256 "{checksums["arm64"]}"
  end

  on_intel do
    url "{urls["x86_64"]}"
    sha256 "{checksums["x86_64"]}"
  end

  def install
    bin.install "osm"
  end

  test do
    assert_match "OSM v#{{version}}", shell_output("#{{bin}}/osm help")
  end
end
'''


def main() -> None:
    formula = FORMULA.read_text()
    installed_version, is_binary = current_version(formula)
    release = json.loads(download(API_URL))
    tag = release["tag_name"]
    match = TAG_PATTERN.fullmatch(tag)
    if not match or release["draft"] or release["prerelease"]:
        raise ValueError(f"Unexpected latest stable release: {tag}")
    version = match.group(1)
    if tuple(map(int, version.split("."))) < tuple(map(int, installed_version.split("."))) or (
        version == installed_version and is_binary
    ):
        print(f"OSM {installed_version} is current; latest stable release is {version}")
        return

    metadata_url = f"https://raw.githubusercontent.com/{REPOSITORY}/{tag}/pyproject.toml"
    project = tomllib.loads(download(metadata_url).decode("utf-8"))["project"]
    if project["name"] != "obsidian-semantic-mcp" or project["version"] != version:
        raise ValueError("Release tag does not match project metadata")

    assets = {asset["name"]: asset for asset in release["assets"] if asset["state"] == "uploaded"}
    expected = {arch: f"osm-{tag}-macos-{arch}.tar.gz" for arch in CPU_TYPES}
    if not all(name in assets for name in (*expected.values(), "SHA256SUMS")):
        print(f"OSM {tag} is waiting for both binary assets and SHA256SUMS")
        return
    manifest = download(assets["SHA256SUMS"]["browser_download_url"]).decode("utf-8")
    manifest_hashes = {}
    for line in manifest.splitlines():
        checksum, filename = line.split(maxsplit=1)
        manifest_hashes[filename.strip()] = checksum

    checksums = {}
    for architecture, filename in expected.items():
        asset = assets[filename]
        data = download(asset["browser_download_url"])
        checksum = hashlib.sha256(data).hexdigest()
        if manifest_hashes.get(filename) != checksum:
            raise ValueError(f"SHA256SUMS mismatch for {filename}")
        if asset.get("digest") and asset["digest"] != f"sha256:{checksum}":
            raise ValueError(f"GitHub asset digest mismatch for {filename}")
        validate_archive(data, architecture)
        checksums[architecture] = checksum

    FORMULA.write_text(render_formula(version, checksums))
    if output := os.environ.get("GITHUB_OUTPUT"):
        with Path(output).open("a") as stream:
            stream.write(f"changed=true\nversion={version}\n")
    print(f"Updated OSM formula to {version} for arm64 and x86_64")


if __name__ == "__main__":
    main()
