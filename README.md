# DXers Community Website

Official website of the **DXers Community** - The HCL DX (Digital Experience) users group.

🌐 **Live Site**: [https://www.dxers.ug/](https://www.dxers.ug/)
💬 **Discord**: [Join our community](https://discord.gg/RtG4nyCEDX)
📦 **Repository**: [GitHub](https://github.com/DXersCommunity/dxers-site)

This site is built with [Hugo](https://gohugo.io/) and uses Google's [Docsy](https://github.com/google/docsy) theme.

## 📚 Documentation

- **[CLAUDE.md](CLAUDE.md)** - Complete documentation for Claude Code and AI developers
- **[DOCS.md](DOCS.md)** - Detailed technical project documentation
- **[HUGO_UPDATE_2026.md](HUGO_UPDATE_2026.md)** - Hugo upgrade guide to version 0.154.1
- **[CLOUDFLARE_DEPLOYMENT.md](CLOUDFLARE_DEPLOYMENT.md)** - CloudFlare Pages deployment guide
- **[CONTRIBUTING.md](CONTRIBUTING.md)** - Contribution guidelines

## 🚀 Quick Start

### Prerequisites

- **Hugo Extended** 0.154.1 or higher ([Download](https://gohugo.io/installation/))
- **Node.js** LTS (v18+) and npm
- **Git** with submodule support

⚠️ **IMPORTANT**: You need the **Extended** version of Hugo, not the standard one!

### Installation

```bash
# 1. Clone repository with submodules
git clone --recurse-submodules https://github.com/DXersCommunity/dxers-site.git
cd dxers-site

# 2. Install npm dependencies (for PostCSS)
npm install

# 3. Start development server
hugo server

# 4. Open browser at http://localhost:1313
```

### Verify Hugo

```bash
# Verify that Hugo Extended is installed
hugo version

# Expected output: hugo v0.154.1+extended linux/amd64
```

If Hugo is not installed or the version is outdated, consult **[HUGO_UPDATE_2026.md](HUGO_UPDATE_2026.md)**.

### Docsy Theme

The theme is included as a Git submodule in `themes/docsy`:

```bash
# Check submodule status
git submodule status

# Update submodule (if needed)
git submodule update --init --recursive
```

## 📋 Main Commands

### Development

```bash
# Development server
hugo server

# Server with drafts and future content
hugo server -D -F

# Server accessible from local network
hugo server --bind 0.0.0.0
```

### Production Build

```bash
# Build static site
hugo --minify

# Output generated in: ./public/
```

### Testing

```bash
# Performance metrics
hugo --templateMetrics

# Verify build
hugo --minify --verbose
```

### Docker

You can run the site inside a [Docker](https://docs.docker.com/) container.
This approach doesn't require installing any dependencies other than Docker.

```bash
# 1. Build Docker image
docker build -f dev.Dockerfile -t dxers-site-dev:latest .

# 2. Run container
docker run --publish 1313:1313 --detach \
  --mount src="$(pwd)",target=/home/docsy/app,type=bind \
  dxers-site-dev:latest

# 3. Open browser at http://localhost:1313

# 4. Stop container
docker container ls  # Find CONTAINER_ID
docker stop [CONTAINER_ID]

# 5. Remove container
docker container rm [CONTAINER_ID]
```

## 🛠️ Tech Stack

- **Hugo Extended** 0.154.1+ - Static site generator
- **Docsy Theme** - Google's documentation theme
- **PostCSS** - CSS processing
- **Autoprefixer** - CSS vendor prefixes
- **CloudFlare Pages** - Hosting and deployment
- **Wrangler** - CloudFlare CLI for deployments
- **Just** - Command runner for development tasks

## 📂 Project Structure

```
dxers-site/
├── assets/scss/           # Custom SCSS
├── content/en/            # English content
│   ├── community/         # Community pages
│   └── docs/              # Documentation
├── layouts/               # Custom Hugo layouts
├── themes/docsy/          # Docsy theme (submodule)
├── config.toml            # Main Hugo configuration
├── wrangler.toml          # CloudFlare Pages configuration
├── justfile               # Just command runner recipes
├── package.json           # npm dependencies
├── .env.example           # Environment variables template
└── deploy.sh              # Deployment script
```

## 🔄 Hugo Update

**Current required version**: Hugo Extended **0.154.1**

If you're using an outdated version or Hugo is not installed, consult the complete guide:

📖 **[HUGO_UPDATE_2026.md](HUGO_UPDATE_2026.md)**

The guide includes:
- ✅ Installation instructions for Linux/macOS/Windows
- ✅ Pre-upgrade checklist
- ✅ Testing and validation
- ✅ Troubleshooting
- ✅ CI/CD configuration

## 🤝 Contributing

Contributions are welcome! Please:

1. Read [CONTRIBUTING.md](CONTRIBUTING.md)
2. Follow the [Code of Conduct](content/en/community/code_of_conduct/index.md)
3. Fork the repository
4. Create a feature branch
5. Commit your changes
6. Push and create a Pull Request

## 📝 Additional Documentation

- **[Hugo Documentation](https://gohugo.io/documentation/)**
- **[Docsy Documentation](https://www.docsy.dev/docs/)**
- **[Docsy Guide](https://www.docsy.dev/docs/getting-started/)**

## 🐛 Support

- **Issues**: [GitHub Issues](https://github.com/DXersCommunity/dxers-site/issues)
- **Discussions**: [GitHub Discussions](https://github.com/DXersCommunity/dxers-site/discussions)
- **Discord**: [DXers Community](https://discord.gg/RtG4nyCEDX)

## 📜 License

See [LICENSE](LICENSE) for details.

---

**DXers Community** - The HCL DX Users Group
Made with ❤️ by the DXers Community
