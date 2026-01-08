# Hugo Update Guide 2026

## Executive Summary

**Recommendation**: ✅ **UPDATE to Hugo Extended 0.154.1**

### Current Status
- ❌ Hugo **NOT installed** in development system
- ⚠️ Minimum required version: **0.146.0 Extended**
- ✅ Available version: **0.154.1 Extended** (January 2026)

### Required Action
**Install Hugo Extended 0.154.1** to ensure:
- Compatibility with Docsy theme v0.12.0+
- Access to latest features
- Better build performance
- Security and bug fixes

---

## Version Analysis

### Hugo 0.154.1 (January 2026) - RECOMMENDED ✅

**Release Date**: January 2026
**Status**: Stable, latest available version

#### Advantages
- ✅ Fully compatible with Docsy
- ✅ Faster builds (streaming builds)
- ✅ LaTeX/TeX support for mathematical documentation
- ✅ Server-side math rendering with KaTeX
- ✅ Content adapters for remote data
- ✅ Tailwind CSS improvements
- ✅ Obsidian-style callouts
- ✅ All security patches

#### Disadvantages
- ⚠️ Possible breaking changes compared to very old versions
- ⚠️ Requires complete testing after installation

### Hugo 0.146.0 (Minimum Version)

**Release Date**: 2024
**Status**: Minimum version required by Docsy v0.12.0

#### Advantages
- ✅ Guaranteed compatibility with Docsy
- ✅ Stable and tested

#### Disadvantages
- ❌ Missing recent features
- ❌ Lower performance
- ❌ Missing recent security patches

### Conclusion: UPDATE to 0.154.1 ✅

---

## Pre-Update Checklist

Before installing Hugo, verify:

- [ ] **Complete project backup**
  ```bash
  git status  # Make sure there are no uncommitted changes
  ```

- [ ] **Node.js installed** (LTS v18+)
  ```bash
  node --version
  npm --version
  ```

- [ ] **npm dependencies installed**
  ```bash
  npm install
  ```

- [ ] **Git submodules updated**
  ```bash
  git submodule update --init --recursive
  ```

---

## Installation Procedure

### IMPORTANT: Extended Version

⚠️ **CRITICAL**: Install **Hugo Extended**, NOT the standard version!

The Docsy theme requires Hugo Extended for SCSS/SASS support.

### Linux (Recommended for Servers)

```bash
# 1. Define version
HUGO_VERSION=0.154.1

# 2. Download Hugo Extended
cd /tmp
wget https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_linux-amd64.tar.gz

# 3. Extract archive
tar -xzf hugo_extended_${HUGO_VERSION}_linux-amd64.tar.gz

# 4. Install in /usr/local/bin
sudo mv hugo /usr/local/bin/
sudo chmod +x /usr/local/bin/hugo

# 5. Verify installation
hugo version

# Expected output:
# hugo v0.154.1+extended linux/amd64 BuildDate=2026-xx-xx
```

### macOS

#### With Homebrew (Recommended)

```bash
# Install Hugo Extended
brew install hugo

# Verify version
hugo version

# If version < 0.154.1, update
brew upgrade hugo
```

#### Manual Download

```bash
# 1. Download for macOS (ARM - Apple Silicon)
cd /tmp
wget https://github.com/gohugoio/hugo/releases/download/v0.154.1/hugo_extended_0.154.1_darwin-universal.tar.gz

# 2. Extract
tar -xzf hugo_extended_0.154.1_darwin-universal.tar.gz

# 3. Install
sudo mv hugo /usr/local/bin/
sudo chmod +x /usr/local/bin/hugo

# 4. Verify
hugo version
```

### Windows

#### With Chocolatey (Recommended)

```powershell
# Install Hugo Extended
choco install hugo-extended -y

# Verify
hugo version
```

#### With Scoop

```powershell
# Install Scoop if not present
# https://scoop.sh

# Install Hugo Extended
scoop install hugo-extended

# Verify
hugo version
```

#### With Winget

```powershell
# Install Hugo Extended
winget install Hugo.Hugo.Extended

# Verify
hugo version
```

#### Manual Download

1. Go to: https://github.com/gohugoio/hugo/releases/tag/v0.154.1
2. Download: `hugo_extended_0.154.1_windows-amd64.zip`
3. Extract to `C:\Hugo\bin\`
4. Add `C:\Hugo\bin\` to PATH
5. Verify: `hugo version`

### Docker (Alternative)

```dockerfile
# Use official Hugo image
FROM klakegg/hugo:0.154.1-ext-alpine

