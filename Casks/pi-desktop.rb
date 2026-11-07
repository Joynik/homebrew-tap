cask "pi-desktop" do
  version "0.2.2-alpha"
  sha256 "4f98662d567c51620afbd0a8a07addf1f4c873490de329476c2d6d74ebc69777"

  url "https://github.com/FaqFirebase/pi-desktop/releases/download/v#{version}/Pi-Desktop-#{version}-mac-arm64.dmg"
  name "Pi Desktop"
  desc "Pi Desktop: a free, open source desktop GUI for the Pi coding agent and oh-my-pi. Chat, edit files, run a terminal, and review diffs in one window."
  homepage "https://github.com/FaqFirebase/pi-desktop/"

  depends_on :macos

  livecheck do
    url :url
    regex(/^v?(\d+(?:\.\d+)+(?:-[0-9a-z.-]+)?)$/i)
    # Upstream currently publishes alpha prereleases without a stable latest release.
    strategy :github_releases do |releases, regex|
      releases.filter_map do |release|
        next if release["draft"]

        version = release["tag_name"]&.[](regex, 1)
        next unless version
        next unless release.fetch("assets", []).any? do |asset|
          asset["state"] == "uploaded" &&
            asset["name"] == "Pi-Desktop-#{version}-mac-arm64.dmg"
        end

        version
      end
    end
  end

  app "Pi Desktop.app"
end