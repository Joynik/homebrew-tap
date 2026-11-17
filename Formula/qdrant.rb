class Qdrant < Formula
  desc "Vector search engine and database for AI applications"
  homepage "https://qdrant.tech"
  license "Apache-2.0"
  version "1.20.2"

  on_macos do
    on_arm do
      url "https://github.com/qdrant/qdrant/releases/download/v#{version}/qdrant-aarch64-apple-darwin.tar.gz"
      sha256 "385b244e6283968b2be926358541b5bc19b9ada7ea9586e900684388bc912d5f" # arm
    end
    on_intel do
      url "https://github.com/qdrant/qdrant/releases/download/v#{version}/qdrant-x86_64-apple-darwin.tar.gz"
      sha256 "73a6538ccccb892ec2c6fa3431faf1e73fba7eb2179079adbd0c65ae4c55bf6a" # intel
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/qdrant/qdrant/releases/download/v#{version}/qdrant-aarch64-unknown-linux-musl.tar.gz"
      sha256 "c0c16a08440213b89facfbd2dd3cf4cd6fa222c1260b057a0ea77b41a75774c0"
    end
    on_intel do
      url "https://github.com/qdrant/qdrant/releases/download/v#{version}/qdrant-x86_64-unknown-linux-musl.tar.gz"
      sha256 "7c3e956b97830a9faa6391540330380c2fa4aa2f92df99bd8d1880a703b922af"
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
