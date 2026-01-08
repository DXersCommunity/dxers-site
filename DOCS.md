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
       ┌───────┴────────┐
       │                │
┌──────▼──────┐  ┌──────▼──────┐
│   Docsy     │  │   Content   │
│   Theme     │  │  (Markdown) │
└──────┬──────┘  └──────┬──────┘
       │                │
       └───────┬────────┘
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

### Build Flow

1. **Markdown → HTML**: Hugo converts Markdown content into HTML
2. **SCSS → CSS**: PostCSS processes SCSS into optimized CSS
3. **Asset Optimization**: HTML/CSS/JS minification
4. **Output**: Static files ready for deployment

## Development Environment Setup

### Prerequisites

#### 1. Hugo Extended

**IMPORTANT**: The **Extended** version is required, not the standard one!

```bash
# Verify installation
hugo version

# Expected output:
# hugo v0.154.1+extended linux/amd64
```

**Installation:**

##### Linux
```bash
# Download latest Extended version
VERSION=0.154.1
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

#### 2. Node.js and npm

```bash
# Verify installation
node --version  # v18.x or higher (LTS)
npm --version   # 9.x or higher

# Install project dependencies
npm install
```

#### 3. Git

```bash
# Clone repository with submodules
git clone --recurse-submodules https://github.com/DXersCommunity/dxers-site.git
cd dxers-site

# If already cloned, initialize submodules
git submodule update --init --recursive
```

### Initial Configuration

```bash
# 1. Clone repository
git clone --recurse-submodules https://github.com/DXersCommunity/dxers-site.git
cd dxers-site

# 2. Install npm dependencies
npm install

# 3. Start development server
hugo server

# 4. Open browser
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

#### Override Single Page

```
layouts/
├── 404.html              # Custom 404 page
├── _default/
│   ├── baseof.html      # Base template
│   └── single.html      # Single page template
└── partials/
    ├── header.html      # Custom header
    └── footer.html      # Custom footer
```

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
   - `HUGO_VERSION`: `0.154.1`

#### Build Settings

```toml
# CloudFlare Pages automatically detects Hugo
# But you can specify the version

# Create file: .hugo-version
0.154.1
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

```bash
# Update submodule
git submodule update --remote themes/docsy

# Test
hugo server

# Commit update
git add themes/docsy
git commit -m "chore: update Docsy theme"
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

5. **Submodules**: Update regularly
   ```bash
   git submodule update --remote
   ```

---

**References:**
- [Hugo Documentation](https://gohugo.io/documentation/)
- [Docsy Documentation](https://www.docsy.dev/docs/)
- [DXers Community](https://www.dxers.ug/)
