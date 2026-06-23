cask "virustotal" do
  version "1.5.3"
  sha256 "1213138b678d54f000c8796c9a348a978f0f9eec7387fb8e41a2d87752cbd7c6"

  url "https://github.com/Jerry23011/VirusTotal-macOS/releases/download/#{version}/VirusTotal.dmg"
  name "virustotal"
  desc "An elegant VirusTotal client built with Swift and SwiftUI"
  homepage "https://github.com/Jerry23011/VirusTotal-macOS/"

  depends_on :macos

  livecheck do
    url :url
    strategy :github_latest
  end

  app "virustotal.app"

  zap trash: [
    "~/Library/Application Scripts/org.eu.moyuapp.VirusTotal",
    "~/Library/Application Support/org.eu.moyuapp.VirusTotal",
    "~/Library/Caches/org.eu.moyuapp.VirusTotal",
    "~/Library/HTTPStorages/org.eu.moyuapp.VirusTotal",
    "~/Library/Preferences/org.eu.moyuapp.VirusTotal.plist",
    "~/Library/Saved Application State/org.eu.moyuapp.VirusTotal.savedState",
  ]
end