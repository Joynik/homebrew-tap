cask "machstruct" do
  version "2.4.0"
  sha256 "c8580566417b02d66872aef782c19ebc6d01a65b1fe2e7a933f5eabb77d213a0"

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