# Guida Aggiornamento Hugo 2026

## Executive Summary

**Raccomandazione**: ✅ **AGGIORNARE a Hugo Extended 0.154.1**

### Status Corrente
- ❌ Hugo **NON installato** nel sistema di sviluppo
- ⚠️ Versione richiesta minima: **0.146.0 Extended**
- ✅ Versione disponibile: **0.154.1 Extended** (gennaio 2026)

### Azione Richiesta
**Installare Hugo Extended 0.154.1** per garantire:
- Compatibilità con tema Docsy v0.12.0+
- Accesso alle ultime funzionalità
- Migliori prestazioni di build
- Sicurezza e bug fixes

---

## Analisi Versioni

### Hugo 0.154.1 (Gennaio 2026) - RACCOMANDATO ✅

**Data Rilascio**: Gennaio 2026
**Status**: Stabile, ultima versione disponibile

#### Vantaggi
- ✅ Completamente compatibile con Docsy
- ✅ Build più veloci (streaming builds)
- ✅ Supporto LaTeX/TeX per documentazione matematica
- ✅ Math rendering server-side con KaTeX
- ✅ Content adapters per dati remoti
- ✅ Miglioramenti Tailwind CSS
- ✅ Callout Obsidian-style
- ✅ Tutte le patch di sicurezza

#### Svantaggi
- ⚠️ Possibili breaking changes rispetto a versioni molto vecchie
- ⚠️ Richiede testing completo dopo installazione

### Hugo 0.146.0 (Versione Minima)

**Data Rilascio**: 2024
**Status**: Versione minima richiesta da Docsy v0.12.0

#### Vantaggi
- ✅ Compatibilità garantita con Docsy
- ✅ Stabile e testata

#### Svantaggi
- ❌ Mancano funzionalità recenti
- ❌ Prestazioni inferiori
- ❌ Mancano patch di sicurezza recenti

### Conclusione: AGGIORNARE a 0.154.1 ✅

---

## Checklist Pre-Aggiornamento

Prima di installare Hugo, verifica:

- [ ] **Backup completo progetto**
  ```bash
  git status  # Assicurati che non ci siano modifiche non committate
  ```

- [ ] **Node.js installato** (LTS v18+)
  ```bash
  node --version
  npm --version
  ```

- [ ] **Dipendenze npm installate**
  ```bash
  npm install
  ```

- [ ] **Git submodules aggiornati**
  ```bash
  git submodule update --init --recursive
  ```

---

## Procedura di Installazione

### IMPORTANTE: Versione Extended

⚠️ **CRITICO**: Installare **Hugo Extended**, NON la versione standard!

Il tema Docsy richiede Hugo Extended per il supporto SCSS/SASS.

### Linux (Raccomandato per Server)

```bash
# 1. Definisci versione
HUGO_VERSION=0.154.1

# 2. Download Hugo Extended
cd /tmp
wget https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_linux-amd64.tar.gz

# 3. Estrai archivio
tar -xzf hugo_extended_${HUGO_VERSION}_linux-amd64.tar.gz

# 4. Installa in /usr/local/bin
sudo mv hugo /usr/local/bin/
sudo chmod +x /usr/local/bin/hugo

# 5. Verifica installazione
hugo version

# Output atteso:
# hugo v0.154.1+extended linux/amd64 BuildDate=2026-xx-xx
```

### macOS

#### Con Homebrew (Raccomandato)

```bash
# Installa Hugo Extended
brew install hugo

# Verifica versione
hugo version

# Se version < 0.154.1, aggiorna
brew upgrade hugo
```

#### Download Manuale

```bash
# 1. Download per macOS (ARM - Apple Silicon)
cd /tmp
wget https://github.com/gohugoio/hugo/releases/download/v0.154.1/hugo_extended_0.154.1_darwin-universal.tar.gz

# 2. Estrai
tar -xzf hugo_extended_0.154.1_darwin-universal.tar.gz

# 3. Installa
sudo mv hugo /usr/local/bin/
sudo chmod +x /usr/local/bin/hugo

# 4. Verifica
hugo version
```

### Windows

#### Con Chocolatey (Raccomandato)

```powershell
# Installa Hugo Extended
choco install hugo-extended -y

# Verifica
hugo version
```

#### Con Scoop

```powershell
# Installa Scoop se non presente
# https://scoop.sh

# Installa Hugo Extended
scoop install hugo-extended

# Verifica
hugo version
```

#### Con Winget

```powershell
# Installa Hugo Extended
winget install Hugo.Hugo.Extended

# Verifica
hugo version
```

#### Download Manuale

1. Vai a: https://github.com/gohugoio/hugo/releases/tag/v0.154.1
2. Scarica: `hugo_extended_0.154.1_windows-amd64.zip`
3. Estrai in `C:\Hugo\bin\`
4. Aggiungi `C:\Hugo\bin\` al PATH
5. Verifica: `hugo version`

### Docker (Alternativa)

```dockerfile
# Usa immagine Hugo ufficiale
FROM klakegg/hugo:0.154.1-ext-alpine

