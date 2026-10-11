cask "omniroute" do
  version "3.8.50"
  sha256 "db4897bf300bda63dc8613097bd0fdb69e38dc925751bf18c951e1190eb4f02f"

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