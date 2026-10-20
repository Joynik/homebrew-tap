cask "omniroute" do
  version "3.8.52"
  sha256 "354f12c1f268bd9f309acbe1d49ebf5929be19e060e74b975d36304d8699dd5c"

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