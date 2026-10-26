"""Update versioned HTTPS archives in a formula without evaluating Ruby code."""

import argparse
import hashlib
import json
import os
import tempfile
from contextlib import nullcontext
import re
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path
from urllib.parse import quote, unquote
from urllib.request import Request, urlopen

VERSION = re.compile(r'^  version "([^"\n]+)"$', re.M)
PAIR = re.compile(
    r'^(?P<url_line>[ \t]*url ")(?P<url>[^"\n]+)(?P<url_end>"[^\n]*\n)'
    r'(?P<middle>(?:[ \t]*version "[^"\n]+"\n)?)'
    r'(?P<sha_line>[ \t]*sha256 ")[0-9a-f]{64}(?P<sha_end>"[^\n]*)$', re.M,
)


def request(url):
    headers = {"User-Agent": "homebrew-tap-updater"}
    if url.startswith("https://api.github.com/"):
        if token := os.environ.get("HOMEBREW_GITHUB_API_TOKEN"):
            headers["Authorization"] = f"Bearer {token}"
    return Request(url, headers=headers)


def download(url):
    with urlopen(request(url), timeout=120) as response:
        return response.read()


def checksum(url, expected=None, validator=None):
    if not url.startswith("https://"):
        raise ValueError("Only HTTPS archives are supported")
    # Never send the repository token to upstream download servers.
    with urlopen(request(url), timeout=120) as response, (
        tempfile.TemporaryFile() if validator else nullcontext(None)
    ) as archive:
        if not response.geturl().startswith("https://"):
            raise ValueError("Insecure download redirect")
        if response.headers.get_content_type() in {"text/html", "application/json"}:
            raise ValueError("Expected a release archive, received a web page or API response")
        digest = hashlib.sha256()
        size = 0
        while chunk := response.read(1024 * 1024):
            size += len(chunk)
            digest.update(chunk)
            if archive is not None:
                archive.write(chunk)
        if not size:
            raise ValueError("Empty release archive")
        content_length = response.headers.get("Content-Length")
        if content_length and size != int(content_length):
            raise ValueError("Incomplete release archive")
        actual = digest.hexdigest()
        if expected and expected != f"sha256:{actual}":
            raise ValueError(f"GitHub asset digest mismatch: {url}")
        if validator:
            archive.seek(0)
            validator(archive, url)
        return actual


def archive_checksums(urls, package, version):
    releases = {}
    assets = []
    validator = None
    if package == "osm":
        import osm
        validator = osm.validate_archive
    for url in urls:
        match = re.fullmatch(r'https://github\.com/([^/]+/[^/]+)/releases/download/([^/]+)/([^/?#]+)', url)
        if not match:
            if package == "osm":
                raise ValueError("OSM must use a GitHub release archive")
            assets.append(None)
            continue
        repository, encoded_tag, filename = match.groups()
        tag = unquote(encoded_tag)
        key = (repository, tag)
        if key not in releases:
            api = f"https://api.github.com/repos/{repository}/releases/tags/{quote(tag, safe='')}"
            release = json.loads(download(api))
            if release["tag_name"] != tag or release["draft"] or release["prerelease"]:
                raise ValueError(f"Not a stable published release: {repository} {tag}")
            if package == "osm":
                osm.validate_release(repository, tag, version, download)
            releases[key] = {asset["name"]: asset for asset in release["assets"] if asset["state"] == "uploaded"}
        asset = releases[key].get(unquote(filename))
        if not asset or asset["browser_download_url"] != url:
            raise ValueError(f"Release artifact is missing or has an unexpected URL: {url}")
        assets.append(asset)
    # Preflight every platform before downloading any archives.
    def fetch(item):
        url, asset = item
        return checksum(url, asset.get("digest") if asset else None, validator)
    with ThreadPoolExecutor(max_workers=3) as pool:
        return list(pool.map(fetch, zip(urls, assets)))


def render(source, version, fetch=None, package=None):
    if not re.fullmatch(r'\d+(?:\.\d+)+(?:[a-zA-Z0-9._+-]*)', version):
        raise ValueError("Unsupported release version")
    # shortcut: support the documented archive template; fail on complex recipes.
    header, separator, body = source.partition("  def install\n")
    versions = list(VERSION.finditer(header))
    if not separator or len(versions) != 1:
        raise ValueError("Expected one explicit version and def install")
    old = versions[0].group(1)
    if old == version:
        return source
    if re.search(r'^\s*(resource|patch|bottle|head|mirror|stable)\b', header, re.M):
        raise ValueError("Resources, patches, bottles, HEAD, mirrors and stable blocks need manual review")
    pairs = list(PAIR.finditer(header))
    if not pairs or len(pairs) != len(re.findall(r'^\s*url[ \t]+"', header, re.M)) or len(pairs) != len(re.findall(r'^\s*sha256\s', header, re.M)):
        raise ValueError("Every archive URL must be followed immediately by its sha256")
    urls = []
    for pair in pairs:
        url = pair['url'].replace(old, version).replace('#{version}', version)
        if '#{' in url or url == pair['url'] or not url.startswith('https://'):
            raise ValueError("Each HTTPS URL must contain the version or #{version}")
        urls.append(url)
    # All platforms must succeed before any file is written. Limit RAM and connections.
    if fetch is None:
        hashes = archive_checksums(urls, package, version)
    else:
        with ThreadPoolExecutor(max_workers=3) as pool:
            hashes = list(pool.map(fetch, urls))
    for pair, digest in reversed(list(zip(pairs, hashes))):
        if not re.fullmatch(r'[0-9a-f]{64}', digest):
            raise ValueError("Invalid SHA256")
        stored_url = pair['url'].replace(old, version)
        replacement = f"{pair['url_line']}{stored_url}{pair['url_end']}{pair['middle']}{pair['sha_line']}{digest}{pair['sha_end']}"
        header = header[:pair.start()] + replacement + header[pair.end():]
    header = VERSION.sub(lambda _: f'  version "{version}"', header)
    header = re.sub(r'^  revision \d+\n', '', header, flags=re.M)
    return header + separator + body


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('formula', type=Path)
    parser.add_argument('version')
    args = parser.parse_args()
    updated = render(args.formula.read_text(), args.version, package=args.formula.stem)
    args.formula.write_text(updated)
