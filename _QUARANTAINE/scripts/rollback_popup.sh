#!/bin/bash
set -e

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; BLUE='\033[0;34m'; NC='\033[0m'

echo -e "${BLUE}=================================================${NC}"
echo -e "${BLUE} ROLLBACK — Annulation du pop-up tarifs${NC}"
echo -e "${BLUE}=================================================${NC}\n"

# ---------- 1. Trouver le dernier backup popup ----------
BACKUPS=($(ls -dt .backup_popup_* 2>/dev/null))

if [ ${#BACKUPS[@]} -eq 0 ]; then
    echo -e "${RED}❌ Aucun backup .backup_popup_* trouvé${NC}"
    echo ""
    echo -e "${YELLOW}Backups disponibles :${NC}"
    ls -dt .backup_* 2>/dev/null | head -10 | sed 's/^/   /'
    exit 1
fi

TARGET="${BACKUPS[0]}"
echo -e "${GREEN}✔ Backup trouvé : $TARGET${NC}"
echo ""

# ---------- 2. Vérifier le contenu ----------
if [ ! -f "$TARGET/chambres.html" ]; then
    echo -e "${RED}❌ chambres.html manquant dans le backup${NC}"
    exit 1
fi

echo -e "${BLUE}Fichiers disponibles dans le backup :${NC}"
ls -la "$TARGET/" | grep -v '^total' | grep -v '^d' | sed 's/^/   /'
echo ""

# ---------- 3. Confirmation ----------
echo -e "${YELLOW}⚠️  Restaurer chambres.html et chambres.css depuis $TARGET ?${NC}"
read -p "Confirmer ? (o/N) " CONFIRM
if [[ ! "$CONFIRM" =~ ^[oOyY]$ ]]; then
    echo "Annulé."
    exit 0
fi

# ---------- 4. Sauvegarder l'état cassé ----------
SAFETY=".backup_AVANT_ROLLBACK_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$SAFETY"
cp chambres.html "$SAFETY/" 2>/dev/null || true
cp css/chambres.css "$SAFETY/" 2>/dev/null || true
echo -e "\n${GREEN}📦 État actuel sauvegardé → $SAFETY${NC}"

# ---------- 5. Restaurer ----------
echo -e "\n${BLUE}♻️  Restauration...${NC}"

cp "$TARGET/chambres.html" .
echo -e "${GREEN}   ✔ chambres.html restauré${NC}"

if [ -f "$TARGET/chambres.css" ]; then
    cp "$TARGET/chambres.css" css/
    echo -e "${GREEN}   ✔ css/chambres.css restauré${NC}"
fi

# ---------- 6. Vérification ----------
echo -e "\n${BLUE}━━━ VÉRIFICATION ━━━${NC}"

H=$(cat chambres.html)

check() {
    local label="$1"
    local pattern="$2"
    local expected="$3"
    local count=$(echo "$H" | grep -c "$pattern" 2>/dev/null || echo 0)
    if [ "$count" -eq "$expected" ]; then
        echo -e "   ${GREEN}✔${NC}  $label : $count/$expected"
    else
        echo -e "   ${YELLOW}⚠${NC}  $label : $count/$expected"
    fi
}

check "Pop-up supprimée (0 attendu)" 'tariffsModal' 0
check "CSS pop-up supprimé (0 attendu)" 'tariffs-modal-overlay' 0
check "Boutons RÉSERVER (3 attendus)" 'btn-reserver-room' 3
check "Section CTA (1 attendu)" 'booking-section' 1
check "Modale réservation (0 attendu)" 'reservationModal' 0

echo ""
echo -e "${GREEN}✅ Rollback terminé !${NC}"
echo -e "${BLUE}💾 État cassé conservé dans : $SAFETY${NC}"
echo ""
echo -e "${BLUE}📌 Étapes suivantes :${NC}"
echo "   1. Ctrl + Shift + R dans le navigateur"
echo "   2. Vérifiez que chambres.html est revenu à l'état précédent"
echo ""
echo -e "${BLUE}🔄 Si ça ne suffit pas, restaure depuis un backup plus ancien :${NC}"
echo "   cp .backup_final_XXXXXXXX_XXXXXX/chambres.html ."
echo "   cp .backup_final_XXXXXXXX_XXXXXX/chambres.css css/"
echo ""
