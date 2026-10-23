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

# The platforms of the releases, the suffix of the asset of every platform.
PLATFORMS: tuple[str, ...] = (
    "macos-arm64",
    "linux-x86_64",
    "linux-arm64",
)

VERSION_LINE_PATTERN = re.compile(r'^  version "([^"]+)"$', re.MULTILINE)
URL_LINE_PATTERN = re.compile(r'^(?P<prefix>\s*url ")(?P<url>[^"]+)(?P<suffix>")$')
SHA256_LINE_PATTERN = re.compile(
    r'^(?P<prefix>\s*sha256 ")(?P<sha>[0-9a-f]{64})(?P<suffix>")$',
)


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


def asset_url(version: str, platform: str) -> str:
    """
    Get the URL of the asset of a platform.

    Args:
        version (str): The version of the release.
        platform (str): The suffix of the platform.

    Returns:
        str
    """
    return (
        f"https://github.com/{REPOSITORY}/releases/download/{version}/"
        f"mackeep-cli-{version}-{platform}.tar.gz"
    )


def platform_of(url: str) -> str | None:
    """
    Get the platform of an asset URL.

    Args:
        url (str): The URL of the asset.

    Returns:
        str or None: The suffix of the platform, None when the URL is not
        the one of a known platform.
    """
    for platform in PLATFORMS:
        if url.endswith(f"-{platform}.tar.gz"):
            return platform
    return None


def render(formula: str, version: str, checksums: dict[str, str]) -> str:
    """
    Update the URLs, the version and the checksums of the formula.

    Every platform of the formula is updated, the rest of the formula is
    left as it is.

    Args:
        formula (str): The formula.
        version (str): The version of the release.
        checksums (dict): The checksum of the asset of every platform.

    Returns:
        str
    """
    lines: list[str] = formula.splitlines()
    result: list[str] = []
    platform: str | None = None

    for line in lines:
        url = URL_LINE_PATTERN.match(line)
        if url:
            found = platform_of(url.group("url"))
            if found:
                platform = found
                line = (
                    f"{url.group('prefix')}"
                    f"{asset_url(version, found)}{url.group('suffix')}"
                )
        elif platform:
            checksum = SHA256_LINE_PATTERN.match(line)
            if checksum:
                line = (
                    f"{checksum.group('prefix')}"
                    f"{checksums[platform]}{checksum.group('suffix')}"
                )
                platform = None
        result.append(line)

    formula = "\n".join(result) + "\n"
    formula = VERSION_LINE_PATTERN.sub(f'  version "{version}"', formula, count=1)
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

    assets = {
        asset["name"]: asset
        for asset in release["assets"]
        if asset["state"] == "uploaded"
    }

    checksums: dict[str, str] = {}
    for platform in PLATFORMS:
        name = f"mackeep-cli-{version}-{platform}.tar.gz"
        if name not in assets:
            print(f"Mackeep {version} is waiting for the {name} artifact")
            return

        asset = assets[name]
        data = download(asset["browser_download_url"])
        checksum = hashlib.sha256(data).hexdigest()
        if asset.get("digest") and asset["digest"] != f"sha256:{checksum}":
            raise ValueError(f"GitHub asset digest mismatch for {name}")
        checksums[platform] = checksum

    FORMULA.write_text(render(formula, version, checksums))
    if output := os.environ.get("GITHUB_OUTPUT"):
        with Path(output).open("a") as stream:
            stream.write(f"changed=true\nversion={version}\n")
    print(f"Updated the Mackeep formula to {version}")


if __name__ == "__main__":
    main()
