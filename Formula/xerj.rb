class Xerj < Formula
  desc "Local-first search engine and MCP server for AI agents"
  homepage "https://xerj.org"
  version "1.0.0-rc.100"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/xerj-org/xerj/releases/download/v#{version}/xerj-#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "c88fdcb99c4155d2f7260138c3a5898d0f3cf6b07cd208895137ff03c52b9d1a"
    end

    on_intel do
      url "https://github.com/xerj-org/xerj/releases/download/v#{version}/xerj-#{version}-x86_64-apple-darwin.tar.gz"
      sha256 "30f6148c68c584ab990eeaa9bc9a05209c2ba2374a5ae90651be17f588edac91"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/xerj-org/xerj/releases/download/v#{version}/xerj-#{version}-aarch64-unknown-linux-musl.tar.gz"
      sha256 "611962942ed13337e66a8552555e9c141e48bd254d13cbd396ffe13b390c5e55"
    end

    on_intel do
      url "https://github.com/xerj-org/xerj/releases/download/v#{version}/xerj-#{version}-x86_64-unknown-linux-musl.tar.gz"
      sha256 "4b12a47e8433e9d01d2b3f505b17b342a6e28d41edaabd274eba5a759e9cde1e"
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
        cat > "$CONFIG_FILE" <<'TOML'
  # XERJ Configuration

  [server]
  # Required: set your data directory before starting.
  # data_dir = "/path/to/xerj/data"

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
