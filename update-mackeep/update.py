"""Update the Mackeep formula from the GitHub release artifacts."""

import hashlib
import json
import os
import re
from pathlib import Path
from urllib.request import Request, urlopen

FORMULA = Path(__file__).resolve().parents[1] / "Formula" / "mackeep-cli.rb"
REPOSITORY = "Joynik/mackeep"
API_URL = f"https://api.github.com/repos/{REPOSITORY}/releases/latest"
VERSION_PATTERN = re.compile(r"^v?(\d+\.\d+\.\d+)\Z")
URL_PATTERN = re.compile(
    r'^  url "(https://github\.com/Joynik/mackeep/releases/download/[^"]+'
    r'/mackeep[^"]*\.tar\.gz)"$',
    re.MULTILINE,
)
VERSION_LINE_PATTERN = re.compile(r'^  version "([^"]+)"$', re.MULTILINE)
SHA256_PATTERN = re.compile(r'^  sha256 "([0-9a-f]{64})"$', re.MULTILINE)


def download(url: str) -> bytes:
    headers = {"User-Agent": "mackeep-formula-updater"}
    if token := os.environ.get("GITHUB_TOKEN"):
        headers["Authorization"] = f"Bearer {token}"
    with urlopen(Request(url, headers=headers), timeout=180) as response:
        return response.read()


def current_version(formula: str) -> str:
    if "class MackeepCli < Formula" not in formula:
        raise ValueError("Unexpected Mackeep formula")
    version = VERSION_LINE_PATTERN.search(formula)
    if not version:
        raise ValueError("Cannot determine current Mackeep formula version")
    return version.group(1)


def render(formula: str, version: str, checksum: str) -> str:
    """Update the URL, the version and the checksum of the formula."""
    url = (
        f"https://github.com/{REPOSITORY}/releases/download/{version}/"
        f"mackeep-cli-{version}-macos-arm64.tar.gz"
    )
    formula = URL_PATTERN.sub(f'  url "{url}"', formula, count=1)
    formula = VERSION_LINE_PATTERN.sub(f'  version "{version}"', formula, count=1)
    formula = SHA256_PATTERN.sub(f'  sha256 "{checksum}"', formula, count=1)
    return formula


def main() -> None:
    formula = FORMULA.read_text()
    installed_version = current_version(formula)
    release = json.loads(download(API_URL))
    tag = release["tag_name"]
    match = VERSION_PATTERN.fullmatch(tag)
    if not match or release["draft"] or release["prerelease"]:
        raise ValueError(f"Unexpected latest stable release: {tag}")
    version = match.group(1)
    if tuple(map(int, version.split("."))) <= tuple(
        map(int, installed_version.split("."))
    ):
        print(f"Mackeep {installed_version} is current; latest stable release is {version}")
        return

    name = f"mackeep-cli-{version}-macos-arm64.tar.gz"
    assets = {
        asset["name"]: asset
        for asset in release["assets"]
        if asset["state"] == "uploaded"
    }
    if name not in assets:
        print(f"Mackeep {version} is waiting for the {name} artifact")
        return

    asset = assets[name]
    data = download(asset["browser_download_url"])
    checksum = hashlib.sha256(data).hexdigest()
    if asset.get("digest") and asset["digest"] != f"sha256:{checksum}":
        raise ValueError(f"GitHub asset digest mismatch for {name}")

    FORMULA.write_text(render(formula, version, checksum))
    if output := os.environ.get("GITHUB_OUTPUT"):
        with Path(output).open("a") as stream:
            stream.write(f"changed=true\nversion={version}\n")
    print(f"Updated the Mackeep formula to {version}")


if __name__ == "__main__":
    main()
