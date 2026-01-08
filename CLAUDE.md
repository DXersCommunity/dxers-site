# CLAUDE.md - DXers Community Website

## Panoramica Progetto

**DXers Community Website** è il sito web ufficiale della DXers Community, il gruppo utenti di HCL DX (Digital Experience).

- **URL**: https://www.dxers.ug/
- **Repository**: https://github.com/DXersCommunity/dxers-site
- **Branch principale**: `dxers-site`
- **Tipo**: Sito web statico di documentazione tecnica

## Stack Tecnologico

### Hugo Static Site Generator
- **Versione raccomandata**: Hugo Extended **0.154.1** (ultima versione - gennaio 2026)
- **Versione minima richiesta**: Hugo Extended **0.146.0+**
- **IMPORTANTE**: È necessaria la versione **Extended** di Hugo per il supporto SCSS
- **Download**: https://gohugo.io/installation/

### Tema Docsy
- **Tema**: [Docsy](https://github.com/google/docsy) di Google
- **Installazione**: Git submodule in `themes/docsy`
- **Documentazione**: https://www.docsy.dev/docs/
- **Versione Docsy**: v0.12.0+ (richiede Hugo 0.146.0+)

### Dipendenze Node.js
```json
{
  "devDependencies": {
    "autoprefixer": "^9.8.6",
    "postcss-cli": "^7.1.2"
  }
}
```

## Struttura del Progetto

```
dxers-site/
├── assets/
│   └── scss/                    # SCSS personalizzati
│       └── _variables_project.scss
├── content/
│   └── en/                      # Contenuti in inglese
│       ├── community/           # Pagine community
│       │   ├── join_discord/
│       │   ├── code_of_conduct/
│       │   └── join_meetings/
│       └── docs/                # Documentazione
│           ├── Resources/
│           │   ├── community_resources/
│           │   └── hcl_resources/
│           └── Contribution guidelines/
├── layouts/                     # Layout personalizzati Hugo
│   └── 404.html
├── themes/
│   └── docsy/                   # Tema Docsy (submodule)
├── config.toml                  # Configurazione Hugo principale
├── package.json                 # Dipendenze Node.js
└── deploy.sh                    # Script di deployment
```

## Prerequisiti per lo Sviluppo

### 1. Hugo Extended
**CRITICO**: Installare la versione Extended di Hugo, non quella standard.

```bash
# Verifica versione installata
hugo version

# Output atteso:
# hugo v0.154.1+extended linux/amd64 ...
```

### 2. Node.js e npm
- **Versione richiesta**: Node.js LTS (Long Term Support)
- **Utilizzo**: Per PostCSS e Autoprefixer

```bash
# Installa dipendenze
npm install
```

### 3. Git Submodules
Il tema Docsy è installato come Git submodule:

```bash
# Clone con submodules
git clone --recurse-submodules https://github.com/DXersCommunity/dxers-site.git

# Se già clonato, inizializza submodules
git submodule update --init --recursive
```

### 4. Go (Opzionale)
Se si vuole usare Docsy come Hugo Module invece di submodule.

## Comandi Principali

### Sviluppo Locale

```bash
# Avvia server di sviluppo
hugo server

# Avvia con draft e future content
hugo server -D -F

# Server accessibile su http://localhost:1313
```

### Build per Produzione

```bash
# Build sito statico
hugo

# Output in: ./public/
```

### Build con PostCSS (per deployment)

```bash
# Prima installa dipendenze
npm install

# Poi build
hugo --minify
```

### Docker

```bash
# Build immagine Docker
docker build -f dev.Dockerfile -t dxers-site-dev:latest .

# Run container
docker run --publish 1313:1313 --detach \
  --mount src="$(pwd)",target=/home/docsy/app,type=bind \
  dxers-site-dev:latest
```

## Configurazione (config.toml)

### Configurazioni Chiave

- **baseURL**: `https://www.dxers.ug/`
- **title**: `DXers Community Website`
- **theme**: `docsy`
- **contentDir**: `content/en`
- **defaultContentLanguage**: `en`

### Link Social

- **Discord**: https://discord.gg/RtG4nyCEDX
- **GitHub**: https://github.com/DXersCommunity/dxers-site

## Aggiornamento Hugo

### Versione Corrente
**Hugo non è attualmente installato** nel sistema di sviluppo.

### Versioni Disponibili (Gennaio 2026)
- **Ultima versione**: Hugo Extended **0.154.1**
- **Versione stabile consigliata**: Hugo Extended **0.146.0+**

### Perché Aggiornare?

**Nuove funzionalità Hugo 2024-2025:**
- LaTeX e TeX typesetting
- Server-side math rendering con KaTeX
- Streaming builds per milioni di pagine
- Content adapters per dati remoti
- Supporto Tailwind CSS migliorato
- Callout Obsidian-style

### Come Aggiornare

#### Linux
```bash
# Download versione Extended
wget https://github.com/gohugoio/hugo/releases/download/v0.154.1/hugo_extended_0.154.1_linux-amd64.tar.gz

# Estrai
tar -xzf hugo_extended_0.154.1_linux-amd64.tar.gz

# Sposta in PATH
sudo mv hugo /usr/local/bin/

# Verifica
hugo version
```

#### macOS
```bash
# Con Homebrew
brew install hugo
```

#### Windows
```powershell
# Con Chocolatey
choco install hugo-extended

# O con Scoop
scoop install hugo-extended
```

### Raccomandazioni

1. ✅ **AGGIORNARE a Hugo Extended 0.154.1**
   - Compatibile con Docsy v0.12.0+
   - Include tutte le ultime funzionalità
   - Migliori prestazioni
   - Bug fixes

2. ✅ **Testare dopo l'aggiornamento**
   ```bash
   # Test locale
   hugo server

   # Build test
   hugo --minify
   ```

3. ✅ **Verificare compatibilità tema Docsy**
   ```bash
   # Aggiorna submodule Docsy
   git submodule update --remote themes/docsy
   ```

4. ⚠️ **Attenzione Breaking Changes**
   - Hugo 0.146.0+ ha cambiato alcune API
   - Testare tutte le pagine prima del deployment
   - Verificare che PostCSS funzioni correttamente

## Workflow di Sviluppo

### 1. Creare Nuova Feature Branch
```bash
git checkout -b feature/nome-feature
```

### 2. Sviluppo Locale
```bash
hugo server -D
```

### 3. Test e Verifica
- Verifica tutti i link
- Test responsive design
- Valida HTML/CSS
- Check accessibilità

### 4. Build Produzione
```bash
npm install
hugo --minify
```

### 5. Commit e Push
```bash
git add .
git commit -m "feat: descrizione feature"
git push origin feature/nome-feature
```

### 6. Pull Request
Creare PR verso branch `dxers-site`

## Deployment

### Ambiente Produzione
- **Piattaforma**: CloudFlare Pages
- **Branch deploy**: `dxers-site`
- **Build command**: `hugo --minify`
- **Output directory**: `public/`

### Script Deployment
```bash
# Usa lo script deploy.sh
./deploy.sh
```

## Troubleshooting

### Hugo non trovato
```bash
# Installa Hugo Extended
# Vedi sezione "Come Aggiornare"
```

### Tema Docsy mancante
```bash
# Inizializza submodules
git submodule update --init --recursive
```

### Errori PostCSS
```bash
# Reinstalla dipendenze
rm -rf node_modules package-lock.json
npm install
```

### Build fallisce
```bash
# Verifica versione Hugo Extended
hugo version | grep extended

# Se non è Extended, reinstalla Hugo Extended
```

## Risorse Utili

### Hugo
- [Documentazione Hugo](https://gohugo.io/documentation/)
- [Hugo Quick Start](https://gohugo.io/getting-started/quick-start/)
- [Hugo Forum](https://discourse.gohugo.io/)

### Docsy
- [Documentazione Docsy](https://www.docsy.dev/docs/)
- [Docsy GitHub](https://github.com/google/docsy)
- [Docsy Example](https://github.com/google/docsy-example)

### Comunità DXers
- [Discord](https://discord.gg/RtG4nyCEDX)
- [GitHub](https://github.com/DXersCommunity)
- [Sito Web](https://www.dxers.ug/)

## Contribuire

Vedi [CONTRIBUTING.md](CONTRIBUTING.md) per le linee guida di contribuzione.

### Code of Conduct
Vedi [Code of Conduct](content/en/community/code_of_conduct/index.md)

## Licenza

Vedi [LICENSE](LICENSE) per i dettagli.

---

**Ultimo aggiornamento**: 2026-01-08
**Versione Hugo consigliata**: 0.154.1 Extended
**Versione Hugo minima**: 0.146.0 Extended
