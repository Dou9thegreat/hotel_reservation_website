#!/usr/bin/env bash
# =============================================================================
# patch_reservation_images.sh
#
# Centralise la gestion des images de reservation.html dans :
#   - reservation.html  (config ROOM_PHOTOS + patch renderRooms)
#   - reservation.css   (hero + override extras)
#
# AUCUN autre fichier n'est touché.
# Idempotent : peut être relancé sans risque.
# =============================================================================
set -euo pipefail

# ---------------------------------------------------------------------------
# ⚙️  CONFIGURATION — Modifiez ces chemins selon vos images
# ---------------------------------------------------------------------------
HERO_IMAGE="${HERO_IMAGE:-images/hero.png}"

# Photos des chambres (utilisées dans la page Réservation)
declare -A ROOM_PHOTOS=(
  ["classique-ville"]="images/imageluxe1.jpg"
  ["classique-twin"]="images/imageluxe2.jpg.jpg"
  ["superieure-ocean"]="images/imagesuperieur1.jpg.jpg"
  ["deluxe-ocean"]="images/imageluxe1.jpg"
  ["suite-ambassadeur"]="images/imagesambassadeur-1.jpg (2).jpg"
)

# Photos des extras (pour le pop-up et le bandeau de la page Réservation)
# Modifiez ces chemins si vous voulez changer les images affichées.
declare -A EXTRA_PHOTOS=(
  ["spa-massage"]="images/massage3.jpg"
  ["spa-hammam"]="images/Hamman.jpg"
  ["spa-journee"]="images/piscine.jpg"
  ["resto-brunch"]="images/resto-brunch.jpg"
  ["resto-diner"]="images/resto-chef-sow.jpg"
  ["resto-beach"]="images/resto-feu-bois.jpg"
  ["bar-cocktail"]="images/resto-bar-nuit.jpg"
  ["bar-champagne"]="images/resto-bar-nuit.jpg"
  ["svc-late"]="images/imageluxe1.jpg"
  ["svc-transfer"]="images/hero.png"
  ["svc-breakfast"]="images/resto-brunch.jpg"
)

HTML_FILE="${1:-reservation.html}"
CSS_FILE="${2:-css/reservation.css}"

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; BLUE='\033[0;34m'; NC='\033[0m'

echo -e "${BLUE}=====================================================${NC}"
echo -e "${BLUE} PATCH IMAGES RESERVATION — Hero + Chambres + Extras${NC}"
echo -e "${BLUE}=====================================================${NC}\n"

# ---------------------------------------------------------------------------
# VÉRIFICATIONS
# ---------------------------------------------------------------------------
if [ ! -f "$HTML_FILE" ]; then echo -e "${RED}❌ $HTML_FILE introuvable${NC}"; exit 1; fi
if [ ! -f "$CSS_FILE" ]; then echo -e "${RED}❌ $CSS_FILE introuvable${NC}"; exit 1; fi
if ! command -v python3 >/dev/null 2>&1; then echo -e "${RED}❌ python3 requis${NC}"; exit 1; fi

echo -e "${GREEN}   ✔ $HTML_FILE${NC}"
echo -e "${GREEN}   ✔ $CSS_FILE${NC}"

# ---------------------------------------------------------------------------
# SAUVEGARDE
# ---------------------------------------------------------------------------
BACKUP=".backup_patch_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP"
cp "$HTML_FILE" "$BACKUP/"
cp "$CSS_FILE" "$BACKUP/"
echo -e "${GREEN}📦 Sauvegarde → $BACKUP${NC}\n"

# ---------------------------------------------------------------------------
# GÉNÉRATION DES BLOCS CSS/JS À INSÉRER
# ---------------------------------------------------------------------------
TMP_CSS_OVERRIDE=$(mktemp)
TMP_JS_CONFIG=$(mktemp)
trap 'rm -f "$TMP_CSS_OVERRIDE" "$TMP_JS_CONFIG"' EXIT

# --- Bloc CSS : override des images extras ---
{
  echo ""
  echo "/* ============================================================= */"
  echo "/* OVERRIDE EXTRAS IMAGES — Bloc généré par patch_reservation   */"
  echo "/* ============================================================= */"
  echo "/* Ce bloc surcharge les images des extras définies dans        */"
  echo "/* js/extras.js, SANS toucher à extras.js.                      */"
  echo "/* Modifiez simplement les url() ci-dessous.                    */"
  echo "/* ============================================================= */"
  echo ""
  for key in "${!EXTRA_PHOTOS[@]}"; do
    img="${EXTRA_PHOTOS[$key]}"
    echo "/* --- Extra : $key --- */"
    echo ".exb-quick[data-quick-id=\"$key\"] .exb-quick-thumb,"
    echo ".exb-card[data-extra-id=\"$key\"] .exb-card-image {"
    echo "    background-image: url('../$img') !important;"
    echo "    background-size: cover !important;"
    echo "    background-position: center !important;"
    echo "}"
    echo ""
  done
} > "$TMP_CSS_OVERRIDE"

