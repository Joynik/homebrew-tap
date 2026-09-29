cask "codeburn" do
  version "0.9.25"
  sha256 "1b8664f4d5f3121d3953f1e447973a823f0012b17f082dd41ed790bee599618c"

  url "https://github.com/getagentseal/codeburn/releases/download/desktop-v#{version}/CodeBurn-#{version}-arm64.dmg"
  name "CodeBurn"
  desc "See where your AI spend goes."
  homepage "https://github.com/getagentseal/codeburn/"

  depends_on :macos

  livecheck do
    url :url
    strategy :github_latest
  end

  app "codeburn.app"
end