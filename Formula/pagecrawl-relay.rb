# PageCrawl Relay.
#
# Homebrew rather than a downloaded binary for two reasons that matter more than
# convenience: `brew upgrade` is a real update path, and brew fetches with curl, so
# the file never carries the quarantine flag that makes macOS refuse an unsigned
# download. The binaries are not code-signed yet; see the repository's README.
class PagecrawlRelay < Formula
  desc "Route your own PageCrawl checks through a computer you own"
  homepage "https://github.com/pagecrawl/pagecrawl-relay"
  version "0.1.4"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/pagecrawl/pagecrawl-relay/releases/download/v0.1.4/pagecrawl-relay-darwin-arm64"
      sha256 "398aba631ae86a866e1d700dd7af7a33b63410a0176a4cb5d9b0aae48f892317"
    end

    on_intel do
      url "https://github.com/pagecrawl/pagecrawl-relay/releases/download/v0.1.4/pagecrawl-relay-darwin-amd64"
      sha256 "658c7a4d5889d07727f62bae3eefc92238fb71e6571ea0700caa45650f770ff5"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/pagecrawl/pagecrawl-relay/releases/download/v0.1.4/pagecrawl-relay-linux-arm64"
      sha256 "1dcd3e6197acc67aaf00bdac074906e3fac13c96ba0872edcb092b643ac1707a"
    end

    on_intel do
      url "https://github.com/pagecrawl/pagecrawl-relay/releases/download/v0.1.4/pagecrawl-relay-linux-amd64"
      sha256 "cdb3ddba9166a79b3e04470d76ce7fe4abc20c58ef9b61f1415c509b16c427ff"
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
