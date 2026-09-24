class CodexWallpaper < Formula
  desc "Local video wallpapers and frosted glass for the Codex desktop app"
  homepage "https://github.com/TheRangerStar/codex-video-wallpaper"
  url "https://github.com/TheRangerStar/codex-video-wallpaper/releases/download/v0.1.1/codex-video-wallpaper-0.1.1.tar.gz"
  sha256 "cdde6f9c7aef6775691894bab45b44923a26e6a852593bd58e5d0abb2da2f29d"
  license "MIT"

  depends_on :macos
  depends_on "node@22"

  def install
    libexec.install Dir["*.mjs"], "renderer.js"
    (bin/"codex-wallpaper").write <<~SH
      #!/bin/sh
      export CODEX_WALLPAPER_DATA_DIR="${CODEX_WALLPAPER_DATA_DIR:-$HOME/Library/Application Support/codex-video-wallpaper}"
      export CODEX_WALLPAPER_INSTALL_ROOT="#{HOMEBREW_CELLAR}/codex-wallpaper"
      exec "#{Formula["node@22"].opt_bin}/node" "#{libexec}/terminal-entry.mjs" "$@"
    SH
  end

  def caveats
    <<~EOS
      Run codex-wallpaper to connect and open the menu.
      Select option 4 to stop the wallpaper before uninstalling.
      Settings are kept in ~/Library/Application Support/codex-video-wallpaper.
    EOS
  end

  test do
    assert_equal "0.1.1", shell_output("#{bin}/codex-wallpaper --version").strip
    assert_match "MP4", shell_output("#{bin}/codex-wallpaper --help")
    assert_match "codex-wallpaper", shell_output("#{bin}/codex-wallpaper invalid 2>&1", 2)
  end
end
