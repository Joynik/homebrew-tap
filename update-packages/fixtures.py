"""Stable input for parser tests, independent of the tap package inventory."""

ARCHIVE_FORMULA = '''class Example < Formula
  version "1.2.3"
  on_arm do
    url "https://github.com/example/example/releases/download/v#{version}/example-arm64.tar.gz"
    sha256 "''' + 'a' * 64 + '''"
  end
  on_intel do
    url "https://github.com/example/example/releases/download/v#{version}/example-x86_64.tar.gz"
    sha256 "''' + 'b' * 64 + '''"
  end
  def install
    bin.install "example"
  end
end
'''
