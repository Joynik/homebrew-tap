cask "codeburn" do
  version "0.9.28"
  sha256 "37ce4922d7d04531a486bc743307329c21325b2f573fea7caf20eabd072efc5a"

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