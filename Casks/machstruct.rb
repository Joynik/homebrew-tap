cask "machstruct" do
  version "1.0.4"
  sha256 "91dedd4f20566bdfdc591821bc274960451f4b39a8551f08558ef9bda239e7e8"

  url "https://github.com/lustech/MachStruct/releases/download/v#{version}/MachStruct-v#{version}.dmg"
  name "MachStruct"
  desc "Native macOS viewer and editor for JSON, XML, YAML, CSV"
  homepage "https://github.com/lustech/MachStruct"

  depends_on :macos

  livecheck do
    url :url
    strategy :github_latest
  end

  app "MachStruct.app"
end