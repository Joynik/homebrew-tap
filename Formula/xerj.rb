class Xerj < Formula
  desc "Local-first search engine and MCP server for AI agents"
  homepage "https://xerj.org"
  version "1.0.0-rc.104"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/xerj-org/xerj/releases/download/v#{version}/xerj-#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "5f16b17dcf46abb566ec33a0f4733b459c0fbc229fcd0f58a9e6ad698f37d58e"
    end

    on_intel do
      url "https://github.com/xerj-org/xerj/releases/download/v#{version}/xerj-#{version}-x86_64-apple-darwin.tar.gz"
      sha256 "e2642528fb8ef568ff92b0166a4a10b509ad265568e848b575ab4d9ef13a2c64"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/xerj-org/xerj/releases/download/v#{version}/xerj-#{version}-aarch64-unknown-linux-musl.tar.gz"
      sha256 "cd3acf3b37d7f942157bebb05efa4221651b25f07b18a85beeacb5757647ea4f"
    end

    on_intel do
      url "https://github.com/xerj-org/xerj/releases/download/v#{version}/xerj-#{version}-x86_64-unknown-linux-musl.tar.gz"
      sha256 "1628ee401a9a121156cc380950f9d48923e6e856458ae1e6648f0ef18db7b693"
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
