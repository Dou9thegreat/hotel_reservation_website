#!/bin/bash
set -e

echo "============================================================"
echo "  Amélioration footer global"
echo "  - Logo symbole décoratif (bas droite)"
echo "  - Sélecteur langue fonctionnel"
echo "  - Sélecteur devise fonctionnel (XOF/EUR/USD)"
echo "  - Application à toutes les pages"
echo "============================================================"

# ---------- 1) Sauvegarde ----------
BACKUP=".backup_ftg_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP"
cp *.html "$BACKUP/" 2>/dev/null || true
cp css/*.css "$BACKUP/" 2>/dev/null || true
cp js/*.js "$BACKUP/" 2>/dev/null || true
echo "📦 Sauvegarde → $BACKUP"

# ============================================================
# 2) CSS — Logo décoratif + dropdowns
# ============================================================
cat >> css/footer-cta.css << 'CSS_EOF'

/* ============================================================= */
/* LOGO SYMBOLE DÉCORATIF EN BAS À DROITE DU FOOTER             */
/* ============================================================= */
.main-footer {
    position: relative;
    overflow: hidden;
}
.main-footer::after {
    content: "";
    position: absolute;
    bottom: -70px;
    right: -80px;
    width: 320px;
    height: 320px;
    background-image: url('../images/logo-symbole.png');
    background-size: contain;
    background-repeat: no-repeat;
    background-position: center;
    opacity: 0.08;
    pointer-events: none;
    z-index: 0;
}
.main-footer .container {
    position: relative;
    z-index: 1;
}

/* ============================================================= */
/* SÉLECTEUR DE LANGUE (TOPBAR)                                  */
/* ============================================================= */
.lang-switch {
    position: relative;
    user-select: none;
}
.lang-current {
    display: inline-flex;
    align-items: center;
    gap: 4px;
    cursor: pointer;
    color: #C59A67;
    font-weight: 600;
}
.lang-menu {
    display: none;
    position: absolute;
    top: calc(100% + 8px);
    right: 0;
    background: #ffffff;
    border: 1px solid #E9ECEF;
    border-radius: 6px;
    min-width: 140px;
    padding: 6px 0;
    list-style: none;
    margin: 0;
    box-shadow: 0 8px 20px rgba(0,0,0,.12);
    z-index: 2000;
}
.lang-switch.open .lang-menu { display: block; }
.lang-menu li { margin: 0; }
.lang-menu a {
    display: block;
    padding: 8px 14px;
    color: #404040;
    text-decoration: none;
    font-size: 12px;
    font-weight: 500;
    transition: background .15s, color .15s;
}
.lang-menu a:hover {
    background: #f7f7f7;
    color: #C59A67;
}
.lang-menu a.active {
    color: #C59A67;
    font-weight: 700;
}

/* ============================================================= */
/* SÉLECTEUR DE DEVISE (FOOTER)                                  */
/* ============================================================= */
.main-footer .footer-bottom {
    display: flex !important;
    justify-content: space-between !important;
    align-items: center !important;
    flex-wrap: wrap;
    gap: 12px;
    text-align: left !important;
    padding-top: 22px !important;
}
.main-footer .footer-bottom p { margin: 0; }
.main-footer .footer-bottom-right {
    display: flex;
    align-items: center;
    gap: 14px;
}
.main-footer .currency-switch { position: relative; }
.main-footer .currency-current {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    font-size: 11px;
    color: #A0AEC0;
    font-weight: 600;
    letter-spacing: .3px;
    cursor: pointer;
    background: none;
    border: none;
    font-family: inherit;
    padding: 6px 10px;
    border-radius: 4px;
    transition: background .2s, color .2s;
}
.main-footer .currency-current:hover {
    background: rgba(255,255,255,.06);
    color: #ffffff;
}
.main-footer .currency-current i { font-size: 10px; }
.main-footer .currency-menu {
    display: none;
    position: absolute;
    bottom: calc(100% + 6px);
    right: 0;
    background: #1a1a1a;
    border: 1px solid rgba(255,255,255,.1);
    border-radius: 6px;
    min-width: 190px;
    padding: 6px 0;
    list-style: none;
    margin: 0;
    box-shadow: 0 8px 20px rgba(0,0,0,.4);
    z-index: 2000;
}
.main-footer .currency-switch.open .currency-menu { display: block; }
.main-footer .currency-menu li { margin: 0; }
.main-footer .currency-menu a {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 10px;
    padding: 9px 14px;
    color: #A0AEC0;
    text-decoration: none;
    font-size: 12px;
    transition: background .15s, color .15s;
}
.main-footer .currency-menu a:hover {
    background: rgba(255,255,255,.06);
    color: #ffffff;
}
.main-footer .currency-menu a.active {
    color: #38E28F;
    font-weight: 700;
}
.main-footer .currency-menu a .code {
    font-weight: 700;
    font-size: 11px;
    color: #ffffff;
    background: rgba(255,255,255,.08);
    padding: 2px 8px;
    border-radius: 4px;
}

