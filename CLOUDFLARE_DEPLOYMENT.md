# CloudFlare Pages Deployment Guide

Complete guide for deploying the DXers Community Website to CloudFlare Pages.

## Table of Contents

1. [Overview](#overview)
2. [Prerequisites](#prerequisites)
3. [Configuration](#configuration)
4. [Deployment Methods](#deployment-methods)
5. [Environment Variables](#environment-variables)
6. [Troubleshooting](#troubleshooting)

---

## Overview

The DXers Community Website is configured for deployment to **CloudFlare Pages** using the **Wrangler CLI** and **wrangler.toml** configuration.

### Key Features

- ✅ **Automatic Deployments**: Git-based deployments from main branch
- ✅ **Preview Deployments**: Automatic previews for pull requests
- ✅ **Environment-Specific Configs**: Separate production and preview settings
- ✅ **Custom Headers**: Security and caching headers configured
- ✅ **Redirects**: URL redirects for Discord and GitHub
- ✅ **Hugo & Node Version Control**: Specify exact versions per environment

---

## Prerequisites

### 1. CloudFlare Account

- Sign up at https://dash.cloudflare.com/sign-up
- No credit card required for Pages

### 2. Wrangler CLI

```bash
# Install wrangler globally
npm install -g wrangler

# Verify installation
wrangler --version

# Login to CloudFlare
wrangler login
```

### 3. Project Repository

- GitHub repository connected to CloudFlare Pages
- Repository: https://github.com/DXersCommunity/dxers-site

---

## Configuration

### wrangler.toml Structure

The `wrangler.toml` file contains all deployment configuration:

```toml
name = "dxers-site"
compatibility_date = "2024-01-01"
pages_build_output_dir = "public"

[env.production.vars]
HUGO_VERSION = "0.154.3"
NODE_VERSION = "22"
# ... more vars

[env.preview.vars]
HUGO_VERSION = "0.154.3"
NODE_VERSION = "22"
# ... more vars
```

### Key Sections

#### 1. **Production Environment** (`env.production`)

Used for deployments to the `dxers-site` branch (production).

**Variables:**
- `HUGO_VERSION`: `0.154.3` - Hugo Extended version
- `HUGO_ENV`: `production` - Production mode
- `NODE_VERSION`: `22` - Node.js LTS version
- `SITE_URL`: `https://www.dxers.ug` - Production URL

#### 2. **Preview Environment** (`env.preview`)

Used for pull request previews and feature branch deployments.

**Variables:**
- `HUGO_VERSION`: `0.154.3` - Same Hugo version
- `HUGO_ENV`: `development` - Development mode
- `NODE_VERSION`: `22` - Same Node version
- `HUGO_ENABLEGITINFO`: `false` - Disable GitInfo for faster builds

#### 3. **Headers**

Custom HTTP headers for security and caching:

```toml
[[headers]]
for = "/*"
[headers.values]
X-Frame-Options = "DENY"
X-Content-Type-Options = "nosniff"
# ... more security headers
```

#### 4. **Redirects**

URL redirects for convenience:

```toml
[[redirects]]
from = "/discord"
to = "https://discord.gg/RtG4nyCEDX"
status = 301
```

---

## Deployment Methods

### Method 1: Automatic Git Deployment (Recommended)

**Production:**
1. Push to `dxers-site` branch
2. CloudFlare Pages automatically builds and deploys
3. Available at https://www.dxers.ug

**Preview:**
1. Create pull request or push to feature branch
2. CloudFlare Pages creates preview deployment
3. Preview URL provided in PR comments

### Method 2: Wrangler CLI

#### Deploy Production

```bash
# Using justfile (recommended)
just cf-deploy

# Or directly with wrangler
wrangler pages deploy public --project-name=dxers-site --branch=dxers-site
```

#### Deploy Preview

```bash
# Using justfile
just cf-deploy-preview

# Or directly with wrangler
wrangler pages deploy public --project-name=dxers-site --branch=preview
```

### Method 3: Manual Upload (Dashboard)

1. Build site locally: `just build`
2. Go to https://dash.cloudflare.com/pages
3. Select "dxers-site" project
4. Click "Create deployment"
5. Upload `public/` directory

---

## Environment Variables

### Required Variables (Set in CloudFlare Dashboard)

Go to: **Pages Project** → **Settings** → **Environment Variables**

#### Production Variables

| Variable | Value | Description |
|----------|-------|-------------|
| `HUGO_VERSION` | `0.154.3` | Hugo Extended version |
| `NODE_VERSION` | `22` | Node.js version |
| `HUGO_ENV` | `production` | Hugo environment |
| `NODE_ENV` | `production` | Node environment |

#### Preview Variables

| Variable | Value | Description |
|----------|-------|-------------|
| `HUGO_VERSION` | `0.154.3` | Hugo Extended version |
| `NODE_VERSION` | `22` | Node.js version |
| `HUGO_ENV` | `development` | Hugo environment |
| `NODE_ENV` | `development` | Node environment |

### Optional Variables

| Variable | Value | Description |
|----------|-------|-------------|
| `HUGO_ENABLEGITINFO` | `true`/`false` | Enable Git info |
| `ENABLE_ANALYTICS` | `true`/`false` | Enable analytics |
| `ENABLE_SEARCH` | `true`/`false` | Enable search |

---

## Wrangler CLI Commands

### Using Justfile (Recommended)

```bash
# Deploy to production
just cf-deploy

# Deploy preview
just cf-deploy-preview

# Check deployment status
just cf-status

# View project info
just cf-info

# Tail logs
just cf-logs

# Open dashboard
just cf-dashboard

# Validate configuration
just cf-validate
```

### Direct Wrangler Commands

```bash
# List deployments
wrangler pages deployment list --project-name=dxers-site

# View project details
wrangler pages project list

# Tail deployment logs
wrangler pages deployment tail --project-name=dxers-site

# Deploy with specific branch
wrangler pages deploy public --project-name=dxers-site --branch=my-branch

# Create new Pages project
wrangler pages project create dxers-site
```

---

## Build Configuration

### CloudFlare Pages Build Settings

**Framework preset:** Hugo

**Build command:**
```bash
npm install && hugo mod tidy && hugo --minify
```

**Build output directory:**
```
public
```

**Root directory:**
```
/
```

**Environment variables:**
```
HUGO_VERSION=0.154.3
NODE_VERSION=22
GO_VERSION=1.21
```

⚠️ **`GO_VERSION` is required.** Docsy is loaded as a Hugo Module and its own dependencies (Bootstrap, Font Awesome) are resolved via `hugo mod tidy`, which needs Go on the build machine. CloudFlare Pages' build image includes Go by default, but pin `GO_VERSION` explicitly so the build doesn't silently break if the default changes. Without Go available, the build fails with `File to import not found or unreadable: ../vendor/bootstrap/scss/bootstrap`. See [CLAUDE.md](CLAUDE.md#module-architecture-hybrid-submodule--hugo-modules) for the full explanation.

### Build Process

1. **Install Dependencies**
   ```bash
   npm install
   ```

2. **Resolve Docsy's Hugo Module Dependencies**
   ```bash
   hugo mod tidy
   ```
   Downloads Bootstrap and Font Awesome (Docsy's indirect dependencies) into the Go module cache. Requires Go and network access to the Go module proxy.

3. **Build Hugo Site**
   ```bash
   hugo --minify
   ```
   Verified locally: 29 pages, 30 static files, 2 processed images, zero warnings/errors, ~1.7–2s.

4. **Output to `public/`**
   - Static HTML, CSS, JS
   - Optimized and minified

---

## Troubleshooting

### Common Issues

#### 1. Build Fails: "hugo: command not found"

**Cause:** Hugo version not specified or incorrect

**Solution:**
```bash
# Check wrangler.toml has correct HUGO_VERSION
# Production and preview should both have:
HUGO_VERSION = "0.154.3"

# Or set in CloudFlare Dashboard:
# Settings → Environment Variables → HUGO_VERSION = 0.154.3
```

#### 2. Build Fails: "Error: failed to extract shortcode"

**Cause:** Standard Hugo instead of Extended version

**Solution:**
```bash
# Hugo Extended is automatically used when HUGO_VERSION is set
# Ensure version is 0.146.0 or higher
HUGO_VERSION = "0.154.3"
```

#### 3. PostCSS Errors

**Cause:** npm dependencies not installed

**Solution:**
```bash
# Ensure build command includes npm install:
BUILD_COMMAND = "npm install && hugo mod tidy && hugo --minify"
```

#### 3b. Build Fails: "File to import not found or unreadable: ../vendor/bootstrap/scss/bootstrap"

**Cause:** Docsy's own dependencies (Bootstrap, Font Awesome) are Hugo Modules, not vendored files. The build command is missing `hugo mod tidy`, or Go isn't available in the build image.

**Solution:**
```bash
# Build command must include hugo mod tidy BEFORE hugo build:
BUILD_COMMAND = "npm install && hugo mod tidy && hugo --minify"

# And Go must be available — set explicitly:
GO_VERSION = "1.21"
```

This was actually encountered and fixed during local build verification — see [BUILD_READINESS_REPORT.md](BUILD_READINESS_REPORT.md) and [CLAUDE.md](CLAUDE.md#module-architecture-hybrid-submodule--hugo-modules) for the full root-cause writeup.

#### 4. Preview Deployments Not Working

**Cause:** Branch pattern not matching

**Solution:**
```toml
# In wrangler.toml, check preview_branch_includes:
[deployment]
preview_branch_includes = ["feat/*", "fix/*", "docs/*", "chore/*", "claude/*"]
```

#### 5. Environment Variables Not Applied

**Cause:** Variables set in wrong environment

**Solution:**
1. Go to CloudFlare Dashboard → Pages → Settings → Environment Variables
2. Verify variables are set for correct environment (Production vs Preview)
3. Redeploy to apply changes

---

## Advanced Configuration

### Custom Domains

1. Go to **Pages Project** → **Custom Domains**
2. Click **Set up a custom domain**
3. Enter: `www.dxers.ug`
4. CloudFlare provides DNS records
5. Update DNS at your registrar
6. Wait for SSL certificate (automatic)

### Access Control

1. Go to **Pages Project** → **Settings** → **Access Policy**
2. Enable **Access** for preview deployments
3. Configure authentication (email, SSO, etc.)
4. Protect preview URLs from public access

### Build Notifications

1. Go to **Pages Project** → **Settings** → **Notifications**
2. Configure webhook for build status
3. Options: Slack, Discord, Email, Custom webhook

**Discord Webhook Example:**
```bash
# Set in .env
DISCORD_WEBHOOK_URL=https://discord.com/api/webhooks/YOUR_WEBHOOK
```

### Build Caching

CloudFlare Pages automatically caches:
- `node_modules/` (npm dependencies)
- Hugo resources cache
- Build artifacts

**Clear cache:**
```bash
# In CloudFlare Dashboard
Pages → Deployments → Clear build cache
```

---

## Security Best Practices

### 1. Use API Tokens (Not API Keys)

```bash
# Create scoped API token at:
# https://dash.cloudflare.com/profile/api-tokens

# Permissions required:
# - Account → Cloudflare Pages → Edit

# Set in .env
CLOUDFLARE_API_TOKEN=your_token_here
```

### 2. Protect Sensitive Variables

```bash
# Use CloudFlare Dashboard for secrets
# Don't commit to wrangler.toml or .env

# Set as encrypted environment variables
# Pages → Settings → Environment Variables
```

### 3. Enable Security Headers

Already configured in `wrangler.toml`:
- `X-Frame-Options: DENY`
- `X-Content-Type-Options: nosniff`
- `X-XSS-Protection: 1; mode=block`
- `Referrer-Policy: strict-origin-when-cross-origin`

### 4. Use Branch Protection

```toml
[deployment]
production_branch = "dxers-site"

# Only this branch deploys to production
# All others are preview deployments
```

---

## Monitoring and Analytics

### CloudFlare Web Analytics

Enabled in `wrangler.toml`:
```toml
[analytics]
enabled = true
```

View analytics:
1. Go to CloudFlare Dashboard
2. Navigate to **Analytics & Logs** → **Web Analytics**
3. View traffic, performance, and user behavior

### Build Logs

```bash
# Tail logs in real-time
wrangler pages deployment tail --project-name=dxers-site

# View deployment history
wrangler pages deployment list --project-name=dxers-site

# Or use justfile
just cf-logs
```

### Performance Metrics

CloudFlare provides:
- Page load times
- Core Web Vitals
- Geographic distribution
- Browser/device breakdown

---

## Resources

### CloudFlare Documentation
- [CloudFlare Pages](https://developers.cloudflare.com/pages/)
- [Wrangler CLI](https://developers.cloudflare.com/workers/wrangler/)
- [Hugo on Pages](https://developers.cloudflare.com/pages/framework-guides/deploy-a-hugo-site/)

### DXers Community
- [Discord](https://discord.gg/RtG4nyCEDX)
- [GitHub](https://github.com/DXersCommunity/dxers-site)
- [Website](https://www.dxers.ug/)

### Related Documentation
- [README.md](README.md) - Quick start
- [DOCS.md](DOCS.md) - Technical documentation
- [HUGO_UPDATE_2026.md](HUGO_UPDATE_2026.md) - Hugo upgrade guide

---

**Last Updated:** 2026-01-08
**CloudFlare Pages:** Recommended hosting platform
**Wrangler Version:** 3.x+
