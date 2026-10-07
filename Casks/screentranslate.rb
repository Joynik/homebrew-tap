cask "screentranslate" do
  version "1.6.0"
  sha256 "9fca5f290f5159aea6f394b3214e70963efd60f9397934d594ddcc0fc49be5f6"

  url "https://github.com/hcmhcs/screenTranslate/releases/download/v#{version}/ScreenTranslate-#{version}.dmg"
  name "ScreenTranslate"
  desc "Translate any text on your Mac screen — capture or select."
  homepage "https://github.com/hcmhcs/screenTranslate"

  depends_on :macos

  livecheck do
    url :url
    strategy :github_latest
  end

  app "ScreenTranslate.app"
end