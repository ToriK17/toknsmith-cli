# Toknsmith::CLI 🗝️
[![Last Commit](https://img.shields.io/github/last-commit/ToriK17/toknsmith-cli)](https://github.com/ToriK17/toknsmith-cli)
> A minimal, secure CLI for storing and rotating tokens — so you can stop dreading secret management.

## 🚀 Why This Exists

Every team I’ve worked on has treated token rotation like it’s jury duty. It's never fun, it's never fast. 

So I built `toknsmith` — a CLI-first tool that helps you manage sensitive tokens *securely*, *reliably*, and *without hating your life*.

## ✅ What It Does (Today)

- 🔐 `toknsmith login` – Authenticate via CLI and store your session token in macOS Keychain
- 👤 `toknsmith whoami` – Identify the current user (verifies token)
- 🚪 `toknsmith logout` – Revoke your token locally *and* via the API
- 📦 `toknsmith tokens store github` – Store external tokens (like GitHub PATs) with optional notes and expiry metadata
- ⚙️ CLI powered by Thor and built for extension
- 🌐 Fully authenticated API interactions (Bearer + HTTPS)
- 🔒 No secrets ever stored in plain text, anywhere

## 🧠 How It Works

- CLI token is stored in the **macOS Keychain** (Linux & Windows support coming soon)
- API tokens are encrypted **on write** using Rails credentials
- All sessions are scoped, tracked, and revocable
- You control your secrets. We don’t see them. Ever.

## 🛣️ What’s Coming

- ⏳ `--expires-in 30d` style TTLs with automatic cleanup
- 📝 Notes & tags per token for context
- 🔁 CLI token rotation support
- 🔌 GitHub OAuth integration
- 🧠 Fine-grained PAT issuance via CLI
- 📡 Webhook-based rotation events
- 📊 Dashboard for team-wide visibility (long-term vision)

## 📦 Install Locally

_Coming soon via RubyGems — for now:_

```bash
git clone https://github.com/yourhandle/toknsmith-cli.git
cd toknsmith-cli
bundle install
bundle exec rake install
```
🔐 You’ll need an API token to get started. Reach out to request access.

## 🛠️ Usage

`toknsmith login`
- Authenticate and store token in Keychain
- See your token in the macOS keychain with `security find-generic-password -s toknsmith -a auth_token -w`

`toknsmith whoami`
- Confirm your identity with the server

`toknsmith logout`
- Wipe token from Keychain + revoke remotely

```
toknsmith tokens store github \
  --token ghp_abcdef123456 \
  --note "CI deploy key" \
  --expires-in 30d
```
- Store a GitHub token with metadata

## 🔒 Security Notes
- Tokens are persisted using the native macOS Keychain, encrypted at rest by the system, and never stored in plaintext.
_support for Linux and Windows in the future_
- External tokens (like GitHub PATs) are encrypted-at-rest using AES-GCM
- CLI uses Bearer Auth over HTTPS for all requests
- Logs are filtered, secrets are wiped from memory after use
- This CLI assumes zero trust, zero plaintext, and zero nonsense.

## 📜 License & IP
This project was developed independently and is not affiliated with any current or former employer.
All code, documentation, and design is © Kernels & Bits 2025 and released under the [MIT License](https://opensource.org/licenses/MIT).
