# PageCrawl Relay.
#
# Homebrew rather than a downloaded binary for two reasons that matter more than
# convenience: `brew upgrade` is a real update path, and brew fetches with curl, so
# the file never carries the quarantine flag that makes macOS refuse an unsigned
# download. The binaries are not code-signed yet; see the repository's README.
class PagecrawlRelay < Formula
  desc "Route your own PageCrawl checks through a computer you own"
  homepage "https://github.com/pagecrawl/pagecrawl-relay"
  version "0.1.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/pagecrawl/pagecrawl-relay/releases/download/v0.1.2/pagecrawl-relay-darwin-arm64"
      sha256 "7416d7825fbc6b9b9491b6703f145779607597f822caa7d91fee15de208a5df7"
    end

    on_intel do
      url "https://github.com/pagecrawl/pagecrawl-relay/releases/download/v0.1.2/pagecrawl-relay-darwin-amd64"
      sha256 "56f1a655ee3934bcec855df8b51677b98324f02292ebf37846e56e8cb82be282"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/pagecrawl/pagecrawl-relay/releases/download/v0.1.2/pagecrawl-relay-linux-arm64"
      sha256 "f8e7d465c909011a2db164fb055898b459c7ab5b9cb5f8a13eb6cf7c8fe70b1f"
    end

    on_intel do
      url "https://github.com/pagecrawl/pagecrawl-relay/releases/download/v0.1.2/pagecrawl-relay-linux-amd64"
      sha256 "e66afb204ef511dabaf3d277e4a7a0398045ab08265baea06781e4d3a96927fa"
    end
  end

  def install
    # A bare binary download stages exactly one file, whose name is the release asset's
    # and so differs per platform. Taking whatever is there beats matching a pattern
    # against a name Homebrew is free to change, and installs it under one command
    # name so upgrades replace it cleanly.
    bin.install Dir["*"].first => "pagecrawl-relay"
  end

  # `brew services start pagecrawl-relay` for a machine that should relay whenever it
  # is awake. Headless because a service has no browser to open: set the token once
  # with the app or with PAGECRAWL_RELAY_TOKEN, and it is remembered.
  service do
    run [opt_bin/"pagecrawl-relay", "-headless"]
    keep_alive true
    log_path var/"log/pagecrawl-relay.log"
    error_log_path var/"log/pagecrawl-relay.log"
  end

  def caveats
    <<~EOS
      Enrol this machine in PageCrawl under Settings then Relays, then run:

        pagecrawl-relay

      It opens a settings page in your browser where you paste the token. For a
      machine that should always relay:

        brew services start pagecrawl-relay

      Check it at any time with:

        pagecrawl-relay -check
    EOS
  end

  test do
    assert_match "pagecrawl-relay", shell_output("#{bin}/pagecrawl-relay -version")
  end
end
