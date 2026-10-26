"""Check real Git credential plumbing offline with a fake gh helper."""
import os
import shutil
import subprocess
import tempfile
import unittest
from pathlib import Path

SCRIPT = Path(__file__).with_name('update.sh')


class GitAuthTests(unittest.TestCase):
    def test_git_receives_credentials_from_gh_without_persisting_token(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            helper = root / 'gh'
            helper.write_text('#!/bin/sh\n'
                              '[ "$1 $2 $3" = "auth git-credential get" ] || exit 1\n'
                              'cat >/dev/null\n'
                              'printf "username=x-access-token\\npassword=%s\\n" "$GH_TOKEN"\n')
            helper.chmod(0o755)
            config = root / 'gitconfig'
            config.write_text('')
            env = dict(os.environ, PATH=f"{root}:{os.environ['PATH']}",
                       GIT_CONFIG_GLOBAL=str(config), GIT_CONFIG_NOSYSTEM='1',
                       GIT_TERMINAL_PROMPT='0', GH_TOKEN='offline-test-token')
            # Prevent parent Git environment or user helpers from affecting this check.
            for key in list(env):
                if key.startswith('GIT_CONFIG_') and key not in {'GIT_CONFIG_GLOBAL', 'GIT_CONFIG_NOSYSTEM'}:
                    del env[key]
            git = shutil.which('git')
            plain = subprocess.run([git, '-C', directory, '-c', 'credential.helper=', 'credential', 'fill'],
                                   input='protocol=https\nhost=github.com\n\n',
                                   env=env, text=True, capture_output=True)
            self.assertNotEqual(plain.returncode, 0)
            source = SCRIPT.read_text()
            start = source.index('git_with_auth() {')
            end = source.index('\n}', start) + 2
            result = subprocess.run(['bash', '-c', source[start:end] + '\ngit_with_auth -C "$1" credential fill', 'test', directory],
                                    input='protocol=https\nhost=github.com\n\n',
                                    env=env, text=True, capture_output=True)
            self.assertEqual(result.returncode, 0, result.stderr)
            self.assertIn('password=offline-test-token', result.stdout)
            self.assertEqual(config.read_text(), '')


if __name__ == '__main__':
    unittest.main()
