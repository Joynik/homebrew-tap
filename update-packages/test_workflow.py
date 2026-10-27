"""Exercise shared shell orchestration with mocked external commands."""
import json
import os
import shutil
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
STUB = r'''
import json, os, pathlib, shutil, sys
name = pathlib.Path(sys.argv[0]).name
args = sys.argv[1:]
root = pathlib.Path(os.environ['FIXTURE'])
with (root / 'calls').open('a') as log:
    log.write(json.dumps([name, *args]) + '\n')
if name == 'brew':
    if args[0] == 'livecheck':
        package = args[-1].split('/')[-1]
        if os.environ.get('LIVECHECK_FAIL') == package:
            print('upstream livecheck detail')
            sys.exit(1)
        if os.environ.get('BAD_JSON') == package:
            print('[]')
        else:
            print(json.dumps([{'version': {'latest': '99.0.0', 'outdated': True}}]))
    elif args[0] == 'bump-cask-pr':
        (root / 'pr').touch()
elif name == 'gh':
    if args[:2] == ['pr', 'list']:
        if 'open' in args and (root / 'pr').exists():
            print('123\tabc123')
    elif args[:2] == ['pr', 'create']:
        (root / 'pr').touch()
    elif args[:2] == ['pr', 'merge'] and '--auto' in args and os.environ.get('MERGE_FALLBACK'):
        print(os.environ.get('MERGE_ERROR', 'Branch does not have required protected branch rules'))
        sys.exit(1)
    elif args[:2] == ['pr', 'merge'] and '--auto' not in args and os.environ.get('DIRECT_MERGE_FAIL'):
        print('Pull request is blocked by branch protection')
        sys.exit(1)
elif name == 'git':
    if args[:2] == ['worktree', 'add']:
        shutil.copytree(root / 'Formula', pathlib.Path(args[-2]) / 'Formula')
    elif args[:2] == ['worktree', 'remove']:
        shutil.rmtree(args[-1])
elif name == 'python3':
    if os.environ.get('DOWNLOAD_FAIL'):
        sys.exit(1)
'''


class WorkflowTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        (self.root / 'bin').mkdir()
        for command in ['brew', 'gh', 'git', 'python3']:
            path = self.root / 'bin' / command
            path.write_text(f'#!{sys.executable}\n' + STUB)
            path.chmod(0o755)
        for directory in ['Formula', 'Casks']:
            (self.root / directory).mkdir()
        for name in ['qdrant', 'solidcraft-cli']:
            shutil.copy(ROOT / 'Formula' / f'{name}.rb', self.root / 'Formula')
        (self.root / 'Casks/example.rb').write_text('cask "example" do\nend\n')
        self.env = dict(os.environ, PATH=f"{self.root / 'bin'}:{os.environ['PATH']}",
                        FIXTURE=str(self.root), TAP_NAME='joynik/tap',
                        GH_TOKEN='test', HOMEBREW_GITHUB_API_TOKEN='test',
                        GITHUB_REPOSITORY='Joynik/homebrew-tap')

    def run_updater(self, **env):
        result = subprocess.run(['bash', str(ROOT / 'update-packages/update.sh')],
                                cwd=self.root, env=self.env | env,
                                text=True, capture_output=True)
        calls = [json.loads(line) for line in (self.root / 'calls').read_text().splitlines()]
        return result, calls

    def test_cask_creation_and_merge_fallback(self):
        result, calls = self.run_updater(PACKAGE_KIND='cask', MERGE_FALLBACK='1')
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertTrue(any(c[:2] == ['brew', 'bump-cask-pr'] for c in calls))
        self.assertEqual(sum(c[:3] == ['gh', 'pr', 'merge'] for c in calls), 2)

    def test_clean_pr_falls_back_to_merge_with_matching_head(self):
        result, calls = self.run_updater(
            PACKAGE_KIND='cask', MERGE_FALLBACK='1',
            MERGE_ERROR='GraphQL: Pull request Pull request is in clean status (enablePullRequestAutoMerge)')
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        merges = [c for c in calls if c[:3] == ['gh', 'pr', 'merge']]
        self.assertEqual(len(merges), 2)
        self.assertNotIn('--auto', merges[1])
        self.assertIn('--squash', merges[1])
        self.assertEqual(merges[1][-2:], ['--match-head-commit', 'abc123'])

    def test_clean_pr_direct_merge_failure_is_reported(self):
        result, calls = self.run_updater(
            PACKAGE_KIND='cask', MERGE_FALLBACK='1', DIRECT_MERGE_FAIL='1',
            MERGE_ERROR='GraphQL: Pull request Pull request is in clean status (enablePullRequestAutoMerge)')
        self.assertEqual(result.returncode, 1)
        self.assertIn('Could not merge PR #123', result.stdout)

    def test_unrelated_auto_merge_error_does_not_attempt_direct_merge(self):
        result, calls = self.run_updater(
            PACKAGE_KIND='cask', MERGE_FALLBACK='1', MERGE_ERROR='GraphQL: Resource not accessible')
        self.assertEqual(result.returncode, 1)
        self.assertEqual(sum(c[:3] == ['gh', 'pr', 'merge'] for c in calls), 1)

    def test_formula_creation_is_isolated_and_no_force_push(self):
        result, calls = self.run_updater(PACKAGE_KIND='formula', PACKAGE_NAME='qdrant')
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertTrue(any(c[:3] == ['git', 'worktree', 'add'] for c in calls))
        self.assertTrue(any(c[:3] == ['git', 'worktree', 'remove'] for c in calls))
        self.assertTrue(any(c[:3] == ['gh', 'pr', 'create'] for c in calls))
        self.assertFalse(any('--force' in c and 'push' in c for c in calls))

    def test_formula_network_commands_use_explicit_credentials(self):
        result, calls = self.run_updater(PACKAGE_KIND='formula', PACKAGE_NAME='qdrant')
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        network = [c for c in calls if c[0] == 'git' and ('fetch' in c or 'push' in c)]
        self.assertEqual(len(network), 2)
        for call in network:
            self.assertIn('credential.helper=', call)
            self.assertIn('credential.helper=!gh auth git-credential', call)
            self.assertNotIn(self.env['GH_TOKEN'], call)

    def test_failed_download_cleans_up_and_never_publishes(self):
        result, calls = self.run_updater(PACKAGE_KIND='formula', DOWNLOAD_FAIL='1')
        self.assertEqual(result.returncode, 1)
        self.assertTrue(any('joynik/tap/solidcraft-cli' in c for c in calls))
        self.assertTrue(any(c[:3] == ['git', 'worktree', 'remove'] for c in calls))
        self.assertFalse(any('push' in c or 'commit' in c for c in calls))
        self.assertFalse(any(c[:3] == ['gh', 'pr', 'merge'] for c in calls))

    def test_invalid_livecheck_does_not_publish_and_continues(self):
        result, calls = self.run_updater(PACKAGE_KIND='formula', BAD_JSON='qdrant')
        self.assertEqual(result.returncode, 1)
        self.assertTrue(any('joynik/tap/solidcraft-cli' in c for c in calls))
        self.assertFalse(any('bump-formula-qdrant-99.0.0' in c for c in calls))

    def test_bulk_checks_include_personal_projects(self):
        for kind, directory, names in [
            ('formula', 'Formula', ['osm', 'mackeep-cli']),
            ('cask', 'Casks', ['mackeep']),
        ]:
            for name in names:
                (self.root / directory / f'{name}.rb').write_text('')
            result, calls = self.run_updater(PACKAGE_KIND=kind, BAD_JSON='qdrant')
            for name in names:
                self.assertTrue(any(f'joynik/tap/{name}' in c for c in calls))

    def test_failed_livecheck_preserves_upstream_diagnostic(self):
        result, calls = self.run_updater(PACKAGE_KIND='formula', LIVECHECK_FAIL='qdrant')
        self.assertEqual(result.returncode, 1)
        self.assertIn('upstream livecheck detail', result.stdout)
        self.assertTrue(any('joynik/tap/solidcraft-cli' in c for c in calls))

    def test_unknown_package_is_rejected(self):
        result = subprocess.run(['bash', str(ROOT / 'update-packages/update.sh')],
                                cwd=self.root, env=self.env | {'PACKAGE_NAME': '../bad'},
                                capture_output=True)
        self.assertEqual(result.returncode, 1)
        self.assertFalse((self.root / 'calls').exists())


if __name__ == '__main__':
    unittest.main()
