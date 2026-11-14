class Qdrant < Formula
  desc "Vector search engine and database for AI applications"
  homepage "https://qdrant.tech"
  license "Apache-2.0"
  version "1.20.1"

  on_macos do
    on_arm do
      url "https://github.com/qdrant/qdrant/releases/download/v#{version}/qdrant-aarch64-apple-darwin.tar.gz"
      sha256 "5deb80dfa44afea90fa27bb3fcd269e60b1e88347e769f2547a0269aadb37003" # arm
    end
    on_intel do
      url "https://github.com/qdrant/qdrant/releases/download/v#{version}/qdrant-x86_64-apple-darwin.tar.gz"
      sha256 "5f3ae5d62d476788f0c529b6f9276d5517e9c70b4707ef6374c1cceea4369597" # intel
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/qdrant/qdrant/releases/download/v#{version}/qdrant-aarch64-unknown-linux-musl.tar.gz"
      sha256 "d608764d7d8e331633cba9f953ac15270e1330b55a2ff61cd1a6748222f97355"
    end
    on_intel do
      url "https://github.com/qdrant/qdrant/releases/download/v#{version}/qdrant-x86_64-unknown-linux-musl.tar.gz"
      sha256 "52ea6723c10f8bd7be63950f4210bd52e93a8f45e8e81347f5ec94aa918fe14f"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  def install
    bin.install "qdrant"
  end

  def post_install
    (var/"qdrant").mkpath
  end

  service do
    run [opt_bin/"qdrant"]
    working_dir var/"qdrant"
    environment_variables QDRANT__SERVICE__HOST: "127.0.0.1"
    keep_alive true
    log_path var/"log/qdrant.log"
    error_log_path var/"log/qdrant.log"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/qdrant --help")
  end
end
