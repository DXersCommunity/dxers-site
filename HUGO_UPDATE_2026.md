# Hugo Update Guide 2026

## Executive Summary

**Recommendation**: ✅ **Hugo Extended 0.154.3 installed and verified working**

### Current Status
- ✅ Hugo Extended **0.154.3** installed and verified with `hugo version` → `hugo v0.154.3+extended linux/amd64`
- ✅ Minimum required version: **0.146.0 Extended** (Docsy v0.15.0 requirement)
- ⚠️ **"0.154.1" was never a real release** — an earlier draft of this document assumed that version number, but it does not exist on the [Hugo releases page](https://github.com/gohugoio/hugo/releases). **0.154.3** was the actual latest Extended release available at test time (2026-09-01). Always re-check https://github.com/gohugoio/hugo/releases/latest before hardcoding a version — Hugo ships frequent patch releases and the "latest" number drifts quickly.
- ✅ Full build pipeline (submodule + Hugo Modules + npm + `hugo --minify`) executed end-to-end successfully — see "Known Issues Encountered & Fixed" below for what it took to get there.

### Required Action (completed this session)
1. Install Hugo Extended (latest available, verified as **0.154.3** — re-check the number at install time).
2. Set up the **hybrid submodule + Hugo Modules** configuration required by modern Docsy (see dedicated section below) — a plain submodule checkout is **not** sufficient.
3. Pin the Docsy submodule to **v0.15.0** specifically (not `main`, not the latest tag).
4. Remove two obsolete custom layout overrides made unnecessary by the Docsy upgrade.
5. Fix two additional deprecated `config.toml` keys surfaced by the real build.

---

## Version Analysis

### Hugo 0.154.3 (verified 2026-09-01) — INSTALLED ✅

**Status**: Latest stable Extended release at time of testing, confirmed via `hugo version`.

> ⚠️ Do not hardcode "0.154.3" as a permanent target either. Hugo releases frequently; treat this number as "verified at the time this document was last tested" and re-check https://github.com/gohugoio/hugo/releases/latest before every future install.

#### Advantages
- ✅ Compatible with Docsy v0.15.0 (see version pin section below)
- ✅ Faster builds (streaming builds)
- ✅ LaTeX/TeX support for mathematical documentation
- ✅ Server-side math rendering with KaTeX
- ✅ Content adapters for remote data
- ✅ Tailwind CSS improvements
- ✅ Obsidian-style callouts
- ✅ All security patches as of release date

#### Disadvantages
- ⚠️ Possible breaking changes compared to very old versions
- ⚠️ Requires complete testing after installation (done — see "Post-Installation" below)

### Hugo 0.146.0 (Minimum Version)

**Status**: Minimum version required by Docsy v0.15.0.

#### Advantages
- ✅ Guaranteed compatibility with Docsy v0.15.0
- ✅ Stable and tested

#### Disadvantages
- ❌ Missing recent features
- ❌ Lower performance
- ❌ Missing recent security patches

### Conclusion: Use the latest Hugo Extended release (verified 0.154.3), paired with Docsy v0.15.0 ✅

---

## ⚠️ Critical: Docsy Dependencies Now Require Hugo Modules

This is the single most important architectural fact in this document. **A plain `git submodule update --init --recursive` is no longer sufficient to build the site.**

### Why

Modern Docsy no longer vendors its indirect dependencies (Bootstrap SCSS, Font Awesome, etc.) inside the `themes/docsy` theme repo. Those are distributed as **Hugo Modules**, resolved via Go's module system. If you only check out the `themes/docsy` submodule and run `hugo --minify`, the build fails with:

```
ERROR ... File to import not found or unreadable: ../vendor/bootstrap/scss/bootstrap.
```

### The Fix: Hybrid Submodule + Hugo Modules Setup

Keep `themes/docsy` as a physical git submodule (no network needed to fetch the theme itself), but let Hugo Modules resolve Docsy's own dependencies:

1. **Add a `go.mod` at the project root:**
   ```
   module github.com/DXersCommunity/dxers-site

   go 1.24.7

   replace github.com/google/docsy => ./themes/docsy

   require github.com/google/docsy v0.15.0 // indirect
   ```
   The `replace` directive is what lets the local submodule checkout stand in for the theme itself, while Hugo Modules still resolves Docsy's *own* dependency graph (Bootstrap, Font Awesome) from the network.

2. **Update `config.toml`** — replace the legacy theme array:
   ```toml
   # Before (legacy, no longer sufficient on its own):
   theme = ["docsy"]
   ```
   with a Hugo Modules import:
   ```toml
   # After:
   [module]
     [[module.imports]]
       path = "github.com/google/docsy"
   ```

3. **Run `hugo mod tidy`** to download Bootstrap/Font Awesome into the Go module cache and generate `go.sum`. This step requires:
   - **Go installed** (verified with go1.24.7 in this session)
   - **Network access** to the Go module proxy (proxy.golang.org or equivalent)

### Full Working Setup Sequence (verified)

```bash
git submodule update --init --recursive
npm install
hugo mod tidy
hugo --minify
```

This exact sequence produced a clean, zero-warning, zero-error build in this session (see "Post-Installation" for the verified output).

---

## ⚠️ Critical: Pin Docsy to v0.15.0 (do NOT use the latest tag)

It is tempting to run `git submodule update --remote themes/docsy` to grab the newest Docsy release. **Do not do this blindly** — as of this writing, the latest Docsy tags are incompatible with the latest available Hugo release:

- **Docsy v0.16.0 and v0.17.0** bump `theme.toml`'s `min_version` requirement to **Hugo 0.160.1**, which **does not exist yet** as a Hugo release (latest verified is 0.154.3). Using either version with current Hugo breaks the build outright.
- From **v0.16.0 onward**, Docsy also restructured its repository: the actual Hugo module now lives in a `theme/` subfolder, with Go module path `github.com/google/docsy/theme` (not `github.com/google/docsy`), and layout paths moved from `layouts/_partials/...` to `theme/layouts/_partials/...`. This means the `go.mod` / `config.toml` setup above would need different paths for v0.16.0+.

**v0.15.0 is the correct, verified-working pin** for use with Hugo 0.154.3:
- Requires only Hugo 0.146.0+
- Keeps the old repo layout (module path `github.com/google/docsy`, `layouts/_partials/...` paths) — matches the `go.mod` and `config.toml` setup documented above.

### Pinning Docsy to v0.15.0

```bash
cd themes/docsy
git fetch --tags
git checkout v0.15.0
cd ../..
git add themes/docsy
git commit -m "chore: pin Docsy theme to v0.15.0 (verified working with Hugo 0.154.3)"
```

Before ever moving past v0.15.0 in the future, re-verify: check the target Docsy tag's `theme.toml` `min_version` against the Hugo release actually available at that time, and confirm whether the module path/layout restructuring (v0.16.0+) has been accounted for in `go.mod` and `config.toml`.

---

## Known Issues Encountered & Fixed

These are real problems hit during this session's build, in the order they were resolved.

### 1. `section-index.html` nil pointer error (old Docsy checkout)

With the pre-upgrade Docsy checkout (a commit based off tag v0.4.0), the build failed with:

```
ERROR ... File is nil; wrap it in if or with
```

The failure was in `themes/docsy/layouts/partials/section-index.html`, at:
```go-html-template
{{ $pages = (where $pages "Parent.File.UniqueID" "==" $parent.File.UniqueID) }}
```

This is a known upstream Docsy bug: https://github.com/google/docsy/issues/1874, fixed upstream by Docsy PRs #1890 and #1947, which add a nil-guard (`{{ if $page.File -}}`) before accessing `.File.UniqueID`.

**Fix**: confirmed the fix is present in Docsy v0.15.0. Upgrading the submodule to v0.15.0 resolved this error — no local template patch was needed.

### 2. Two obsolete custom layout overrides removed

Once Docsy was upgraded to v0.15.0, two local overrides became redundant workarounds for problems the theme itself no longer has, and were deleted:

- **`layouts/partials/head.html`** — originally a workaround for deprecated Hugo 0.120.0-era APIs (`_internal/google_analytics_async.html`, `.Site.GoogleAnalytics`, `.Site.DisqusShortname`) needed by a very old Docsy checkout. Docsy v0.15.0's native `layouts/_partials/head.html` already handles Google Analytics correctly via `{{ partial "google_analytics.html" . }}`, and additionally provides native dark-mode support that the old override lacked.
- **`layouts/docs/list.html`** — same story; Docsy v0.15.0's native `layouts/docs/list.html` already uses `.Site.Config.Services.Disqus.Shortname` correctly.

**Lesson for future maintainers**: if asked to add a similar Hugo-version-compatibility layout override again, check the native Docsy template first. It is very likely already fixed upstream, and a stale custom override risks silently blocking future Docsy upgrades — exactly what happened here.

### 3. Two additional `config.toml` deprecation warnings found and fixed

Surfaced during the real build (in addition to two deprecations already fixed in a prior session — see "Breaking Changes and Migrations" below):

- **`algolia_docsearch = false`** (top-level key) — deprecated; Hugo's warning points to `[params.search.algolia]` instead. Since Algolia search is not actually used on this site, the key was simply removed (left as a comment explaining why, rather than migrated).
- **`params.ui.footer_about_disable = false`** — deprecated. The fix is **not** a simple rename: the replacement key `footer_about_enable` has **inverted boolean logic**. `footer_about_disable = false` correctly becomes `footer_about_enable = true` (not `false`).

### 4. Top-level `contentDir` silently ignored once `[languages]` exists → homepage rendered empty at `/`

**Found via a different method than issues 1–3 above**: issues 1–3 were all caught by local `hugo --minify` failing outright with an `ERROR` line. This one produced **zero WARN, zero ERROR** — `hugo --minify` looked completely clean. It was only caught in a later session by fetching and byte-comparing two **live URLs**: production (`https://www.dxers.ug/`) against a CloudFlare Pages preview deployment of this branch (`https://006f66f1.dxers-site.pages.dev/`). This is worth calling out explicitly: **a clean local build log is not proof the deployed output is correct** — testing the actual rendered pages (ideally a real deployed URL, not just the build log) matters just as much as a warning-free build.

**Symptom**: the preview's homepage at the site root `/` — what every visitor actually lands on — rendered as `<main role=main class=td-main></main>`, completely empty: no hero cover block, no background image, no "Join on Discord" / "Get in the next meeting" buttons. Production's homepage, by contrast, had all of that content. The real, fully-rendered homepage content was sitting at `/en/index.html`, a URL nothing links to and no visitor would ever navigate to.

**Root cause**: `config.toml` declared `contentDir = "content/en"` at the **top level**, alongside an explicit `[languages.en]` table (kept for Docsy's multilingual template features, even though this site only has one language). Running `hugo config` on Hugo Extended 0.154.3 showed that Hugo **silently ignores a top-level `contentDir` once a `[languages]` table is present** — it resolves to Hugo's own default `contentdir = 'content'` instead, no warning or error emitted anywhere. This made Hugo render the site **twice**:
1. A fully correct site under `/en/` — this only worked by coincidence, because `content/en/` happens to match Hugo's own default per-language content-directory convention (directory name == language code), not because the top-level config override was doing anything.
2. A second, broken, empty site at the actual site root `/` — produced by `defaultContentLanguageInSubdir = false`'s "flatten to root" logic running against the wrongly-resolved top-level contentDir, yielding a stub Home page with no content.

Since visitors go to `/`, not `/en/`, every visitor to the live site saw the broken, empty homepage.

**Fix**: move `contentDir` out of the top-level config and into the per-language `[languages.en]` block, which is the shape Hugo actually honors once explicit language tables exist:

```toml
# Before (broken — silently ignored by Hugo once [languages] exists):
contentDir = "content/en"
defaultContentLanguage = "en"
defaultContentLanguageInSubdir = false
...
[languages]
[languages.en]
  title = "..."

# After (fixed):
defaultContentLanguage = "en"
defaultContentLanguageInSubdir = false
...
[languages]
[languages.en]
  contentDir = "content/en"
  title = "..."
```

**Verified after the fix** (local `hugo --minify`, Hugo Extended 0.154.3, Docsy v0.15.0):
- No `/en/` output directory at all anymore — `community/`, `docs/`, `search/` now sit directly under the site root (`public/community/`, `public/docs/`, etc.), matching production's URL structure exactly.
- Root `public/index.html` grew from 19718 bytes (the empty stub) to 22560 bytes, and now contains the hero cover block (`td-cover-block` class), both resized `featured-background_*.jpg` images (Hugo's image processing pipeline correctly resizing `content/en/featured-background.jpg`), and both call-to-action buttons.
- Page count went from **29 to 27** (the two duplicate/phantom pages from the double-render are gone).
- 32 static files, 2 processed images, zero WARN, zero ERROR, ~1.6s build.
- Spot-checked `community/index.html` and `docs/index.html` — both render real content correctly.

**Separate, unrelated note surfaced during the same live-URL comparison** (not a bug): `wrangler.toml`'s `[env.preview.vars]` sets `HUGO_ENV = "development"` for preview deployments, and Docsy's templates gate asset minification/fingerprinting/SRI hashes and the search-index-production robots tag behind `hugo.IsProduction`. So preview builds intentionally serve unminified, unfingerprinted CSS/JS with no SRI attributes, compared to production — a deliberate, working-as-designed difference for preview builds, not a defect.

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

- [ ] **Go installed** (required for `hugo mod tidy` — verified with go1.24.7 in this session)
  ```bash
  go version
  ```

- [ ] **npm dependencies installed**
  ```bash
  npm install
  ```

- [ ] **Git submodules updated**
  ```bash
  git submodule update --init --recursive
  ```

- [ ] **Network access to the Go module proxy** (needed for `hugo mod tidy` to fetch Bootstrap/Font Awesome)

---

## Installation Procedure

### IMPORTANT: Extended Version

⚠️ **CRITICAL**: Install **Hugo Extended**, NOT the standard version!

The Docsy theme requires Hugo Extended for SCSS/SASS support.

⚠️ **Also check the actual latest version number** at https://github.com/gohugoio/hugo/releases/latest before running the commands below — "0.154.3" is what was verified working in this session, but it will not stay current.

### Linux (Recommended for Servers)

```bash
# 1. Define version (verify this is still the latest at https://github.com/gohugoio/hugo/releases/latest)
HUGO_VERSION=0.154.3

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

# Verified output (this session):
# hugo v0.154.3+extended linux/amd64
```

### macOS

#### With Homebrew (Recommended)

```bash
# Install Hugo Extended
brew install hugo

# Verify version
hugo version

# If outdated, update
brew upgrade hugo
```

#### Manual Download

```bash
# 1. Download for macOS (ARM - Apple Silicon)
cd /tmp
wget https://github.com/gohugoio/hugo/releases/download/v0.154.3/hugo_extended_0.154.3_darwin-universal.tar.gz

# 2. Extract
tar -xzf hugo_extended_0.154.3_darwin-universal.tar.gz

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

1. Go to: https://github.com/gohugoio/hugo/releases/latest (do not assume a fixed version number)
2. Download: `hugo_extended_<version>_windows-amd64.zip`
3. Extract to `C:\Hugo\bin\`
4. Add `C:\Hugo\bin\` to PATH
5. Verify: `hugo version`

### Docker (Alternative)

```dockerfile
# Use official Hugo image — check for a current tag matching your target version
FROM klakegg/hugo:0.154.3-ext-alpine

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

# Verified output (this session):
# hugo v0.154.3+extended linux/amd64

# 2. Verify it's Extended
hugo version | grep extended

# Must contain "+extended"
```

### Project Test (full sequence, verified working)

```bash
# 1. Go to project directory
cd /path/to/dxers-site

# 2. Update submodules
git submodule update --init --recursive

# 3. Install npm dependencies
npm install

# 4. Resolve Docsy's Hugo Module dependencies (Bootstrap, Font Awesome)
hugo mod tidy

# 5. Start development server
hugo server

# 6. Open browser
# http://localhost:1313

# 7. Verify site loads correctly
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

### 1. Complete Testing — ✅ Verified This Session

All steps below were actually executed against a clean environment, not just planned.

#### Test Checklist — Results

- ✅ `hugo mod tidy` resolved Bootstrap/Font Awesome via Hugo Modules with no errors
- ✅ `hugo --minify` completed with **zero WARN and zero ERROR lines**
- ✅ Build output: **29 Pages | 30 Static files | 2 Processed images | 0 Paginator pages | 0 Aliases**
- ✅ Build time: **~1.7–2 seconds**
- ✅ `hugo server` starts correctly
- ✅ Homepage served **HTTP 200** with correct page title: *"DXers - The HCL DX user's group"*
- [ ] Full manual click-through of every docs/community page (not exhaustively re-verified this session; spot-checked via homepage + build output only)
- [ ] Responsive design check on mobile/tablet breakpoints (not covered this session)

#### Test Commands (as run)

```bash
# Full verified sequence
git submodule update --init --recursive
npm install
hugo mod tidy
hugo --minify
# → 29 Pages | 30 Static files | 2 Processed images | 0 Paginator pages | 0 Aliases
# → 0 WARN, 0 ERROR

hugo server
# → serves http://localhost:1313, HTTP 200, title "DXers - The HCL DX user's group"
```

```bash
# Additional useful commands (not required for the verified pass above)
hugo server --bind 0.0.0.0
hugo --templateMetrics
```

### 2. Update Documentation

```bash
# Create .hugo-version file for CI/CD
echo "0.154.3" > .hugo-version

# Commit
git add .hugo-version
git commit -m "chore: specify Hugo version 0.154.3"
```

### 3. Update CI/CD

If using CloudFlare Pages, GitHub Actions, or other CI/CD, remember the build now also needs `hugo mod tidy` (and therefore Go + network access to the Go module proxy) before `hugo --minify`.

#### CloudFlare Pages

```toml
# File: .cloudflare/build-config.toml
[build]
command = "hugo mod tidy && hugo --minify"
publish = "public"

[build.environment]
HUGO_VERSION = "0.154.3"
```

#### GitHub Actions

```yaml
# File: .github/workflows/hugo.yml
- name: Setup Hugo
  uses: peaceiris/actions-hugo@v2
  with:
    hugo-version: '0.154.3'
    extended: true

- name: Setup Go
  uses: actions/setup-go@v5
  with:
    go-version: '1.24'

- name: Build
  run: |
    hugo mod tidy
    hugo --minify
```

#### Netlify

```toml
# File: netlify.toml
[build]
  command = "hugo mod tidy && hugo --minify"
  publish = "public"

[build.environment]
  HUGO_VERSION = "0.154.3"
```

### 4. Docsy Version — Pinned, Do Not Auto-Update

Unlike a typical "update to latest" recommendation, Docsy is deliberately **pinned to v0.15.0** (see the dedicated section above). Do **not** run `git submodule update --remote themes/docsy` without first checking whether the target tag's `min_version` is satisfied by an actually-released Hugo version, and whether the v0.16.0+ repo restructuring has been accounted for.

```bash
# Check current Docsy version (should report v0.15.0)
cd themes/docsy
git describe --tags
cd ../..
```

### 5. `.gitignore` Update

`hugo server` / build creates a `.hugo_build.lock` file that must never be committed. This was added to `.gitignore` this session.

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

### Problem: "File to import not found or unreadable: ../vendor/bootstrap/scss/bootstrap"

**Cause**: Docsy's Bootstrap/Font Awesome dependencies were not resolved — a plain submodule checkout alone is not enough with modern Docsy.

**Solution**: Follow the "Critical: Docsy Dependencies Now Require Hugo Modules" section above — add `go.mod`, switch `config.toml` to `[module.imports]`, and run `hugo mod tidy`.

### Problem: "File is nil; wrap it in if or with" in `section-index.html`

**Cause**: Old Docsy checkout carrying the upstream bug described in https://github.com/google/docsy/issues/1874.

**Solution**: Upgrade the `themes/docsy` submodule to v0.15.0 (fix is included there — do not hand-patch the template).

### Problem: Build fails immediately after updating the Docsy submodule to the latest tag

**Cause**: Docsy v0.16.0+ requires Hugo 0.160.1 (min_version), which does not yet exist as a release, and also restructured the module path/layout locations.

**Solution**: Re-pin to v0.15.0 (`git checkout v0.15.0` inside `themes/docsy`) until a Hugo release satisfying the newer `min_version` actually exists, and the `go.mod`/`config.toml` paths are updated to match the new `theme/` subfolder structure.

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

✅ **Status**: Fixed in a prior session — `[blackfriday]` section removed from `config.toml`.

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

✅ **Status**: Already configured in `config.toml`.

#### 3. Taxonomy naming

**Before**:
```toml
disableKinds = ["taxonomy", "taxonomyTerm"]
```

**After**:
```toml
disableKinds = ["taxonomy", "term"]
```

✅ **Status**: Fixed in a prior session.

#### 4. `algolia_docsearch` deprecated — fixed this session

**Before**:
```toml
algolia_docsearch = false
```

**After**: key removed entirely (Algolia search is not used on this site; a comment was left in `config.toml` explaining why, in place of migrating to `[params.search.algolia]`).

✅ **Status**: Fixed this session.

#### 5. `footer_about_disable` deprecated — fixed this session, note the inverted logic

**Before**:
```toml
[params.ui]
  footer_about_disable = false
```

**After** — note the boolean is **inverted**, not just renamed:
```toml
[params.ui]
  footer_about_enable = true
```

✅ **Status**: Fixed this session.

#### 6. `.Page.RSSLink` → `.OutputFormats`

If using custom RSS, update code. Not applicable to this project (no custom RSS templates).

### Status: All known deprecations resolved ✅

The DXers project's `config.toml` has no remaining deprecation warnings as of the verified build this session (zero WARN lines in `hugo --minify` output).

---

## Post-Update Monitoring

### Metrics to Monitor

#### 1. Build Time

```bash
# Verified this session
time hugo --minify
# → ~1.7-2 seconds, 29 Pages
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

### 1. Previous Hugo Version

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

### 3. Docsy Rollback

If v0.15.0 ever turns out to have a regression, roll back to the last known-good pre-Hugo-Modules commit (based off tag v0.4.0) — but note this reintroduces the `section-index.html` nil-pointer bug (see "Known Issues Encountered & Fixed") and requires restoring the two deleted custom layout overrides.

### 4. CI/CD Rollback

Modify Hugo version and the `hugo mod tidy` step in CI/CD configuration as needed.

---

## Final Recommendations

### ✅ Done This Session

1. **Installed Hugo Extended 0.154.3** (verified latest at time of testing)
2. **Set up hybrid submodule + Hugo Modules** (`go.mod`, `config.toml` `[module.imports]`, `hugo mod tidy`)
3. **Pinned Docsy submodule to v0.15.0**
4. **Removed two obsolete custom layout overrides** (`layouts/partials/head.html`, `layouts/docs/list.html`)
5. **Fixed two additional deprecated config keys** (`algolia_docsearch`, `footer_about_disable` → `footer_about_enable`)
6. **Added `.hugo_build.lock` to `.gitignore`**
7. **Verified clean `hugo --minify` build** (0 WARN, 0 ERROR, 29 pages, ~1.7–2s) and working `hugo server`

### ⚠️ TO AVOID Going Forward

1. ❌ **DO NOT install the standard (non-Extended) Hugo version**
2. ❌ **DO NOT run `git submodule update --remote themes/docsy`** without checking the target tag's `min_version` against an actually-released Hugo version, and the v0.16.0+ repo restructuring
3. ❌ **DO NOT assume a submodule checkout alone is enough** — Docsy's own dependencies require `hugo mod tidy`
4. ❌ **DO NOT hardcode a Hugo version number as permanently current** — always re-check https://github.com/gohugoio/hugo/releases/latest
5. ❌ **DO NOT re-add local layout overrides** for Hugo-version compatibility without first checking whether the native Docsy template already handles it
6. ❌ **DO NOT skip local testing** before deploy
7. ❌ **DO NOT ignore build errors or warnings**

---

## Recommended Timeline

### Phase 1: Preparation — ✅ Done
- [x] Project backup / clean git status confirmed
- [x] Environment preparation (Hugo, Go, Node.js)

### Phase 2: Installation — ✅ Done
- [x] Install Hugo 0.154.3 Extended
- [x] Verify installation
- [x] Set up hybrid submodule + Hugo Modules, pin Docsy to v0.15.0
- [x] Test local build

### Phase 3: Testing — ✅ Done (build-level); manual page-by-page pending
- [x] `hugo --minify` clean build verification
- [x] `hugo server` smoke test (HTTP 200, correct title)
- [ ] Full manual click-through of every page
- [ ] Responsive design testing across breakpoints

### Phase 4: Deployment
- [ ] Update CI/CD to include `hugo mod tidy` step
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
- [Hugo Modules](https://gohugo.io/hugo-modules/)

### Docsy Documentation
- [Docsy Prerequisites](https://www.docsy.dev/docs/get-started/docsy-as-module/installation-prerequisites/)
- [Docsy GitHub](https://github.com/google/docsy)
- [Docsy issue #1874 — nil File in section-index.html](https://github.com/google/docsy/issues/1874) (fixed by PRs #1890, #1947; fix present in v0.15.0)

### Support
- [Hugo Forum](https://discourse.gohugo.io/)
- [Hugo GitHub Issues](https://github.com/gohugoio/hugo/issues)
- [DXers Community Discord](https://discord.gg/RtG4nyCEDX)

---

**Document created**: 2026-01-08
**Last revision**: 2026-09-01 — corrected to real, verified end-to-end results (Hugo Modules requirement, Docsy v0.15.0 pin, known issues fixed, version number corrections)
**Verified Hugo version**: 0.154.3 Extended (re-check latest before future installs)
**Verified Docsy version**: v0.15.0 (pinned — do not blindly update)
**Status**: ✅ VERIFIED WORKING — clean `hugo --minify` build, 0 WARN / 0 ERROR
