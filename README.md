# DXers Community Website

Sito web ufficiale della **DXers Community** - Il gruppo utenti di HCL DX (Digital Experience).

🌐 **Live Site**: [https://www.dxers.ug/](https://www.dxers.ug/)
💬 **Discord**: [Join our community](https://discord.gg/RtG4nyCEDX)
📦 **Repository**: [GitHub](https://github.com/DXersCommunity/dxers-site)

Questo sito è costruito con [Hugo](https://gohugo.io/) e utilizza il tema [Docsy](https://github.com/google/docsy) di Google.

## 📚 Documentazione

- **[CLAUDE.md](CLAUDE.md)** - Documentazione completa per Claude Code e sviluppatori AI
- **[DOCS.md](DOCS.md)** - Documentazione tecnica dettagliata del progetto
- **[HUGO_UPDATE_2026.md](HUGO_UPDATE_2026.md)** - Guida aggiornamento Hugo alla versione 0.154.1
- **[CONTRIBUTING.md](CONTRIBUTING.md)** - Linee guida per contribuire

## 🚀 Quick Start

### Prerequisiti

- **Hugo Extended** 0.154.1 o superiore ([Download](https://gohugo.io/installation/))
- **Node.js** LTS (v18+) e npm
- **Git** con supporto submodules

⚠️ **IMPORTANTE**: Serve la versione **Extended** di Hugo, non quella standard!

### Installazione

```bash
# 1. Clone repository con submodules
git clone --recurse-submodules https://github.com/DXersCommunity/dxers-site.git
cd dxers-site

# 2. Installa dipendenze npm (per PostCSS)
npm install

# 3. Avvia server di sviluppo
hugo server

# 4. Apri browser su http://localhost:1313
```

### Verifica Hugo

```bash
# Verifica che Hugo Extended sia installato
hugo version

# Output atteso: hugo v0.154.1+extended linux/amd64
```

Se Hugo non è installato o la versione è obsoleta, consulta **[HUGO_UPDATE_2026.md](HUGO_UPDATE_2026.md)**.

### Tema Docsy

Il tema è incluso come Git submodule in `themes/docsy`:

```bash
# Verifica submodule
git submodule status

# Aggiorna submodule (se necessario)
git submodule update --init --recursive
```

## 📋 Comandi Principali

### Sviluppo

```bash
# Server di sviluppo
hugo server

# Server con draft e contenuti futuri
hugo server -D -F

# Server accessibile dalla rete locale
hugo server --bind 0.0.0.0
```

### Build Produzione

```bash
# Build sito statico
hugo --minify

# Output generato in: ./public/
```

### Testing

```bash
# Metriche performance
hugo --templateMetrics

# Verifica build
hugo --minify --verbose
```

### Docker

Puoi eseguire il sito dentro un container [Docker](https://docs.docker.com/).
Questo approccio non richiede installazione di dipendenze oltre a Docker.

```bash
# 1. Build immagine Docker
docker build -f dev.Dockerfile -t dxers-site-dev:latest .

# 2. Run container
docker run --publish 1313:1313 --detach \
  --mount src="$(pwd)",target=/home/docsy/app,type=bind \
  dxers-site-dev:latest

# 3. Apri browser su http://localhost:1313

# 4. Stop container
docker container ls  # Trova CONTAINER_ID
docker stop [CONTAINER_ID]

# 5. Rimuovi container
docker container rm [CONTAINER_ID]
```

## 🛠️ Stack Tecnologico

- **Hugo Extended** 0.154.1+ - Static site generator
- **Docsy Theme** - Google's documentation theme
- **PostCSS** - CSS processing
- **Autoprefixer** - CSS vendor prefixes
- **CloudFlare Pages** - Hosting e deployment

## 📂 Struttura Progetto

```
dxers-site/
├── assets/scss/           # SCSS personalizzati
├── content/en/            # Contenuti in inglese
│   ├── community/         # Pagine community
│   └── docs/              # Documentazione
├── layouts/               # Layout Hugo personalizzati
├── themes/docsy/          # Tema Docsy (submodule)
├── config.toml            # Configurazione Hugo
├── package.json           # Dipendenze npm
└── deploy.sh              # Script deployment
```

## 🔄 Aggiornamento Hugo

**Versione corrente richiesta**: Hugo Extended **0.154.1**

Se stai usando una versione obsoleta o Hugo non è installato, consulta la guida completa:

📖 **[HUGO_UPDATE_2026.md](HUGO_UPDATE_2026.md)**

La guida include:
- ✅ Istruzioni installazione per Linux/macOS/Windows
- ✅ Checklist pre-aggiornamento
- ✅ Testing e validazione
- ✅ Troubleshooting
- ✅ Configurazione CI/CD

## 🤝 Contribuire

Benvenuti i contributi! Per favore:

1. Leggi [CONTRIBUTING.md](CONTRIBUTING.md)
2. Segui il [Code of Conduct](content/en/community/code_of_conduct/index.md)
3. Fork il repository
4. Crea una feature branch
5. Commit le modifiche
6. Push e crea una Pull Request

## 📝 Documentazione Aggiuntiva

- **[Documentazione Hugo](https://gohugo.io/documentation/)**
- **[Documentazione Docsy](https://www.docsy.dev/docs/)**
- **[Guida Docsy](https://www.docsy.dev/docs/getting-started/)**

## 🐛 Supporto

- **Issues**: [GitHub Issues](https://github.com/DXersCommunity/dxers-site/issues)
- **Discussions**: [GitHub Discussions](https://github.com/DXersCommunity/dxers-site/discussions)
- **Discord**: [DXers Community](https://discord.gg/RtG4nyCEDX)

## 📜 Licenza

Vedi [LICENSE](LICENSE) per i dettagli.

---

**DXers Community** - The HCL DX Users Group
Made with ❤️ by the DXers Community 
