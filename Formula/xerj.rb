class Xerj < Formula
  desc "Local-first search engine and MCP server for AI agents"
  homepage "https://xerj.org"
  version "1.0.0-rc.101"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/xerj-org/xerj/releases/download/v#{version}/xerj-#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "eb2113ec8a7d3057d5ed97d91a52900b804108db173ba213292506926e6b790f"
    end

    on_intel do
      url "https://github.com/xerj-org/xerj/releases/download/v#{version}/xerj-#{version}-x86_64-apple-darwin.tar.gz"
      sha256 "49327e1931515d1c5ac66b9b06769f13dd1271c55ad279c6a7501b9e89a6ed76"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/xerj-org/xerj/releases/download/v#{version}/xerj-#{version}-aarch64-unknown-linux-musl.tar.gz"
      sha256 "b17caa7eedf3ef1d7b9809bf3ba134daaa60224aa6175367355a8f493cb33918"
    end

    on_intel do
      url "https://github.com/xerj-org/xerj/releases/download/v#{version}/xerj-#{version}-x86_64-unknown-linux-musl.tar.gz"
      sha256 "43a974407da17be6d487c481a00f539d1edd081c19a2c3662b7b6881bbccf163"
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
