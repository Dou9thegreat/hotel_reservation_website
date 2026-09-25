#!/usr/bin/env bash
# =============================================================================
# insert_hero_photo.sh
# Insère une photo dans le hero de reservation.html
#
# Usage :
#   ./insert_hero_photo.sh                          → utilise images/hero.png
#   ./insert_hero_photo.sh ma-photo.jpg             → utilise ma-photo.jpg
#   ./insert_hero_photo.sh /chemin/vers/photo.jpg   → copie + utilise la photo
#
# Idempotent : met à jour le CSS même si déjà patché.
# =============================================================================
set -euo pipefail

# ---------- Arguments ----------
PHOTO_ARG="${1:-}"
HTML_FILE="${2:-reservation.html}"
CSS_FILE="${3:-css/reservation.css}"
IMAGES_DIR="images"

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; BLUE='\033[0;34m'; NC='\033[0m'

echo -e "${BLUE}=====================================================${NC}"
echo -e "${BLUE} INSERTION PHOTO HERO — reservation.html${NC}"
echo -e "${BLUE}=====================================================${NC}\n"

# =============================================================================
# 1) VÉRIFICATIONS
# =============================================================================
echo -e "${BLUE}━━━ Vérifications ━━━${NC}"

if [ ! -f "$HTML_FILE" ]; then
  echo -e "${RED}❌ $HTML_FILE introuvable${NC}"; exit 1
fi
if [ ! -f "$CSS_FILE" ]; then
  echo -e "${RED}❌ $CSS_FILE introuvable${NC}"; exit 1
fi
if ! command -v python3 >/dev/null 2>&1; then
  echo -e "${RED}❌ python3 requis${NC}"; exit 1
fi

mkdir -p "$IMAGES_DIR"
echo -e "${GREEN}   ✔ $HTML_FILE${NC}"
echo -e "${GREEN}   ✔ $CSS_FILE${NC}"
echo -e "${GREEN}   ✔ $IMAGES_DIR/${NC}"

# =============================================================================
# 2) DÉTERMINER LA PHOTO À UTILISER
# =============================================================================
echo ""
echo -e "${BLUE}━━━ Photo source ━━━${NC}"

PHOTO_FILENAME=""

if [ -n "$PHOTO_ARG" ]; then
  # L'utilisateur a passé un argument
  if [ -f "$PHOTO_ARG" ]; then
    # C'est un fichier existant → on le copie dans images/
    PHOTO_FILENAME=$(basename "$PHOTO_ARG")
    cp "$PHOTO_ARG" "$IMAGES_DIR/$PHOTO_FILENAME"
    echo -e "${GREEN}   ✔ Photo copiée : $PHOTO_ARG → $IMAGES_DIR/$PHOTO_FILENAME${NC}"
  else
    # C'est peut-être déjà un nom de fichier dans images/
    if [ -f "$IMAGES_DIR/$PHOTO_ARG" ]; then
      PHOTO_FILENAME="$PHOTO_ARG"
      echo -e "${GREEN}   ✔ Photo trouvée dans $IMAGES_DIR/ : $PHOTO_FILENAME${NC}"
    else
      echo -e "${RED}❌ Photo introuvable : $PHOTO_ARG${NC}"
      echo -e "${YELLOW}   Vérifie le chemin ou place la photo dans $IMAGES_DIR/${NC}"
      exit 1
    fi
  fi
else
  # Aucun argument → auto-détection dans images/
  echo -e "${YELLOW}   Aucune photo passée en argument → auto-détection...${NC}"
  for candidate in hero.png hero.jpg hero.jpeg hero.webp hero-reservation.jpg hero-reservation.png ocean.jpg ocean.png piscine.jpg; do
    if [ -f "$IMAGES_DIR/$candidate" ]; then
      PHOTO_FILENAME="$candidate"
      echo -e "${GREEN}   ✔ Trouvée : $IMAGES_DIR/$PHOTO_FILENAME${NC}"
      break
    fi
  done

  if [ -z "$PHOTO_FILENAME" ]; then
    # Chercher n'importe quelle image dans images/
    FOUND=$(find "$IMAGES_DIR" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) 2>/dev/null | head -n 1 || true)
    if [ -n "$FOUND" ]; then
      PHOTO_FILENAME=$(basename "$FOUND")
      echo -e "${YELLOW}   ⚠  Aucune photo 'hero' trouvée — utilisation de : $PHOTO_FILENAME${NC}"
      echo -e "${YELLOW}      (pour choisir : ./insert_hero_photo.sh ma-photo.jpg)${NC}"
    fi
  fi

  if [ -z "$PHOTO_FILENAME" ]; then
    echo -e "${RED}❌ Aucune image trouvée dans $IMAGES_DIR/${NC}"
    echo ""
    echo -e "${YELLOW}📌 Comment faire :${NC}"
    echo "   1. Place une photo dans $IMAGES_DIR/ (ex: hero.png)"
    echo "   2. Relance : ./insert_hero_photo.sh"
    echo "   OU passe directement :"
    echo "      ./insert_hero_photo.sh /chemin/vers/ma-photo.jpg"
    exit 1
  fi
