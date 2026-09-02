# Build Readiness Report
**DXers Community Website**
**Date**: 2026-01-08 (updated after real build verification; amended 2026-09-02 after a live-URL comparison found and fixed a functional bug the clean build log had missed — see "Important Nuance" section below)
**Status**: ✅ BUILD VERIFIED (clean `hugo --minify`, zero errors/warnings) — ✅ ALSO VERIFIED against live-URL output after the `contentDir` fix (27 pages)

---

## Executive Summary

Hugo **is now installed** and the site **builds successfully end-to-end with zero errors and zero warnings**. This is no longer a readiness estimate — it is a completed, verified build.

The previous version of this report (2026-01-08, earlier session) concluded the project was "95% ready" and blocked solely on Hugo installation, which network restrictions prevented at the time. In this session, Hugo was downloaded and installed without issue, and a real (not simulated) build was run through to a clean `public/` output. Along the way, four real build failures were found and fixed — none of them was the originally-suspected "Hugo not installed" blocker; all were configuration/theme-version issues uncovered only by actually running the build. Those fixes are documented below as a troubleshooting record for future maintainers.

---

## ✅ Verified Environment

| Component | Version | Status |
|-----------|---------|--------|
| **Hugo** | v0.154.3+extended linux/amd64 | ✅ VERIFIED |
| **Go** | go1.24.7 | ✅ VERIFIED (newly required, see below) |
| **Node.js** | v22.22.2 | ✅ VERIFIED |
| **npm** | 10.9.7 | ✅ VERIFIED |
| **Git submodule (Docsy)** | v0.15.0 (pinned) | ✅ VERIFIED |

Hugo was installed with:
```bash
wget https://github.com/gohugoio/hugo/releases/download/v0.154.3/hugo_extended_0.154.3_linux-amd64.tar.gz
tar -xzf hugo_extended_0.154.3_linux-amd64.tar.gz
sudo mv hugo /usr/local/bin/
hugo version
# hugo v0.154.3+extended linux/amd64 BuildDate=2026-01-06T16:30:17Z VendorInfo=gohugoio
```

Note: earlier documentation (including the prior version of this report and `CLAUDE.md`) referenced "0.154.1" as the latest Hugo release. That version does not exist on GitHub releases — **0.154.3** is the actual current release and is what was installed and verified. Version numbers referenced in docs should always be re-checked against GitHub releases before being treated as literal, since they age quickly.

`npm install` succeeded again in this session (13 vulnerabilities: 5 moderate, 8 high — same legacy dev-dependency vulnerabilities as noted previously, non-blocking, unchanged in nature from prior report).

`git submodule update --init --recursive` succeeded, checking out `themes/docsy`.

---

## 🔧 Issues Found & Fixed

Running the real build surfaced four distinct failures, resolved in sequence. Each is a genuine issue a future contributor could hit again — this section is the troubleshooting record.

### 1. Stale submodule state → `unknown output format "print" for kind "section"`

**Build attempt #1** failed with:
```
ERROR failed to create config: unknown output format "print" for kind "section"
```
This turned out to be a stale-state artifact from the submodule not yet being fully initialized in this session — no code or config change was needed. Once `git submodule update --init --recursive` completed properly, this error did not recur on the next attempt.

### 2. No Hugo Modules setup → `File to import not found: ../vendor/bootstrap/scss/bootstrap`

**Build attempt #2** failed with:
```
ERROR ... File to import not found or unreadable: ../vendor/bootstrap/scss/bootstrap.
```
**Root cause**: Docsy's own third-party dependencies (Bootstrap, Font Awesome) are distributed via **Hugo Modules**, not vendored inside the theme repo. The project only had the legacy `theme = ["docsy"]` array in `config.toml` and no `go.mod`, so Hugo had no way to resolve those module dependencies.

**Fix applied**:
- Added a project-root `go.mod`:
  ```
  module github.com/DXersCommunity/dxers-site
  go 1.24.7
  replace github.com/google/docsy => ./themes/docsy
  require github.com/google/docsy v0.15.0 // indirect
  ```
- Changed `config.toml` from `theme = ["docsy"]` to:
  ```toml
  [module]
    [[module.imports]]
      path = "github.com/google/docsy"
  ```
- Ran `hugo mod tidy`, which downloaded Bootstrap/Font Awesome into the Go module cache. This step requires **Go** to be installed (verified go1.24.7) and working network access to the Go module proxy — both were unavailable in the prior session but worked in this one.

### 3. Outdated Docsy checkout → `File is nil; wrap it in if or with`

**Build attempt #3** failed with:
```
ERROR ... File is nil; wrap it in if or with
```
pointing at `Parent.File.UniqueID` inside `themes/docsy/layouts/partials/section-index.html`.