WORKDIR /src

COPY . .

RUN hugo --minify

# Output in /src/public
```

```bash
# Build con Docker
docker build -t dxers-site .
```

---

## Verifica Installazione

### Test Base

```bash
# 1. Verifica versione
hugo version

# Output atteso:
# hugo v0.154.1+extended linux/amd64

# 2. Verifica che sia Extended
hugo version | grep extended

# Deve contenere "+extended"
```

### Test Progetto

```bash
# 1. Vai nella directory progetto
cd /path/to/dxers-site

# 2. Aggiorna submodules
git submodule update --init --recursive

# 3. Installa dipendenze npm
npm install

# 4. Avvia server sviluppo
hugo server

# 5. Apri browser
# http://localhost:1313

# 6. Verifica che il sito carichi correttamente
```

### Test Build Produzione

```bash
# Build con minificazione
hugo --minify

# Verifica output
ls -lh public/

# Controlla errori
# Non devono esserci errori nel log
```

---

## Post-Installazione

### 1. Test Completo

#### Checklist Test
- [ ] Homepage carica correttamente
- [ ] Menu navigazione funziona
- [ ] Tutte le pagine docs accessibili
- [ ] Pagine community accessibili
- [ ] Link Discord funziona
- [ ] Ricerca funziona (se abilitata)
- [ ] Stili CSS caricano correttamente
- [ ] Responsive design OK (mobile/tablet/desktop)
- [ ] Performance accettabili

#### Comandi Test

```bash
# Server sviluppo
hugo server -D

# Test su network locale
hugo server --bind 0.0.0.0

# Build produzione
hugo --minify

# Metriche performance
hugo --templateMetrics
```

### 2. Aggiorna Documentazione

```bash
# Crea file .hugo-version per CI/CD
echo "0.154.1" > .hugo-version

# Commit
git add .hugo-version
git commit -m "chore: specify Hugo version 0.154.1"
```

### 3. Aggiorna CI/CD

Se usi CloudFlare Pages, GitHub Actions, o altro CI/CD:

#### CloudFlare Pages

```toml
# File: .cloudflare/build-config.toml
[build]
command = "hugo --minify"
publish = "public"

[build.environment]
HUGO_VERSION = "0.154.1"
```

#### GitHub Actions

```yaml
# File: .github/workflows/hugo.yml
- name: Setup Hugo
  uses: peaceiris/actions-hugo@v2
  with:
    hugo-version: '0.154.1'
    extended: true
```

#### Netlify

```toml
# File: netlify.toml
[build]
  command = "hugo --minify"
  publish = "public"

[build.environment]
  HUGO_VERSION = "0.154.1"
```

### 4. Considera Aggiornamento Docsy

```bash
# Verifica versione Docsy corrente
cd themes/docsy
git describe --tags

# Aggiorna a ultima versione
cd ../..
git submodule update --remote themes/docsy

# Test
hugo server

# Se OK, commit
git add themes/docsy
git commit -m "chore: update Docsy theme to latest"
```

---

## Troubleshooting

### Problema: "hugo: command not found"

**Causa**: Hugo non è nel PATH

**Soluzione**:
```bash
# Linux/macOS: Aggiungi a ~/.bashrc o ~/.zshrc
export PATH=$PATH:/usr/local/bin

# Ricarica
source ~/.bashrc

# Windows: Aggiungi a PATH sistema
# Pannello di controllo > Sistema > Variabili ambiente
```

### Problema: "Error: failed to extract shortcode"

**Causa**: Versione Hugo standard invece di Extended

**Soluzione**:
```bash
# Verifica
hugo version | grep extended

# Se non vedi "+extended", reinstalla Hugo Extended
```

### Problema: "POSTCSS: failed to transform"

**Causa**: PostCSS non configurato correttamente

**Soluzione**:
```bash
# Reinstalla dipendenze
rm -rf node_modules package-lock.json
npm install

# Verifica Node.js version
node --version  # Deve essere LTS (v18+)
```

### Problema: "TOCSS: failed to transform"

**Causa**: Problemi SCSS/SASS

**Soluzione**:
```bash
# Verifica Hugo Extended
hugo version | grep extended

# Pulisci cache Hugo
hugo --cleanDestinationDir
rm -rf resources/
```

### Problema: Build molto lento

**Causa**: Cache o configurazione non ottimale

**Soluzione**:
```bash
# Pulisci tutto
hugo --cleanDestinationDir
rm -rf resources/ public/

# Rebuild
hugo --minify

# Se ancora lento, disabilita temporaneamente GitInfo
hugo --ignoreCache
```

---

## Breaking Changes e Migrazioni

### Da versioni < 0.146.0

#### 1. Goldmark è ora il parser Markdown predefinito

**Prima** (Blackfriday):
```toml
[blackfriday]
  plainIDAnchors = true