fi

echo -e "${GREEN}   → Photo retenue : $PHOTO_FILENAME${NC}"

# =============================================================================
# 3) SAUVEGARDE
# =============================================================================
BACKUP=".backup_hero_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP"
cp "$HTML_FILE" "$BACKUP/"
cp "$CSS_FILE" "$BACKUP/"
echo ""
echo -e "${GREEN}📦 Sauvegarde → $BACKUP${NC}"

# =============================================================================
# 4) PATCH DU HTML — ajouter la classe hero-photo sur le .ph du hero
# =============================================================================
echo ""
echo -e "${BLUE}━━━ Patch HTML ━━━${NC}"

python3 - "$HTML_FILE" << 'PY_HTML'
import re, sys
from pathlib import Path

path = Path(sys.argv[1])
html = path.read_text(encoding='utf-8')

# Chercher : <div class="ph" aria-hidden="true"></div> UNIQUEMENT dans <section class="hero">
# On cible le premier .ph qui suit <section class="hero">
pattern = re.compile(
    r'(<section\s+class="hero">\s*)'
    r'<div\s+class="ph"(\s+aria-hidden="true")?\s*></div>',
    re.IGNORECASE
)

def repl(m):
    return m.group(1) + '<div class="ph hero-photo" aria-hidden="true"></div>'

new_html, n = pattern.subn(repl, html, count=1)

if n == 0:
    # Peut-être déjà patché
    if 'ph hero-photo' in html:
        print("   ℹ  Classe 'hero-photo' déjà présente dans le HTML")
    else:
        # Fallback : chercher n'importe quel <div class="ph"...> après <section class="hero">
        m = re.search(r'<section\s+class="hero">', html)
        if m:
            after = html[m.end():]
            m2 = re.search(r'<div\s+class="ph"([^>]*)>', after)
            if m2:
                old_tag = m2.group(0)
                new_tag = old_tag.replace('class="ph"', 'class="ph hero-photo"')
                html = html[:m.end()] + after.replace(old_tag, new_tag, 1)
                new_html = html
                print("   ✔ Classe 'hero-photo' ajoutée au .ph (fallback)")
            else:
                print("   ❌ Impossible de trouver le <div class=\"ph\"> du hero")
                sys.exit(1)
        else:
            print("   ❌ <section class=\"hero\"> introuvable")
            sys.exit(1)
else:
    print("   ✔ Classe 'hero-photo' ajoutée au .ph du hero")

path.write_text(new_html, encoding='utf-8')
PY_HTML

# =============================================================================
# 5) PATCH DU CSS — ajouter les règles pour .hero-photo
# =============================================================================
echo ""
echo -e "${BLUE}━━━ Patch CSS ━━━${NC}"

# On calcule le chemin relatif depuis le CSS vers l'image
# css/reservation.css → ../images/hero.png
CSS_DEPTH=$(echo "$CSS_FILE" | awk -F/ '{print NF-1}')
REL_PREFIX=""
for ((i=0; i<CSS_DEPTH; i++)); do
  REL_PREFIX="${REL_PREFIX}../"
done
REL_IMAGE_PATH="${REL_PREFIX}${IMAGES_DIR}/${PHOTO_FILENAME}"

echo -e "${GREEN}   → Chemin CSS : url('$REL_IMAGE_PATH')${NC}"

# Marqueurs pour rendre le script idempotent
MARKER_START="/* ===== HERO PHOTO — INSERTION AUTO ====="
MARKER_END="/* ===== /HERO PHOTO ====="

