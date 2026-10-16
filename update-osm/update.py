"""Update the OSM Homebrew formula from the latest stable GitHub release."""

import hashlib
import io
import json
import os
import re
import tarfile
import tomllib
from pathlib import Path
from urllib.request import Request, urlopen

FORMULA = Path("Formula/osm.rb")
REPOSITORY = "Joynik/obsidian-semantic-mcp"
API_URL = f"https://api.github.com/repos/{REPOSITORY}/releases/latest"
URL_PATTERN = re.compile(
    rf'^  url "https://github\.com/{REPOSITORY}/archive/refs/tags/v(\d+\.\d+\.\d+)\.tar\.gz"$',
    re.MULTILINE,
)
SHA_PATTERN = re.compile(r'^  sha256 "[0-9a-f]{64}"$', re.MULTILINE)
VERSION_PATTERN = re.compile(r"v(\d+\.\d+\.\d+)\Z")


def download(url: str) -> bytes:
    headers = {"User-Agent": "osm-formula-updater"}
    token = os.environ.get("GITHUB_TOKEN")
    if token:
        headers["Authorization"] = f"Bearer {token}"
    with urlopen(Request(url, headers=headers), timeout=60) as response:
        return response.read()


def archive_version(archive: bytes) -> str:
    with tarfile.open(fileobj=io.BytesIO(archive), mode="r:gz") as tar:
        members = [member for member in tar if member.name.endswith("/pyproject.toml")]
        if len(members) != 1 or not members[0].isfile():
            raise ValueError("Release archive must contain exactly one pyproject.toml")
        source = tar.extractfile(members[0])
        if source is None:
            raise ValueError("Cannot read pyproject.toml from release archive")
        metadata = tomllib.loads(source.read().decode("utf-8"))
    if metadata["project"]["name"] != "obsidian-semantic-mcp":
        raise ValueError("Release archive contains a different project")
    return metadata["project"]["version"]


def main() -> None:
    formula = FORMULA.read_text()
    current = URL_PATTERN.search(formula)
    if current is None or len(SHA_PATTERN.findall(formula)) != 1:
        raise ValueError("Unexpected Formula/osm.rb URL or SHA-256 format")

    release = json.loads(download(API_URL))
    tag = release["tag_name"]
    match = VERSION_PATTERN.fullmatch(tag)
    if not match or release["draft"] or release["prerelease"]:
        raise ValueError(f"Unexpected latest stable release: {tag}")
    version = match.group(1)
    if tuple(map(int, version.split("."))) <= tuple(map(int, current.group(1).split("."))):
        print(f"OSM {current.group(1)} is current; latest stable release is {version}")
        return

    url = f"https://github.com/{REPOSITORY}/archive/refs/tags/{tag}.tar.gz"
    archive = download(url)
    if archive_version(archive) != version:
        raise ValueError(f"Archive project version does not match release tag {tag}")
    checksum = hashlib.sha256(archive).hexdigest()
    updated = URL_PATTERN.sub(f'  url "{url}"', formula, count=1)
    updated = SHA_PATTERN.sub(f'  sha256 "{checksum}"', updated, count=1)
    FORMULA.write_text(updated)
    output = os.environ.get("GITHUB_OUTPUT")
    if output:
        with Path(output).open("a") as stream:
            stream.write(f"changed=true\nversion={version}\n")
    print(f"Updated OSM formula to {version} ({checksum})")


if __name__ == "__main__":
    main()
