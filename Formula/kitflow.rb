# frozen_string_literal: true

class Kitflow < Formula
  desc "Start projects and maintain configuration standards"
  homepage "https://github.com/Joynik/KitFlow"
  version "0.5.0"

  on_macos do
    depends_on macos: :sequoia
    depends_on arch: :arm64

    url "https://github.com/Joynik/KitFlow/releases/download/0.5.0/kitflow-0.5.0-macos-arm64.tar.gz"
    sha256 "a8a168487a6ec5a46c8c576aa79a44def38920167b3c401903ea0d1c1a2185df"
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/Joynik/KitFlow/releases/download/0.5.0/kitflow-0.5.0-linux-arm64.tar.gz"
      sha256 "0ce90450599b22da4dbbdfc3b30b5499a15a515e56cf76d27866d572c8a6d970"
    else
      url "https://github.com/Joynik/KitFlow/releases/download/0.5.0/kitflow-0.5.0-linux-x86_64.tar.gz"
      sha256 "aebe58909081af13e6b30196c50ee44d5dd1da60808c65ad4663c61ee01ea754"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  def install
    libexec.install Dir["*"]
    bin.install_symlink libexec/"kitflow"
  end

  test do
    assert_match "KitFlow #{version}", shell_output("#{bin}/kitflow --version")
  end
end
