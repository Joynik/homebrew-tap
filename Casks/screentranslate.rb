cask "screentranslate" do
  version "1.5.3"
  sha256 "38b861b4debf63badc6666e31fa72f2f3f2d03093a659a2718cab9f6aee5186d"

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