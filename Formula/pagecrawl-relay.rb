# PageCrawl Relay.
#
# Homebrew rather than a downloaded binary because `brew upgrade` is a real update
# path. The macOS binaries are signed with an Apple Developer ID and notarized as of
# v0.1.7, so a browser download no longer warns either; this installs the
# command-line program, while the release's .dmg carries the menu-bar app.
class PagecrawlRelay < Formula
  desc "Route your own PageCrawl checks through a computer you own"
  homepage "https://github.com/pagecrawl/pagecrawl-relay"
  version "0.1.7"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/pagecrawl/pagecrawl-relay/releases/download/v0.1.7/pagecrawl-relay-darwin-arm64"
      sha256 "7af21d16d10e1e18a574d9c3520b43990e4877a81fff4d76e6c29c8aa9924f2d"
    end

    on_intel do
      url "https://github.com/pagecrawl/pagecrawl-relay/releases/download/v0.1.7/pagecrawl-relay-darwin-amd64"
      sha256 "9ae3ec8797422e9c3e248b77985036947ecbb525a16b8bec840f8d2523bf9c2d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/pagecrawl/pagecrawl-relay/releases/download/v0.1.7/pagecrawl-relay-linux-arm64"
      sha256 "6d882602bb55e81919ce481289c0e6a24f858a786a9c5033350872cf8a2f5432"
    end

    on_intel do
      url "https://github.com/pagecrawl/pagecrawl-relay/releases/download/v0.1.7/pagecrawl-relay-linux-amd64"
      sha256 "50a17b4793319fcb16204ff4fb76c3ad0c91367de0b4e37f60d8d08b1c2a1433"
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
