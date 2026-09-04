class Claudemux < Formula
  desc "Live status pane and tmux launcher for Claude Code sessions"
  homepage "https://github.com/mquinnv/claudemux"
  license "MIT"

  depends_on "git"
  depends_on "jq"
  depends_on "tmux"

  on_macos do
    on_arm do
      url "https://github.com/mquinnv/claudemux/releases/download/v1.4.0/claudemux_1.4.0_darwin_arm64.tar.gz"
      sha256 "f703164204f48facc05cb54de93da19c06672c10179591bc24405af6e02577c0"
    end
    on_intel do
      url "https://github.com/mquinnv/claudemux/releases/download/v1.4.0/claudemux_1.4.0_darwin_amd64.tar.gz"
      sha256 "7d8a2f2f4db24a912c2fca38b8913864e16a15d0e0d64339a14366b8c12c11cb"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mquinnv/claudemux/releases/download/v1.4.0/claudemux_1.4.0_linux_arm64.tar.gz"
      sha256 "68c68babe2b2d763e2833d3ae66a9f91a58d8759ae3a430ab67c3a0d2931db8c"
    end
    on_intel do
      url "https://github.com/mquinnv/claudemux/releases/download/v1.4.0/claudemux_1.4.0_linux_amd64.tar.gz"
      sha256 "b66afa6ac84d21c70a0751d3a3a10643e86ec35be9f8923f37ecf9642dd53980"
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
