#!/bin/bash
set -e

BACKUP=".backup_FP_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP"
cp *.html "$BACKUP/" 2>/dev/null
cp js/booking-bridge.js "$BACKUP/" 2>/dev/null
echo "📦 Sauvegarde → $BACKUP"
echo ""

PAGES="index.html chambres.html contact.html galerie.html evenements.html experiences.html experiences-piscine.html experiences-restaurant.html reservation.html"

# ============================================================
# ÉTAPE 1 — Ajouter Flatpickr CSS + JS sur les pages qui l'oublient
# ============================================================
echo "─── ÉTAPE 1 : Flatpickr sur toutes les pages ───"
for f in $PAGES; do
    [ ! -f "$f" ] && continue

    # CSS Flatpickr
    if ! grep -q 'flatpickr.min.css' "$f"; then
        perl -0777 -i -pe 's|</head>|<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">\n</head>|' "$f"
        echo "  ✅ $f — CSS Flatpickr ajouté"
    fi

    # JS Flatpickr (avant booking-bridge.js pour être disponible)
    if ! grep -q 'flatpickr"' "$f" && ! grep -q "flatpickr/dist/flatpickr" "$f"; then
        perl -0777 -i -pe 's|(<script src="js/booking-bridge\.js"></script>)|<script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>\n    <script src="https://cdn.jsdelivr.net/npm/flatpickr/dist/l10n/fr.js"></script>\n    $1|' "$f"
        echo "  ✅ $f — JS Flatpickr ajouté"
    fi
done
echo ""

# ============================================================
# ÉTAPE 2 — Ajouter l'init Flatpickr dans booking-bridge.js
# ============================================================
echo "─── ÉTAPE 2 : Init Flatpickr dans booking-bridge.js ───"

# Vérifier si déjà présent
if grep -q 'flatpickr("#cta-checkin"' js/booking-bridge.js; then
    echo "  ℹ️  Init Flatpickr déjà présent"
else
    # Insérer avant la dernière ligne })();
    python3 << 'PYEOF'
with open('js/booking-bridge.js', 'r', encoding='utf-8') as f:
    content = f.read()

init_code = """
    /* ============================================================
       PARTIE 5 — INITIALISATION FLATPICKR (dates cliquables)
       ============================================================ */
    if (typeof flatpickr !== 'undefined') {
      var fpConfig = {
        locale: 'fr',
        dateFormat: 'd M. Y',
        minDate: 'today',
        disableMobile: true
      };

      /* --- Hero (index.html) --- */
      var heroCheckin  = document.getElementById('checkin');
      var heroCheckout = document.getElementById('checkout');
      if (heroCheckin) {
        flatpickr('#checkin', Object.assign({}, fpConfig, {
          defaultDate: '2026-09-09',
          onChange: function (selectedDates) {
            if (heroCheckout && heroCheckout._flatpickr && selectedDates[0]) {
              heroCheckout._flatpickr.set('minDate', selectedDates[0]);
            }
          }
        }));
      }
      if (heroCheckout) {
        flatpickr('#checkout', Object.assign({}, fpConfig, {
          defaultDate: '2026-09-30',
          minDate: '2026-09-09'
        }));
      }

      /* --- CTA (toutes les pages) --- */
      var ctaCheckin  = document.getElementById('cta-checkin');
      var ctaCheckout = document.getElementById('cta-checkout');
      if (ctaCheckin) {
        flatpickr('#cta-checkin', Object.assign({}, fpConfig, {
          onChange: function (selectedDates) {
            if (ctaCheckout && ctaCheckout._flatpickr && selectedDates[0]) {
              ctaCheckout._flatpickr.set('minDate', selectedDates[0]);
            }
          }
        }));
      }
      if (ctaCheckout) {
        flatpickr('#cta-checkout', fpConfig);
      }
    }
  });

})();"""

# Remplacer la fin du fichier (le `  });\n\n})();` final)
content = content.replace(
    '  });\n\n})();',
    init_code
)

with open('js/booking-bridge.js', 'w', encoding='utf-8') as f:
    f.write(content)

print("  ✅ Init Flatpickr injecté dans booking-bridge.js")
PYEOF
fi
echo ""

# ============================================================
# ÉTAPE 3 — Vérification
# ============================================================
echo "─── VÉRIFICATION ───"
printf "  %-32s | %s | %s | %s\n" "Fichier" "css-fp" "js-fp" "bridge"
printf "  %-32s-|-%s-|-%s-|-%s\n" "--------------------------------" "------" "-----" "------"
for f in $PAGES; do
    [ ! -f "$f" ] && continue
    css=$(grep -c 'flatpickr.min.css' "$f" 2>/dev/null || echo 0)
    js=$(grep -c 'flatpickr/dist/flatpickr.min.js\|"https://cdn.jsdelivr.net/npm/flatpickr"' "$f" 2>/dev/null || echo 0)
    br=$(grep -c 'js/booking-bridge.js' "$f" 2>/dev/null || echo 0)
    printf "  %-32s | %-6s | %-5s | %-6s\n" "$f" "$css" "$js" "$br"
done

echo ""
echo "  Attendu : css-fp=1, js-fp≥1, bridge=1"
echo ""
echo "==================================================="
echo "✅ TERMINÉ"
echo "💾 Sauvegarde : $BACKUP"
echo ""
echo "📌 Ctrl + F5 dans le navigateur, puis :"
echo "   - Clique sur n'importe quel 'Sélectionner' → calendrier"
echo "==================================================="
