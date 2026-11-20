# frozen_string_literal: true

class Kitflow < Formula
  desc "Start projects and maintain configuration standards"
  homepage "https://github.com/Joynik/KitFlow"
  version "0.20.1"

  on_macos do
    depends_on macos: :sequoia
    depends_on arch: :arm64

    url "https://github.com/Joynik/KitFlow/releases/download/0.20.1/kitflow-0.20.1-macos-arm64.tar.gz"
    sha256 "23b554bf0ef56fd5e5a8c06cbf7f7db74518bcea5142b516c93ba331a03edf8c"
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/Joynik/KitFlow/releases/download/0.20.1/kitflow-0.20.1-linux-arm64.tar.gz"
      sha256 "6c8dd7e6664e4e1c40d4e5c5a6081aeccaafc5f32f840c5ca77115b99c3bd928"
    else
      url "https://github.com/Joynik/KitFlow/releases/download/0.20.1/kitflow-0.20.1-linux-x86_64.tar.gz"
      sha256 "4ca19af571ca5b3e434673aad4ea4d0d1ce18381570d422258460af85191b456"
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
