# Technical Documentation - DXers Community Website

## Table of Contents

1. [Introduction](#introduction)
2. [Architecture](#architecture)
3. [Development Environment Setup](#development-environment-setup)
4. [Content Management](#content-management)
5. [Customization](#customization)
6. [Deployment](#deployment)
7. [Maintenance](#maintenance)

## Introduction

The DXers Community website is built with Hugo, a static site generator written in Go, known for its exceptional performance. It uses Google's Docsy theme, specifically designed for technical documentation sites.

Docsy is loaded through a **hybrid Git submodule + Hugo Modules setup**: the theme's template/layout files are checked out as a physical Git submodule (`themes/docsy`), while Docsy's own indirect dependencies (Bootstrap, Font Awesome) are resolved through Hugo Modules via `hugo mod tidy`. This means **Go is a required prerequisite** for local development and builds, alongside Hugo and Node.js. See [Architecture](#architecture) and [Development Environment Setup](#development-environment-setup) for details.

### Main Features

- ✅ **Speed**: Ultra-fast builds thanks to Hugo
- ✅ **SEO-Friendly**: Static sites optimized for search engines
- ✅ **Responsive**: Mobile-first design with Bootstrap
- ✅ **Search**: Google Custom Search support
- ✅ **Multi-language**: Ready for internationalization
- ✅ **Versioning**: Documentation version management
- ✅ **Dark Mode**: Dark theme support (configurable)

## Architecture

### Technology Stack

```
┌─────────────────────────────────────┐
│         Hugo Extended               │
│    (Static Site Generator)          │
└──────────────┬──────────────────────┘
               │
       ┌───────┴────────────────────┐
       │                            │
┌──────▼──────────────────┐  ┌──────▼──────┐
│   Docsy Theme            │  │   Content   │
│   (git submodule:        │  │  (Markdown) │
│    layouts/templates)    │  │             │
└──────┬───────────────────┘  └──────┬──────┘
       │
┌──────▼───────────────────┐
│   Hugo Modules            │
│   (go.mod + hugo mod      │
│    tidy — resolves        │
│    Bootstrap, Font        │
│    Awesome, etc. that     │
│    Docsy depends on)      │
└──────┬───────────────────┘
       │
       └───────┬────────────────────┘
               │
       ┌───────▼────────┐
       │   PostCSS      │
       │ (CSS Process)  │
       └───────┬────────┘
               │
       ┌───────▼────────┐
       │  Static Site   │
       │   (HTML/CSS)   │
       └────────────────┘
```

**IMPORTANT — this is not a plain "add Docsy as a submodule and it works" setup.** Docsy's own indirect dependencies (Bootstrap, Font Awesome) are distributed as **Hugo Modules**, not as vendored files inside the theme. If they aren't resolved, the build fails with:

```
ERROR ... File to import not found or unreadable: ../vendor/bootstrap/scss/bootstrap.
```

The working setup combines two mechanisms:

- `themes/docsy` stays a **git submodule** — a physical checkout that provides the theme's own template/layout files (no network needed for these).
- The project-root `go.mod` declares Docsy as a Hugo Module and replaces it with the local submodule checkout:
  ```
  module github.com/DXersCommunity/dxers-site

  go 1.24.7

  replace github.com/google/docsy => ./themes/docsy

  require github.com/google/docsy v0.15.0 // indirect
  ```
- `config.toml` imports the theme as a Hugo Module instead of using the legacy `theme = ["docsy"]` array:
  ```toml
  [module]
    [[module.imports]]
      path = "github.com/google/docsy"
  ```
- `hugo mod tidy` (requires **Go**, verified with go1.24.7, and network access) resolves Bootstrap/Font Awesome into the Go module cache and writes `go.sum`.

Docsy is pinned to **v0.15.0** specifically — not "latest" and not a loose `v0.12.0+` range. Docsy v0.16.0/v0.17.0 raise `theme.toml`'s `min_version` to Hugo `0.160.1` (which does not exist yet) and restructure the repo (the Hugo module moves into a `theme/` subfolder, module path becomes `github.com/google/docsy/theme`, and layout paths move from `layouts/_partials/...` to `theme/layouts/_partials/...`). v0.15.0 only requires Hugo 0.146.0+ and matches this project's `[module.imports]` path. Before ever bumping the Docsy version, re-check the target tag's `theme.toml` `min_version` and repo layout.

### Build Flow

1. **Hugo Modules resolution**: `hugo mod tidy` resolves Docsy's Bootstrap/Font Awesome dependencies (only needed when `go.mod`/`go.sum` change)
2. **Markdown → HTML**: Hugo converts Markdown content into HTML
3. **SCSS → CSS**: PostCSS processes SCSS into optimized CSS
4. **Asset Optimization**: HTML/CSS/JS minification
5. **Output**: Static files ready for deployment

## Development Environment Setup

### Prerequisites

#### 1. Hugo Extended

**IMPORTANT**: The **Extended** version is required, not the standard one!

```bash
# Verify installation
hugo version

# Expected output (verified working in this project):
# hugo v0.154.3+extended linux/amd64
```

> **Note**: Hugo ships frequent releases. Treat `0.154.3` as "the version verified to work at the time of writing," not a value to blindly hardcode forever — always re-check the exact latest patch at [github.com/gohugoio/hugo/releases/latest](https://github.com/gohugoio/hugo/releases/latest) before installing or upgrading, and re-verify a clean `hugo --minify` build afterwards.

**Installation:**

##### Linux
```bash
# Download latest Extended version (check releases/latest for the current patch)
VERSION=0.154.3
wget https://github.com/gohugoio/hugo/releases/download/v${VERSION}/hugo_extended_${VERSION}_linux-amd64.tar.gz

# Extract
tar -xzf hugo_extended_${VERSION}_linux-amd64.tar.gz

# Install
sudo mv hugo /usr/local/bin/
sudo chmod +x /usr/local/bin/hugo

# Verify
hugo version
```

##### macOS
```bash
# With Homebrew
brew install hugo
```

##### Windows
```powershell
# With Chocolatey
choco install hugo-extended -y

# With Scoop
scoop install hugo-extended

# With Winget
winget install Hugo.Hugo.Extended
```

#### 2. Go

**IMPORTANT**: Go is a **required** prerequisite, not optional. Docsy's indirect dependencies (Bootstrap, Font Awesome) are distributed as Hugo Modules rather than vendored files, and resolving them via `hugo mod tidy` requires a working Go toolchain plus network access. See [Architecture](#architecture) for why.

```bash
# Verify installation
go version

# Verified working version in this project:
# go version go1.24.7 linux/amd64
```

**Installation**: see [go.dev/doc/install](https://go.dev/doc/install) (or your OS package manager).

#### 3. Node.js and npm

```bash
# Verify installation
node --version  # v18.x or higher (LTS)
npm --version   # 9.x or higher

# Install project dependencies
npm install
```

#### 4. Git

```bash
# Clone repository with submodules
git clone --recurse-submodules https://github.com/DXersCommunity/dxers-site.git
cd dxers-site

# If already cloned, initialize submodules
git submodule update --init --recursive
```

### Hugo Modules Setup (Docsy Dependencies)

Cloning the submodule is **not enough** on its own — Docsy's Bootstrap/Font Awesome dependencies still need to be resolved through Hugo Modules, or the build fails with `File to import not found or unreadable: ../vendor/bootstrap/scss/bootstrap.` (see [Architecture](#architecture)).

```bash
# Requires Go + network access; resolves dependencies into the Go module
# cache and writes/updates go.sum
hugo mod tidy
```

Run this once after cloning, and again any time `go.mod` changes (e.g. bumping the Docsy version).

### Initial Configuration

Full verified setup sequence:

```bash
git submodule update --init --recursive && npm install && hugo mod tidy && hugo --minify
```

Step by step:

```bash
# 1. Clone repository
git clone --recurse-submodules https://github.com/DXersCommunity/dxers-site.git
cd dxers-site

# 2. Install npm dependencies
npm install

# 3. Resolve Hugo Modules (Bootstrap, Font Awesome, etc. required by Docsy)
hugo mod tidy

# 4. Start development server
hugo server

# 5. Open browser
# http://localhost:1313
```

## Content Management

### Content Structure

```
content/en/
├── _index.html              # Homepage
├── search.md                # Search page
├── community/               # Community section
│   ├── _index.md           # Community index
│   ├── join_discord/       # How to join Discord
│   ├── code_of_conduct/    # Code of conduct
│   └── join_meetings/      # Community meetings
└── docs/                    # Documentation
    ├── _index.md           # Docs index
    ├── Resources/          # Resources
    │   ├── community_resources/
    │   └── hcl_resources/
    └── Contribution guidelines/
```

### Creating New Page

#### 1. Simple Page

```bash
# Create new page
hugo new content/en/docs/new-guide.md
```

Generated content:
```markdown
---
title: "New Guide"
date: 2026-01-08
draft: true
---

# Content here
```

#### 2. Section with Index

```bash
# Create new section
mkdir -p content/en/docs/new-section
hugo new content/en/docs/new-section/_index.md
```

### Front Matter

Each Markdown page has YAML metadata at the beginning:

```yaml
---
title: "Page Title"
description: "Short description for SEO"
date: 2026-01-08
weight: 10              # Menu order (lower = first)
draft: false            # true = not published
---
```

#### Advanced Front Matter

```yaml
---
title: "Advanced Guide"
linkTitle: "Guide"     # Menu name (shorter)
description: "SEO description"
date: 2026-01-08
weight: 20
type: docs              # Page type
categories:
  - Tutorial
  - Guides
tags:
  - hcl-dx
  - docsy
---
```

### Docsy Shortcodes

#### Alert

```markdown
{{< alert title="Warning" color="warning" >}}
This is an important warning message!
{{< /alert >}}
```

Available colors: `primary`, `secondary`, `success`, `danger`, `warning`, `info`, `light`, `dark`

#### Tabs

```markdown
{{< tabpane >}}
{{< tab header="Linux" lang="bash" >}}
sudo apt install hugo
{{< /tab >}}
{{< tab header="macOS" lang="bash" >}}
brew install hugo
{{< /tab >}}
{{< tab header="Windows" lang="powershell" >}}
choco install hugo-extended
{{< /tab >}}
{{< /tabpane >}}
```

#### Card Deck

```markdown
{{< cardpane >}}
{{< card header="Feature 1" >}}
Feature description
{{< /card >}}
{{< card header="Feature 2" >}}
Another description
{{< /card >}}
{{< /cardpane >}}
```

## Customization

### Custom SCSS

File: `assets/scss/_variables_project.scss`

```scss
/*
 * Bootstrap and Docsy variable customizations
 */

// Primary colors
$primary: #007bff;
$secondary: #6c757d;

// Fonts
$font-family-sans-serif: "Roboto", -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;

// Sizes
$navbar-height: 60px;
```

### Custom Layouts

Directory: `layouts/`

**Current state**: the project's **only** custom layout override is `layouts/404.html` (the custom 404 page):

```
layouts/
└── 404.html              # Custom 404 page — the ONLY custom layout override in this project
```

Two other overrides — `layouts/partials/head.html` and `layouts/docs/list.html` — used to exist as workarounds for deprecated Hugo/Docsy APIs (`_internal/google_analytics_async.html`, `.Site.DisqusShortname`, etc.) in a much older Docsy checkout. Both were **deleted**: Docsy v0.15.0's native templates already handle Google Analytics, Disqus, dark mode, and feedback correctly, so those workarounds are obsolete.

#### Override Single Page (general mechanism)

Hugo lets you override any theme template by mirroring its path under the project's `layouts/` directory, e.g.:

```
layouts/
├── 404.html              # overrides themes/docsy's 404 page
├── _default/
│   ├── baseof.html      # would override the base template
│   └── single.html      # would override the single page template
└── partials/
    ├── header.html      # would override the header partial
    └── footer.html      # would override the footer partial
```

Only add an override here when Docsy's native (v0.15.0) template genuinely cannot do what you need — check upstream first, since past overrides in this project were removed once the underlying Docsy bugs/API gaps were fixed.

### config.toml — Deprecated Settings Removed

Two legacy settings were identified and corrected in `config.toml`:

| Old (deprecated)                              | New                                          | Notes |
|------------------------------------------------|-----------------------------------------------|-------|
| `algolia_docsearch = false` (top-level key)     | *removed*                                     | Deprecated top-level key, unused — this site has no Algolia DocSearch configured |
| `params.ui.footer_about_disable = false`        | `params.ui.footer_about_enable = true`        | **Inverted boolean**, not a plain rename — `disable = false` became `enable = true` |

If you copy config snippets from older Docsy tutorials or examples, double-check them against the current [Docsy v0.15.0 docs](https://www.docsy.dev/docs/): deprecated keys like `algolia_docsearch` are silently ignored rather than raising an error, which can mask a misconfiguration.

### Menu Configuration

File: `config.toml`

```toml
[[menu.main]]
  name = "Docs"
  weight = 20
  url = "/docs/"

[[menu.main]]
  name = "Community"
  weight = 30
  url = "/community/"
```

## Deployment

### Production Build

```bash
# Build with minification
hugo --minify

# Output in: ./public/
```

### CloudFlare Pages

#### Configuration

1. **Build command**: `hugo --minify`
2. **Build output directory**: `public`
3. **Root directory**: `/`
4. **Environment variables**:
   - `HUGO_VERSION`: `0.154.3` (verified working; re-check [releases/latest](https://github.com/gohugoio/hugo/releases/latest) before bumping)

**Note**: Since Docsy's dependencies are resolved via Hugo Modules (see [Architecture](#architecture)), make sure `go.mod` and `go.sum` are committed to the repository so the build environment can resolve them during `hugo --minify`.

#### Build Settings

```toml
# CloudFlare Pages automatically detects Hugo
# But you can specify the version

# Create file: .hugo-version
0.154.3
```

### Deploy Script

File: `deploy.sh`

```bash
#!/bin/bash

# Build site
hugo --minify

# Deploy (customize for your hosting)
rsync -avz --delete public/ user@server:/var/www/dxers/
```

## Maintenance

### Hugo Update

```bash
# Check current version
hugo version

# Download new version
# See Setup > Hugo Extended section

# Test after update
hugo server
```

### Docsy Theme Update

**IMPORTANT**: Docsy is pinned to **v0.15.0** — do not blindly run `git submodule update --remote` and track whatever the latest commit is. Docsy v0.16.0/v0.17.0 raise `theme.toml`'s `min_version` to Hugo `0.160.1` (which does not exist yet) and restructure the repo (Hugo module moved into a `theme/` subfolder, module path becomes `github.com/google/docsy/theme`, layout paths move from `layouts/_partials/...` to `theme/layouts/_partials/...`) — incompatible with this project's `go.mod`/`config.toml` setup without further changes.

Before ever bumping the version:

```bash
# Check out a specific tag in the submodule
cd themes/docsy
git fetch --tags
git checkout v0.15.0   # or the target version
cd ../..

# Check the target tag's min_version and repo layout compatibility
cat themes/docsy/theme.toml | grep min_version

# Update the pin in go.mod to match, then re-resolve Hugo Modules
hugo mod tidy

# Test
hugo server
hugo --minify

# Commit update (submodule pointer + go.mod/go.sum)
git add themes/docsy go.mod go.sum
git commit -m "chore: update Docsy theme (verified against theme.toml min_version)"
```

### npm Dependencies Update

```bash
# Check outdated
npm outdated

# Update
npm update

# For major updates
npm install autoprefixer@latest postcss-cli@latest --save-dev
```

### Backup

```bash
# Full backup
tar -czf dxers-site-backup-$(date +%Y%m%d).tar.gz \
  --exclude=node_modules \
  --exclude=.git \
  --exclude=public \
  dxers-site/
```

### Performance Monitoring

```bash
# Build time analysis
hugo --templateMetrics --templateMetricsHints

# Output size analysis
du -sh public/
find public/ -type f -name "*.html" | wc -l
```

## Testing

### Local Testing

```bash
# Development server with drafts
hugo server -D

# Server with external binding
hugo server --bind 0.0.0.0

# Server with live reload disabled
hugo server --disableLiveReload
```

### Validation

```bash
# HTML Validator (requires npm package html-validate)
npm install -g html-validate
html-validate public/**/*.html

# Link Checker
wget --spider -r -nd -nv -l 5 http://localhost:1313/
```

### Verified Build Result

Last confirmed end-to-end run, using the setup documented above (Hugo Extended 0.154.3, Docsy v0.15.0, hybrid submodule + Hugo Modules):

```
git submodule update --init --recursive && npm install && hugo mod tidy && hugo --minify
```

Result: **29 Pages, 30 Static files, 2 Processed images, zero warnings, zero errors**, build completed in roughly **1.7–2 seconds**. `hugo server` was also verified working — the local site responded with HTTP 200 and the correct page title. Use this as the expected baseline; any warnings/errors on a fresh clone point to a setup step being skipped (most commonly `hugo mod tidy`, see [Troubleshooting](#troubleshooting)).

## Troubleshooting

### Problem: Hugo not found

```bash
# Check PATH
echo $PATH

# Check installation
which hugo

# Reinstall
# See Setup > Hugo Extended section
```

### Problem: Docsy theme not loading

```bash
# Initialize submodules
git submodule update --init --recursive

# Check submodule
git submodule status
```

### Problem: `File to import not found or unreadable: ../vendor/bootstrap/scss/bootstrap.`

The git submodule alone is **not** enough — this project uses a hybrid submodule + Hugo Modules setup (see [Architecture](#architecture)), and this error means Docsy's Hugo Modules dependencies (Bootstrap, Font Awesome) were never resolved.

```bash
# Make sure Go is installed (see Prerequisites)
go version

# Resolve Hugo Modules (requires network access)
hugo mod tidy

# Rebuild
hugo --minify
```

### Problem: `File is nil; wrap it in if or with` in `section-index.html`

This is a known upstream Docsy bug ([google/docsy#1874](https://github.com/google/docsy/issues/1874)), present in older Docsy checkouts (around tag `v0.4.0`), triggered by this line in `section-index.html`:

```go-html-template
{{ $pages = (where $pages "Parent.File.UniqueID" "==" $parent.File.UniqueID) }}
```

It was fixed upstream by PRs [#1890](https://github.com/google/docsy/pull/1890) and [#1947](https://github.com/google/docsy/pull/1947), which add a `{{ if $page.File -}}` nil-guard. **Confirmed fixed in Docsy v0.15.0**, which this project is pinned to. If you hit this error, check that `themes/docsy` is actually at v0.15.0 and not an older commit:

```bash
git -C themes/docsy describe --tags
```

### Problem: stale or locked build

Hugo creates a `.hugo_build.lock` file during `hugo server`/`hugo build` runs. It is listed in `.gitignore` and must never be committed. If a build seems stuck, it's safe to remove:

```bash
rm -f .hugo_build.lock
```

### Problem: PostCSS errors

```bash
# Reinstall dependencies
rm -rf node_modules package-lock.json
npm install

# Check Node.js version
node --version  # Must be LTS (v18+)
```

### Problem: Slow build

```bash
# Disable GitInfo (temporary)
hugo --ignoreCache --disableKinds taxonomy,term

# Clean cache
hugo --cleanDestinationDir
```

## Best Practices

1. **Commits**: Use Conventional Commits
   - `feat:` new features
   - `fix:` bug fixes
   - `docs:` documentation
   - `chore:` maintenance

2. **Branches**: Feature branches for new functionality
   ```bash
   git checkout -b feat/feature-name
   ```

3. **Testing**: Always test locally before pushing
   ```bash
   hugo server
   ```

4. **Build**: Verify production build
   ```bash
   hugo --minify
   ```

5. **Submodules**: Keep Docsy pinned to a verified version (currently **v0.15.0**) — do not blindly run `git submodule update --remote`. Before bumping, check the target tag's `theme.toml` `min_version` and repo layout compatibility (see [Docsy Theme Update](#docsy-theme-update)).
   ```bash
   cd themes/docsy && git fetch --tags && git checkout v0.15.0
   ```

6. **Hugo Modules**: After any change to `go.mod` (e.g. bumping Docsy), re-run `hugo mod tidy` and commit the updated `go.sum`.
   ```bash
   hugo mod tidy
   ```

---

**References:**
- [Hugo Documentation](https://gohugo.io/documentation/)
- [Docsy Documentation](https://www.docsy.dev/docs/)
- [DXers Community](https://www.dxers.ug/)
