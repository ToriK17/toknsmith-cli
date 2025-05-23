# Toknsmith::CLI 🗝️
[![Last Commit](https://img.shields.io/github/last-commit/ToriK17/toknsmith-cli)](https://github.com/ToriK17/toknsmith-cli)
> A minimal, secure CLI for storing and rotating tokens — so you can stop dreading secret management.

## 🚀 Why This Exists

Every team I’ve worked on has treated token rotation like it’s jury duty. It's never fun, it's never fast. 

So I built `toknsmith`, a CLI-first tool that helps you manage sensitive tokens *securely*, *reliably*, and *without hating your life*.

## ✅ What It Does (Today)

- 🔐 `toknsmith login` – Authenticate via CLI and store your session token in macOS Keychain
- 👤 `toknsmith whoami` – Identify the current user (verifies token)
- 🚪 `toknsmith logout` – Revoke your token locally *and* via the API
- 📦 `toknsmith tokens store github` – Store external tokens (like GitHub PATs) as an encrypted blob, with optional notes and expiry metadata
- 🔧 `toknsmith oauth configure github` — Kick off the GitHub OAuth browser flow and vault the access token automatically
- 🌐 `toknsmith oauth connect github` – Launch the GitHub OAuth flow, approve access, and vault a live OAuth token automatically
- 🔄 Token encryption & decryption powered by external middleware (zero secret handling inside the API)
- 🔒 CLI, API, and middleware work together in a zero-trust, split-responsibility model
- ⚙️ CLI powered by [Thor](https://github.com/rails/thor) — clean commands, easy extensions
- 🌐 Authenticated API interactions — Bearer Token + HTTPS
- 🔒 Zero secrets stored plaintext. Ever.

## 🧠 How It Works

- CLI token is stored in the **macOS Keychain** (Linux & Windows support coming soon)
- Tokens are encrypted-at-rest using strong authenticated encryption standards before being transmitted.
- OAuth client secrets are vaulted separately via external encryptors (not stored directly)
- All sessions are fully scoped, session-based, and revocable at any time

## 🛣️ What’s Coming

- ⏳ `--expires-in 30d` style token TTLs + automatic cleanup
- 📝 Notes and tags for smarter token management
- 🔁 OAuth token rotation support via CLI
- 🔌 OAuth integrations (GitHub currently complete, plans to expand to other VCS and providers)
- 🧠 Fine-grained PAT issuance via CLI
- 📡 Webhook-based rotation events
- 📊 Admin Dashboard for team token visibility (super long-term vision)

## 📦 Install Toknsmith Locally

_Coming soon via RubyGems — for now:_

```bash
git clone https://github.com/yourhandle/toknsmith-cli.git
cd toknsmith-cli
bundle install
bundle exec rake install
```
🔐 You’ll need an API token to get started. Reach out to request access.

## 🛠️ Usage

### Authenticate:

`toknsmith login`
- Authenticate and store token in Keychain
- See your token in the macOS keychain with `security find-generic-password -s toknsmith -a auth_token -w`

### Check current session:

`toknsmith whoami`
- Confirm your identity with the server

### Logout securely:

`toknsmith logout`
- Wipe token from Keychain + revoke remotely

### Store a Service Token (e.g. GitHub PAT):

```
toknsmith tokens service store github \
  --token ghp_abcdef123456 \
  --note "CI deploy key" \
  --expires-in 30d
```
- Vaults a token for future automation use
- Metadata helps track usage, purpose, and lifecycle

### Configure an OAuth App:

`toknsmith oauth configure github`
- Securely store your GitHub OAuth App's client ID and client secret
- These values are encrypted and stored via external middleware — the API never sees plain text

### Initiate GitHub OAuth Flow:
`toknsmith oauth connect github`
- Opens a browser window to begin OAuth authorization
- After approval, vaults the access token securely
- Ideal for setting up GitHub org-level access

## 🔒 Security Notes
- Auth token is persisted using the native macOS Keychain, encrypted at rest by the system, and never stored in plaintext.
_support for Linux and Windows in the future_
- External tokens (like GitHub PATs) are encrypted-at-rest with a server side algorithm
- CLI uses Bearer Auth over HTTPS for all requests
- No plaintext secrets written to disk, memory, logs, or network
- CLI treats every operation with a zero-trust mentality: verify everything, assume nothing
- Coming soon: external key encryption for maximum split-trust security

## 📜 License & IP
This project was built independently with no employer affiliation.
All code, documentation, and design is © Kernels & Bits LLC 2025 and released under the [MIT License](https://opensource.org/licenses/MIT).
