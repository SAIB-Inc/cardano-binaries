# Cardano Binaries

> 🚀 **Enterprise-grade cross-platform binary releases for Cardano ecosystem tools**  
> *Powered by [SAIB Inc.](https://github.com/SAIB-Inc) | Automated builds from official IntersectMBO sources*

[![Build Status](https://github.com/SAIB-Inc/cardano-binaries/workflows/Build%20Cardano%20Addresses/badge.svg)](https://github.com/SAIB-Inc/cardano-binaries/actions)
[![License](https://img.shields.io/github/license/SAIB-Inc/cardano-binaries)](LICENSE)
[![Latest Release](https://img.shields.io/github/v/release/SAIB-Inc/cardano-binaries)](https://github.com/SAIB-Inc/cardano-binaries/releases/latest)

## 🎯 **What We Provide**

Ready-to-use, statically-linked Cardano binaries for multiple platforms:
- ✅ **ARM64 Linux** (Raspberry Pi, Apple Silicon servers)
- 🚧 **x64 Linux** (Traditional servers) 
- 🚧 **macOS** (Intel & Apple Silicon)
- 🚧 **Windows** (x64)

## 🔥 **Why Choose Our Binaries?**

- 🔒 **Security-First**: Non-root execution, minimal attack surface
- ⚡ **Performance**: Optimized builds with intelligent caching  
- 🛡️ **Reliability**: Enterprise-grade error handling & validation
- 📦 **Portable**: Static linking ensures maximum compatibility
- 🤖 **Automated**: Direct builds from official IntersectMBO sources
- ✅ **Verified**: Comprehensive testing & checksum validation

## Available Binaries

- **cardano-addresses** - Address derivation and validation tool for Linux ARM64 (Raspberry Pi)

## Release System

This repository uses binary-specific tags to trigger builds for individual tools:

### Tag Format
```
<binary-name>-<version>
```

### Examples
- `cardano-addresses-4.0.0` - Builds cardano-addresses version 4.0.0 (latest)
- `cardano-cli-8.20.0` - Would build cardano-cli version 8.20.0 (when implemented)
- `cardano-node-8.9.0` - Would build cardano-node version 8.9.0 (when implemented)

### How It Works
1. **Tag Push**: Push a binary-specific tag (e.g., `cardano-addresses-4.0.0`)
2. **Version Extraction**: The workflow extracts the version (`4.0.0`) from the tag
3. **Source Checkout**: Checks out the corresponding tag from the IntersectMBO repository
4. **Build**: Builds the binary using the recommended GHC/Cabal versions
5. **Release**: Creates a GitHub release with the compiled binaries

### Usage
```bash
# Release cardano-addresses 4.0.0 (latest)
git tag cardano-addresses-4.0.0
git push origin cardano-addresses-4.0.0

# This will:
# 1. Trigger the cardano-addresses workflow
# 2. Build from IntersectMBO/cardano-addresses tag 4.0.0
# 3. Create release with ARM64 binaries
```

## Supported Platforms

| Binary | Linux ARM64 | Linux x64 | macOS ARM64 | macOS x64 | Windows x64 |
|--------|-------------|-----------|-------------|-----------|-------------|
| cardano-addresses | ✅ | 🚧 | 🚧 | 🚧 | 🚧 |

Legend: ✅ Available, 🚧 Planned, ❌ Not supported

## Contributing

We welcome contributions to add support for more binaries and platforms!

### Development Workflow

1. **Fork and Clone**: Fork this repository and clone your fork
2. **Create Feature Branch**: `git checkout -b feat/your-feature-name`
3. **Make Changes**: Add new Dockerfiles, workflows, or improvements
4. **Test Locally**: Build and test your changes locally when possible
5. **Commit**: Use conventional commits (e.g., `feat:`, `fix:`, `docs:`)
6. **Create PR**: Open a pull request against the `main` branch
7. **Squash Merge**: All PRs should be **squash merged** to maintain clean commit history

### Adding New Binaries

To add support for a new Cardano binary:

1. Create `Dockerfile.<binary-name>-<platform>` (e.g., `Dockerfile.cardano-cli-linux-arm64`)
2. Create `.github/workflows/build-<binary-name>.yml` workflow
3. Use binary-specific tag pattern: `<binary-name>-v*`
4. Update this README with the new binary information
5. Test with a version tag (e.g., `cardano-cli-v8.20.0`)

### PR Requirements

- ✅ **Squash merge required** - Maintains clean commit history
- ✅ Use conventional commit messages
- ✅ Test builds locally when possible  
- ✅ Update documentation for new features
- ✅ Follow existing patterns and conventions

### Questions?

Open an issue for questions about contributing or adding new binary support.

---

## 🏢 **About SAIB**

**SAIB** is a software development company based in the Philippines, established by connecting the dots of its founders' shared passion for Cardano. We specialize in:

- 🚀 **Cardano Development**: .NET ecosystem integration with Chrysalis & Argus frameworks
- 🔧 **Developer Tools**: Open-source utilities for the Cardano ecosystem  
- 🏗️ **Digital Transformation**: Custom blockchain integrations and enterprise solutions
- 📦 **Infrastructure**: Cross-platform binary distributions and developer resources

*"Softwarez, at its Best - Where Software Meets Perfection"*

**Connect with us:**
- 🌐 **Website**: [saib.dev](https://saib.dev)
- 📚 **Documentation**: [docs.saib.dev](https://docs.saib.dev)
- 🐙 **GitHub**: [@SAIB-Inc](https://github.com/SAIB-Inc)
- 📅 **Schedule a Call**: [calendly.com/saibdev](https://calendly.com/saibdev)
- 🐦 **Twitter**: [@saibdev](https://x.com/saibdev)
- 💼 **LinkedIn**: [SAIB LLC](https://www.linkedin.com/company/saibllc/)

---

<div align="center">

**⭐ Star this repo if you find it useful!**

Made with ❤️ by [SAIB](https://saib.dev) | Contributing to the Cardano ecosystem

</div>
