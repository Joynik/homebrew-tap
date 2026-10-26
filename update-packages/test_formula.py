"""Regression checks for the shared formula updater; no network or real writes."""
import unittest
from pathlib import Path
from unittest.mock import Mock

from formula import render

ROOT = Path(__file__).resolve().parents[1]


class FormulaTests(unittest.TestCase):
    def test_all_current_formulae_update_every_archive(self):
        for path in sorted((ROOT / 'Formula').glob('*.rb')):
            with self.subTest(formula=path.name):
                source = path.read_text()
                fetch = Mock(return_value='a' * 64)
                result = render(source, '99.0.0', fetch)
                count = source.partition('  def install\n')[0].count('sha256 "')
                self.assertEqual(fetch.call_count, count)
                self.assertEqual(result.count('sha256 "' + 'a' * 64 + '"'), count)
                self.assertIn('version "99.0.0"', result)
                self.assertEqual(source.split('  def install\n')[1], result.split('  def install\n')[1])
                self.assertTrue(all('99.0.0' in call.args[0] for call in fetch.call_args_list))
                self.assertTrue(all('#{' not in call.args[0] for call in fetch.call_args_list))

    def test_version_prefix_does_not_get_replaced_twice(self):
        source = (ROOT / 'Formula/qdrant.rb').read_text()
        from formula import VERSION
        version = VERSION.search(source)[1] + '.1'
        fetch = Mock(return_value='a' * 64)
        render(source, version, fetch)
        self.assertTrue(all(f'/v{version}/' in call.args[0] for call in fetch.call_args_list))

    def test_missing_platform_fails_before_write(self):
        source = (ROOT / 'Formula/qdrant.rb').read_text()
        def fetch(url):
            if 'x86_64' in url:
                raise OSError('missing artifact')
            return 'a' * 64
        with self.assertRaisesRegex(OSError, 'missing artifact'):
            render(source, '99.0.0', fetch)

    def test_unchanged_version_does_not_download(self):
        source = (ROOT / 'Formula/qdrant.rb').read_text()
        from formula import VERSION
        fetch = Mock()
        self.assertEqual(render(source, VERSION.search(source)[1], fetch), source)
        fetch.assert_not_called()

    def test_unsupported_recipes_fail_closed(self):
        source = (ROOT / 'Formula/qdrant.rb').read_text()
        for extra in ['  resource "other" do\n  end\n', '  bottle do\n  end\n', '  mirror "https://example.org"\n']:
            with self.subTest(extra=extra), self.assertRaises(ValueError):
                render(source.replace('  def install', extra + '  def install'), '99.0.0', Mock())

    def test_unsafe_versions_are_rejected(self):
        source = (ROOT / 'Formula/qdrant.rb').read_text()
        for version in ['1.0"\nsystem "oops', '#{system("oops")}', '../evil']:
            with self.subTest(version=version), self.assertRaises(ValueError):
                render(source, version, Mock())

    def test_unpaired_checksum_is_rejected(self):
        source = (ROOT / 'Formula/qdrant.rb').read_text().replace('      sha256', '      # sha256', 1)
        with self.assertRaises(ValueError):
            render(source, '99.0.0', Mock())


if __name__ == '__main__':
    unittest.main()
