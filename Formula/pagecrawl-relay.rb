# PageCrawl Relay.
#
# Homebrew rather than a downloaded binary for two reasons that matter more than
# convenience: `brew upgrade` is a real update path, and brew fetches with curl, so
# the file never carries the quarantine flag that makes macOS refuse an unsigned
# download. The binaries are not code-signed yet; see the repository's README.
class PagecrawlRelay < Formula
  desc "Route your own PageCrawl checks through a computer you own"
  homepage "https://github.com/pagecrawl/pagecrawl-relay"
  version "0.1.3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/pagecrawl/pagecrawl-relay/releases/download/v0.1.3/pagecrawl-relay-darwin-arm64"
      sha256 "1a0fb24eb50dad44b694c7889db26d12917ae47c95edf3c0e8d2ebb102ca374d"
    end

    on_intel do
      url "https://github.com/pagecrawl/pagecrawl-relay/releases/download/v0.1.3/pagecrawl-relay-darwin-amd64"
      sha256 "88c59285f431d712b30aa78938ed3954126f87df32691b17c4b863c8251553e9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/pagecrawl/pagecrawl-relay/releases/download/v0.1.3/pagecrawl-relay-linux-arm64"
      sha256 "71720a76db1541e590060eca8f7524cae619cc7e923843ccb9b1c53a821b2ffa"
    end

    on_intel do
      url "https://github.com/pagecrawl/pagecrawl-relay/releases/download/v0.1.3/pagecrawl-relay-linux-amd64"
      sha256 "03cb06def9ea04e9f5c5787d8655054a4960bf60340fe684b99c46921f1321cb"
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
