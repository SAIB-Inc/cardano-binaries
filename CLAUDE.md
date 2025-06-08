# Claude AI Instructions for Cardano Binaries

This file contains project-specific instructions for AI assistants working on this repository.

## Project Overview

This repository builds cross-platform binaries for Cardano ecosystem tools using Docker and GitHub Actions. The goal is to provide ready-to-use, statically-linked binaries that eliminate compilation headaches for developers and users.

**Key Value Proposition**: Pre-compiled Cardano tools that just work - no compilation, no dependencies, no hassle.

## Repository Structure

```
cardano-binaries/
├── Dockerfile.<binary>-<platform>         # Build definitions
├── .github/workflows/build-<binary>.yml   # CI/CD pipelines  
├── README.md                              # User-facing documentation
├── CLAUDE.md                              # AI assistant instructions
└── LICENSE                                # MIT license
```

## Key Conventions

### Tagging System
- **Format**: `<binary-name>-<version>` (NO 'v' prefix)
- **Examples**: `cardano-addresses-4.0.0`, `bech32-1.1.7`
- **Purpose**: Enables independent releases for each binary
- **Important**: Version must match exact upstream tag from source repository

### File Naming Patterns
- **Dockerfiles**: `Dockerfile.<binary-name>-<platform>` 
  - Example: `Dockerfile.cardano-addresses-linux-arm64`
- **Workflows**: `.github/workflows/build-<binary-name>.yml`
- **Artifacts**: `<binary-name>-<platform>.tar.gz`
- **Cache Scopes**: `test-<binary>-<platform>` and `build-<binary>-<platform>`

### Infrastructure
- **Runners**: Use `ubuntu-22.04-arm` for ARM64 builds (GitHub's native ARM64 runners)
- **Permissions**: All workflows need `permissions.contents: write` for releases
- **Platform Strategy**: Build natively on ARM64 runners, no emulation needed

### Merge Policy
- **ALL PRs must be squash merged** to maintain clean commit history
- Use conventional commit messages (`feat:`, `fix:`, `docs:`, etc.)
- Always create branch → PR → squash merge (never commit directly to main)

## Supported Binaries

### Currently Available
- ✅ **cardano-addresses-4.0.0** (Linux ARM64) - IntersectMBO/cardano-addresses
- ✅ **bech32-1.1.7** (Linux ARM64) - input-output-hk/bech32

### Planned Additions
- 🚧 cardano-cli (multiple platforms)
- 🚧 cardano-node (multiple platforms)
- 🚧 Additional platforms for existing binaries (x64, macOS, Windows)

## Technical Implementation

### Docker Build Strategy
- **Multi-stage builds**: Build stage + minimal runtime stage
- **Static linking**: `--enable-executable-static` for portability
- **Security**: Non-root user in final image
- **Optimization**: Minimal runtime dependencies, clean up package lists

### Source Repositories
- **cardano-addresses**: https://github.com/IntersectMBO/cardano-addresses
- **bech32**: https://github.com/input-output-hk/bech32
- **General pattern**: IntersectMBO/<tool-name> or input-output-hk/<tool-name>

### Build Environment
- **GHC Version**: 9.10.1 (current standard)
- **Cabal Version**: 3.12.1.0 (current standard)
- **Base Image**: Ubuntu 22.04
- **Runtime Dependencies**: Only essential libraries (libgmp10, libssl3, etc.)

### Release Process
1. **Tag Creation**: `git tag <binary>-<version> && git push origin <binary>-<version>`
2. **Automated Build**: GitHub Actions builds on ARM64 runners
3. **Binary Extraction**: Using `--user root` to handle permissions
4. **Packaging**: tar.gz + sha256 checksum
5. **Release**: Automatic GitHub release with simple description

## Development Workflow

### Adding New Binaries
1. **Research**: Check upstream repo for latest version and build requirements
2. **Create Dockerfile**: Copy existing pattern, update source repo and binary name
3. **Create Workflow**: Copy existing workflow, update all binary-specific references
4. **Update Documentation**: Add to README.md tables and examples
5. **Test Locally**: Build Docker image to verify it works
6. **Create PR**: Follow conventional commit format
7. **Test Release**: Create actual version tag to verify end-to-end

### Version Updates
- Monitor upstream repositories for new releases
- Update build arguments in Dockerfiles if needed
- Test with new version tags
- Keep toolchain versions aligned with IntersectMBO recommendations

### Troubleshooting Common Issues
- **Permission Denied**: Use `--user root` in docker run for file extraction
- **Platform Mismatch**: Ensure using `ubuntu-22.04-arm` runners for ARM64 builds
- **Release Failures**: Check `permissions.contents: write` is set
- **Build Hanging**: Ensure `BOOTSTRAP_HASKELL_NONINTERACTIVE=1` for ghcup
- **Binary Not Found**: Use `cabal list-bin exe:<name>` to locate built executables

## Current Status & Context

### Recent Major Changes
- **ARM64 Native Builds**: Switched from emulation to native ARM64 runners
- **Simplified README**: Redesigned with problem/solution messaging
- **MIT License**: Added proper licensing
- **Release Optimization**: Simplified release descriptions
- **Bech32 Addition**: Second binary successfully added

### Infrastructure Learnings
- GitHub provides free ARM64 runners for public repos (`ubuntu-22.04-arm`)
- No `--platform` flags needed when using native runners
- Binary extraction requires root permissions in containers
- Cache scoping prevents conflicts between different binary builds

### Performance Optimizations
- Docker layer caching with GitHub Actions cache
- Scoped cache keys prevent cross-contamination
- Native ARM64 builds are faster than emulated builds
- Multi-stage builds keep final images minimal

## Project Goals & Vision

### Primary Objectives
1. **Eliminate Build Friction**: Save users hours of compilation time
2. **Cross-Platform Support**: Provide binaries for all major platforms
3. **Reliability**: Automated testing and verified releases
4. **Accessibility**: Simple download and run experience

### Quality Standards
- All binaries must be statically linked and portable
- Comprehensive testing beyond just `--version` checks
- Automated checksum generation and verification
- Clean, professional release presentation

### Future Expansion
- Support for more Cardano ecosystem tools
- Additional platforms (Windows, macOS, x64 Linux)
- Enhanced testing capabilities
- Community contribution guidelines

## When Working on This Project

### Pre-work Checklist
1. Check upstream repositories for latest versions
2. Verify build requirements haven't changed
3. Test Docker builds locally when possible
4. Confirm tag format matches upstream exactly

### During Development
1. Follow existing patterns and naming conventions
2. Use ARM64 runners for consistency
3. Test with real version tags, not just latest
4. Update all relevant documentation

### Post-merge Actions  
1. Create release tag to verify end-to-end functionality
2. Monitor build logs for any issues
3. Verify release artifacts are complete and correct
4. Update project status documentation

### Important Reminders
- **Never commit directly to main** - always use PR workflow
- **Always squash merge** - maintains clean history
- **Test release builds** - don't just test PR builds
- **Keep documentation current** - update README and CLAUDE.md
- **Monitor upstream changes** - stay current with source repositories

This repository represents a practical solution to a real developer pain point: the complexity of building Cardano tools from source. By providing reliable, tested binaries, we enable faster development and easier adoption of Cardano ecosystem tools.