cask "machstruct" do
  version "2.1.0"
  sha256 "6d0088377afda6dca23a19602c2f35ed5a607f1347a7a23e545dc60459d53767"

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