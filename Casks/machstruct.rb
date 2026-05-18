cat > Casks/machstruct.rb << 'EOF'
cask "machstruct" do
  version "1.0.4"
  sha256 "91dedd4f20566bdfdc591821bc274960451f4b39a8551f08558ef9bda239e7e8"

  url "https://github.com/lustech/MachStruct/releases/download/v#{version}/MachStruct-#{version}.dmg"
  name "MachStruct"
  desc "Native macOS viewer and editor for JSON, XML, YAML, CSV"
  homepage "https://github.com/lustech/MachStruct"

  livecheck do
    url "https://github.com/lustech/MachStruct/releases/latest"
    strategy :header_match
  end

  app "MachStruct.app"
end
EOF