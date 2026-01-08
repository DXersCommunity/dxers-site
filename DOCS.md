# Documentazione Tecnica - DXers Community Website

## Indice

1. [Introduzione](#introduzione)
2. [Architettura](#architettura)
3. [Setup Ambiente di Sviluppo](#setup-ambiente-di-sviluppo)
4. [Gestione Contenuti](#gestione-contenuti)
5. [Personalizzazione](#personalizzazione)
6. [Deployment](#deployment)
7. [Manutenzione](#manutenzione)

## Introduzione

Il sito web della DXers Community è costruito con Hugo, un generatore di siti statici scritto in Go, noto per le sue prestazioni eccezionali. Utilizza il tema Docsy di Google, specificamente progettato per siti di documentazione tecnica.

### Caratteristiche Principali

- ✅ **Velocità**: Build ultra-rapidi grazie a Hugo
- ✅ **SEO-Friendly**: Siti statici ottimizzati per i motori di ricerca
- ✅ **Responsive**: Design mobile-first con Bootstrap
- ✅ **Ricerca**: Supporto Google Custom Search
- ✅ **Multi-lingua**: Pronto per internazionalizzazione
- ✅ **Versioning**: Gestione versioni documentazione
- ✅ **Dark Mode**: Supporto tema scuro (configurabile)

## Architettura

### Stack Tecnologico

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

### Flusso di Build

1. **Markdown → HTML**: Hugo converte contenuti Markdown in HTML
2. **SCSS → CSS**: PostCSS processa SCSS in CSS ottimizzato
3. **Asset Optimization**: Minificazione HTML/CSS/JS
4. **Output**: File statici pronti per deployment

## Setup Ambiente di Sviluppo

### Prerequisiti

#### 1. Hugo Extended

**IMPORTANTE**: Serve la versione **Extended**, non quella standard!

```bash
# Verifica installazione
hugo version

# Output atteso:
# hugo v0.154.1+extended linux/amd64
```

**Installazione:**

##### Linux
```bash
# Download ultima versione Extended
VERSION=0.154.1
wget https://github.com/gohugoio/hugo/releases/download/v${VERSION}/hugo_extended_${VERSION}_linux-amd64.tar.gz

# Estrazione
tar -xzf hugo_extended_${VERSION}_linux-amd64.tar.gz

# Installazione
sudo mv hugo /usr/local/bin/
sudo chmod +x /usr/local/bin/hugo

# Verifica
hugo version
```

##### macOS
```bash
# Con Homebrew
brew install hugo
```

##### Windows
```powershell
# Con Chocolatey
choco install hugo-extended -y

# Con Scoop
scoop install hugo-extended

# Con Winget
winget install Hugo.Hugo.Extended
```

#### 2. Node.js e npm

```bash
# Verifica installazione
node --version  # v18.x o superiore (LTS)
npm --version   # 9.x o superiore

# Installa dipendenze progetto
npm install
```

#### 3. Git

```bash
# Clone repository con submodules
git clone --recurse-submodules https://github.com/DXersCommunity/dxers-site.git
cd dxers-site

# Se già clonato, inizializza submodules
git submodule update --init --recursive
```

### Prima Configurazione

```bash
# 1. Clone repository
git clone --recurse-submodules https://github.com/DXersCommunity/dxers-site.git
cd dxers-site

# 2. Installa dipendenze npm
npm install

# 3. Avvia server di sviluppo
hugo server

# 4. Apri browser
# http://localhost:1313
```

## Gestione Contenuti

### Struttura Contenuti

```
content/en/
├── _index.html              # Homepage
├── search.md                # Pagina ricerca
├── community/               # Sezione community
│   ├── _index.md           # Index community
│   ├── join_discord/       # Come unirsi a Discord
│   ├── code_of_conduct/    # Codice di condotta
│   └── join_meetings/      # Meeting della community
└── docs/                    # Documentazione
    ├── _index.md           # Index docs
    ├── Resources/          # Risorse
    │   ├── community_resources/
    │   └── hcl_resources/
    └── Contribution guidelines/
```

### Creare Nuova Pagina

#### 1. Pagina Semplice

```bash
# Crea nuova pagina
hugo new content/en/docs/nuova-guida.md
```

Contenuto generato:
```markdown
---
title: "Nuova Guida"
date: 2026-01-08
draft: true
---

# Contenuto qui
```

#### 2. Sezione con Index

```bash
# Crea nuova sezione
mkdir -p content/en/docs/nuova-sezione
hugo new content/en/docs/nuova-sezione/_index.md
```

### Front Matter

Ogni pagina Markdown ha metadati YAML all'inizio:

```yaml
---
title: "Titolo Pagina"
description: "Descrizione breve per SEO"
date: 2026-01-08
weight: 10              # Ordine nel menu (più basso = prima)
draft: false            # true = non pubblicato
---
```

#### Front Matter Avanzato

```yaml
---
title: "Guida Avanzata"
linkTitle: "Guida"     # Nome nel menu (più corto)
description: "Descrizione SEO"
date: 2026-01-08
weight: 20
type: docs              # Tipo di pagina
categories:
  - Tutorial
  - Guide
tags:
  - hcl-dx
  - docsy
---
```

### Shortcodes Docsy

#### Alert

```markdown
{{< alert title="Attenzione" color="warning" >}}
Questo è un messaggio di avviso importante!
{{< /alert >}}
```

Colori disponibili: `primary`, `secondary`, `success`, `danger`, `warning`, `info`, `light`, `dark`

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
Descrizione feature
{{< /card >}}
{{< card header="Feature 2" >}}
Altra descrizione
{{< /card >}}
{{< /cardpane >}}
```

## Personalizzazione

### SCSS Personalizzato

File: `assets/scss/_variables_project.scss`

```scss
/*
 * Personalizzazioni variabili Bootstrap e Docsy
 */

// Colori primari
$primary: #007bff;
$secondary: #6c757d;

// Font
$font-family-sans-serif: "Roboto", -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;

// Dimensioni
$navbar-height: 60px;
```

### Layout Personalizzati

Directory: `layouts/`

#### Override Singola Pagina

```
layouts/
├── 404.html              # Pagina 404 personalizzata
├── _default/
│   ├── baseof.html      # Template base
│   └── single.html      # Template pagina singola
└── partials/
    ├── header.html      # Header personalizzato
    └── footer.html      # Footer personalizzato
```

### Configurazione Menu

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

### Build Produzione

```bash
# Build con minificazione
hugo --minify

# Output in: ./public/
```

### CloudFlare Pages

#### Configurazione

1. **Build command**: `hugo --minify`
2. **Build output directory**: `public`
3. **Root directory**: `/`
4. **Environment variables**:
   - `HUGO_VERSION`: `0.154.1`

#### Build Settings

```toml
# CloudFlare Pages rileva automaticamente Hugo
# Ma si può specificare la versione

# Crea file: .hugo-version
0.154.1
```

### Deploy Script

File: `deploy.sh`

```bash
#!/bin/bash

# Build sito
hugo --minify

# Deploy (customizza per tuo hosting)
rsync -avz --delete public/ user@server:/var/www/dxers/
```

## Manutenzione

### Aggiornamento Hugo

```bash
# Verifica versione corrente
hugo version

# Download nuova versione
# Vedi sezione Setup > Hugo Extended

# Test dopo aggiornamento
hugo server
```

### Aggiornamento Tema Docsy

```bash
# Aggiorna submodule
git submodule update --remote themes/docsy

# Test
hugo server

# Commit aggiornamento
git add themes/docsy
git commit -m "chore: update Docsy theme"
```

### Aggiornamento Dipendenze npm

```bash
# Verifica outdated
npm outdated

# Aggiorna
npm update

# Per major updates
npm install autoprefixer@latest postcss-cli@latest --save-dev
```

### Backup

```bash
# Backup completo
tar -czf dxers-site-backup-$(date +%Y%m%d).tar.gz \
  --exclude=node_modules \
  --exclude=.git \
  --exclude=public \
  dxers-site/
```

### Performance Monitoring

```bash
# Analisi tempo di build
hugo --templateMetrics --templateMetricsHints

# Analisi dimensioni output
du -sh public/
find public/ -type f -name "*.html" | wc -l
```

## Testing

### Test Locale

```bash
# Server di sviluppo con draft
hugo server -D

# Server con binding esterno
hugo server --bind 0.0.0.0

# Server con live reload disabilitato
hugo server --disableLiveReload
```

### Validazione

```bash
# HTML Validator (richiede npm package html-validate)
npm install -g html-validate
html-validate public/**/*.html

# Link Checker
wget --spider -r -nd -nv -l 5 http://localhost:1313/
```

## Troubleshooting

### Problema: Hugo non trovato

```bash
# Verifica PATH
echo $PATH

# Verifica installazione
which hugo

# Reinstalla
# Vedi sezione Setup > Hugo Extended
```

### Problema: Tema Docsy non carica

```bash
# Inizializza submodules
git submodule update --init --recursive

# Verifica submodule
git submodule status
```

### Problema: Errori PostCSS

```bash
# Reinstalla dipendenze
rm -rf node_modules package-lock.json
npm install

# Verifica Node.js version
node --version  # Deve essere LTS (v18+)
```

### Problema: Build lento

```bash
# Disabilita GitInfo (temporaneo)
hugo --ignoreCache --disableKinds taxonomy,term

# Pulisci cache
hugo --cleanDestinationDir
```

## Best Practices

1. **Commits**: Usa Conventional Commits
   - `feat:` nuove feature
   - `fix:` bug fix
   - `docs:` documentazione
   - `chore:` manutenzione

2. **Branch**: Feature branches per nuove funzionalità
   ```bash
   git checkout -b feat/nome-feature
   ```

3. **Testing**: Testa sempre localmente prima del push
   ```bash
   hugo server
   ```

4. **Build**: Verifica build produzione
   ```bash
   hugo --minify
   ```

5. **Submodules**: Aggiorna regolarmente
   ```bash
   git submodule update --remote
   ```

---

**Riferimenti:**
- [Hugo Documentation](https://gohugo.io/documentation/)
- [Docsy Documentation](https://www.docsy.dev/docs/)
- [DXers Community](https://www.dxers.ug/)
