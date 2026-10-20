cask "machstruct" do
  version "2.1.2"
  sha256 "17ec23070300fdb003494e6c27b0b6f16ed13f441ff4febceee95af78fad176f"

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