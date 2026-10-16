class Osm < Formula
  desc "Local MCP server for semantic search in Obsidian vaults"
  homepage "https://github.com/Joynik/obsidian-semantic-mcp"
  url "https://github.com/Joynik/obsidian-semantic-mcp/archive/refs/tags/v0.41.8.tar.gz"
  sha256 "6271f355c0a2e4bd546ee92abbe3d4c50d6604394e5dcd8390a8e352e860c596"
  license "Apache-2.0"

  depends_on "uv" => :build
  depends_on "libpq"
  depends_on "python@3.14"

  def fetch
    ENV["UV_CACHE_DIR"] = (buildpath/"uv-cache").to_s
    ENV["UV_PROJECT_ENVIRONMENT"] = (buildpath/"fetch-venv").to_s
    ENV["UV_NO_MANAGED_PYTHON"] = "1"
    ENV["UV_NO_BINARY_PACKAGE"] = "psycopg2-binary"
    ENV["UV_LINK_MODE"] = "copy"
    ENV.prepend_path "PATH", formula_opt_bin("libpq")
    system formula_opt_bin("uv")/"uv", "sync", "--frozen", "--no-dev",
           "--python", formula_opt_bin("python@3.14")/"python3.14"
  end

  def install
    libexec.install "pyproject.toml", "uv.lock", "README.md", "osm_cli.py", "src", "embedding-profiles"
    ENV["UV_CACHE_DIR"] = (buildpath/"uv-cache").to_s
    ENV["UV_PROJECT_ENVIRONMENT"] = (libexec/"venv").to_s
    ENV["UV_NO_MANAGED_PYTHON"] = "1"
    ENV["UV_NO_BINARY_PACKAGE"] = "psycopg2-binary"
    ENV["UV_LINK_MODE"] = "copy"
    ENV.prepend_path "PATH", formula_opt_bin("libpq")
    cd libexec do
      system formula_opt_bin("uv")/"uv", "sync", "--offline", "--frozen", "--no-dev",
             "--python", formula_opt_bin("python@3.14")/"python3.14"
    end
    bin.install_symlink libexec/"venv/bin/osm"
  end

  test do
    assert_match "OSM v#{version}", shell_output("#{bin}/osm help")
  end
end
