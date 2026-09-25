#!/usr/bin/env bash
# =============================================================================
# fix_reservation_room_photos.sh
#
# Corrige 2 bugs dans reservation.html introduits par le patch précédent :
#   1. ROOM_PHOTOS passe de 'const' à 'var' (accès global)
#   2. renderRooms() n'émet plus url('') si aucune photo
#      → dégradé gris par défaut au lieu de l'icône cassée
#
# Fichier modifié : reservation.html UNIQUEMENT
# Idempotent : peut être relancé sans risque
# =============================================================================
set -euo pipefail

HTML_FILE="${1:-reservation.html}"
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; BLUE='\033[0;34m'; NC='\033[0m'

echo -e "${BLUE}=====================================================${NC}"
echo -e "${BLUE} FIX ROOM PHOTOS — reservation.html${NC}"
echo -e "${BLUE}=====================================================${NC}\n"

if [ ! -f "$HTML_FILE" ]; then
  echo -e "${RED}❌ $HTML_FILE introuvable${NC}"; exit 1
fi
if ! command -v python3 >/dev/null 2>&1; then
  echo -e "${RED}❌ python3 requis${NC}"; exit 1
fi

# ---------- Sauvegarde ----------
BACKUP=".backup_fixphotos_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP"
cp "$HTML_FILE" "$BACKUP/"
echo -e "${GREEN}📦 Sauvegarde → $BACKUP${NC}\n"

# =============================================================================
# PATCH
# =============================================================================
echo -e "${BLUE}━━━ Patch ━━━${NC}"

python3 - "$HTML_FILE" << 'PYEOF'
import re, sys
from pathlib import Path

path = Path(sys.argv[1])
html = path.read_text(encoding='utf-8')
changes = []

# --- Fix 1 : const → var pour ROOM_PHOTOS ---
if 'var ROOM_PHOTOS = {' in html:
    changes.append("ROOM_PHOTOS : déjà en 'var' (ok)")
elif 'const ROOM_PHOTOS = {' in html:
    html = html.replace('const ROOM_PHOTOS = {', 'var ROOM_PHOTOS = {', 1)
    changes.append("ROOM_PHOTOS : 'const' → 'var'")
else:
    changes.append("⚠  ROOM_PHOTOS introuvable (lancez d'abord patch_reservation_images.sh)")

# --- Fix 2 : helper getRoomPhotoStyle() avant renderRooms ---
helper = """function getRoomPhotoStyle(roomId) {
  var url = (typeof ROOM_PHOTOS !== 'undefined' && ROOM_PHOTOS[roomId]) ? ROOM_PHOTOS[roomId] : '';
  if (!url) return '';
  return 'style="background-image:url(\\'' + url + '\\');background-size:cover;background-position:center;font-size:0;"';
}

"""

if 'function getRoomPhotoStyle(' in html:
    changes.append("Helper getRoomPhotoStyle() : déjà présent")
elif 'function renderRooms(){' in html:
    html = html.replace('function renderRooms(){', helper + 'function renderRooms(){', 1)
    changes.append("Helper getRoomPhotoStyle() : ajouté")
else:
    changes.append("⚠  renderRooms() introuvable")

# --- Fix 3 : remplacer la ligne .ph de renderRooms ---
pattern = re.compile(
    r"(<div class=\"rc-gallery\"><div class=\"ph\")[^>]*?(>Photo —<br>' \+ r\.name \+ '</div></div>)",
    re.DOTALL
)

def repl(m):
    return m.group(1) + "' + getRoomPhotoStyle(r.id) + '" + m.group(2)

new_html, n = pattern.subn(repl, html, count=1)
if n > 0:
    html = new_html
    changes.append("Ligne .ph de renderRooms() : patchée")
else:
    changes.append("⚠  Ligne .ph de renderRooms() introuvable")

path.write_text(html, encoding='utf-8')
for c in changes:
    print("   ✔ " + c)
PYEOF

# =============================================================================
# VÉRIFICATION
# =============================================================================
echo ""
echo -e "${BLUE}━━━ VÉRIFICATION ━━━${NC}"

check() {
  local label="$1"; local pattern="$2"
  if grep -q "$pattern" "$HTML_FILE" 2>/dev/null; then
    echo -e "   ${GREEN}✔${NC} $label"
  else
    echo -e "   ${RED}✘${NC} $label — MANQUANT"
  fi
}

check "ROOM_PHOTOS en 'var'"              "var ROOM_PHOTOS = {"
check "Helper getRoomPhotoStyle définie"  "function getRoomPhotoStyle("
check "renderRooms utilise getRoomPhotoStyle" "getRoomPhotoStyle(r.id)"

if grep -q "window.ROOM_PHOTOS" "$HTML_FILE" 2>/dev/null; then
  echo -e "   ${YELLOW}⚠${NC}  Il reste des références à window.ROOM_PHOTOS"
else
  echo -e "   ${GREEN}✔${NC} Plus aucune référence à window.ROOM_PHOTOS"
fi

echo ""
echo -e "${GREEN}✅ TERMINÉ${NC}"
echo -e "${BLUE}💾 Sauvegarde : $BACKUP${NC}"
echo ""
echo -e "${BLUE}🧪 TEST :${NC}"
echo "   1. Ctrl + Shift + R dans le navigateur sur reservation.html"
echo "   2. Sélectionnez un tarif d'une chambre"
echo "   3. Les emplacements sans photo montrent le dégradé gris (plus d'icône cassée)"
echo "   4. Une fois les chemins remplis dans ROOM_PHOTOS, les photos s'affichent."
echo ""
echo -e "${BLUE}📌 MODIFIER LES PHOTOS DES CHAMBRES :${NC}"
echo "   Ouvrez $HTML_FILE"
echo "   Cherchez : var ROOM_PHOTOS = {"
echo "   Remplacez les chemins par vos vraies images."
echo ""
echo -e "${BLUE}🔄 ROLLBACK :${NC}"
echo "   cp $BACKUP/$HTML_FILE ."
echo ""
