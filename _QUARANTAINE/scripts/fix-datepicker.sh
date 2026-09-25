#!/bin/bash
# =============================================================
# FIX-DATEPICKER.SH
# Force l'ouverture du datepicker au clic sur tout le widget-field
# =============================================================

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE} FIX DATEPICKER — Toutes les pages HTML   ${NC}"
echo -e "${BLUE}=========================================${NC}"
echo ""

# ---------- 1. Sauvegardes ----------
echo "📦 Sauvegarde des HTML..."
mkdir -p .backup-datepicker
for f in *.html; do
    cp "$f" ".backup-datepicker/$f.bak"
done
echo "   ✔ dans .backup-datepicker/"
echo ""

# ---------- 2. Créer le fichier JS ----------
echo "✍️  Création de js/fix-datepicker.js..."
mkdir -p js

cat > js/fix-datepicker.js << 'JSEOF'
/* =============================================================
   FIX DATEPICKER — Ouvre le calendrier au clic sur tout le champ
   Commun à toutes les pages sauf reservation.html
   ============================================================= */
(function () {
    'use strict';

    function init() {
        document.querySelectorAll('.booking-section .widget-field').forEach(function (field) {
            var input = field.querySelector('input[type="date"]');
            if (!input) return;

            // Curseur main sur tout le champ
            field.style.cursor = 'pointer';

            field.addEventListener('click', function (e) {
                // Si le clic est déjà sur l'input, ne rien faire (comportement natif)
                if (e.target === input) return;

                // Focus sur l'input
                input.focus({ preventScroll: true });

                // Ouvre le picker natif si dispo (Chrome, Edge, Firefox récents)
                if (typeof input.showPicker === 'function') {
                    try {
                        input.showPicker();
                    } catch (err) {
                        // Certains navigateurs bloquent showPicker hors interaction
                        // Le focus seul suffit alors
                    }
                }
            });
        });
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }
})();
JSEOF

echo "   ✔ js/fix-datepicker.js créé"
echo ""

# ---------- 3. Injecter dans tous les HTML sauf reservation ----------
echo "🔧 Injection dans les HTML (sauf reservation.html)..."
MODIFIED=0

for f in *.html; do
    # Skip reservation.html
    if [ "$f" = "reservation.html" ]; then
        echo -e "   ${YELLOW}⏭  $f (ignoré — page réservation)${NC}"
        continue
    fi

    # Skip si déjà présent
    if grep -q "fix-datepicker.js" "$f"; then
        echo -e "   ℹ  $f (déjà présent)"
        continue
    fi

    # Injecter juste avant </body>
    if grep -q "</body>" "$f"; then
        # Utilise python pour un remplacement propre (gère les sauts de ligne)
        python3 - "$f" << 'PYEOF'
import sys
from pathlib import Path
f = Path(sys.argv[1])
c = f.read_text(encoding="utf-8")
tag = '    <script src="js/fix-datepicker.js"></script>\n</body>'
if '</body>' in c:
    c = c.replace('</body>', tag, 1)
    f.write_text(c, encoding="utf-8")
PYEOF
        echo -e "   ${GREEN}✔ $f${NC}"
        MODIFIED=$((MODIFIED+1))
    else
        echo -e "   ${YELLOW}⚠  $f : </body> introuvable${NC}"
    fi
done

echo ""
echo -e "${BLUE}=========================================${NC}"
echo -e "${GREEN}✅ Terminé — $MODIFIED fichier(s) modifié(s)${NC}"
echo -e "${BLUE}=========================================${NC}"
echo ""
echo -e "${BLUE}📋 Étapes suivantes :${NC}"
echo "   1. Ouvre galerie.html → Ctrl+Shift+R"
echo "   2. Clique n'importe où sur ARRIVÉE ou DÉPART"
echo "      → le calendrier doit s'ouvrir"
echo ""
echo -e "${BLUE}🔄 Rollback :${NC}"
echo "   cp .backup-datepicker/*.bak ."
echo ""
