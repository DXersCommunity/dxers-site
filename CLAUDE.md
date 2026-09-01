# CLAUDE.md - DXers Community Website

## Project Overview

**DXers Community Website** is the official website of the DXers Community, the HCL DX (Digital Experience) users group.

- **URL**: https://www.dxers.ug/
- **Repository**: https://github.com/DXersCommunity/dxers-site
- **Main branch**: `dxers-site`
- **Type**: Technical documentation static website

## Technology Stack

### Hugo Static Site Generator
- **Verified working version**: Hugo Extended **0.154.3** (latest GitHub release as of this writing)
- **IMPORTANT**: The **Extended** version of Hugo is required for SCSS support
- **Download**: https://gohugo.io/installation/

### Docsy Theme
- **Theme**: [Docsy](https://github.com/google/docsy) by Google
- **Pinned version**: **v0.15.0** (git tag) — checked out in the `themes/docsy` submodule
- **Loaded via**: Hugo Modules (see "Module Architecture" below), NOT the legacy `theme = [...]` array
- **Documentation**: https://www.docsy.dev/docs/

⚠️ **Do not upgrade Docsy past v0.15.0 without also upgrading Hugo.** Docsy v0.16.0 and v0.17.0 bumped `theme.toml`'s `min_version` to **0.160.1**, which does not exist yet on Hugo's GitHub releases (latest is 0.154.3 at time of writing). Jumping to v0.16.0/v0.17.0 with Hugo 0.154.3 will break the build. Re-verify `min_version` in `themes/docsy/theme.toml` (or `theme/theme.toml` for v0.16.0+, which also relocates the theme into a `theme/` subfolder with module path `github.com/google/docsy/theme`) before ever bumping the submodule tag.

### Module Architecture (Hybrid: submodule + Hugo Modules)

Docsy's own indirect dependencies (Bootstrap, Font Awesome) are distributed via **Hugo Modules**, not vendored files in the theme repo. This project uses a **hybrid setup**:

1. `themes/docsy` is still a plain Git submodule (physical checkout, no network needed to fetch the theme itself).
2. `go.mod` at the project root declares the project as a Hugo Module and adds a `replace` directive pointing `github.com/google/docsy` at the local `./themes/docsy` checkout — so Hugo never tries to download Docsy itself over the network.
3. `config.toml` imports Docsy via `[module.imports]` (not the old `theme = ["docsy"]` array).
4. Hugo then resolves Docsy's *indirect* dependencies (Bootstrap, Font Awesome) as normal Hugo Modules, which **does** require network access and downloads them into the Go module cache (`$(go env GOMODCACHE)`, no vendoring committed to the repo).

**Requires Go installed** (verified with Go 1.24.7) purely so `hugo mod tidy` / the Hugo Modules resolver can run — no Go code is written for this project.

```toml
# go.mod
module github.com/DXersCommunity/dxers-site
go 1.24.7
replace github.com/google/docsy => ./themes/docsy
require github.com/google/docsy v0.15.0 // indirect
```

```toml
# config.toml
[module]
  [[module.imports]]
    path = "github.com/google/docsy"
```

If `go.sum` is ever deleted or dependencies change, regenerate with:
```bash
hugo mod tidy
```

### Node.js Dependencies
```json
{
  "devDependencies": {
    "autoprefixer": "^9.8.6",
    "postcss-cli": "^7.1.2"
  }
}
```

## Project Structure

```
dxers-site/
├── assets/
│   └── scss/                    # Custom SCSS
│       └── _variables_project.scss
├── content/
│   └── en/                      # English content
│       ├── community/           # Community pages
│       │   ├── join_discord/
│       │   ├── code_of_conduct/
│       │   └── join_meetings/
│       └── docs/                # Documentation
│           ├── Resources/
│           │   ├── community_resources/
│           │   └── hcl_resources/
│           └── Contribution guidelines/
├── layouts/                      # Custom Hugo layout overrides
│   └── 404.html                  # Only remaining override — Docsy v0.15.0
│                                  # covers everything else natively now
├── themes/
│   └── docsy/                   # Docsy theme (submodule, pinned to v0.15.0)
├── config.toml                  # Main Hugo configuration
├── go.mod / go.sum               # Hugo Modules manifest (see above)
├── package.json                 # Node.js dependencies
├── wrangler.toml                 # CloudFlare Pages configuration
├── justfile                      # Command runner recipes
└── deploy.sh                    # Deployment script
```

**Note**: Two custom layout overrides (`layouts/partials/head.html` and `layouts/docs/list.html`) were removed — they were workarounds for a very old, pre-Hugo-Modules Docsy checkout (deprecated `_internal/google_analytics_async.html`, `.Site.DisqusShortname`, etc.) and are now fully superseded by Docsy v0.15.0's native templates. Do not re-add them.

## Development Prerequisites

### 1. Hugo Extended
**CRITICAL**: Install the Extended version of Hugo, not the standard one.

```bash
# Check installed version
hugo version

# Verified working output:
# hugo v0.154.3+extended linux/amd64 ...
```

### 2. Go
Required for Hugo Modules resolution (Docsy's Bootstrap/Font Awesome dependencies).

```bash
go version
# Verified with go1.24.7
```

### 3. Node.js and npm
- **Required version**: Node.js LTS (Long Term Support)
- **Usage**: For PostCSS and Autoprefixer

```bash
# Install dependencies
npm install
```

### 4. Git Submodules
The Docsy theme is installed as a Git submodule:

```bash
# Clone with submodules
git clone --recurse-submodules https://github.com/DXersCommunity/dxers-site.git

# If already cloned, initialize submodules
git submodule update --init --recursive
```

### Full Setup Sequence (Verified Working)

```bash
git submodule update --init --recursive
npm install
hugo mod tidy      # resolves Bootstrap/Font Awesome via Hugo Modules (needs network)
hugo --minify      # build ✅ 29 pages, 0 errors, 0 warnings
```

## Main Commands

### Local Development

```bash
# Start development server
hugo server

# Start with draft and future content
hugo server -D -F

# Server accessible at http://localhost:1313
```

### Production Build

```bash
# Build static site (verified: 29 pages, ~1.7s, zero warnings)
hugo --minify

# Output in: ./public/
```

### Docker

```bash
# Build Docker image
docker build -f dev.Dockerfile -t dxers-site-dev:latest .

# Run container
docker run --publish 1313:1313 --detach \
  --mount src="$(pwd)",target=/home/docsy/app,type=bind \
  dxers-site-dev:latest
```

## Configuration (config.toml)

### Key Settings

- **baseURL**: `https://www.dxers.ug/`
- **title**: `DXers Community Website`
- **theme**: loaded via `[module.imports]` (Docsy), not the legacy `theme` array
- **contentDir**: `content/en`
- **defaultContentLanguage**: `en`

### Deprecated settings fixed (verified via clean build with zero warnings)

| Old (deprecated) | New | Notes |
|---|---|---|
| `disableKinds = ["taxonomy", "taxonomyTerm"]` | `disableKinds = ["taxonomy", "term"]` | `taxonomyTerm` deprecated since Hugo 0.73.0 |
| `[blackfriday]` section | *(removed)* | Blackfriday parser deprecated; Hugo uses Goldmark (`[markup.goldmark]`) by default |
| `algolia_docsearch = false` | *(removed, use `[params.search.algolia]` if ever enabled)* | Top-level key deprecated |
| `footer_about_disable = false` | `footer_about_enable = true` | Renamed **and inverted** — do not just rename, flip the boolean |

### Social Links

- **Discord**: https://discord.gg/RtG4nyCEDX
- **GitHub**: https://github.com/DXersCommunity/dxers-site

## Development Workflow

### 1. Create New Feature Branch
```bash
git checkout -b feature/feature-name
```

### 2. Local Development
```bash
hugo server -D
```

### 3. Test and Verify
- Check all links
- Test responsive design
- Validate HTML/CSS
- Check accessibility
- Run `hugo --minify` and confirm **zero** `WARN`/`ERROR` lines in the output

### 4. Production Build
```bash
npm install
hugo --minify
```

### 5. Commit and Push
```bash
git add .
git commit -m "feat: feature description"
git push origin feature/feature-name
```

### 6. Pull Request
Create PR to `dxers-site` branch

## Deployment

### Production Environment
- **Platform**: CloudFlare Pages
- **Deploy branch**: `dxers-site`
- **Build command**: `hugo --minify` (CloudFlare Pages needs Go available in the build image to resolve Hugo Modules — see `wrangler.toml` / `CLOUDFLARE_DEPLOYMENT.md`)
- **Output directory**: `public/`

### Deployment Script
```bash
# Use the deploy.sh script
./deploy.sh
```

## Troubleshooting

### Hugo not found
```bash
# Install Hugo Extended 0.154.3 (or whatever is the current latest release
# that still satisfies themes/docsy/theme.toml's min_version)
wget https://github.com/gohugoio/hugo/releases/download/v0.154.3/hugo_extended_0.154.3_linux-amd64.tar.gz
tar -xzf hugo_extended_0.154.3_linux-amd64.tar.gz
sudo mv hugo /usr/local/bin/ && sudo chmod +x /usr/local/bin/hugo
```

### Missing Docsy theme
```bash
# Initialize submodules
git submodule update --init --recursive
```

### `ERROR ... File to import not found ... vendor/bootstrap/scss/bootstrap`
**Cause**: Hugo Modules not resolved (missing/stale `go.mod`, `go.sum`, or no network access to the Go module proxy).

```bash
hugo mod tidy
hugo --minify
```

### `ERROR ... File is nil; wrap it in if or with` (in `section-index.html`)
**Cause**: Using a Docsy version older than the fix for [google/docsy#1874](https://github.com/google/docsy/issues/1874) (fixed by PRs #1890/#1947). Ensure `themes/docsy` submodule is checked out at **v0.15.0 or later** (but see the min_version warning above before going past v0.15.0).

### `ERROR ... unknown output format "print" for kind "section"` or template errors referencing `layouts/partials/head.html` / `layouts/docs/list.html`
**Cause**: Stale custom layout overrides from a pre-Hugo-Modules Docsy checkout. These were removed — if they reappear, delete them; Docsy v0.15.0 handles Google Analytics, Disqus, dark mode, and feedback natively.

### PostCSS errors
```bash
# Reinstall dependencies
rm -rf node_modules package-lock.json
npm install
```

### Build fails
```bash
# Check Hugo Extended version
hugo version | grep extended

# If not Extended, reinstall Hugo Extended
```

## Useful Resources

### Hugo
- [Hugo Documentation](https://gohugo.io/documentation/)
- [Hugo Quick Start](https://gohugo.io/getting-started/quick-start/)
- [Hugo Forum](https://discourse.gohugo.io/)
- [Hugo Modules](https://gohugo.io/hugo-modules/)

### Docsy
- [Docsy Documentation](https://www.docsy.dev/docs/)
- [Docsy GitHub](https://github.com/google/docsy)
- [Docsy Example](https://github.com/google/docsy-example)
- [Docsy issue #1874 (section-index NPE)](https://github.com/google/docsy/issues/1874)

### DXers Community
- [Discord](https://discord.gg/RtG4nyCEDX)
- [GitHub](https://github.com/DXersCommunity)
- [Website](https://www.dxers.ug/)

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for contribution guidelines.

### Code of Conduct
See [Code of Conduct](content/en/community/code_of_conduct/index.md)

## License

See [LICENSE](LICENSE) for details.

---

**Last updated**: 2026-09-01 (verified end-to-end with a real Hugo install and build)
**Verified working Hugo version**: 0.154.3 Extended
**Pinned Docsy version**: v0.15.0
