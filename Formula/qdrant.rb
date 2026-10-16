class Qdrant < Formula
  desc "Vector search engine and database for AI applications"
  homepage "https://qdrant.tech"
  license "Apache-2.0"
  version "1.19.2"

  on_macos do
    on_arm do
      url "https://github.com/qdrant/qdrant/releases/download/v#{version}/qdrant-aarch64-apple-darwin.tar.gz"
      sha256 "d24dfd25f4584684b337dd30ee016472cd25f53fc2501f1cd058ab3d7ee0b019" # arm
    end
    on_intel do
      url "https://github.com/qdrant/qdrant/releases/download/v#{version}/qdrant-x86_64-apple-darwin.tar.gz"
      sha256 "e095b682ad7460baff43827eaa13647b5ec97c48edcb676646ae2f4108395044" # intel
    end
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