class Qdrant < Formula
  desc "Vector search engine and database for AI applications"
  homepage "https://qdrant.tech"
  license "Apache-2.0"
  version "1.20.0"

  on_macos do
    on_arm do
      url "https://github.com/qdrant/qdrant/releases/download/v#{version}/qdrant-aarch64-apple-darwin.tar.gz"
      sha256 "531904e822050790bb8c1da6705f801ee48b91eb4c229d0d605ff06f6331b20a" # arm
    end
    on_intel do
      url "https://github.com/qdrant/qdrant/releases/download/v#{version}/qdrant-x86_64-apple-darwin.tar.gz"
      sha256 "94a2e6f6b8ef3a3b5756a11172fd66554ac753e0a71c1d8d8b5349356c084f4d" # intel
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