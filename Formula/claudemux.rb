class Claudemux < Formula
  desc "Live status pane and tmux launcher for Claude Code sessions"
  homepage "https://github.com/mquinnv/claudemux"
  license "MIT"

  depends_on "git"
  depends_on "jq"
  depends_on "tmux"

  on_macos do
    on_arm do
      url "https://github.com/mquinnv/claudemux/releases/download/v1.2.0/claudemux_1.2.0_darwin_arm64.tar.gz"
      sha256 "b4fc7b50d860a50f2f8b02162d17b8e3d14923a68b57941f4bec592d89908b1a"
    end
    on_intel do
      url "https://github.com/mquinnv/claudemux/releases/download/v1.2.0/claudemux_1.2.0_darwin_amd64.tar.gz"
      sha256 "6ffe19af24d1ac292a5f2f72ab999fb432783a712377036ea77ed17d57d6a45d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mquinnv/claudemux/releases/download/v1.2.0/claudemux_1.2.0_linux_arm64.tar.gz"
      sha256 "1041397fe462312b3edc3f76ab0905171ddd1f92112fd2c791887b98a528eead"
    end
    on_intel do
      url "https://github.com/mquinnv/claudemux/releases/download/v1.2.0/claudemux_1.2.0_linux_amd64.tar.gz"
      sha256 "87f82b45b2773733347bf59ca5df9d00412d29b70bc8b47522fe5f5ecd72fae7"
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
