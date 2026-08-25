class Claudemux < Formula
  desc "Live status pane and tmux launcher for Claude Code sessions"
  homepage "https://github.com/mquinnv/claudemux"
  license "MIT"

  depends_on "git"
  depends_on "jq"
  depends_on "tmux"

  on_macos do
    on_arm do
      url "https://github.com/mquinnv/claudemux/releases/download/v1.3.0/claudemux_1.3.0_darwin_arm64.tar.gz"
      sha256 "987e46a4fb5a17848ab97174bdc61cecb09a65d21e639357c71ec029062ac3e1"
    end
    on_intel do
      url "https://github.com/mquinnv/claudemux/releases/download/v1.3.0/claudemux_1.3.0_darwin_amd64.tar.gz"
      sha256 "79d2553021985305ac67acaf5ef260a12d6fd53779af132a1d53fb3d4bdbe508"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mquinnv/claudemux/releases/download/v1.3.0/claudemux_1.3.0_linux_arm64.tar.gz"
      sha256 "61c39882216ddb71eafff77f93e0dfa41f3fe6deab7bd3ad87166039ecbddd64"
    end
    on_intel do
      url "https://github.com/mquinnv/claudemux/releases/download/v1.3.0/claudemux_1.3.0_linux_amd64.tar.gz"
      sha256 "1d88781742be2f679a087c53324af4fba337df04aa93f4d8be0377ec93aa3d68"
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
