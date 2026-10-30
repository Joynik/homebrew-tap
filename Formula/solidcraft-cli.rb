
require "json"

class SolidcraftCli < Formula
  desc "Headless CLI and MCP server for SolidCraft parametric CAD"
  homepage "https://github.com/tangency-labs/solidcraft"
  version "0.27.1"
  url "https://github.com/tangency-labs/solidcraft/releases/download/v#{version}/solidcraft-cli-#{version}-macos-universal.zip"
  sha256 "98222a069979388bf9ec7f432d214f0ad1911efff28cad7b439872f8c658b3b6"
  license any_of: ["MIT", "Apache-2.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  def install
    # Install SolidCraft CLI.
    binary = Dir["**/solidcraft-cli"].first
    odie "solidcraft-cli binary not found" unless binary

    bin.install binary

    # --------------------------------------------------
    # Claude Desktop MCPB Extension
    # --------------------------------------------------

    extension_dir = buildpath/"claude-extension"
    server_dir = extension_dir/"server"

    server_dir.mkpath
    pkgshare.mkpath

    # Launcher uses the Homebrew-managed CLI.
    # It supports both Headless and Visual modes.
    launcher = server_dir/"launch.sh"

    launcher.write <<~SH
      #!/bin/sh
      set -eu

      CLI="#{HOMEBREW_PREFIX}/bin/solidcraft-cli"

      if [ ! -x "$CLI" ]; then
        echo "SolidCraft CLI not found: $CLI" >&2
        exit 1
      fi

      case "${SOLIDCRAFT_VISUAL_MODE:-false}" in
        true|1)
          HOST="${SOLIDCRAFT_HOST:-127.0.0.1}"
          PORT="${SOLIDCRAFT_PORT:-7878}"

          exec "$CLI" mcp --connect "$HOST:$PORT"
          ;;
        *)
          exec "$CLI" mcp
          ;;
      esac
    SH

    launcher.chmod 0755

    # MCPB manifest with user-configurable modes.
    manifest = {
      manifest_version: "0.3",
      name: "solidcraft-mcp",
      display_name: "SolidCraft MCP",
      version: version.to_s,
      description: "Parametric CAD modeling with Claude Desktop",
      author: {
        name: "Tangency Labs",
        url: "https://github.com/tangency-labs/solidcraft"
      },
      homepage: "https://github.com/tangency-labs/solidcraft",
      documentation: "https://github.com/tangency-labs/solidcraft/blob/main/docs/mcp.md",
      license: "MIT OR Apache-2.0",
      server: {
        type: "binary",
        entry_point: "server/launch.sh",
        mcp_config: {
          command: "${__dirname}/server/launch.sh",
          args: [],
          env: {
            SOLIDCRAFT_VISUAL_MODE: "${user_config.visual_mode}",
            SOLIDCRAFT_HOST: "${user_config.host}",
            SOLIDCRAFT_PORT: "${user_config.port}"
          }
        }
      },
      user_config: {
        visual_mode: {
          type: "boolean",
          title: "Visual Mode",
          description: "Connect to the running SolidCraft GUI",
          default: false,
          required: false
        },
        host: {
          type: "string",
          title: "Host",
          description: "SolidCraft GUI control host",
          default: "127.0.0.1",
          required: false
        },
        port: {
          type: "number",
          title: "Port",
          description: "SolidCraft GUI control port",
          default: 7878,
          min: 1,
          max: 65535,
          required: false
        }
      },
      compatibility: {
        platforms: ["darwin"]
      },
      tools_generated: true
    }

    (extension_dir/"manifest.json").write(
      JSON.pretty_generate(manifest)
    )

    # Create MCPB package using the macOS ZIP utility.
    mcpb_path = pkgshare/"solidcraft.mcpb"

    Dir.chdir(extension_dir) do
      system "/usr/bin/zip", "-q", "-r",
             mcpb_path.to_s,
             "manifest.json", "server"
    end

    # --------------------------------------------------
    # End Claude Desktop MCPB Extension
    # --------------------------------------------------
  end

  def caveats
    <<~EOS
      SolidCraft CLI and MCP server installed.

      Claude Desktop extension:
        #{pkgshare}/solidcraft.mcpb

      Install the extension in:
        Claude Desktop > Settings > Extensions

      Extension settings:
        Visual Mode: OFF (Headless)
        Host:        127.0.0.1
        Port:        7878
    EOS
  end

  test do
    system bin/"solidcraft-cli", "commands"
  end
end