WORKDIR /src

COPY . .

RUN hugo --minify

# Output in /src/public
```

```bash
# Build with Docker
docker build -t dxers-site .
```

---

## Installation Verification

### Basic Test

```bash
# 1. Verify version
hugo version

# Expected output:
# hugo v0.154.1+extended linux/amd64

# 2. Verify it's Extended
hugo version | grep extended

# Must contain "+extended"
```

### Project Test

```bash
# 1. Go to project directory
cd /path/to/dxers-site

# 2. Update submodules
git submodule update --init --recursive

# 3. Install npm dependencies
npm install

# 4. Start development server
hugo server

# 5. Open browser
# http://localhost:1313

# 6. Verify site loads correctly
```

### Production Build Test

```bash
# Build with minification
hugo --minify

# Verify output
ls -lh public/

# Check errors
# There should be no errors in the log
```

---

## Post-Installation

### 1. Complete Testing

#### Test Checklist
- [ ] Homepage loads correctly
- [ ] Navigation menu works
- [ ] All docs pages accessible
- [ ] Community pages accessible
- [ ] Discord link works
- [ ] Search works (if enabled)
- [ ] CSS styles load correctly
- [ ] Responsive design OK (mobile/tablet/desktop)
- [ ] Acceptable performance

#### Test Commands

```bash
# Development server
hugo server -D

# Test on local network
hugo server --bind 0.0.0.0

# Production build
hugo --minify

# Performance metrics
hugo --templateMetrics
```

### 2. Update Documentation

```bash
# Create .hugo-version file for CI/CD
echo "0.154.1" > .hugo-version

# Commit
git add .hugo-version
git commit -m "chore: specify Hugo version 0.154.1"
```

### 3. Update CI/CD

If using CloudFlare Pages, GitHub Actions, or other CI/CD:

#### CloudFlare Pages

```toml
# File: .cloudflare/build-config.toml
[build]
command = "hugo --minify"
publish = "public"

[build.environment]
HUGO_VERSION = "0.154.1"
```

#### GitHub Actions

```yaml
# File: .github/workflows/hugo.yml
- name: Setup Hugo
  uses: peaceiris/actions-hugo@v2
  with:
    hugo-version: '0.154.1'
    extended: true
```

#### Netlify

```toml
# File: netlify.toml
[build]
  command = "hugo --minify"
  publish = "public"

[build.environment]
  HUGO_VERSION = "0.154.1"
```

### 4. Consider Updating Docsy

```bash
# Check current Docsy version
cd themes/docsy
git describe --tags

# Update to latest version
cd ../..
git submodule update --remote themes/docsy

# Test
hugo server

# If OK, commit
git add themes/docsy
git commit -m "chore: update Docsy theme to latest"
```

---

## Troubleshooting

### Problem: "hugo: command not found"

**Cause**: Hugo is not in PATH

**Solution**:
```bash
# Linux/macOS: Add to ~/.bashrc or ~/.zshrc
export PATH=$PATH:/usr/local/bin

# Reload
source ~/.bashrc

# Windows: Add to system PATH
# Control Panel > System > Environment Variables
```

### Problem: "Error: failed to extract shortcode"

**Cause**: Standard Hugo version instead of Extended

**Solution**:
```bash
# Verify
hugo version | grep extended

# If you don't see "+extended", reinstall Hugo Extended
```

### Problem: "POSTCSS: failed to transform"

**Cause**: PostCSS not configured correctly

**Solution**:
```bash
# Reinstall dependencies
rm -rf node_modules package-lock.json
npm install

# Verify Node.js version
node --version  # Should be LTS (v18+)
```

### Problem: "TOCSS: failed to transform"

**Cause**: SCSS/SASS issues

**Solution**:
```bash
# Verify Hugo Extended
hugo version | grep extended

# Clean Hugo cache
hugo --cleanDestinationDir
rm -rf resources/
```

### Problem: Very slow build

**Cause**: Cache or non-optimal configuration

**Solution**:
```bash
# Clean everything
hugo --cleanDestinationDir
rm -rf resources/ public/

# Rebuild
hugo --minify

# If still slow, temporarily disable GitInfo
hugo --ignoreCache
```

---

## Breaking Changes and Migrations

### From versions < 0.146.0

#### 1. Goldmark is now the default Markdown parser

**Before** (Blackfriday):
```toml
[blackfriday]
  plainIDAnchors = true