**Root cause**: the submodule was checked out at an old commit based on Docsy tag `v0.4.0`, which has a known upstream bug (see [google/docsy#1874](https://github.com/google/docsy/issues/1874)), fixed upstream in Docsy PRs #1890/#1947.

**Fix applied**: `git checkout v0.15.0` inside the `themes/docsy` submodule. This version was chosen deliberately over the newer `v0.16.0`/`v0.17.0` tags because those bump Docsy's required Hugo `min_version` to `0.160.1`, which does not exist as a Hugo release yet, and also restructure the repo into a `theme/` subfolder with a different Go module path. v0.15.0 still only requires Hugo 0.146.0+ and matches this project's Hugo Modules configuration.

### 4. Leftover custom layout overrides → `no such template "partials/page-description.html"`

**Build attempt #4** failed with:
```
ERROR ... template: docs/list.html:4:7 ... no such template "partials/page-description.html"
```
**Root cause**: two custom layout overrides — `layouts/partials/head.html` and `layouts/docs/list.html` — were leftover workarounds from an even older Docsy checkout, referencing internal template paths that no longer exist in Docsy v0.15.0's native templates (which already correctly handle Google Analytics, Disqus, dark mode, and feedback without an override).

**Fix applied**: deleted both override files.

### 5. Deprecated config keys → build warnings

**Build attempt #5** succeeded but emitted two deprecation warnings:
```
WARN  Config 'params.algolia_docsearch' is deprecated: use 'params.search.algolia'.
WARN  Config parameter '.params.ui.footer_about_disable' is DEPRECATED, use '.params.ui.footer_about_enable' instead.
```
**Fix applied**:
- Removed the unused top-level `algolia_docsearch = false` key (Algolia search isn't in use on this site).
- Replaced `footer_about_disable = false` with `footer_about_enable = true` under `[params.ui]`. Note this is an inverted boolean, not a simple rename — a naive find/replace would have flipped the behavior.

---

## ✅ Final Build Result (as of this session)

**Build attempt #6: clean success.** `hugo --minify` output:
```
Pages: 29 | Paginator pages: 0 | Non-page files: 1 | Static files: 30 | Processed images: 2 | Aliases: 0 | Cleaned: 0
Total in ~1.7-2s
```
Zero `WARN` lines, zero `ERROR` lines.

**Output verification** (`public/`):
- Spot-checked `index.html` — correct site title and content render.
- Bootstrap CSS classes confirmed present in the compiled `scss/main.min.*.css` (~380KB), confirming the Hugo Modules fix actually pulled in and compiled Bootstrap.
- Total `public/` directory size ~2.9MB: 29 HTML pages, `sitemap.xml`, `robots.txt`, print versions under `_print/`, RSS `index.xml`, favicons, webfonts all present.

**Dev server verification**: `hugo server` started on `127.0.0.1:1313` with Fast Render Mode active; `curl` against it returned HTTP 200 and the correct page title `DXers - The HCL DX user's group`.

---

## ⚠️ Important Nuance Found in a Subsequent Session: "Zero Warnings" Was Not Enough

The "Final Build Result" above is a **true, accurate description of the build log** from this session — but a **later** session found that the build log being clean did **not** mean the deployed site actually worked. The root-level `index.html` spot-check above confirmed *a* page rendered with the correct title, but did not catch that the rendered homepage under `/en/` and the site-root homepage the theme actually serves to visitors at `/` were two different, differently-broken outputs.

**What was found**: comparing the live production site (`https://www.dxers.ug/`) against a CloudFlare Pages preview deployment of this branch byte-for-byte showed the preview's homepage at `/` rendering as an empty `<main role=main class=td-main></main>` — no hero block, no background image, no call-to-action buttons — while production had all of that content. `hugo --minify` had reported **zero warnings and zero errors** the whole time; the bug was invisible in the build log.

**Root cause**: `config.toml` had `contentDir = "content/en"` at the top level alongside an explicit `[languages.en]` table. Hugo Extended 0.154.3 silently ignores a top-level `contentDir` once `[languages]` exists (confirmed via `hugo config`, which showed it resolving to Hugo's default `contentdir = 'content'`), causing Hugo to render the site twice: once correctly under `/en/` (working only by coincidence, since `content/en/` matches Hugo's default per-language directory convention) and once as a broken, empty stub at the actual site root `/` — which is what every visitor actually reaches. Full root-cause and fix detail is in `CLAUDE.md` (Configuration section) and `HUGO_UPDATE_2026.md` ("Known Issues Encountered & Fixed", entry 4).

**Fix**: move `contentDir` into `[languages.en]` instead of the top level. This has since been applied.

**Corrected build result, post-fix**:
```
Pages: 27 | Static files: 32 | Processed images: 2 | 0 WARN | 0 ERROR
Total in ~1.6s
```
Page count dropped from 29 to **27** — the two duplicate/phantom pages produced by the double-render (the broken root-level stub pages) are gone. `public/index.html` grew from 19718 bytes (the empty stub) to 22560 bytes and now contains the hero cover block, both resized `featured-background_*.jpg` images, and both call-to-action buttons. No `/en/` output directory exists anymore — `community/`, `docs/`, and `search/` sit directly under `public/`, matching production's URL structure.

**Lesson for future maintainers**: a clean `hugo --minify` log (zero WARN/ERROR) is **necessary but not sufficient** evidence that the site works. It proves the build didn't error out; it does not prove the rendered pages at the URLs visitors actually use contain the right content. Spot-checking one HTML file's title, as this report's original verification did, is not enough either — the broken and working homepages both existed simultaneously in the same build. Whenever feasible, compare the actual deployed output (a preview URL vs. production, or at minimum the site-root output path) rather than relying on the build log or a single spot-check alone.

---

## Architecture Changes Made

This build verification pass changed the project's theming architecture from a plain Git-submodule theme to **Hugo Modules**, because Docsy's CSS/JS dependencies (Bootstrap, Font Awesome) are only distributed that way:

- New project-root `go.mod` declaring the module, requiring Go 1.24.7+, and using a local `replace` directive pointing at the `themes/docsy` submodule.
- `config.toml` theme declaration switched from `theme = ["docsy"]` to a `[[module.imports]]` block.
- `themes/docsy` submodule pinned to tag **v0.15.0** specifically (not the latest tag) — see reasoning in issue #3 above.
- Two obsolete custom layout overrides removed (`layouts/partials/head.html`, `layouts/docs/list.html`).
- Two deprecated `config.toml` params corrected (Algolia key removed, `footer_about_enable` used instead of `footer_about_disable`).
- `.hugo_build.lock` (created by `hugo server`/`hugo` during builds) added to `.gitignore` — this file should never be committed.

Full narrative detail and rationale for the Hugo/Docsy version choices live in `CLAUDE.md` and `HUGO_UPDATE_2026.md`; this report summarizes only what changed and why, not the complete configuration reference.

---

## ✅ Prerequisites Checklist

- [x] **Hugo Extended 0.154.3** installed and verified (`hugo version`)
- [x] **Go 1.24.7** installed and verified — newly discovered as required, for `hugo mod tidy` under the Hugo Modules setup
- [x] **Node.js v22.22.2 / npm 10.9.7** installed and verified
- [x] **Git** installed, submodules initialized (`git submodule update --init --recursive`)
- [x] Docsy theme submodule pinned to v0.15.0
- [x] `go.mod` present and Hugo Modules import configured in `config.toml`
- [x] `npm install` completed successfully
- [x] Clean `hugo --minify` build produced (0 errors, 0 warnings)
- [x] `public/` output spot-checked and verified correct
- [x] `hugo server` dev mode verified working (HTTP 200, correct title)

Go was not previously listed as a project prerequisite; it now is, because `hugo mod tidy` depends on it whenever the Docsy Hugo Module needs to be resolved (e.g. after a fresh clone, or a `go.sum`/module cache miss).

---

## 🚀 Next Steps

This section is now about **ongoing maintenance**, not getting a first build working.

1. **Before bumping Docsy past v0.15.0**: re-verify carefully. v0.16.0/v0.17.0 raise Docsy's Hugo `min_version` requirement to `0.160.1` (which doesn't exist as a Hugo release yet) and restructure the theme repo into a `theme/` subfolder with a different Go module path — both changes require corresponding updates to `go.mod` and `config.toml`, not just a submodule bump.
2. **Before hardcoding a Hugo version in docs**: check GitHub releases directly (`https://github.com/gohugoio/hugo/releases`) rather than trusting a previously-documented "latest" number — this report itself found the previously-documented "0.154.1" doesn't exist; the real latest at time of writing is 0.154.3.
3. **Keep `go.sum`/module cache in sync**: after any Docsy version change, re-run `hugo mod tidy` and commit the resulting lock state so CI/CD (CloudFlare Pages) resolves the same module versions.
4. **Periodically re-run `npm audit`**: the 13 vulnerabilities (5 moderate, 8 high) are in legacy dev dependencies (`autoprefixer@9.8.6`, `postcss-cli@7.1.2`) and don't block builds, but should be revisited if those packages are ever upgraded.
5. **CI/CD verification**: confirm CloudFlare Pages' build environment also has Go available (in addition to Hugo Extended and Node.js), since the Hugo Modules setup introduced in this session now requires it at build time, not just for local development.

---

## 📚 References

- [Hugo Update Notes](HUGO_UPDATE_2026.md)
- [Project Documentation](DOCS.md)
- [Claude Documentation](CLAUDE.md)
- [Hugo Official Docs](https://gohugo.io/installation/)
- [Hugo Releases](https://github.com/gohugoio/hugo/releases)
- [Docsy Theme Docs](https://www.docsy.dev/docs/)
- [Docsy issue #1874 (File is nil bug, fixed in v0.15.0)](https://github.com/google/docsy/issues/1874)

---

**Report Generated**: 2026-01-08
**Amended**: 2026-09-02 — contentDir/`[languages]` bug found via live-URL comparison and fixed; page count corrected 29 → 27
**Environment**: Linux
**Hugo Status**: Installed and verified (v0.154.3+extended)
**Build Status**: ✅ Clean build verified (`hugo --minify`, 0 errors, 0 warnings) — ✅ Deployed output verified correct after `contentDir` fix (27 pages)
