# Release Process for HACC

This document describes how to create a new release of the HACC Home Assistant add-on.

## Prerequisites

- GitHub repository created at `github.com/baublet/hacc`
- Push access to the repository
- `gh` CLI installed (optional, for creating releases from command line)

## Initial Setup (First Time Only)

1. Create the GitHub repository:
   ```bash
   gh repo create baublet/hacc --public --source=. --push
   ```

   Or manually:
   - Create repo at https://github.com/new
   - Push existing code:
     ```bash
     git remote add origin git@github.com:baublet/hacc.git
     git push -u origin main
     ```

2. Verify the README badges work after pushing.

## Release Steps

### 1. Update Version Numbers

Update the version in `claude-code/config.yaml`:
```yaml
version: "X.Y.Z"
```

Update the version in `claude-code/Dockerfile` labels:
```dockerfile
io.hass.version="X.Y.Z"
```

### 2. Update CHANGELOG

Add a new section to `claude-code/CHANGELOG.md`:
```markdown
## [X.Y.Z] - YYYY-MM-DD

### Added
- New feature description

### Changed
- Changed behavior description

### Fixed
- Bug fix description
```

### 3. Commit Version Bump

```bash
git add claude-code/config.yaml claude-code/Dockerfile claude-code/CHANGELOG.md
git commit -m "Release vX.Y.Z"
```

### 4. Create Git Tag

```bash
git tag -a vX.Y.Z -m "Release vX.Y.Z"
```

### 5. Push to GitHub

```bash
git push origin main
git push origin vX.Y.Z
```

### 6. Create GitHub Release

Using `gh` CLI:
```bash
gh release create vX.Y.Z \
  --title "vX.Y.Z" \
  --notes "See [CHANGELOG](claude-code/CHANGELOG.md) for details."
```

Or manually:
1. Go to https://github.com/baublet/hacc/releases/new
2. Choose tag: `vX.Y.Z`
3. Title: `vX.Y.Z`
4. Description: Copy relevant section from CHANGELOG.md
5. Click "Publish release"

## How Home Assistant Discovers Updates

Home Assistant add-on updates work as follows:

1. **Version Detection**: HA reads `version` from `config.yaml` in your repository
2. **Update Check**: Users click "Check for updates" in Add-on Store (⋮ menu)
3. **Comparison**: HA compares installed version against repo's `config.yaml`
4. **Update Available**: If repo version is higher, "Update" button appears

**Important**: GitHub Releases are for user visibility and changelog tracking. The actual version HA uses comes from `config.yaml` in the default branch.

## Versioning Guidelines

Follow [Semantic Versioning](https://semver.org/):

- **MAJOR** (X.0.0): Breaking changes, incompatible config changes
- **MINOR** (0.X.0): New features, backward compatible
- **PATCH** (0.0.X): Bug fixes, minor improvements

## Quick Release Checklist

- [ ] Update version in `claude-code/config.yaml`
- [ ] Update version in `claude-code/Dockerfile`
- [ ] Update `claude-code/CHANGELOG.md`
- [ ] Commit: `git commit -m "Release vX.Y.Z"`
- [ ] Tag: `git tag -a vX.Y.Z -m "Release vX.Y.Z"`
- [ ] Push: `git push origin main && git push origin vX.Y.Z`
- [ ] Create GitHub release