```

**After** (Goldmark):
```toml
[markup.goldmark.renderer]
  unsafe = true
```

✅ **Status**: Already configured in `config.toml`

#### 2. Syntax Highlighting

**Before**:
```toml
pygmentsUseClasses = false
```

**After**:
```toml
[markup.highlight]
  style = "tango"
```

✅ **Status**: Already configured in `config.toml`

#### 3. .Page.RSSLink → .OutputFormats

If using custom RSS, update code.

### No Action Required

The DXers project is already configured for modern Hugo! ✅

---

## Post-Update Monitoring

### Metrics to Monitor

#### 1. Build Time

```bash
# Before
time hugo --minify

# After update
time hugo --minify

# Expected improvement: 10-30% faster
```

#### 2. Output Size

```bash
# Check sizes
du -sh public/

# Check generated files
find public/ -type f | wc -l
```

#### 3. Template Performance

```bash
# Identify slow templates
hugo --templateMetrics --templateMetricsHints
```

### Log Monitoring

```bash
# Build with verbose logging
hugo --verbose --debug

# Save log
hugo --minify --verbose > build.log 2>&1
```

---

## Rollback Plan

If the update causes problems:

### 1. Previous Version

```bash
# Linux: Install specific version
VERSION=0.146.0
wget https://github.com/gohugoio/hugo/releases/download/v${VERSION}/hugo_extended_${VERSION}_linux-amd64.tar.gz
tar -xzf hugo_extended_${VERSION}_linux-amd64.tar.gz
sudo mv hugo /usr/local/bin/
```

### 2. Docker Pinned Version

```dockerfile
FROM klakegg/hugo:0.146.0-ext-alpine
```

### 3. CI/CD Rollback

Modify Hugo version in CI/CD configuration.

---

## Final Recommendations

### ✅ TO DO

1. **Install Hugo Extended 0.154.1**
   - Stable and tested version
   - All modern features
   - Best Docsy support

2. **Test locally**
   - Verify all pages
   - Check production build
   - Validate HTML/CSS

3. **Update CI/CD**
   - Specify Hugo version
   - Test deployment

4. **Document version**
   - Create `.hugo-version`
   - Update README.md
   - Commit changes

5. **Monitor**
   - First week: daily checks
   - Verify performance metrics
   - Collect team feedback

### ⚠️ TO AVOID

1. ❌ **DO NOT install standard version** (only Extended)
2. ❌ **DO NOT skip local testing** before deploy
3. ❌ **DO NOT update** without backup
4. ❌ **DO NOT ignore build errors**
5. ❌ **DO NOT deploy** without complete testing

---

## Recommended Timeline

### Phase 1: Preparation (Day 1)
- [ ] Project backup
- [ ] Documentation review
- [ ] Environment preparation

### Phase 2: Installation (Day 1-2)
- [ ] Install Hugo 0.154.1 Extended
- [ ] Verify installation
- [ ] Test local build

### Phase 3: Testing (Day 2-3)
- [ ] Complete site testing
- [ ] Verify all pages
- [ ] Performance testing

### Phase 4: Deployment (Day 3-4)
- [ ] Update CI/CD
- [ ] Deploy staging
- [ ] Test staging
- [ ] Deploy production

### Phase 5: Monitoring (Week 1)
- [ ] Monitor metrics
- [ ] Collect feedback
- [ ] Fix any issues

---

## Resources

### Hugo Documentation
- [Hugo Releases](https://github.com/gohugoio/hugo/releases)
- [Hugo Installation](https://gohugo.io/installation/)
- [Hugo Documentation](https://gohugo.io/documentation/)

### Docsy Documentation
- [Docsy Prerequisites](https://www.docsy.dev/docs/get-started/docsy-as-module/installation-prerequisites/)
- [Docsy GitHub](https://github.com/google/docsy)

### Support
- [Hugo Forum](https://discourse.gohugo.io/)
- [Hugo GitHub Issues](https://github.com/gohugoio/hugo/issues)
- [DXers Community Discord](https://discord.gg/RtG4nyCEDX)

---

**Document created**: 2026-01-08
**Last revision**: 2026-01-08
**Target Hugo version**: 0.154.1 Extended
**Status**: ✅ RECOMMENDED FOR INSTALLATION
