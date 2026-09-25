#!/usr/bin/env bash
# =============================================================================
# add-loading.sh — Ajoute un écran de chargement global au site Pullman
# -----------------------------------------------------------------------------
# Crée :
#   - css/loading-overlay.css
#   - js/loading-overlay.js
# Puis injecte les 2 balises <link> et <script> dans chaque *.html
#
# Usage :
#   bash add-loading.sh              # installation complète
#   bash add-loading.sh --dry-run    # simulation
#   bash add-loading.sh --rollback   # restaure les HTML
#   bash add-loading.sh --force      # réécrit CSS/JS
# =============================================================================

# --- Localisation projet ---
_SRC="${BASH_SOURCE[0]:-$0}"
_SCRIPT_DIR="$(cd "$(dirname "$_SRC")" 2>/dev/null && pwd)"
[ -n "$_SCRIPT_DIR" ] && cd "$_SCRIPT_DIR" 2>/dev/null

# --- Couleurs ---
if [ -t 1 ]; then
    _R=$'\033[0m'; _B=$'\033[1m'; _RD=$'\033[31m'; _GR=$'\033[32m'
    _YL=$'\033[33m'; _BL=$'\033[34m'; _CY=$'\033[36m'; _DM=$'\033[2m'
else
    _R=""; _B=""; _RD=""; _GR=""; _YL=""; _BL=""; _CY=""; _DM=""
fi

ok()   { printf '%s✓%s %s\n' "${_GR}${_B}" "$_R" "$*"; }
err()  { printf '%s✗%s %s\n' "${_RD}${_B}" "$_R" "$*"; }
warn() { printf '%s⚠%s %s\n' "${_YL}${_B}" "$_R" "$*"; }
info() { printf '%s→%s %s\n' "${_BL}${_B}" "$_R" "$*"; }
head() { printf '\n%s%s▶ %s%s\n' "${_B}" "${_CY}" "$*" "$_R"; }

# --- Config ---
CSS_FILE="css/loading-overlay.css"
JS_FILE="js/loading-overlay.js"
BACKUP_DIR=".loading-backup"
SKIP_FILES="gabarit.html loading.html"
CSS_MARK="loading-overlay.css"
JS_MARK="loading-overlay.js"

DRY=0; FORCE=0; ROLLBACK=0

# --- Arguments ---
while [ $# -gt 0 ]; do
    case "$1" in
        --dry-run)  DRY=1 ;;
        --force)    FORCE=1 ;;
        --rollback) ROLLBACK=1 ;;
        --help|-h)
            echo "add-loading.sh — Installation du loader global Pullman"
            echo ""
            echo "  --dry-run     Simulation"
            echo "  --force       Régénère CSS et JS"
            echo "  --rollback    Restaure les HTML depuis $BACKUP_DIR/"
            exit 0
            ;;
    esac
    shift
done

# --- Vérifications ---
head "Vérification de l'environnement"

if [ ! -f "index.html" ]; then
    err "index.html introuvable — lance depuis la racine du projet"
    exit 1
fi

mkdir -p css js
ok "Dossiers css/ et js/ prêts"

# --- Rollback ---
if [ "$ROLLBACK" -eq 1 ]; then
    head "Restauration"
    if [ ! -d "$BACKUP_DIR" ]; then
        err "Aucun backup dans $BACKUP_DIR/"
        exit 1
    fi
    n=0
    for f in "$BACKUP_DIR"/*.html; do
        [ -f "$f" ] || continue
        cp -p "$f" "./$(basename "$f")" && n=$((n+1))
    done
    ok "$n fichier(s) restauré(s)"
    exit 0
fi

# =============================================================================
# 1. ÉCRITURE DU CSS
# =============================================================================
head "Fichier CSS"

if [ -f "$CSS_FILE" ] && [ "$FORCE" -eq 0 ]; then
    _sz=$(wc -c < "$CSS_FILE" | tr -d ' ')
    if [ "$_sz" -gt 500 ]; then
        ok "CSS déjà présent : $CSS_FILE ($_sz octets)"
    else
        rm -f "$CSS_FILE"
    fi
fi

if [ ! -f "$CSS_FILE" ] || [ "$FORCE" -eq 1 ]; then
    if [ "$DRY" -eq 1 ]; then
        info "[dry-run] créerait $CSS_FILE"
    else
        info "Écriture $CSS_FILE..."
        cat > "$CSS_FILE" << 'CSS_EOF'
/* LOADING-OVERLAY.CSS — Écran de chargement global Pullman */
#rp-loader{position:fixed;inset:0;
  background:radial-gradient(120% 90% at 50% 22%,rgba(71,178,125,.12),transparent 60%),#04080D;
  color:#F3F6F4;display:flex;align-items:center;justify-content:center;z-index:99999;
  opacity:0;visibility:hidden;transition:opacity .35s ease,visibility .35s ease;
  font-family:'Montserrat',sans-serif;overflow:hidden;pointer-events:none}
