# Cardano Binaries

Cross-platform binary releases for Cardano ecosystem tools.

## Available Binaries

- **cardano-addresses** - Address derivation and validation tool for Linux ARM64 (Raspberry Pi)

## Release System

This repository uses binary-specific tags to trigger builds for individual tools:

### Tag Format
```
<binary-name>-v<version>
```

### Examples
- `cardano-addresses-v3.15.0` - Builds cardano-addresses version 3.15.0
- `cardano-cli-v8.20.0` - Would build cardano-cli version 8.20.0 (when implemented)
- `cardano-node-v8.9.0` - Would build cardano-node version 8.9.0 (when implemented)

### How It Works
1. **Tag Push**: Push a binary-specific tag (e.g., `cardano-addresses-v3.15.0`)
2. **Version Extraction**: The workflow extracts the version (`v3.15.0`) from the tag
3. **Source Checkout**: Checks out the corresponding tag from the IntersectMBO repository
4. **Build**: Builds the binary using the recommended GHC/Cabal versions
5. **Release**: Creates a GitHub release with the compiled binaries

### Usage
```bash
# Release cardano-addresses v3.15.0
git tag cardano-addresses-v3.15.0
git push origin cardano-addresses-v3.15.0

# This will:
# 1. Trigger the cardano-addresses workflow
# 2. Build from IntersectMBO/cardano-addresses tag v3.15.0
# 3. Create release with ARM64 binaries
```

## Supported Platforms

| Binary | Linux ARM64 | Linux x64 | macOS ARM64 | macOS x64 | Windows x64 |
|--------|-------------|-----------|-------------|-----------|-------------|
| cardano-addresses | ✅ | 🚧 | 🚧 | 🚧 | 🚧 |

Legend: ✅ Available, 🚧 Planned, ❌ Not supported
