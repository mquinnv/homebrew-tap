class Claudemux < Formula
  desc "Live status pane and tmux launcher for Claude Code sessions"
  homepage "https://github.com/mquinnv/claudemux"
  license "MIT"

  depends_on "git"
  depends_on "jq"
  depends_on "tmux"

  on_macos do
    on_arm do
      url "https://github.com/mquinnv/claudemux/releases/download/v1.3.1/claudemux_1.3.1_darwin_arm64.tar.gz"
      sha256 "ce13938b13652a35bcf0402cbdbc45a6bea52c87462283b6e368e70bfceea5ad"
    end
    on_intel do
      url "https://github.com/mquinnv/claudemux/releases/download/v1.3.1/claudemux_1.3.1_darwin_amd64.tar.gz"
      sha256 "d65a6539c84c19f9d4c47fde726ff35de8e8edd031fdf2a74abc98dfefc3727b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mquinnv/claudemux/releases/download/v1.3.1/claudemux_1.3.1_linux_arm64.tar.gz"
      sha256 "01a3f9b72f8b1c1623e0616a9e0794c8de3de5fb17bf36c94f88c4bf71f1d096"
    end
    on_intel do
      url "https://github.com/mquinnv/claudemux/releases/download/v1.3.1/claudemux_1.3.1_linux_amd64.tar.gz"
      sha256 "dc540e2ad89da91e151d78cc1abf7b4b264c26b4986a46ee2e8c2890d663ccce"
    end
  end

  def install
    # All six files must stay SIBLINGS: claudemux locates
    # project-color-resolve.sh, and claudemux-head locates claudemux-map.sh,
    # claudemux-worktree.sh and claudemux-ask.sh, by looking next to their own
    # resolved path. Keep the real files together in libexec and put only
    # symlinks on PATH.
    #
    # `claudemux-head hook ensure` validates EVERY name below before copying
    # any of them, so omitting one silently disables hook registration
    # entirely -- not just the missing script. Keep this list in sync with
    # install.sh and .github/workflows/release.yml in mquinnv/claudemux.
    libexec.install "claudemux-head", "claudemux",
                    "project-color-resolve.sh", "claudemux-map.sh",
                    "claudemux-worktree.sh", "claudemux-ask.sh"
    bin.install_symlink libexec/"claudemux-head"
    bin.install_symlink libexec/"claudemux"
  end

  def caveats
    <<~EOS
      claudemux registers its Claude Code hooks automatically the first time
      you run it. No manual edits to ~/.claude/settings.json are needed.

      Get started:
        claudemux ~/path/to/project
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claudemux-head version")
  end
end
