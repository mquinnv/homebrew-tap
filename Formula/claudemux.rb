class Claudemux < Formula
  desc "Live status pane and tmux launcher for Claude Code sessions"
  homepage "https://github.com/mquinnv/claudemux"
  version "1.1.0"
  license "MIT"

  depends_on "git"
  depends_on "jq"
  depends_on "tmux"

  on_macos do
    on_arm do
      url "https://github.com/mquinnv/claudemux/releases/download/v1.1.0/claudemux_1.1.0_darwin_arm64.tar.gz"
      sha256 "9c4aeebccacd045e2678e09a937eeab8c384f2abf7c16828056b0d6bcc7c3179"
    end
    on_intel do
      url "https://github.com/mquinnv/claudemux/releases/download/v1.1.0/claudemux_1.1.0_darwin_amd64.tar.gz"
      sha256 "29dc8119a6d6a439198a78b17a125e6bd5cf77683c797a141c17916eb3d13db5"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mquinnv/claudemux/releases/download/v1.1.0/claudemux_1.1.0_linux_arm64.tar.gz"
      sha256 "0ae87d742adf9948038dc541314468bc56411455e6820918decc25d31ca429ee"
    end
    on_intel do
      url "https://github.com/mquinnv/claudemux/releases/download/v1.1.0/claudemux_1.1.0_linux_amd64.tar.gz"
      sha256 "bfab042559cadc40c8293ff9449cd1433914fd7024a04728f454cfa21910a9af"
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
