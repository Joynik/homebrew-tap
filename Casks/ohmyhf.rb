cask "ohmyhf" do
  version "0.0.20"
  sha256 "6823be3340dc4f2c8f65e992abf7e353ddd70e4c4797a3f755fad27c4dc009b0"

  url "https://github.com/fzlzjerry/ohmyhf/releases/download/v#{version}/Oh-My-HuggingFace-#{version}-arm64.dmg"
  name "Oh My HuggingFace"
  desc "Unofficial cross-platform desktop client for the Hugging Face Hub"
  homepage "https://github.com/fzlzjerry/ohmyhf/"

  depends_on :macos

  livecheck do
    url :url
    strategy :github_latest
  end

  app "Oh My HuggingFace.app"
end
