cask "omniroute" do
  version "3.8.54"
  sha256 "175e524f0a5021d22ffc4c6e67f44b931dcacd61d5d5f014b2874a31efdc7656"

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