#rp-loader.rp-is-active{opacity:1;visibility:visible;pointer-events:auto}
#rp-loader .rp-loader-inner{display:flex;flex-direction:column;align-items:center;
  justify-content:center;gap:1.4rem;width:100%;max-width:640px;padding:2rem 6vw;
  transform:translateY(8px);opacity:0;
  transition:transform .6s cubic-bezier(.25,1,.5,1),opacity .5s ease}
#rp-loader.rp-is-active .rp-loader-inner{transform:translateY(0);opacity:1;transition-delay:.1s}
.rp-orb-wrap{width:200px;height:200px;flex:none}
.rp-orb-wrap svg{overflow:visible;display:block}
.rp-ring-dotted{animation:rpSpin 42s linear infinite;transform-origin:110px 110px}
.rp-ring-arc-a{animation:rpSpin 6s linear infinite;transform-origin:110px 110px}
.rp-ring-arc-b{animation:rpSpinRev 8s linear infinite;transform-origin:110px 110px}
@keyframes rpSpin{to{transform:rotate(360deg)}}
@keyframes rpSpinRev{to{transform:rotate(-360deg)}}
.rp-mark-pulse{animation:rpPulseScale 2.8s ease-in-out infinite;transform-origin:836.19px 323.56px}
.rp-mark-pulse path{fill:#47B27D}
@keyframes rpPulseScale{0%,100%{transform:scale(1)}50%{transform:scale(1.035)}}
.rp-wordmark path{fill:#F3F6F4}
.rp-loader-label{font-size:.72rem;letter-spacing:.34em;color:#8AD4AD;text-align:center;
  font-weight:500;text-transform:uppercase}
.rp-loader-bar-row{display:flex;align-items:center;gap:.9rem;width:100%;max-width:280px}
.rp-loader-bar{flex:1;height:1px;background:rgba(243,246,244,.14);position:relative}
.rp-loader-bar-fill{position:absolute;left:0;top:-1px;height:3px;width:0%;background:#47B27D;
  box-shadow:0 0 12px rgba(71,178,125,.75);transition:width .15s linear}
.rp-loader-pct{font-size:.7rem;letter-spacing:.06em;color:#9AA3A0;min-width:2.6em;
  font-weight:500;text-align:right}
.rp-loader-word{text-align:center;line-height:1.4;margin-top:.3rem;
  font-size:clamp(1.1rem,4.2vw,1.75rem)}
.rp-loader-word .bold{color:#9AA3A0;font-weight:700}
.rp-loader-word .reg{color:#47B27D;font-weight:400}
@media (max-width:480px){
  .rp-orb-wrap{width:160px;height:160px}
  .rp-orb-wrap svg{width:160px;height:160px}
  .rp-loader-label{font-size:.65rem;letter-spacing:.28em}
  #rp-loader .rp-loader-inner{gap:1.1rem}
}
@media (prefers-reduced-motion:reduce){
  #rp-loader *{animation:none !important}
  .rp-loader-bar-fill{width:100% !important}
}
body.rp-loading-locked{overflow:hidden !important}
CSS_EOF
        _sz=$(wc -c < "$CSS_FILE" | tr -d ' ')
        ok "Écrit : $CSS_FILE ($_sz octets)"
    fi
fi

# =============================================================================
# 2. ÉCRITURE DU JS
# =============================================================================
head "Fichier JS"

if [ -f "$JS_FILE" ] && [ "$FORCE" -eq 0 ]; then
    _sz=$(wc -c < "$JS_FILE" | tr -d ' ')
    if [ "$_sz" -gt 500 ]; then
        ok "JS déjà présent : $JS_FILE ($_sz octets)"
    else
        rm -f "$JS_FILE"
    fi
fi

if [ ! -f "$JS_FILE" ] || [ "$FORCE" -eq 1 ]; then
    if [ "$DRY" -eq 1 ]; then
        info "[dry-run] créerait $JS_FILE"
    else
        info "Écriture $JS_FILE..."
        cat > "$JS_FILE" << 'JS_EOF'
/* LOADING-OVERLAY.JS — Écran de chargement global Pullman */
(function () {
    'use strict';

    /* === Configuration === */
    var DURATION = 3400;  // Durée du loader (ms) — 3.4 secondes
    var EXCLUDE_PROTOCOLS = /^(mailto:|tel:|sms:|javascript:|#)/i;
    var EXCLUDE_TARGETS = ['_blank', '_parent', '_top'];

    /* === SVG inline === */
    var LOADER_HTML =
      '<div class="rp-loader-inner">' +
        '<div class="rp-orb-wrap">' +
          '<svg viewBox="0 0 220 220" width="200" height="200">' +
            '<circle class="rp-ring-dotted" cx="110" cy="110" r="96" fill="none" stroke="rgba(138,212,173,0.4)" stroke-width="1.4" stroke-dasharray="1 7" stroke-linecap="round"/>' +
            '<g class="rp-ring-arc-a">' +
              '<path d="M110 22 A88 88 0 0 1 194 92" fill="none" stroke="#47B27D" stroke-width="2" stroke-linecap="round" style="filter:drop-shadow(0 0 5px rgba(71,178,125,0.85))"/>' +
              '<circle cx="194" cy="92" r="4" fill="#47B27D" style="filter:drop-shadow(0 0 6px rgba(71,178,125,0.9))"/>' +
            '</g>' +
            '<g class="rp-ring-arc-b">' +
              '<path d="M110 198 A88 88 0 0 1 26 128" fill="none" stroke="#8AD4AD" stroke-width="2" stroke-linecap="round" style="filter:drop-shadow(0 0 5px rgba(138,212,173,0.85))"/>' +
              '<circle cx="26" cy="128" r="3.5" fill="#8AD4AD" style="filter:drop-shadow(0 0 6px rgba(138,212,173,0.9))"/>' +
            '</g>' +
            '<svg x="40" y="40" width="140" height="140" viewBox="746.58 233.91 179.22 179.30">' +
              '<g class="rp-mark-pulse">' +
                '<path d="M858.74,348.44l-8-7.93-60.75,60.14-9.55-6.57,62.31-61.72-8.13-7.86-62.62,62-7.5-8.67,62.27-61.63-8.15-7.87-60.38,59.81c-.57-1-1.12-1.9-1.58-2.83-1.1-2.23-2.12-4.5-3.24-6.72a1.64,1.64,0,0,1,.43-2.2q16.58-16.35,33.1-32.76l23.15-22.91c.21-.21.39-.46.67-.79l-8.13-7.78-53.67,53.16c-.34-1.42-.68-2.59-.88-3.78-.47-2.8-.86-5.62-1.32-8.43a2.65,2.65,0,0,1,.88-2.58q19.14-18.89,38.22-37.85c2.92-2.91,5.68-6,8.5-9l-7.77-7.59L746.9,315.39l-.32-.15c.31-2.27.51-4.55,1-6.79.71-3.53,1.59-7,2.38-10.53a7.53,7.53,0,0,1,2.25-3.82q13-12.78,25.89-25.63a5.78,5.78,0,0,1,.91-.57L771.58,261A90,90,0,0,1,808.35,238l-29.16,29.91L787,275.6c.46-.44,1.07-1,1.65-1.58q19.82-19.65,39.62-39.27a2.61,2.61,0,0,1,1.57-.81c5-.07,9.94,0,14.91,0l.2.41L794.86,283.9l8.49,7.94c2.44-2.55,5.06-5.39,7.8-8.11q15.78-15.74,31.63-31.41c5-5,10.06-9.95,15.06-14.94a1.77,1.77,0,0,1,2.1-.56c2.94,1,5.91,2,8.86,2.93.61.21,1.19.5,2,.86L810.93,300l8.36,8c2.41-2.5,5-5.26,7.64-7.92q24.54-24.35,49.1-48.66c1.61-1.6,3.2-3.22,4.85-4.78.28-.26,1-.49,1.2-.34,3,1.92,6,3.91,9.22,6l-64.41,63.83L835,324l64.75-64.12,7.58,8.55-64.44,63.85,8.05,7.92,62.69-62.11a12.29,12.29,0,0,1,.75,1.15c1.41,2.78,2.77,5.57,4.21,8.33a1.51,1.51,0,0,1-.38,2.07q-10.12,10-20.2,20l-29.86,29.59L860,347.23c-.35.34-.67.7-1.08,1.13,2.71,2.62,5.37,5.2,8.13,7.85l56.07-55.56c.28,1.15.53,2,.69,2.91.57,3.19,1.17,6.38,1.63,9.58a2.45,2.45,0,0,1-.61,1.85q-18.44,18.38-36.93,36.67-5.77,5.73-11.6,11.43a14.73,14.73,0,0,1-1.56,1.17l8.37,8,42.35-41.94.34.15c-.28,2.4-.41,4.82-.87,7.19-.68,3.57-1.53,7.11-2.43,10.64a5.48,5.48,0,0,1-1.4,2.33q-14.45,14.43-29,28.78c-.38.37-.81.68-1.38,1.16L898.7,388A86,86,0,0,1,862,409.19l28.76-28.46-8.1-7.6.19-.43c-.44.41-.9.81-1.32,1.24q-19.15,19-38.27,38a3.9,3.9,0,0,1-3,1.27c-4.57-.1-9.14-.1-13.71-.14l-.19-.49,48.46-48-8.51-7.93a16.86,16.86,0,0,1-1.58,2q-22.5,22.31-45,44.58c-2.12,2.1-4.22,4.22-6.36,6.29-.28.27-.81.59-1.1.5-3.8-1.19-7.57-2.45-11.72-3.81Z"/>' +
              '</g>' +
            '</svg>' +
          '</svg>' +
        '</div>' +
        '<svg class="rp-wordmark" viewBox="670.34 536.84 331.73 53.31" width="212" height="34" xmlns="http://www.w3.org/2000/svg">' +
          '<path d="M674.77,569.72V590.1H670.5c0-.49-.1-1-.1-1.55,0-8.92-.07-17.84-.06-26.76,0-6.24,3.23-10.8,9.16-12.74a26.81,26.81,0,0,1,17.16,0c7,2.34,10.51,8.53,8.61,15.1-1.46,5-5.35,7.58-10.1,8.91C688.13,575.06,682.38,574.08,674.77,569.72Zm13.77,1.19a59.67,59.67,0,0,0,6.28-1.46,8.94,8.94,0,0,0,.48-17,18.74,18.74,0,0,0-13.78-.25,11.13,11.13,0,0,0-3.46,2.12c-5,4.48-4.32,10.72,1.56,13.91A22.46,22.46,0,0,0,688.54,570.91Z"/>' +
          '<path d="M865.25,552.07c4.57-4.47,10-5.05,15.79-3.73,4.64,1.06,7.57,4,7.82,8.47.3,5.41.07,10.86.07,16.41h-4.18c0-5.09,0-10,0-15,0-3.56-1.5-5.88-5-6.59a18.15,18.15,0,0,0-7.12,0c-3.78.78-5.43,3.25-5.44,7.11,0,4.77,0,9.53,0,14.47h-4.08V558.56c0-4-1.53-6.28-5.43-7a18.71,18.71,0,0,0-7.3.22c-3.09.7-4.47,2.92-4.5,6.22,0,4.33,0,8.67,0,13v2.2h-4.26c0-5.71-.29-11.35.09-17,.32-4.55,4.51-7.69,9.81-8.32S861.39,548.12,865.25,552.07Z"/>' +
          '<path d="M948.18,573.25h-4v-4l-2.06,1.28c-7.1,4.54-17.35,4.58-23.73.09a11.74,11.74,0,0,1,.41-19.92c6.55-4.2,18-3.94,24.37.6a11,11,0,0,1,5,8.72C948.31,564.36,948.18,568.69,948.18,573.25Zm-17.69-2.59a19.08,19.08,0,0,0,10.9-3.82A5.93,5.93,0,0,0,944.1,562a10.08,10.08,0,0,0-4.39-8.57c-4.9-3.42-14.09-3.11-18.76.62a8.77,8.77,0,0,0,.14,13.84C923.76,569.94,926.88,570.54,930.49,570.66Z"/>' +
          '<path d="M1001.87,590.15h-4.13V560c0-5-2.12-7.91-7.06-8.59a22.38,22.38,0,0,0-8.38.6c-3.35.87-4.74,3.19-4.79,6.66,0,4.09,0,8.17,0,12.26v2.13h-4.31v-2.88c0-3.65,0-7.3,0-11,0-4.88,2.35-8.38,7.1-10.2a19.94,19.94,0,0,1,14.52-.08c4.57,1.71,7.16,5.1,7.21,10,.09,10.15,0,20.31,0,30.46A3.93,3.93,0,0,1,1001.87,590.15Z"/>' +
          '<path d="M729.86,548.43h4.19c0,.72.11,1.38.11,2.05,0,3.9,0,7.8,0,11.71,0,4.53,2.1,7.23,6.57,8.1a19.16,19.16,0,0,0,6.09.2c4.93-.67,7.34-3.58,7.41-8.62.06-3.78,0-7.55,0-11.33,0-.67.06-1.34.09-2.09h4.22v4.3c0,3.29.06,6.57,0,9.85-.15,6-3.55,10.07-9.44,10.84a39.06,39.06,0,0,1-10,0c-5.38-.68-8.82-4.2-9.21-9.61C729.58,558.78,729.86,553.7,729.86,548.43Z"/>' +
          '<path d="M783.51,536.86h4.11v36.37h-4.11Z"/>' +
          '<path d="M812.55,536.84h4.07v36.37h-4.07Z"/>' +
        '</svg>' +
        '<div class="rp-loader-label">TERANGA NDAKARU</div>' +
        '<div class="rp-loader-bar-row">' +
          '<div class="rp-loader-bar"><div class="rp-loader-bar-fill" id="rpBarFill"></div></div>' +
          '<div class="rp-loader-pct" id="rpPctLabel">0%</div>' +
        '</div>' +
        '<div class="rp-loader-word"><span class="bold">Yeksil Ak Jàam</span> <span class="reg">« You are welcome »</span></div>' +
      '</div>';

    /* === État === */
    var loader = null;
    var barFill = null;
    var pctLabel = null;
    var startTime = 0;

    /* === Créer le loader === */
    function ensureLoader() {
        if (loader) return;
        loader = document.createElement('div');
        loader.id = 'rp-loader';
        loader.setAttribute('aria-hidden', 'true');
        loader.setAttribute('role', 'status');
        loader.setAttribute('aria-live', 'polite');
        loader.innerHTML = LOADER_HTML;
        document.body.appendChild(loader);
        barFill = document.getElementById('rpBarFill');
        pctLabel = document.getElementById('rpPctLabel');
    }

    /* === Animer la barre === */
    function startProgress() {
        if (!barFill || !pctLabel) return;
        barFill.style.width = '0%';
        pctLabel.textContent = '0%';
        startTime = performance.now();
        function tick(now) {
            var elapsed = now - startTime;
            var t = Math.min(1, elapsed / DURATION);
            var eased = 1 - Math.pow(1 - t, 1.8);
            var p = Math.floor(eased * 100);
            barFill.style.width = p + '%';
            pctLabel.textContent = p + '%';
            if (t < 1) requestAnimationFrame(tick);
        }
        requestAnimationFrame(tick);
    }

    /* === Afficher / Cacher === */
    function showLoader() {
        ensureLoader();
        loader.classList.add('rp-is-active');
        loader.setAttribute('aria-hidden', 'false');
        document.body.classList.add('rp-loading-locked');
        startProgress();
    }
    function hideLoader() {
        if (!loader) return;
        loader.classList.remove('rp-is-active');
        loader.setAttribute('aria-hidden', 'true');
        document.body.classList.remove('rp-loading-locked');
    }

    /* === Navigation différée === */
    function navigateTo(url) {
        var elapsed = performance.now() - startTime;
        var wait = Math.max(DURATION - elapsed, 0);
        setTimeout(function () {
            if (barFill) barFill.style.width = '100%';
            if (pctLabel) pctLabel.textContent = '100%';
            setTimeout(function () {
                window.location.href = url;
            }, 200);
        }, wait);
    }

    /* === Filtrage des liens === */
    function isInternalLink(anchor) {
        if (!anchor) return false;
        var href = anchor.getAttribute('href');
        if (!href) return false;
        if (EXCLUDE_PROTOCOLS.test(href)) return false;
        var target = anchor.getAttribute('target');
        if (target && EXCLUDE_TARGETS.indexOf(target) !== -1) return false;
        if (anchor.hasAttribute('download')) return false;
        if (href.indexOf('#') === 0) return false;
        try {
            var url = new URL(href, window.location.href);
            if (url.origin !== window.location.origin) return false;
            if (/\.(pdf|jpg|jpeg|png|gif|webp|svg|zip|mp4|mp3|doc|docx|xls|xlsx)$/i.test(url.pathname)) return false;
            if (url.pathname === window.location.pathname && url.search === window.location.search) return false;
        } catch (e) { return false; }
        return true;
    }

    function onLinkClick(e) {
        if (e.metaKey || e.ctrlKey || e.shiftKey || e.altKey) return;
        if (e.button !== undefined && e.button !== 0) return;
        var anchor = e.target.closest('a');
        if (!anchor) return;
        if (!isInternalLink(anchor)) return;
        e.preventDefault();
        var href = anchor.getAttribute('href');
        showLoader();
        navigateTo(href);
    }

    /* === Retour navigateur (bfcache) === */
    window.addEventListener('pageshow', function (event) {
        if (event.persisted) hideLoader();
    });

    /* === Init === */
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', function () {
            document.addEventListener('click', onLinkClick, false);
        });
    } else {
        document.addEventListener('click', onLinkClick, false);
    }
})();
JS_EOF
        _sz=$(wc -c < "$JS_FILE" | tr -d ' ')
        ok "Écrit : $JS_FILE ($_sz octets)"
    fi
fi

# =============================================================================
# 3. INJECTION DANS LES HTML
# =============================================================================
head "Injection dans les fichiers HTML"

mkdir -p "$BACKUP_DIR"

CSS_LINE='    <link rel="stylesheet" href="css/loading-overlay.css">'
JS_LINE='<script src="js/loading-overlay.js" defer></script>'

added=0; skipped=0; failed=0

for f in *.html; do
    [ -f "$f" ] || continue

    skip=0
    for s in $SKIP_FILES; do
        [ "$f" = "$s" ] && skip=1 && break
    done
    [ "$skip" -eq 1 ] && { printf '  %s•%s %s %s(skip)%s\n' "$_YL" "$_R" "$f" "$_DM" "$_R"; continue; }

    has_css=0; has_js=0
    grep -q "$CSS_MARK" "$f" 2>/dev/null && has_css=1
    grep -q "$JS_MARK" "$f" 2>/dev/null && has_js=1

    if [ "$has_css" -eq 1 ] && [ "$has_js" -eq 1 ]; then
        printf '  %s•%s %s %s(déjà intégré)%s\n' "$_YL" "$_R" "$f" "$_DM" "$_R"
        skipped=$((skipped+1))
        continue
    fi

    if [ "$DRY" -eq 1 ]; then
        printf '  %s→%s %s %s[dry-run]%s\n' "$_BL" "$_R" "$f" "$_DM" "$_R"
        added=$((added+1))
        continue
    fi

    # Backup
    [ -f "$BACKUP_DIR/$f" ] || cp -p "$f" "$BACKUP_DIR/$f"

    # Injection CSS avant </head>
    if [ "$has_css" -eq 0 ]; then
        if grep -qi '</head>' "$f"; then
            awk -v line="$CSS_LINE" 'BEGIN{d=0} /<\/head>/ && !d {print line; d=1} {print}' "$f" > "$f.tmp" && mv "$f.tmp" "$f"
        fi
    fi

    # Injection JS avant </body>
    if [ "$has_js" -eq 0 ]; then
        if grep -qi '</body>' "$f"; then
            awk -v line="$JS_LINE" 'BEGIN{d=0} /<\/body>/ && !d {print line; d=1} {print}' "$f" > "$f.tmp" && mv "$f.tmp" "$f"
        fi
    fi

    status=""
    [ "$has_css" -eq 0 ] && status="$status ${_GR}css+${_R}"
    [ "$has_js" -eq 0 ]  && status="$status ${_GR}js+${_R}"

    printf '  %s✓%s %s%s\n' "$_GR" "$_R" "$f" "$status"
    added=$((added+1))
done

# =============================================================================
# 4. RAPPORT
# =============================================================================
head "Rapport"
echo "  Pages modifiées   : $added"
echo "  Déjà à jour       : $skipped"
[ "$failed" -gt 0 ] && echo "  Échecs            : $failed"
echo "  Backup            : $BACKUP_DIR/"
echo ""

if [ "$DRY" -eq 1 ]; then
    warn "Mode DRY-RUN — aucune modification réelle"
else
    ok "Installation terminée !"
    echo ""
    echo "  ${_B}Étapes suivantes :${_R}"
    echo "    1. Ouvre index.html dans le navigateur"
    echo "    2. Fais Ctrl + Shift + R (hard refresh)"
    echo "    3. Clique sur un lien (CHAMBRES, GALERIE…)"
    echo "    4. Le loader doit apparaître 3.4 s avant la navigation"
    echo ""
    echo "  ${_B}Pour ajuster la durée :${_R}"
    echo "    Édite js/loading-overlay.js → var DURATION = 3400;"
    echo ""
    echo "  ${_B}Pour annuler :${_R}"
    echo "    bash add-loading.sh --rollback"
fi
