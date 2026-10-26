"""Shared release preflight, digest checks and OSM validation without network."""
import hashlib
import io
import json
import struct
import tarfile
import unittest
from email.message import Message
from pathlib import Path
from unittest.mock import patch

import formula
import osm

ROOT = Path(__file__).resolve().parents[1]


def osm_archive(cpu_type=0x0100000C, dependencies=True, executable=True, extra=None):
    output = io.BytesIO()
    files = [('osm.dist/osm', struct.pack('<II', 0xFEEDFACF, cpu_type), 0o755 if executable else 0o644),
             ('LICENSE', b'license', 0o644)]
    if dependencies:
        files.append(('osm.dist/libpython.dylib', b'dependency', 0o644))
    if extra:
        files.append((extra, b'bad', 0o644))
    with tarfile.open(fileobj=output, mode='w:gz') as archive:
        for name, data, mode in files:
            member = tarfile.TarInfo(name)
            member.size, member.mode = len(data), mode
            archive.addfile(member, io.BytesIO(data))
    return output.getvalue()


class Response(io.BytesIO):
    def __init__(self, url, data, content_type='application/octet-stream'):
        super().__init__(data)
        self.url = url
        self.headers = Message()
        self.headers['Content-Type'] = content_type
        self.headers['Content-Length'] = str(len(data))

    def geturl(self):
        return self.url


class ArtifactTests(unittest.TestCase):
    def fixture(self, name='mackeep-cli', **archive_options):
        source = (ROOT / 'Formula' / f'{name}.rb').read_text()
        version = '99.0.0'
        old = formula.VERSION.search(source)[1]
        urls = [p['url'].replace(old, version).replace('#{version}', version)
                for p in formula.PAIR.finditer(source.partition('  def install\n')[0])]
        data = osm_archive(**archive_options) if name == 'osm' else b'archive bytes'
        assets = [{'name': url.rsplit('/', 1)[1], 'state': 'uploaded',
                   'browser_download_url': url,
                   'digest': 'sha256:' + hashlib.sha256(data).hexdigest()} for url in urls]
        tag = urls[0].split('/download/')[1].split('/')[0]
        release = dict(tag_name=tag, draft=False, prerelease=False, assets=assets)
        def download(url):
            if url.startswith('https://api.github.com/'):
                return json.dumps(release).encode()
            return b'[project]\nname = "obsidian-semantic-mcp"\nversion = "99.0.0"\n'
        return source, urls, data, release, download

    def run_render(self, name='mackeep-cli', **options):
        source, urls, data, release, download = self.fixture(name, **options)
        with patch.object(formula, 'download', side_effect=download), patch.object(
            formula, 'urlopen', side_effect=lambda req, **kw: Response(req.full_url, data)
        ):
            return formula.render(source, '99.0.0', package=name)

    def test_real_download_path_updates_all_platforms(self):
        for name in ['qdrant', 'mackeep-cli', 'osm', 'solidcraft-cli']:
            with self.subTest(name=name):
                result = self.run_render(name)
                self.assertIn('version "99.0.0"', result)
                original = (ROOT / 'Formula' / f'{name}.rb').read_text()
                self.assertEqual(original.split('  def install\n')[1], result.split('  def install\n')[1])

    def test_missing_platform_prevents_all_downloads(self):
        source, urls, data, release, download = self.fixture()
        release['assets'].pop()
        with patch.object(formula, 'download', side_effect=download), patch.object(formula, 'checksum') as fetch:
            with self.assertRaisesRegex(ValueError, 'artifact is missing'):
                formula.render(source, '99.0.0', package='mackeep-cli')
            fetch.assert_not_called()

    def test_release_metadata_is_requested_once_for_all_platforms(self):
        source, urls, data, release, download = self.fixture()
        with patch.object(formula, 'download', side_effect=download) as metadata, patch.object(formula, 'checksum', return_value='a' * 64):
            formula.render(source, '99.0.0', package='mackeep-cli')
            self.assertEqual(metadata.call_count, 1)

    def test_prerelease_is_rejected(self):
        source, urls, data, release, download = self.fixture()
        release['prerelease'] = True
        with patch.object(formula, 'download', side_effect=download), self.assertRaisesRegex(ValueError, 'stable published'):
            formula.render(source, '99.0.0', package='mackeep-cli')

    def test_digest_mismatch_is_rejected(self):
        with patch.object(formula, 'urlopen', return_value=Response('https://example.org/archive', b'archive')):
            with self.assertRaisesRegex(ValueError, 'digest mismatch'):
                formula.checksum('https://example.org/archive', 'sha256:' + '0' * 64)

    def test_empty_html_and_truncated_downloads_are_rejected(self):
        for data, content_type, length in [(b'', 'application/octet-stream', 0),
                                            (b'<html>', 'text/html', 6),
                                            (b'archive', 'application/octet-stream', 999)]:
            response = Response('https://example.org/archive', data, content_type)
            response.headers.replace_header('Content-Length', str(length))
            with self.subTest(data=data), patch.object(formula, 'urlopen', return_value=response), self.assertRaises(ValueError):
                formula.checksum('https://example.org/archive')

    def test_token_is_only_sent_to_github_api(self):
        with patch.dict('os.environ', HOMEBREW_GITHUB_API_TOKEN='secret'):
            for url in ['https://github.com/owner/repo/releases/download/v1/a', 'https://raw.githubusercontent.com/owner/repo/v1/file']:
                self.assertIsNone(formula.request(url).get_header('Authorization'))
            self.assertEqual(formula.request('https://api.github.com/repos/owner/repo').get_header('Authorization'), 'Bearer secret')

    def test_osm_invalid_archives_fail_through_shared_updater(self):
        for options in [dict(cpu_type=0x01000007), dict(dependencies=False),
                        dict(executable=False), dict(extra='../escape')]:
            with self.subTest(options=options), self.assertRaises(ValueError):
                self.run_render('osm', **options)

    def test_osm_metadata_version_mismatch_is_rejected(self):
        with self.assertRaisesRegex(ValueError, 'project metadata'):
            osm.validate_release('Joynik/obsidian-semantic-mcp', 'v1.2.3', '1.2.3',
                                 lambda url: b'[project]\nname="obsidian-semantic-mcp"\nversion="0.0.0"')


if __name__ == '__main__':
    unittest.main()
