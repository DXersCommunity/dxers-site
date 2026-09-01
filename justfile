# DXers Community Website - Justfile
# Just command runner recipes for common development tasks
# Install just: https://github.com/casey/just

# Load environment variables from .env file if it exists
set dotenv-load := true

# Default recipe (list all recipes)
default:
    @just --list

# === Development Commands ===

# Start Hugo development server
dev:
    hugo server

# Start Hugo development server with drafts and future content
dev-all:
    hugo server -D -F

# Start Hugo development server accessible from local network
dev-network:
    hugo server --bind 0.0.0.0

# Start Hugo development server with live reload disabled
dev-no-reload:
    hugo server --disableLiveReload

# === Build Commands ===

# Build site for production with minification
build:
    hugo --minify

# Build site with verbose output
build-verbose:
    hugo --minify --verbose

# Build and show template performance metrics
build-metrics:
    hugo --templateMetrics --templateMetricsHints

# Clean build artifacts
clean:
    hugo --cleanDestinationDir
    rm -rf resources/ public/

# Full clean (including node_modules)
clean-all: clean
    rm -rf node_modules/

# === Testing Commands ===

# Run local tests (build + serve)
test: build dev

# Validate HTML (requires html-validate)
validate-html:
    html-validate public/**/*.html

# Check site links (requires wget)
check-links:
    wget --spider -r -nd -nv -l 5 http://localhost:1313/

# Run all tests
test-all: build validate-html check-links

# === Setup Commands ===

# Initialize project (install dependencies, submodules, and Hugo Modules)
setup:
    @echo "Initializing DXers site..."
    git submodule update --init --recursive
    npm install
    hugo mod tidy
    @echo "✅ Setup complete!"

# Resolve Docsy's Hugo Module dependencies (Bootstrap, Font Awesome)
# Requires Go installed and network access. Run after cloning or if the
# build fails with "File to import not found ... vendor/bootstrap".
mod-tidy:
    hugo mod tidy

# Install npm dependencies
npm-install:
    npm install

# Update npm dependencies
npm-update:
    npm update

# Install npm dependencies (fresh)
npm-fresh:
    rm -rf node_modules/ package-lock.json
    npm install

# === Git Submodule Commands ===

# Update Docsy theme submodule
# WARNING: Do NOT blindly update to the latest tag. Docsy v0.16.0+ requires
# Hugo 0.160.1+ (not released yet as of the last verified build with Hugo
# 0.154.3) and restructures the repo (module moves to a "theme/" subfolder
# with Go module path "github.com/google/docsy/theme"). Check
# themes/docsy/theme.toml's min_version against your installed `hugo version`
# BEFORE checking out a newer tag. See CLAUDE.md for details.
update-theme:
    @echo "Updating Docsy theme..."
    git submodule update --remote themes/docsy
    @echo "⚠️  Check themes/docsy/theme.toml min_version against 'hugo version' before committing!"
    @echo "✅ Theme updated! Test with: just build"

# Initialize git submodules
init-submodules:
    git submodule update --init --recursive

# Check submodule status
submodule-status:
    git submodule status

# === Docker Commands ===

# Build Docker image
docker-build:
    docker build -f dev.Dockerfile -t dxers-site-dev:latest .

# Run Docker container
docker-run:
    docker run --publish 1313:1313 --detach \
        --mount src="$(pwd)",target=/home/docsy/app,type=bind \
        dxers-site-dev:latest

# Stop all dxers-site Docker containers
docker-stop:
    docker ps -q --filter ancestor=dxers-site-dev:latest | xargs -r docker stop

# Remove dxers-site Docker containers
docker-clean:
    docker ps -a -q --filter ancestor=dxers-site-dev:latest | xargs -r docker rm

# Full Docker workflow (build and run)
docker: docker-build docker-run
    @echo "✅ Docker container running at http://localhost:1313"

# === Hugo Commands ===

# Check Hugo version
hugo-version:
    hugo version

# Verify Hugo Extended is installed
hugo-check:
    @hugo version | grep -q extended && echo "✅ Hugo Extended is installed" || echo "❌ Hugo Extended is NOT installed - please install it!"

# Create new content page
new-page path:
    hugo new {{path}}

# Create new blog post
new-post title:
    hugo new content/en/blog/{{title}}.md

# === CloudFlare Pages / Wrangler Commands ===

# Deploy to CloudFlare Pages (production)
cf-deploy: build
    @echo "Deploying to CloudFlare Pages (production)..."
    wrangler pages deploy public --project-name=dxers-site --branch=dxers-site

# Deploy preview to CloudFlare Pages
cf-deploy-preview: build
    @echo "Deploying preview to CloudFlare Pages..."
    wrangler pages deploy public --project-name=dxers-site --branch=preview

# Check CloudFlare Pages deployment status
cf-status:
    wrangler pages deployment list --project-name=dxers-site

# View CloudFlare Pages project info
cf-info:
    wrangler pages project list

# Tail CloudFlare Pages logs
cf-logs:
    wrangler pages deployment tail --project-name=dxers-site

# Open CloudFlare Pages dashboard
cf-dashboard:
    @echo "Opening CloudFlare Pages dashboard..."
    @echo "https://dash.cloudflare.com/pages"

# Validate wrangler.toml configuration
cf-validate:
    @echo "Validating wrangler.toml..."
    wrangler pages project list > /dev/null && echo "✅ Wrangler configuration valid" || echo "❌ Wrangler configuration invalid"

# === Deployment Commands ===

# Deploy site (requires configuration)
deploy: build
    @echo "Deploying site..."
    ./deploy.sh

