# PageCrawl Homebrew tap

Formulae for [PageCrawl](https://pagecrawl.io) tools.

## PageCrawl Relay

Runs your PageCrawl checks through a computer you own, for pages that refuse
datacenter addresses or that only your network can reach. Free on every plan.

```bash
brew install pagecrawl/tap/pagecrawl-relay
pagecrawl-relay
```

That opens a settings page in your browser. Paste the token from **Settings → Relays**
in PageCrawl and press Connect.

For a machine that should relay whenever it is awake:

```bash
brew services start pagecrawl-relay
```

To update:

```bash
brew upgrade pagecrawl-relay
```

### Why install it this way

The binaries are not code-signed yet, so a browser download is quarantined and macOS
refuses to open it. Homebrew fetches with curl, which sets no quarantine flag, so the
program installs and runs without that warning, and `brew upgrade` gives you a real
update path.

Source, security policy and the destination guard that refuses your own network:
[github.com/pagecrawl/pagecrawl-relay](https://github.com/pagecrawl/pagecrawl-relay).
