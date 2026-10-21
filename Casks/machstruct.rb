cask "machstruct" do
  version "2.1.3"
  sha256 "b15bda41a82c0e96c3780fe1bfd59d3252fa828726347df370b737738d57d65d"

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