```

**Dopo** (Goldmark):
```toml
[markup.goldmark.renderer]
  unsafe = true
```

✅ **Status**: Già configurato in `config.toml`

#### 2. Syntax Highlighting

**Prima**:
```toml
pygmentsUseClasses = false
```

**Dopo**:
```toml
[markup.highlight]
  style = "tango"
```

✅ **Status**: Già configurato in `config.toml`

#### 3. .Page.RSSLink → .OutputFormats

Se usi RSS customizzato, aggiorna codice.

### Nessuna Azione Richiesta

Il progetto DXers è già configurato per Hugo moderno! ✅

---

## Monitoring Post-Aggiornamento

### Metriche da Monitorare

#### 1. Tempo di Build

```bash
# Before
time hugo --minify

# Dopo aggiornamento
time hugo --minify

# Miglioramento atteso: 10-30% più veloce
```

#### 2. Dimensione Output

```bash
# Controlla dimensioni
du -sh public/

# Controlla file generati
find public/ -type f | wc -l
```

#### 3. Performance Template

```bash
# Identifica template lenti
hugo --templateMetrics --templateMetricsHints
```

### Log Monitoring

```bash
# Build con verbose logging
hugo --verbose --debug

# Salva log
hugo --minify --verbose > build.log 2>&1
```

---

## Rollback Plan

Se l'aggiornamento causa problemi:

### 1. Versione Precedente

```bash
# Linux: Installa versione specifica
VERSION=0.146.0
wget https://github.com/gohugoio/hugo/releases/download/v${VERSION}/hugo_extended_${VERSION}_linux-amd64.tar.gz
tar -xzf hugo_extended_${VERSION}_linux-amd64.tar.gz
sudo mv hugo /usr/local/bin/
```

### 2. Docker Pinned Version

```dockerfile
FROM klakegg/hugo:0.146.0-ext-alpine
```

### 3. CI/CD Rollback

Modifica versione Hugo in configurazione CI/CD.

---

## Raccomandazioni Finali

### ✅ DA FARE

1. **Installa Hugo Extended 0.154.1**
   - Versione stabile e testata
   - Tutte le funzionalità moderne
   - Miglior supporto Docsy

2. **Testa localmente**
   - Verifica tutte le pagine
   - Controlla build produzione
   - Valida HTML/CSS

3. **Aggiorna CI/CD**
   - Specifica versione Hugo
   - Test deployment

4. **Documenta versione**
   - Crea `.hugo-version`
   - Aggiorna README.md
   - Commit changes

5. **Monitora**
   - Prima settimana: controlli giornalieri
   - Verifica metriche performance
   - Raccogli feedback team

### ⚠️ DA EVITARE

1. ❌ **NON installare versione standard** (solo Extended)
2. ❌ **NON saltare test locali** prima di deploy
3. ❌ **NON aggiornare** senza backup
4. ❌ **NON ignorare errori** di build
5. ❌ **NON deployare** senza test completo

---

## Timeline Consigliata

### Fase 1: Preparazione (Giorno 1)
- [ ] Backup progetto
- [ ] Review documentazione
- [ ] Preparazione ambiente

### Fase 2: Installazione (Giorno 1-2)
- [ ] Installa Hugo 0.154.1 Extended
- [ ] Verifica installazione
- [ ] Test build locale

### Fase 3: Testing (Giorno 2-3)
- [ ] Test completo sito
- [ ] Verifica tutte le pagine
- [ ] Performance testing

### Fase 4: Deployment (Giorno 3-4)
- [ ] Aggiorna CI/CD
- [ ] Deploy staging
- [ ] Test staging
- [ ] Deploy produzione

### Fase 5: Monitoring (Settimana 1)
- [ ] Monitor metriche
- [ ] Raccogli feedback
- [ ] Fix eventuali issues

---

## Risorse

### Documentazione Hugo
- [Hugo Releases](https://github.com/gohugoio/hugo/releases)
- [Hugo Installation](https://gohugo.io/installation/)
- [Hugo Documentation](https://gohugo.io/documentation/)

### Documentazione Docsy
- [Docsy Prerequisites](https://www.docsy.dev/docs/get-started/docsy-as-module/installation-prerequisites/)
- [Docsy GitHub](https://github.com/google/docsy)

### Supporto
- [Hugo Forum](https://discourse.gohugo.io/)
- [Hugo GitHub Issues](https://github.com/gohugoio/hugo/issues)
- [DXers Community Discord](https://discord.gg/RtG4nyCEDX)

---

**Documento creato**: 2026-01-08
**Ultima revisione**: 2026-01-08
**Versione Hugo target**: 0.154.1 Extended
**Status**: ✅ RACCOMANDATO PER INSTALLAZIONE
