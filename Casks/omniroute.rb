cask "omniroute" do
  version "3.8.50"
  sha256 "15484ce1f055f9faede5d53922718ed0ed7712ac9d84c5e3c55df5e580fe36"

  url "https://github.com/diegosouzapw/OmniRoute/releases/download/v#{version}/OmniRoute-#{version}.dmg"
  name "OmniRoute"
  desc "The Free AI Gateway"
  homepage "https://github.com/diegosouzapw/OmniRoute/"

  depends_on :macos

  livecheck do
    url :url
    strategy :github_latest
  end

  app "omniroute.app"
end