#!/bin/bash
set -e

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; BLUE='\033[0;34m'; NC='\033[0m'

echo -e "${BLUE}=================================================${NC}"
echo -e "${BLUE} FIX DATEPICKER — Pages secondaires${NC}"
echo -e "${BLUE}=================================================${NC}\n"

# ---------- Sauvegarde ----------
BACKUP=".backup_dates_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP"
cp *.html "$BACKUP/" 2>/dev/null
echo -e "${GREEN}📦 Sauvegarde → $BACKUP${NC}\n"

# ---------- Pages à corriger ----------
PAGES="chambres.html contact.html galerie.html evenements.html experiences.html experiences-piscine.html experiences-restaurant.html"

for f in $PAGES; do
    [ ! -f "$f" ] && { echo -e "${YELLOW}⚠  $f absent${NC}"; continue; }

    # 1. Ajouter CSS Flatpickr si manquant
    if ! grep -q 'flatpickr.min.css' "$f"; then
        perl -0777 -i -pe 's|</head>|<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">\n</head>|' "$f"
        echo -e "${GREEN}  ✔ $f — CSS Flatpickr ajouté${NC}"
    fi

    # 2. Ajouter JS Flatpickr AVANT booking-bridge.js
    if ! grep -q 'cdn.jsdelivr.net/npm/flatpickr"' "$f"; then
        perl -0777 -i -pe 's|(<script src="js/booking-bridge\.js"></script>)|
<script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <script src="https://cdn.jsdelivr.net/npm/flatpickr/dist/l10n/fr.js"></script>
    $1|' "$f"
        echo -e "${GREEN}  ✔ $f — JS Flatpickr + locale FR ajoutés${NC}"
    else
        echo -e "${YELLOW}  ℹ  $f — Flatpickr JS déjà présent${NC}"
    fi
done

# ---------- Vérification ----------
echo -e "\n${BLUE}━━━ VÉRIFICATION ━━━${NC}"
printf "  %-32s | %s | %s | %s\n" "Fichier" "CSS" "JS" "BRIDGE"
printf "  %-32s-|-%s-|-%s-|-%s\n" "--------------------------------" "---" "--" "------"
for f in $PAGES index.html; do
    [ ! -f "$f" ] && continue
    css=$(grep -c 'flatpickr.min.css' "$f" 2>/dev/null || echo 0)
    js=$(grep -c 'cdn.jsdelivr.net/npm/flatpickr"' "$f" 2>/dev/null || echo 0)
    br=$(grep -c 'js/booking-bridge.js' "$f" 2>/dev/null || echo 0)
    printf "  %-32s | %-3s | %-2s | %-6s\n" "$f" "$css" "$js" "$br"
done

echo -e "\n${GREEN}✅ Terminé !${NC}"
echo -e "${BLUE}💾 Sauvegarde : $BACKUP${NC}"
echo -e "\n${BLUE}📌 Ctrl + F5 dans le navigateur, puis testez :${NC}"
echo "   • Cliquez sur ARRIVÉE ou DÉPART dans le CTA bas de page"
echo "   • Le calendrier doit s'ouvrir"
echo -e "\n${BLUE}🔄 Rollback :${NC}  cp $BACKUP/*.html .\n"
