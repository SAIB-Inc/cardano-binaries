# Cardano Binaries

**Pre-compiled Cardano tools that just work.** No compilation headaches, no dependency issues.

[![Build Status](https://github.com/SAIB-Inc/cardano-binaries/workflows/Build%20Cardano%20Addresses/badge.svg)](https://github.com/SAIB-Inc/cardano-binaries/actions)
[![License](https://img.shields.io/github/license/SAIB-Inc/cardano-binaries)](LICENSE)
[![Latest Release](https://img.shields.io/github/v/release/SAIB-Inc/cardano-binaries)](https://github.com/SAIB-Inc/cardano-binaries/releases/latest)

## The Problem

Building Cardano tools from source is frustrating:
- ❌ **Hours of compilation** time on slower machines
- ❌ **Complex dependency chains** that break randomly  
- ❌ **Platform-specific issues** that waste your time
- ❌ **Missing ARM64 support** for Raspberry Pi users

## The Solution

**Download and run.** We build the binaries so you don't have to.

- ✅ **Ready in seconds** - No compilation required
- ✅ **All dependencies included** - Static linking means it just works
- ✅ **Raspberry Pi support** - First-class ARM64 binaries  
- ✅ **Built from official sources** - Same code, pre-compiled for you

## What's Available

| Tool | Description | Platforms |
|------|-------------|-----------|
| **cardano-addresses** | Derive and validate Cardano addresses | ARM64 Linux (Raspberry Pi) |
| **bech32** | Encode/decode Bech32 address format | ARM64 Linux (Raspberry Pi) |
| cardano-cli | *Coming soon* | - |
| cardano-node | *Coming soon* | - |

## Quick Start

1. **Download** the binary from [Releases](https://github.com/SAIB-Inc/cardano-binaries/releases)
2. **Extract** the archive: `tar -xzf cardano-addresses-linux-arm64.tar.gz`
3. **Run** it: `./cardano-addresses --version`

That's it. No building, no dependencies, no hassle.

## For Maintainers: Release Process

We use binary-specific tags to trigger automated builds:

```bash
# Release cardano-addresses version 4.0.0
git tag cardano-addresses-4.0.0
git push origin cardano-addresses-4.0.0

# Release bech32 version 1.1.7
git tag bech32-1.1.7
git push origin bech32-1.1.7
```

This automatically:
1. Builds the binary from the official IntersectMBO repository
2. Creates a GitHub release with downloadable files
3. Includes checksums for verification

## Platform Roadmap

| Tool | Linux ARM64 | Linux x64 | macOS | Windows |
|------|-------------|-----------|-------|---------|
| cardano-addresses | ✅ | 🚧 | 🚧 | 🚧 |
| bech32 | ✅ | 🚧 | 🚧 | 🚧 |
| cardano-cli | 🚧 | 🚧 | 🚧 | 🚧 |
| cardano-node | 🚧 | 🚧 | 🚧 | 🚧 |

✅ Available • 🚧 Planned

## Contributing

Want to add a new tool or platform? We'd love your help!

**Quick start:**
1. Fork this repo
2. Copy an existing `Dockerfile.*` and workflow as a template  
3. Update for your tool/platform
4. Test it works
5. Open a PR

**Requirements:**
- Use conventional commits (`feat:`, `fix:`, etc.)
- Test builds locally when possible
- All PRs are squash-merged

Questions? Open an issue.

---

## About SAIB

This project is maintained by **SAIB**, a software development company specializing in Cardano ecosystem tools and infrastructure.

**Services:**
- Cardano development (.NET integration)
- Developer tools and utilities
- Custom blockchain solutions

**Connect:** [saib.dev](https://saib.dev) • [GitHub](https://github.com/SAIB-Inc) • [Twitter](https://x.com/saibdev)

---

⭐ **Star this repo if it saves you time!**
