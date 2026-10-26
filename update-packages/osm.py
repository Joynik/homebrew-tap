"""Additional OSM checks; downloads and formula updates live in formula.py."""

import struct
import tarfile
import tomllib

CPU_TYPES = {"arm64": 0x0100000C}


def validate_release(repository, tag, version, download):
    if repository != "Joynik/obsidian-semantic-mcp":
        raise ValueError("Unexpected OSM repository")
    url = f"https://raw.githubusercontent.com/{repository}/{tag}/pyproject.toml"
    project = tomllib.loads(download(url).decode("utf-8"))["project"]
    if project["name"] != "obsidian-semantic-mcp" or project["version"] != version:
        raise ValueError("Release tag does not match project metadata")


def validate_archive(stream, url):
    if not url.endswith("-macos-arm64.tar.gz"):
        raise ValueError("Unsupported OSM archive architecture")
    architecture = "arm64"
    with tarfile.open(fileobj=stream, mode="r:gz") as archive:
        members = {member.name: member for member in archive.getmembers()}
        if not all(
            (name == "LICENSE" or name == "osm.dist" or name.startswith("osm.dist/"))
            and ".." not in name.split("/")
            and (member.isfile() or member.isdir())
            for name, member in members.items()
        ) or not {"LICENSE", "osm.dist/osm"} <= members.keys():
            raise ValueError("OSM release archive has unexpected files")
        if not members["LICENSE"].isfile() or not members["osm.dist/osm"].isfile():
            raise ValueError("OSM release archive is incomplete")
        if not any(
            name != "osm.dist/osm" and name.startswith("osm.dist/") and member.isfile()
            for name, member in members.items()
        ):
            raise ValueError("OSM standalone dependencies are missing")
        if not members["osm.dist/osm"].mode & 0o111:
            raise ValueError("OSM release executable lacks execute permission")
        executable = archive.extractfile(members["osm.dist/osm"])
        if executable is None:
            raise ValueError("OSM release executable is missing")
        magic, cpu_type = struct.unpack("<II", executable.read(8))
        if magic != 0xFEEDFACF or cpu_type != CPU_TYPES[architecture]:
            raise ValueError(f"OSM release archive is not macOS {architecture}")