# --- Bloc JS : config ROOM_PHOTOS ---
{
  echo "/* ===== ROOM PHOTOS CONFIG — Patch reservation.html ===== */"
  echo "/* Ce bloc définit les photos des chambres utilisées dans la   */"
  echo "/* page Réservation. Modifiez simplement les chemins ci-dessous. */"
  echo "const ROOM_PHOTOS = {"
  for key in "${!ROOM_PHOTOS[@]}"; do
    img="${ROOM_PHOTOS[$key]}"
    printf "  '%s': '%s',\n" "$key" "$img"
  done
  echo "};"
  echo "/* ====================================================== */"
  echo ""
} > "$TMP_JS_CONFIG"

# ---------------------------------------------------------------------------
# PATCH CSS — Hero + Override Extras
# ---------------------------------------------------------------------------
echo -e "${BLUE}━━━ Patch CSS ━━━${NC}"

python3 - "$CSS_FILE" "$HERO_IMAGE" "$TMP_CSS_OVERRIDE" << 'PY_EOF'
import re, sys
from pathlib import Path

css_path = Path(sys.argv[1])
hero_img = sys.argv[2]
override_block = Path(sys.argv[3]).read_text(encoding='utf-8')

css = css_path.read_text(encoding='utf-8')
changes = []

# --- 1. HERO : ajouter background-image si absent ---
old_hero_rule = re.compile(
    r'\.reservation-page \.hero \.ph\s*\{[^}]*\}',
    re.DOTALL
)

def repl_hero(m):
    block = m.group(0)
    if 'background-image' in block and 'url(' in block:
        return block  # déjà patché
    # Insérer avant la dernière accolade fermante
    insert = f"""  background-image: url('../{hero_img}');
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
  background-blend-mode: normal;
  border-radius: 0;"""
    return block[:-1].rstrip() + "\n" + insert + "\n}"

new_css, n = old_hero_rule.subn(repl_hero, css, count=1)
if n > 0:
    if 'background-image' in new_css.split('.reservation-page .hero .ph')[1].split('}')[0]:
        changes.append(f"Hero : image '{hero_img}' appliquée")
    css = new_css
else:
    changes.append("⚠️  Règle .hero .ph introuvable (vérifiez reservation.css)")

# --- 2. OVERRIDE EXTRAS : remplacer l'ancien bloc si présent ---
start_marker = "/* OVERRIDE EXTRAS IMAGES"
if start_marker in css:
    # Supprimer l'ancien bloc (du commentaire au prochain double saut de ligne final)
    idx = css.index(start_marker)
    # Chercher la fin du bloc : prochaine ligne "/* ====" qui n'est pas dans le bloc
    # Plus simple : on coupe à la fin du dernier ".exb-card[data-extra-id" match
    tail = css[idx:]
    matches = list(re.finditer(r'\.exb-card\[data-extra-id[^}]*\}', tail))
    if matches:
        end_idx = idx + matches[-1].end()
        # Nettoyer les lignes vides
        css = css[:idx].rstrip() + css[end_idx:].rstrip() + "\n"

css = css.rstrip() + "\n" + override_block + "\n"
changes.append("Override extras : bloc ajouté/remplacé")

css_path.write_text(css, encoding='utf-8')
for c in changes:
    print("   ✔ " + c)
PY_EOF

# ---------------------------------------------------------------------------
# PATCH HTML — ROOM_PHOTOS + renderRooms
# ---------------------------------------------------------------------------
echo ""
echo -e "${BLUE}━━━ Patch HTML ━━━${NC}"

python3 - "$HTML_FILE" "$TMP_JS_CONFIG" << 'PY_EOF'
import re, sys
from pathlib import Path

html_path = Path(sys.argv[1])
js_config = Path(sys.argv[2]).read_text(encoding='utf-8')

html = html_path.read_text(encoding='utf-8')
changes = []

# --- 1. Insérer ROOM_PHOTOS avant "const ROOMS = [" ---
anchor_rooms = "const ROOMS = ["
if 'ROOM_PHOTOS' in html and 'ROOM PHOTOS CONFIG' in html:
    # Mettre à jour l'existant : remplacer le bloc config
    pattern_cfg = re.compile(
        r'/\* ===== ROOM PHOTOS CONFIG.*?const ROOM_PHOTOS = \{.*?\};.*?/\* =+ \*/',
        re.DOTALL
    )
    html = pattern_cfg.sub(js_config.strip(), html, count=1)
    changes.append("Config ROOM_PHOTOS : mise à jour")
elif anchor_rooms in html:
    html = html.replace(anchor_rooms, js_config + anchor_rooms, 1)
    changes.append("Config ROOM_PHOTOS : ajoutée")
else:
    changes.append("⚠️  Ancre 'const ROOMS = [' introuvable")