@media (max-width: 700px) {
    .main-footer .footer-bottom {
        flex-direction: column;
        align-items: flex-start !important;
    }
    .main-footer::after {
        width: 200px;
        height: 200px;
        bottom: -50px;
        right: -50px;
    }
}
CSS_EOF
echo "🎨 CSS ajouté à css/footer-cta.css"

# ============================================================
# 3) JS — Logique des sélecteurs (langue + devise)
# ============================================================
cat >> js/booking-bridge.js << 'JS_EOF'

/* ============================================================= */
/* SÉLECTEURS LANGUE + DEVISE                                    */
/* ============================================================= */
(function(){
  'use strict';

  /* ---------- LANGUE ---------- */
  var langSwitch  = document.querySelector('.lang-switch');
  var langCurrent = document.querySelector('.lang-current');
  var savedLang   = localStorage.getItem('pullman_lang') || 'fr';
  var langNames   = { fr: 'Français', en: 'English', es: 'Español' };

  if (langCurrent && langNames[savedLang]) {
    langCurrent.textContent = langNames[savedLang];
  }
  document.querySelectorAll('.lang-menu a').forEach(function(a){
    a.classList.toggle('active', a.dataset.lang === savedLang);
  });

  if (langSwitch && langCurrent) {
    langCurrent.addEventListener('click', function(e){
      e.stopPropagation();
      document.querySelectorAll('.currency-switch').forEach(function(cs){ cs.classList.remove('open'); });
      langSwitch.classList.toggle('open');
    });
    document.querySelectorAll('.lang-menu a').forEach(function(a){
      a.addEventListener('click', function(e){
        e.preventDefault();
        var lang = a.dataset.lang;
        localStorage.setItem('pullman_lang', lang);
        document.querySelectorAll('.lang-menu a').forEach(function(x){ x.classList.remove('active'); });
        a.classList.add('active');
        langCurrent.textContent = langNames[lang] || 'Français';
        langSwitch.classList.remove('open');
        window.dispatchEvent(new CustomEvent('language-changed', { detail: { lang: lang } }));
      });
    });
  }

  /* ---------- DEVISE ---------- */
  var currencySwitch  = document.querySelector('.currency-switch');
  var currencyCurrent = document.querySelector('.currency-current');
  var savedCur        = localStorage.getItem('pullman_currency') || 'XOF';
  var curLabels       = { XOF: 'FR · XOF', EUR: 'FR · EUR', USD: 'FR · USD' };

  function updateCurrencyUI(cur){
    if (currencyCurrent) {
      currencyCurrent.innerHTML = '<i class="fas fa-globe"></i> ' + (curLabels[cur] || 'FR · XOF') +
                                  ' <i class="fas fa-chevron-down"></i>';
    }
    document.querySelectorAll('.currency-menu a').forEach(function(x){
      x.classList.toggle('active', x.dataset.currency === cur);
    });
  }
  updateCurrencyUI(savedCur);

  if (currencySwitch && currencyCurrent) {
    currencyCurrent.addEventListener('click', function(e){
      e.stopPropagation();
      if (langSwitch) langSwitch.classList.remove('open');
      currencySwitch.classList.toggle('open');
    });
    document.querySelectorAll('.currency-menu a').forEach(function(a){
      a.addEventListener('click', function(e){
        e.preventDefault();
        var cur = a.dataset.currency;
        localStorage.setItem('pullman_currency', cur);
        updateCurrencyUI(cur);
        currencySwitch.classList.remove('open');
        window.dispatchEvent(new CustomEvent('currency-changed', { detail: { currency: cur } }));
      });
    });
  }

  /* ---------- Fermeture au clic extérieur ---------- */
  document.addEventListener('click', function(){
    if (langSwitch) langSwitch.classList.remove('open');
    document.querySelectorAll('.currency-switch').forEach(function(cs){ cs.classList.remove('open'); });
  });
  document.addEventListener('keydown', function(e){
    if (e.key === 'Escape') {
      if (langSwitch) langSwitch.classList.remove('open');
      document.querySelectorAll('.currency-switch').forEach(function(cs){ cs.classList.remove('open'); });
    }
  });
})();
JS_EOF
echo "🧠 JS ajouté à js/booking-bridge.js"

