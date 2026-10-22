class Claudemux < Formula
  desc "Live status pane and tmux launcher for Claude Code sessions"
  homepage "https://github.com/mquinnv/claudemux"
  license "MIT"

  depends_on "git"
  depends_on "tmux"

  on_macos do
    on_arm do
      url "https://github.com/mquinnv/claudemux/releases/download/v1.5.0/claudemux_1.5.0_darwin_arm64.tar.gz"
      sha256 "aee64a5b81fdc56469c0214620279653374d5a815f54cef69ad9ce89a021263b"
    end
    on_intel do
      url "https://github.com/mquinnv/claudemux/releases/download/v1.5.0/claudemux_1.5.0_darwin_amd64.tar.gz"
      sha256 "7a5b016f8dc81fe083bc210137edd844bfb6e800023157c15c389967db5485dd"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mquinnv/claudemux/releases/download/v1.5.0/claudemux_1.5.0_linux_arm64.tar.gz"
      sha256 "2d9783fbb3a8fe1a461cdd6bb7df410d10221f001e43feef34a2f30172a66398"
    end
    on_intel do
      url "https://github.com/mquinnv/claudemux/releases/download/v1.5.0/claudemux_1.5.0_linux_amd64.tar.gz"
      sha256 "59b693cc096aa69ac28fcb1a2d2a1128754a174ffe37d583bae8ba0020917bbc"
    end
  end

  def install
    # All three files must stay SIBLINGS: claudemux locates
    # project-color-resolve.sh by looking next to its own resolved path. The
    # Claude Code hooks are claudemux-head subcommands, so there are no hook
    # scripts to ship. Keep the real files together in libexec and put only
    # symlinks on PATH.
    #
    # Keep this list in sync with install.sh and .github/workflows/release.yml
    # in mquinnv/claudemux: naming a file the tarball lacks fails the install.
    libexec.install "claudemux-head", "claudemux", "project-color-resolve.sh"
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
