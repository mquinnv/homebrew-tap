class Claudemux < Formula
  desc "Live status pane and tmux launcher for Claude Code sessions"
  homepage "https://github.com/mquinnv/claudemux"
  version "0.1.0"
  license "MIT"

  depends_on "git"
  depends_on "jq"
  depends_on "tmux"

  on_macos do
    on_arm do
      url "https://github.com/mquinnv/claudemux/releases/download/v0.1.0/claudemux_0.1.0_darwin_arm64.tar.gz"
      sha256 "ee9d49e0c176c360e56f0cef83d68e8c6c7e11bc8e97e5b30fdb8dc67beff4fd"
    end
    on_intel do
      url "https://github.com/mquinnv/claudemux/releases/download/v0.1.0/claudemux_0.1.0_darwin_amd64.tar.gz"
      sha256 "2d32a02b813040509a6b43db071f8f6ad8ed4153c7086cb3a689526bbafe5906"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mquinnv/claudemux/releases/download/v0.1.0/claudemux_0.1.0_linux_arm64.tar.gz"
      sha256 "6c7b9d9b6821568017ab4f74a873c438657ac6c3cbc6c468d76cd5210fb0c399"
    end
    on_intel do
      url "https://github.com/mquinnv/claudemux/releases/download/v0.1.0/claudemux_0.1.0_linux_amd64.tar.gz"
      sha256 "21eab0e6c904b3a713a32ac8349bb5f1a98e99a35e1bcd1282926005c2a4265d"
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