# ============================================================
# 4) Mise à jour du footer dans reservation.html
#    → remplacer le span statique .footer-currency par un vrai dropdown
# ============================================================
perl -0777 -i -pe 's|<div class="footer-bottom-right">.*?</div>|<div class="footer-bottom-right">\n                <div class="currency-switch">\n                    <button class="currency-current" type="button">\n                        <i class="fas fa-globe"></i> FR · XOF <i class="fas fa-chevron-down"></i>\n                    </button>\n                    <ul class="currency-menu">\n                        <li><a href="#" data-currency="XOF" class="active"><span>Franc CFA</span><span class="code">XOF</span></a></li>\n                        <li><a href="#" data-currency="EUR"><span>Euro</span><span class="code">EUR</span></a></li>\n                        <li><a href="#" data-currency="USD"><span>Dollar US</span><span class="code">USD</span></a></li>\n                    </ul>\n                </div>\n            </div>|s' reservation.html
echo "✅ reservation.html — sélecteur devise ajouté"

# ============================================================
# 5) Mise à jour du topbar (lang-switch) sur TOUTES les pages
# ============================================================
for f in *.html; do
  [ ! -f "$f" ] && continue
  if grep -q 'lang-menu' "$f"; then
    echo "ℹ️  $f — lang-switch déjà à jour"
    continue
  fi
  perl -0777 -i -pe 's|<div class="lang-switch">Français\s*<span class="chevron">▾</span></div>|<div class="lang-switch">\n            <span class="lang-current">Français</span>\n            <span class="chevron">▾</span>\n            <ul class="lang-menu">\n                <li><a href="#" data-lang="fr" class="active">Français</a></li>\n                <li><a href="#" data-lang="en">English</a></li>\n                <li><a href="#" data-lang="es">Español</a></li>\n            </ul>\n        </div>|s' "$f"
  echo "✅ $f — lang-switch remplacé"
done

# ============================================================
# 6) Extraire le nouveau footer depuis reservation.html
# ============================================================
perl -0777 -ne 'print $1 if /(<footer class="main-footer">.*?<\/footer>)/s' reservation.html > /tmp/new_footer.html

if [ ! -s /tmp/new_footer.html ]; then
  echo "❌ Extraction du footer échouée"
  exit 1
fi
echo "📤 Footer extrait de reservation.html ($(wc -c < /tmp/new_footer.html) octets)"

# ============================================================
# 7) Appliquer sur toutes les pages SAUF reservation.html
#    (ne pas toucher au booking-section / CTA)
# ============================================================
for f in index.html chambres.html contact.html galerie.html evenements.html experiences.html experiences-piscine.html experiences-restaurant.html; do
  [ ! -f "$f" ] && continue
  export NEW_FOOTER="$(cat /tmp/new_footer.html)"
  perl -0777 -i -pe 's|<footer class="main-footer">.*?</footer>|$ENV{NEW_FOOTER}|s' "$f"
  unset NEW_FOOTER
  echo "✅ $f — footer remplacé (CTA préservé)"
done

# ============================================================
# 8) Vérifications
# ============================================================
echo ""
echo "=== Vérifications ==="
for f in reservation.html index.html chambres.html contact.html galerie.html evenements.html experiences.html experiences-piscine.html experiences-restaurant.html; do
  [ ! -f "$f" ] && continue
  has_footer=$(grep -c 'payment-badge' "$f" 2>/dev/null || echo 0)
  has_curr=$(grep -c 'currency-switch' "$f" 2>/dev/null || echo 0)
  has_lang=$(grep -c 'lang-menu' "$f" 2>/dev/null || echo 0)
  has_cta=$(grep -c 'booking-section' "$f" 2>/dev/null || echo 0)
  printf "  %-32s footer=%s curr=%s lang=%s cta=%s\n" "$f" "$has_footer" "$has_curr" "$has_lang" "$has_cta"
done

echo ""
echo "============================================================"
echo "✅ TERMINÉ"
echo "💾 Sauvegarde : $BACKUP"
echo ""
echo "📌 Rappels :"
echo "   - Le logo décoratif utilise images/logo-symbole.png"
echo "   - Assure-toi que ce fichier existe dans le dossier images/"
echo "   - Ctrl+F5 dans le navigateur pour voir le résultat"
echo "============================================================"
