cask "machstruct" do
  version "2.3.1"
  sha256 "9853b652e44c162264245d8a4d2e2be05e9f8dac951b8e8043f85f5d1157ff24"

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