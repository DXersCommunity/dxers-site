# CLAUDE.md - DXers Community Website

## Project Overview

**DXers Community Website** is the official website of the DXers Community, the HCL DX (Digital Experience) users group.

- **URL**: https://www.dxers.ug/
- **Repository**: https://github.com/DXersCommunity/dxers-site
- **Main branch**: `dxers-site`
- **Type**: Technical documentation static website

## Technology Stack

### Hugo Static Site Generator
- **Recommended version**: Hugo Extended **0.154.1** (latest version - January 2026)
- **Minimum required version**: Hugo Extended **0.146.0+**
- **IMPORTANT**: The **Extended** version of Hugo is required for SCSS support
- **Download**: https://gohugo.io/installation/

### Docsy Theme
- **Theme**: [Docsy](https://github.com/google/docsy) by Google
- **Installation**: Git submodule in `themes/docsy`
- **Documentation**: https://www.docsy.dev/docs/
- **Docsy version**: v0.12.0+ (requires Hugo 0.146.0+)

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
├── layouts/                     # Custom Hugo layouts
│   └── 404.html
├── themes/
│   └── docsy/                   # Docsy theme (submodule)
├── config.toml                  # Main Hugo configuration
├── package.json                 # Node.js dependencies
└── deploy.sh                    # Deployment script
```

## Development Prerequisites

### 1. Hugo Extended
**CRITICAL**: Install the Extended version of Hugo, not the standard one.

```bash
# Check installed version
hugo version

# Expected output:
# hugo v0.154.1+extended linux/amd64 ...
```

### 2. Node.js and npm
- **Required version**: Node.js LTS (Long Term Support)
- **Usage**: For PostCSS and Autoprefixer

```bash
# Install dependencies
npm install
```

### 3. Git Submodules
The Docsy theme is installed as a Git submodule:

```bash
# Clone with submodules
git clone --recurse-submodules https://github.com/DXersCommunity/dxers-site.git

# If already cloned, initialize submodules
git submodule update --init --recursive
```

### 4. Go (Optional)
If you want to use Docsy as a Hugo Module instead of a submodule.

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
# Build static site
hugo

# Output in: ./public/
```

### Build with PostCSS (for deployment)

```bash
# First install dependencies
npm install

# Then build
hugo --minify
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
- **theme**: `docsy`
- **contentDir**: `content/en`
- **defaultContentLanguage**: `en`

### Social Links

- **Discord**: https://discord.gg/RtG4nyCEDX
- **GitHub**: https://github.com/DXersCommunity/dxers-site

## Hugo Update

### Current Version
**Hugo is not currently installed** in the development system.

### Available Versions (January 2026)
- **Latest version**: Hugo Extended **0.154.1**
- **Recommended stable version**: Hugo Extended **0.146.0+**

### Why Update?

**New Hugo features 2024-2025:**
- LaTeX and TeX typesetting
- Server-side math rendering with KaTeX
- Streaming builds for millions of pages
- Content adapters for remote data
- Improved Tailwind CSS support
- Obsidian-style callouts

### How to Update

#### Linux
```bash
# Download Extended version
wget https://github.com/gohugoio/hugo/releases/download/v0.154.1/hugo_extended_0.154.1_linux-amd64.tar.gz

# Extract
tar -xzf hugo_extended_0.154.1_linux-amd64.tar.gz

# Move to PATH
sudo mv hugo /usr/local/bin/

# Verify
hugo version
```

#### macOS
```bash
# With Homebrew
brew install hugo
```

#### Windows
```powershell
# With Chocolatey
choco install hugo-extended

# Or with Scoop
scoop install hugo-extended
```

### Recommendations

1. ✅ **UPDATE to Hugo Extended 0.154.1**
   - Compatible with Docsy v0.12.0+
   - Includes all latest features
   - Better performance
   - Bug fixes

2. ✅ **Test after update**
   ```bash
   # Local test
   hugo server

   # Build test
   hugo --minify
   ```

3. ✅ **Verify Docsy theme compatibility**
   ```bash
   # Update Docsy submodule
   git submodule update --remote themes/docsy
   ```

4. ⚠️ **Beware of Breaking Changes**
   - Hugo 0.146.0+ changed some APIs
   - Test all pages before deployment
   - Verify PostCSS works correctly

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
- **Build command**: `hugo --minify`
- **Output directory**: `public/`

### Deployment Script
```bash
# Use the deploy.sh script
./deploy.sh
```

## Troubleshooting

### Hugo not found
```bash
# Install Hugo Extended
# See "How to Update" section
```

### Missing Docsy theme
```bash
# Initialize submodules
git submodule update --init --recursive
```

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

### Docsy
- [Docsy Documentation](https://www.docsy.dev/docs/)
- [Docsy GitHub](https://github.com/google/docsy)
- [Docsy Example](https://github.com/google/docsy-example)

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

**Last updated**: 2026-01-08
**Recommended Hugo version**: 0.154.1 Extended
**Minimum Hugo version**: 0.146.0 Extended
