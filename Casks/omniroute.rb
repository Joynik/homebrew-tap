cask "omniroute" do
  version "3.8.53"
  sha256 "57eb52491739137db667bda359adea879690b1e7e94d207b4b80658e219f1389"

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