# --- 2. Patcher renderRooms() : la ligne du .ph ---
old_line = """'<div class="rc-gallery"><div class="ph">Photo —<br>' + r.name + '</div></div>' +"""
new_line = """'<div class="rc-gallery"><div class="ph" style="background-image:url(\\'' + ((window.ROOM_PHOTOS && window.ROOM_PHOTOS[r.id]) || '') + '\\');background-size:cover;background-position:center;font-size:0;">Photo —<br>' + r.name + '</div></div>' +"""

if 'style="background-image:url' in html and 'ROOM_PHOTOS[r.id]' in html:
    changes.append("renderRooms() : déjà patché")
elif old_line in html:
    html = html.replace(old_line, new_line, 1)
    changes.append("renderRooms() : patché")
else:
    # Fallback : essayer une regex plus souple
    pattern_ph = re.compile(
        r"'<div class=\"rc-gallery\"><div class=\"ph\">Photo —<br>' \+ r\.name \+ '</div></div>' \+"
    )
    new_html, n = pattern_ph.subn(new_line, html, count=1)
    if n > 0:
        html = new_html
        changes.append("renderRooms() : patché (fallback)")
    else:
        changes.append("⚠️  Ligne .ph de renderRooms() introuvable")

html_path.write_text(html, encoding='utf-8')
for c in changes:
    print("   ✔ " + c)
PY_EOF

# ---------------------------------------------------------------------------
# VÉRIFICATION
# ---------------------------------------------------------------------------
echo ""
echo -e "${BLUE}━━━ VÉRIFICATION ━━━${NC}"

check() {
  local label="$1"; local pattern="$2"; local file="$3"
  if grep -q "$pattern" "$file" 2>/dev/null; then
    echo -e "   ${GREEN}✔${NC} $label"
  else
    echo -e "   ${RED}✘${NC} $label — MANQUANT"
  fi
}

check "CSS : hero a une background-image" 'reservation-page \.hero \.ph' "$CSS_FILE" 2>/dev/null || true
grep -q "reservation-page .hero .ph" "$CSS_FILE" && grep -A5 "reservation-page .hero .ph" "$CSS_FILE" | grep -q "background-image" \
  && echo -e "   ${GREEN}✔${NC} Hero : background-image présente" \
  || echo -e "   ${YELLOW}⚠${NC} Hero : vérifiez manuellement"

check "CSS : bloc OVERRIDE EXTRAS" 'OVERRIDE EXTRAS IMAGES' "$CSS_FILE"
check "HTML : config ROOM_PHOTOS" 'ROOM_PHOTOS' "$HTML_FILE"
check "HTML : renderRooms() patché" 'ROOM_PHOTOS\[r\.id\]' "$HTML_FILE"

# Compter les overrides extras
N_OVERRIDES=$(grep -c 'exb-card\[data-extra-id' "$CSS_FILE" 2>/dev/null || echo 0)
echo -e "   ${GREEN}ℹ${NC} Overrides extras : $N_OVERRIDES"

# Compter les photos de chambres configurées
N_ROOMS=$(grep -c "':" "$HTML_FILE" 2>/dev/null | head -1 || echo 0)
ROOMS_BLOCK=$(sed -n '/const ROOM_PHOTOS = {/,/};/p' "$HTML_FILE" 2>/dev/null | grep -c "':" || echo 0)
echo -e "   ${GREEN}ℹ${NC} Photos chambres configurées : $ROOMS_BLOCK"

# ---------------------------------------------------------------------------
echo ""
echo -e "${GREEN}✅ TERMINÉ${NC}"
echo -e "${BLUE}💾 Sauvegarde : $BACKUP${NC}"
echo ""
echo -e "${BLUE}📌 POUR MODIFIER LES IMAGES PLUS TARD :${NC}"
echo ""
echo -e "   1. ${YELLOW}Hero Réservation${NC}       → dans $CSS_FILE"
echo -e "      Cherchez : .reservation-page .hero .ph { ... }"
echo -e "      Modifiez : background-image: url('../images/VOTRE-PHOTO.jpg');"
echo ""
echo -e "   2. ${YELLOW}Photos des chambres${NC}     → dans $HTML_FILE"
echo -e "      Cherchez : const ROOM_PHOTOS = { ... };"
echo -e "      Modifiez les chemins ci-dessous."
echo ""
echo -e "   3. ${YELLOW}Photos des extras${NC}       → dans $CSS_FILE"
echo -e "      Cherchez : /* OVERRIDE EXTRAS IMAGES */"
echo -e "      Modifiez les url() dans les blocs .exb-quick et .exb-card."
echo ""
echo -e "${BLUE}🧪 TEST :${NC}"
echo "   1. Ctrl + Shift + R dans le navigateur sur reservation.html"
echo "   2. Vérifiez que le hero a une photo"
echo "   3. Sélectionnez une chambre → sa photo s'affiche"
echo "   4. Ouvrez la pop-up extras → les images s'affichent"
echo ""
echo -e "${BLUE}🔄 ROLLBACK :${NC}"
echo "   cp $BACKUP/$HTML_FILE ."
echo "   cp $BACKUP/$(basename $CSS_FILE) $(dirname $CSS_FILE)/"
echo ""
