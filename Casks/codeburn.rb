cask "codeburn" do
  version "0.9.27"
  sha256 "81f77bb6aa76bc618ff4a3f1798ce60b9b16f6d7b50629b6d1cab4d977cb17fb"

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