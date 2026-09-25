#!/usr/bin/env bash
# =============================================================================
# fix_selection_panel_photo.sh
#
# Corrige UNE SEULE ligne dans reservation.html :
#   renderSelection() → le .ph du panneau "Votre sélection"
#   Utilise getRoomPhotoStyle(room.id) pour afficher la photo de la chambre.
#
# Fichier modifié : reservation.html UNIQUEMENT
# Idempotent : peut être relancé sans risque
# =============================================================================
set -uo pipefail
# ⚠️ Volontairement PAS de 'set -e' : on gère les erreurs nous-mêmes
#    pour pouvoir afficher des messages d'aide en cas de problème.

HTML_FILE="${1:-reservation.html}"
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; BLUE='\033[0;34m'; NC='\033[0m'

echo -e "${BLUE}=====================================================${NC}"
echo -e "${BLUE} FIX PANNEAU SÉLECTION — PHOTO CHAMBRE${NC}"
echo -e "${BLUE}=====================================================${NC}\n"

# ---------- Vérifications préalables ----------
if [ ! -f "$HTML_FILE" ]; then
  echo -e "${RED}❌ $HTML_FILE introuvable${NC}"
  exit 1
fi
if ! command -v python3 >/dev/null 2>&1; then
  echo -e "${RED}❌ python3 requis${NC}"
  exit 1
fi
echo -e "${GREEN}   ✔ $HTML_FILE${NC}"

# ---------- Sauvegarde ----------
BACKUP=".backup_selphoto_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP"
cp "$HTML_FILE" "$BACKUP/"
echo -e "${GREEN}📦 Sauvegarde → $BACKUP${NC}\n"

# ---------- Patch via Python ----------
echo -e "${BLUE}━━━ Patch ━━━${NC}"

python3 - "$HTML_FILE" << 'PY_EOF'
import sys
from pathlib import Path

path = Path(sys.argv[1])
html = path.read_text(encoding='utf-8')

# --- 1. Vérifier la dépendance (getRoomPhotoStyle doit exister) ---
if 'function getRoomPhotoStyle(' not in html:
    print("   ❌ La fonction getRoomPhotoStyle() n'existe pas dans le fichier.")
    print("      → Lancez d'abord : ./fix_reservation_room_photos.sh")
    sys.exit(2)

# --- 2. Patterns exacts ---
old_line = """'<div class="sel-room"><div class="ph">Photo</div>' +"""
new_line = """'<div class="sel-room"><div class="ph" ' + getRoomPhotoStyle(room.id) + '>Photo</div>' +"""

# --- 3. Idempotence ---
if new_line in html:
    print("   ℹ  Déjà patché — aucune action nécessaire")
    sys.exit(0)

# --- 4. Le pattern cible doit exister EXACTEMENT 1 fois ---
count = html.count(old_line)
if count == 0:
    print("   ❌ Ligne cible introuvable dans le fichier.")
    print("      Recherché : " + old_line)
    print("      → Vérifiez que le fichier n'a pas été modifié manuellement.")
    sys.exit(3)
if count > 1:
    print("   ❌ " + str(count) + " occurrences trouvées (attendu : 1).")
    print("      → Abandon par prudence pour ne pas casser le code.")
    sys.exit(4)

# --- 5. Remplacement ---
html = html.replace(old_line, new_line, 1)
path.write_text(html, encoding='utf-8')
print("   ✔ Ligne du panneau sélection patchée")
print("   ✔ getRoomPhotoStyle(room.id) sera appelé pour chaque chambre sélectionnée")
sys.exit(0)
PY_EOF

EXIT_CODE=$?

# ---------- Gestion des erreurs ----------
if [ "$EXIT_CODE" -eq 2 ]; then
  echo ""
  echo -e "${RED}⚠️  Dépendance manquante${NC}"
  echo -e "${YELLOW}   Exécutez d'abord : ./fix_reservation_room_photos.sh${NC}"
  exit 2
fi
if [ "$EXIT_CODE" -eq 3 ]; then
  echo ""
  echo -e "${RED}⚠️  Ligne cible introuvable — fichier non modifié${NC}"
  echo -e "${YELLOW}   Sauvegarde disponible : $BACKUP${NC}"
  exit 3
fi
if [ "$EXIT_CODE" -eq 4 ]; then
  echo ""
  echo -e "${RED}⚠️  Plusieurs occurrences détectées — abandon par prudence${NC}"
  echo -e "${YELLOW}   Sauvegarde disponible : $BACKUP${NC}"
  exit 4
fi
if [ "$EXIT_CODE" -ne 0 ]; then
  echo ""
  echo -e "${RED}⚠️  Erreur inattendue (code $EXIT_CODE)${NC}"
  echo -e "${YELLOW}   Sauvegarde disponible : $BACKUP${NC}"
  exit "$EXIT_CODE"
fi

# ---------- Vérification finale ----------
echo ""
echo -e "${BLUE}━━━ VÉRIFICATION ━━━${NC}"

if grep -q 'getRoomPhotoStyle(room\.id)' "$HTML_FILE"; then
  echo -e "   ${GREEN}✔${NC} getRoomPhotoStyle(room.id) présent dans renderSelection()"
else
  echo -e "   ${RED}✘${NC} Patch non appliqué"
fi

if grep -q 'sel-room"><div class="ph" ' "$HTML_FILE"; then
  echo -e "   ${GREEN}✔${NC} Structure HTML du panneau sélection correcte"
fi

if grep -q 'sel-room"><div class="ph">Photo' "$HTML_FILE"; then
  echo -e "   ${RED}✘${NC} Ancienne ligne toujours présente — inattendu"
else
  echo -e "   ${GREEN}✔${NC} Ancienne ligne remplacée"
fi

if grep -q 'getRoomPhotoStyle(r\.id)' "$HTML_FILE"; then
  echo -e "   ${GREEN}✔${NC} renderRooms() intact (getRoomPhotoStyle(r.id))"
else
  echo -e "   ${YELLOW}⚠${NC}  renderRooms() ne contient plus getRoomPhotoStyle(r.id)"
fi

echo ""
echo -e "${GREEN}✅ TERMINÉ${NC}"
echo -e "${BLUE}💾 Sauvegarde : $BACKUP${NC}"
echo ""
echo -e "${BLUE}🧪 TEST :${NC}"
echo "   1. Ctrl + Shift + R sur reservation.html dans le navigateur"
echo "   2. Sélectionnez un tarif d'une chambre (bouton 'Sélectionner')"
echo "   3. La photo doit apparaître dans le panneau 'Votre sélection' (à droite)"
echo "      à côté du nom de la chambre et du tarif."
echo ""
echo "   ℹ  Si vous voyez encore le dégradé gris hachuré, c'est que le chemin"
echo "      dans ROOM_PHOTOS pointe vers un fichier inexistant."
echo "      Modifiez 'var ROOM_PHOTOS = {...}' dans reservation.html."
echo ""
echo -e "${BLUE}🔄 ROLLBACK :${NC}"
echo "   cp $BACKUP/$HTML_FILE ."
echo ""
