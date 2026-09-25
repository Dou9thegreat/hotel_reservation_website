#!/bin/bash
set -e

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; BLUE='\033[0;34m'; NC='\033[0m'

echo -e "${BLUE}=================================================${NC}"
echo -e "${BLUE} ROLLBACK — Restauration de l'état précédent${NC}"
echo -e "${BLUE}=================================================${NC}\n"

# ---------- 1. Lister les backups disponibles ----------
echo -e "${BLUE}📂 Backups disponibles (du plus récent au plus ancien) :${NC}"
BACKUPS=($(ls -dt .backup_* 2>/dev/null))
if [ ${#BACKUPS[@]} -eq 0 ]; then
    echo -e "${RED}❌ Aucun backup trouvé${NC}"
    exit 1
fi

i=1
for b in "${BACKUPS[@]}"; do
    DATE=$(stat -c %y "$b" 2>/dev/null | cut -d. -f1)
    NB_HTML=$(ls "$b"/*.html 2>/dev/null | wc -l)
    HAS_CSS=$([ -f "$b/footer-cta.css" ] && echo "CSS" || echo "—")
    printf "   %2d) %-40s  [%s]  HTML:%2d  %s\n" "$i" "$(basename $b)" "$DATE" "$NB_HTML" "$HAS_CSS"
    i=$((i+1))
done

echo ""
read -p "Numéro du backup à restaurer [1 = plus récent] : " CHOICE

if ! [[ "$CHOICE" =~ ^[0-9]+$ ]] || [ "$CHOICE" -lt 1 ] || [ "$CHOICE" -gt ${#BACKUPS[@]} ]; then
    echo -e "${RED}❌ Choix invalide${NC}"
    exit 1
fi

TARGET="${BACKUPS[$((CHOICE-1))]}"
echo ""
echo -e "${YELLOW}⚠️  Restauration depuis : $TARGET${NC}"
read -p "Confirmer ? (o/N) " CONFIRM
if [[ ! "$CONFIRM" =~ ^[oOyY]$ ]]; then
    echo "Annulé."
    exit 0
fi

# ---------- 2. Sauvegarder l'état ACTUEL avant écrasement ----------
SAFETY=".backup_BEFORE_ROLLBACK_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$SAFETY"
cp *.html "$SAFETY/" 2>/dev/null || true
[ -f css/footer-cta.css ] && mkdir -p "$SAFETY/css" && cp css/footer-cta.css "$SAFETY/css/" 2>/dev/null || true
echo -e "\n${GREEN}📦 État actuel sauvegardé → $SAFETY${NC}"

# ---------- 3. Restaurer ----------
echo -e "\n${BLUE}♻️  Restauration en cours...${NC}"

# HTML
if ls "$TARGET"/*.html &>/dev/null; then
    cp "$TARGET"/*.html .
    echo -e "${GREEN}   ✔ HTML restaurés ($(ls $TARGET/*.html | wc -l) fichiers)${NC}"
fi

# CSS footer-cta
if [ -f "$TARGET/footer-cta.css" ]; then
    cp "$TARGET/footer-cta.css" css/
    echo -e "${GREEN}   ✔ css/footer-cta.css restauré${NC}"
fi

# Autres CSS si présents
if [ -d "$TARGET/css" ]; then
    cp "$TARGET"/css/*.css css/ 2>/dev/null || true
    echo -e "${GREEN}   ✔ Autres CSS restaurés${NC}"
fi

# ---------- 4. Vérification ----------
echo -e "\n${BLUE}━━━ VÉRIFICATION ━━━${NC}"
printf "   %-32s | %s | %s | %s\n" "Fichier" "features" "items" "cta"
printf "   %-32s-|-%s-|-%s-|-%s\n" "--------------------------------" "--------" "-----" "---"
for f in index.html chambres.html contact.html galerie.html evenements.html experiences.html experiences-piscine.html experiences-restaurant.html; do
    [ ! -f "$f" ] && continue
    feat=$(grep -c 'class="booking-features"' "$f" 2>/dev/null || echo 0)
    items=$(grep -o 'class="feature-item"' "$f" 2>/dev/null | wc -l)
    cta=$(grep -c 'class="booking-section"' "$f" 2>/dev/null || echo 0)
    printf "   %-32s | %-8s | %-5s | %-3s\n" "$f" "$feat" "$items" "$cta"
done

echo ""
echo -e "${GREEN}✅ Rollback terminé !${NC}"
echo -e "${BLUE}💾 État cassé sauvegardé dans : $SAFETY${NC}"
echo ""
echo -e "${BLUE}📌 Étapes suivantes :${NC}"
echo "   1. Ctrl + Shift + R dans le navigateur"
echo "   2. Vérifiez que tout est revenu à la normale"
echo "   3. Si vous voulez revenir au état 'cassé', copiez depuis :"
echo "      cp $SAFETY/*.html . && cp $SAFETY/css/footer-cta.css css/"
echo ""
