class Claudemux < Formula
  desc "Live status pane and tmux launcher for Claude Code sessions"
  homepage "https://github.com/mquinnv/claudemux"
  version "1.0.0"
  license "MIT"

  depends_on "git"
  depends_on "jq"
  depends_on "tmux"

  on_macos do
    on_arm do
      url "https://github.com/mquinnv/claudemux/releases/download/v1.0.0/claudemux_1.0.0_darwin_arm64.tar.gz"
      sha256 "6a83e331a475631dfa198e3fa4ff0ca3be10fa8158e4c99ec138dfcd250b8c23"
    end
    on_intel do
      url "https://github.com/mquinnv/claudemux/releases/download/v1.0.0/claudemux_1.0.0_darwin_amd64.tar.gz"
      sha256 "7a79b2321e10f56007ae17d48aaea7484054b5198e758cf7a95b7e1eb02962fc"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mquinnv/claudemux/releases/download/v1.0.0/claudemux_1.0.0_linux_arm64.tar.gz"
      sha256 "992f8ed422d1125d5e2298fc1397d9492ddb6a2e083688733e1017db56b45a0b"
    end
    on_intel do
      url "https://github.com/mquinnv/claudemux/releases/download/v1.0.0/claudemux_1.0.0_linux_amd64.tar.gz"
      sha256 "ea09451148b6799108ead9379a78e927801cb79c88a9b6133510446206e32629"
    end
  end

  def install
    # All four files must stay SIBLINGS: claudemux locates
    # project-color-resolve.sh, and claudemux-head locates claudemux-map.sh, by
    # looking next to their own resolved path. Keep the real files together in
    # libexec and put only symlinks on PATH.
    libexec.install "claudemux-head", "claudemux",
                    "project-color-resolve.sh", "claudemux-map.sh"
    bin.install_symlink libexec/"claudemux-head"
    bin.install_symlink libexec/"claudemux"
  end

  def caveats
    <<~EOS
      claudemux registers its Claude Code pane-map hook automatically the first
      time you run it. No manual edits to ~/.claude/settings.json are needed.

      Get started:
        claudemux ~/path/to/project
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claudemux-head version")
  end
end