# Create production build and check output
deploy-check: build
    @echo "Build complete. Checking output..."
    @ls -lh public/
    @echo "Total files:"
    @find public/ -type f | wc -l
    @echo "Total size:"
    @du -sh public/

# === Maintenance Commands ===

# Run full site health check
health-check: hugo-check
    @echo "=== Hugo Health Check ==="
    @hugo version
    @echo ""
    @echo "=== Node.js Health Check ==="
    @node --version
    @npm --version
    @echo ""
    @echo "=== Git Submodules ==="
    @git submodule status
    @echo ""
    @echo "✅ Health check complete!"

# Show site statistics
stats: build
    @echo "=== Site Statistics ==="
    @echo "Hugo version:"
    @hugo version
    @echo ""
    @echo "Build output size:"
    @du -sh public/
    @echo ""
    @echo "Total HTML files:"
    @find public/ -type f -name "*.html" | wc -l
    @echo ""
    @echo "Total CSS files:"
    @find public/ -type f -name "*.css" | wc -l
    @echo ""
    @echo "Total JS files:"
    @find public/ -type f -name "*.js" | wc -l
    @echo ""
    @echo "Total images:"
    @find public/ -type f \( -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" -o -name "*.gif" -o -name "*.svg" \) | wc -l

# Create backup of project
backup:
    @echo "Creating backup..."
    tar -czf ../dxers-site-backup-$(date +%Y%m%d-%H%M%S).tar.gz \
        --exclude=node_modules \
        --exclude=.git \
        --exclude=public \
        --exclude=resources \
        .
    @echo "✅ Backup created in parent directory"

# === CI/CD Commands ===

# Create .hugo-version file
set-hugo-version version="0.154.1":
    @echo "{{version}}" > .hugo-version
    @echo "✅ Hugo version set to {{version}}"

# === Development Workflow ===

# Full development setup (for new contributors)
onboard: setup hugo-check
    @echo "=== Welcome to DXers Community Website! ==="
    @echo ""
    @echo "Setup complete! Next steps:"
    @echo "1. Run 'just dev' to start development server"
    @echo "2. Open http://localhost:1313 in your browser"
    @echo "3. Make changes and see them live reload"
    @echo ""
    @echo "Other useful commands:"
    @echo "- 'just build' to build for production"
    @echo "- 'just test' to run tests"
    @echo "- 'just --list' to see all available commands"

# Quick fix workflow (clean and rebuild)
fix: clean setup build

# Pre-commit checks
pre-commit: clean build
    @echo "✅ Pre-commit checks passed!"

# === Content Management ===

# List all content files
list-content:
    @find content/ -type f -name "*.md" | sort

# Count content files
count-content:
    @echo "Total content files:"
    @find content/ -type f -name "*.md" | wc -l

# Search content for term
search term:
    @grep -r "{{term}}" content/ --include="*.md"

# === Hugo New Content Templates ===

# Create new documentation page
new-doc section title:
    hugo new content/en/docs/{{section}}/{{title}}.md

# Create new community page
new-community title:
    hugo new content/en/community/{{title}}/index.md

# === Troubleshooting Commands ===

# Fix PostCSS issues
fix-postcss:
    @echo "Fixing PostCSS issues..."
    rm -rf node_modules/ package-lock.json
    npm install
    @echo "✅ PostCSS dependencies reinstalled"

# Fix submodule issues
fix-submodules:
    @echo "Fixing submodule issues..."
    git submodule update --init --recursive
    @echo "✅ Submodules reinitialized"

# Reset everything (nuclear option)
reset: clean-all
    @echo "Resetting project..."
    git submodule update --init --recursive
    npm install
    @echo "✅ Project reset complete!"

# === Information Commands ===

# Show project information
info:
    @echo "=== DXers Community Website ==="
    @echo "Repository: https://github.com/DXersCommunity/dxers-site"
    @echo "Live Site: https://www.dxers.ug/"
    @echo "Discord: https://discord.gg/RtG4nyCEDX"
    @echo ""
    @echo "=== Environment ==="
    @echo "Hugo version:"
    @hugo version || echo "Hugo not installed"
    @echo ""
    @echo "Node.js version:"
    @node --version || echo "Node.js not installed"
    @echo ""
    @echo "npm version:"
    @npm --version || echo "npm not installed"
    @echo ""
    @echo "Git branch:"
    @git branch --show-current

# Show documentation links
docs:
    @echo "=== Documentation Links ==="
    @echo ""
    @echo "📚 Project Documentation:"
    @echo "  - README.md - Quick start guide"
    @echo "  - CLAUDE.md - Complete documentation for Claude Code"
    @echo "  - DOCS.md - Detailed technical documentation"
    @echo "  - HUGO_UPDATE_2026.md - Hugo upgrade guide"
    @echo "  - CONTRIBUTING.md - Contribution guidelines"
    @echo ""
    @echo "🔗 External Documentation:"
    @echo "  - Hugo: https://gohugo.io/documentation/"
    @echo "  - Docsy: https://www.docsy.dev/docs/"
    @echo "  - Just: https://github.com/casey/just"
    @echo ""
    @echo "💬 Community:"
    @echo "  - Discord: https://discord.gg/RtG4nyCEDX"
    @echo "  - GitHub: https://github.com/DXersCommunity/dxers-site"

# Show help for specific topic
help topic:
    @echo "Getting help for: {{topic}}"
    @echo ""
    @grep -A 20 "{{topic}}" README.md DOCS.md || echo "No help found for '{{topic}}'"
