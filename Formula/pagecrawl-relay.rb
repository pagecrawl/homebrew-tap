# PageCrawl Relay.
#
# Homebrew rather than a downloaded binary for two reasons that matter more than
# convenience: `brew upgrade` is a real update path, and brew fetches with curl, so
# the file never carries the quarantine flag that makes macOS refuse an unsigned
# download. The binaries are not code-signed yet; see the repository's README.
class PagecrawlRelay < Formula
  desc "Route your own PageCrawl checks through a computer you own"
  homepage "https://github.com/pagecrawl/pagecrawl-relay"
  version "0.1.5"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/pagecrawl/pagecrawl-relay/releases/download/v0.1.5/pagecrawl-relay-darwin-arm64"
      sha256 "740039b1db04391880105a1151aa3743f6546bc882a9c6edc4fb3726452fd0c3"
    end

    on_intel do
      url "https://github.com/pagecrawl/pagecrawl-relay/releases/download/v0.1.5/pagecrawl-relay-darwin-amd64"
      sha256 "e428b4ce765cd45d487dbdd6de9434f3bb2a6961745d68ece79e8dd95807468d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/pagecrawl/pagecrawl-relay/releases/download/v0.1.5/pagecrawl-relay-linux-arm64"
      sha256 "895488d0f572f1e12fcac9cbf702099dd659e9e9e71de26841f0045fd23706e6"
    end

    on_intel do
      url "https://github.com/pagecrawl/pagecrawl-relay/releases/download/v0.1.5/pagecrawl-relay-linux-amd64"
      sha256 "f158f4e76c1001d6d3e55dfc06bc5a75116b1596a341702b7d47b3f426bab131"
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
