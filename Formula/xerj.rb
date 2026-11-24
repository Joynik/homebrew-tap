class Xerj < Formula
  desc "Local-first search engine and MCP server for AI agents"
  homepage "https://xerj.org"
  version "1.0.0-rc.105"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/xerj-org/xerj/releases/download/v#{version}/xerj-#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "2eb5834b859bdbeef39122f53a260007ec60f444927deddfd0dd7f6451d4ce15"
    end

    on_intel do
      url "https://github.com/xerj-org/xerj/releases/download/v#{version}/xerj-#{version}-x86_64-apple-darwin.tar.gz"
      sha256 "333563556786272f14763255f2db70f6cac19763205e362397ae2e688ecec1e9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/xerj-org/xerj/releases/download/v#{version}/xerj-#{version}-aarch64-unknown-linux-musl.tar.gz"
      sha256 "691f1bab98cf35ecca1ccc658cec81ffc195e6bb7c363c92c38c11d0bea6c027"
    end

    on_intel do
      url "https://github.com/xerj-org/xerj/releases/download/v#{version}/xerj-#{version}-x86_64-unknown-linux-musl.tar.gz"
      sha256 "52917124e506d9d25eaa0d8386c094f18a599fdd29a17b8c7c0bb2dd9ba21144"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(?:-rc\.\d+)?)$/i)
    strategy :github_latest
  end

  def caveats
    <<~EOS
      XERJ is installed.

      Start the local search server:
        xerj --data-dir ~/xerj-data

      Index a project:
        export XERJ_API_KEY="$(cat ~/xerj-data/admin.key)"
        xerj autoindex /path/to/project

      Connect an MCP client:
        xerj mcp

      Documentation:
        https://github.com/xerj-org/xerj
    EOS
  end

  def install
    bin.install "xerj"

    (libexec/"xerj-launch").write <<~'SH'
      #!/bin/sh
      set -eu

      CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/xerj"
      CONFIG_FILE="$CONFIG_DIR/xerj.toml"

      mkdir -p "$CONFIG_DIR"

      if [ ! -f "$CONFIG_FILE" ]; then
        cat > "$CONFIG_FILE" <<TOML
  # XERJ Configuration

  [server]
  # Required: set your data directory before starting.
  data_dir = "$HOME/.xerj"

  bind_address = "127.0.0.1"
  rest_port = 8080
  grpc_port = 8081
  es_compat_port = 9200

  [auth]
  enabled = true
  TOML
      fi

      if ! grep -Eq '^[[:space:]]*data_dir[[:space:]]*=[[:space:]]*"[^"]+"' "$CONFIG_FILE"; then
        echo "XERJ: configure data_dir in $CONFIG_FILE" >&2
        exit 1
      fi

      exec "$(dirname "$0")/../bin/xerj" --config "$CONFIG_FILE"
    SH

    chmod 0755, libexec/"xerj-launch"
  end

  post_install_steps do
    mkdir_p "log", base: :var
  end

  service do
    run [opt_libexec/"xerj-launch"]
    keep_alive true
    run_at_load true
    log_path var/"log/xerj.log"
    error_log_path var/"log/xerj-error.log"
  end


  test do
    assert_match version.to_s, shell_output("#{bin}/xerj --version")
  end
end