# Retirer un éventuel ancien bloc
python3 - "$CSS_FILE" "$MARKER_START" "$MARKER_END" << 'PY_STRIP'
import sys
from pathlib import Path
path = Path(sys.argv[1])
css = path.read_text(encoding='utf-8')
start, end = sys.argv[2], sys.argv[3]
if start in css:
    i = css.index(start)
    j = css.index(end) + len(end) if end in css else len(css)
    css = css[:i] + css[j:]
    path.write_text(css.rstrip() + '\n', encoding='utf-8')
PY_STRIP

# Ajouter le nouveau bloc
cat >> "$CSS_FILE" << CSS_BLOCK

$MARKER_START */
/* Photo du hero de la page réservation                                */
/* Généré automatiquement par insert_hero_photo.sh                     */
/* Photo : $PHOTO_FILENAME                                              */

.reservation-page .hero .hero-photo {
    background-image:
        linear-gradient(120deg, rgba(14,74,94,.72), rgba(21,94,117,.40)),
        url('$REL_IMAGE_PATH');
    background-size: cover;
    background-position: center;
    background-repeat: no-repeat;
    background-blend-mode: normal;
}

@media (max-width: 760px) {
    .reservation-page .hero .hero-photo {
        background-position: center 35%;
    }
}

$MARKER_END */
CSS_BLOCK

echo -e "${GREEN}   ✔ Règles CSS ajoutées à $CSS_FILE${NC}"

# =============================================================================
# 6) VÉRIFICATION FINALE
# =============================================================================
echo ""
echo -e "${BLUE}━━━ VÉRIFICATION ━━━${NC}"

check_file() {
  local label="$1"; local file="$2"; local pattern="$3"
  if grep -q "$pattern" "$file" 2>/dev/null; then
    echo -e "   ${GREEN}✔${NC} $label"
  else
    echo -e "   ${RED}✘${NC} $label — MANQUANT"
  fi
}

check_file "HTML : classe 'hero-photo' présente"     "$HTML_FILE" 'ph hero-photo'
check_file "CSS  : bloc '.hero-photo' présent"       "$CSS_FILE" '.reservation-page .hero .hero-photo'
check_file "CSS  : background-image défini"          "$CSS_FILE" "url('$REL_IMAGE_PATH')"
check_file "Image: fichier présent sur disque"       "$IMAGES_DIR/$PHOTO_FILENAME" "."

# Taille de l'image
if [ -f "$IMAGES_DIR/$PHOTO_FILENAME" ]; then
  SIZE=$(du -h "$IMAGES_DIR/$PHOTO_FILENAME" | cut -f1)
  echo -e "   ${GREEN}ℹ${NC} Taille de l'image : $SIZE"
  if [ "$(stat -c%s "$IMAGES_DIR/$PHOTO_FILENAME" 2>/dev/null || stat -f%z "$IMAGES_DIR/$PHOTO_FILENAME" 2>/dev/null || echo 0)" -gt 500000 ]; then
    echo -e "   ${YELLOW}⚠${NC}  Image > 500 Ko → compresse-la sur https://tinypng.com pour un meilleur chargement"
  fi
fi

echo ""
echo -e "${GREEN}✅ TERMINÉ${NC}"
echo -e "${BLUE}💾 Sauvegarde : $BACKUP${NC}"
echo ""
echo -e "${BLUE}📌 TEST :${NC}"
echo "   1. Ouvre $HTML_FILE dans le navigateur"
echo "   2. Ctrl + Shift + R (hard refresh)"
echo "   3. La photo doit apparaître derrière le titre"
echo "   4. Si elle n'apparaît pas :"
echo "      - F12 → Network → Images → cherche $PHOTO_FILENAME"
echo "      - Vérifie qu'il n'y a pas de 404"
echo ""
echo -e "${BLUE}🔄 ROLLBACK :${NC}"
echo "   cp $BACKUP/$(basename $HTML_FILE) ."
echo "   cp $BACKUP/$(basename $CSS_FILE) $(dirname $CSS_FILE)/"
echo ""
echo -e "${BLUE}🎨 CHANGER DE PHOTO PLUS TARD :${NC}"
echo "   ./insert_hero_photo.sh autre-photo.jpg"
echo "   (le script met à jour le CSS automatiquement)"
echo ""
