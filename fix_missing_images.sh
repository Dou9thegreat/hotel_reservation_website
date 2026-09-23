#!/usr/bin/env bash
# =============================================================================
# fix_missing_images.sh
#
# Détecte les images référencées dans css/reservation.css et reservation.html
# qui n'existent PAS physiquement dans images/, puis les remplace par une
# image existante partageant des mots-clés (ex: resto-bar-nuit.jpg → resto-X.jpg).
#
# Fichiers modifiés : css/reservation.css + reservation.html (section ROOM_PHOTOS)
# Idempotent, sauvegarde automatique.
# =============================================================================
set -uo pipefail

CSS_FILE="${1:-css/reservation.css}"
HTML_FILE="${2:-reservation.html}"
IMAGES_DIR="${3:-images}"

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; BLUE='\033[0;34m'; NC='\033[0m'

echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  FIX IMAGES MANQUANTES — Page Réservation${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}\n"

# ---- Vérifications préalables ----
if [ ! -f "$CSS_FILE" ]; then  echo -e "${RED}❌ $CSS_FILE introuvable${NC}"; exit 1; fi
if [ ! -f "$HTML_FILE" ]; then echo -e "${RED}❌ $HTML_FILE introuvable${NC}"; exit 1; fi
if [ ! -d "$IMAGES_DIR" ]; then echo -e "${RED}❌ Dossier $IMAGES_DIR/ introuvable${NC}"; exit 1; fi
if ! command -v python3 >/dev/null 2>&1; then echo -e "${RED}❌ python3 requis${NC}"; exit 1; fi

echo -e "${GREEN}✔ $CSS_FILE${NC}"
echo -e "${GREEN}✔ $HTML_FILE${NC}"
echo -e "${GREEN}✔ $IMAGES_DIR/${NC}\n"

# ---- Sauvegarde ----
BACKUP=".backup_images_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP"
cp "$CSS_FILE" "$BACKUP/"
cp "$HTML_FILE" "$BACKUP/"
echo -e "${GREEN}📦 Sauvegarde → $BACKUP${NC}\n"

# ---- Traitement principal (Python) ----
python3 - "$CSS_FILE" "$HTML_FILE" "$IMAGES_DIR" << 'PY_EOF'
import sys, re
from pathlib import Path

css_path = Path(sys.argv[1])
html_path = Path(sys.argv[2])
images_dir = Path(sys.argv[3])

# ============================================================
# 1. Lister les images disponibles dans images/
# ============================================================
available = set()
for f in images_dir.iterdir():
    if f.is_file() and f.suffix.lower() in {'.jpg', '.jpeg', '.png', '.webp', '.gif', '.svg'}:
        available.add(f.name)

if not available:
    print("❌ Aucune image trouvée dans images/")
    sys.exit(1)

print(f"📁 {len(available)} image(s) disponible(s) dans {images_dir}/")
for name in sorted(available):
    print(f"     • {name}")
print()

# ============================================================
# 2. Trouver un substitut par recouvrement de mots-clés
# ============================================================
def keywords(name):
    """Extrait les mots-clés (longueur >= 3) d'un nom de fichier."""
    base = name.rsplit('.', 1)[0].lower()
    parts = re.split(r'[-_.\s()]+', base)
    return {p for p in parts if len(p) >= 3}

def find_substitute(missing):
    """Cherche une image existante qui partage des mots-clés.
    Retourne None si aucun mot-clé commun (pour ne PAS mettre une image au hasard)."""
    kw_missing = keywords(missing)
    if not kw_missing:
        return None
    best_score = 0
    best = None
    for cand in available:
        score = len(kw_missing & keywords(cand))
        if score > best_score:
            best_score = score
            best = cand
    return best if best_score > 0 else None

# ============================================================
# 3. Parser le CSS — remplacer les url('../images/X') manquantes
# ============================================================
css = css_path.read_text(encoding='utf-8')
# Regex : capture le contenu entre quotes (gère les espaces et parenthèses)
css_pattern = re.compile(r"url\(\s*['\"]\.\./images/([^'\"]+)['\"]\s*\)")

css_changes = []
css_unchanged_missing = []

def replace_css_url(m):
    name = m.group(1)
    if name in available:
        return m.group(0)  # fichier existe → on garde
    sub = find_substitute(name)
    if sub:
        if (name, sub) not in css_changes:
            css_changes.append((name, sub))
        return f"url('../images/{sub}')"
    else:
        if name not in css_unchanged_missing:
            css_unchanged_missing.append(name)
        return m.group(0)

new_css = css_pattern.sub(replace_css_url, css)
if new_css != css:
    css_path.write_text(new_css, encoding='utf-8')

# ============================================================
# 4. Parser le HTML — uniquement la section ROOM_PHOTOS
# ============================================================
html = html_path.read_text(encoding='utf-8')
html_changes = []

ro_match = re.search(r'(var|const)\s+ROOM_PHOTOS\s*=\s*\{', html)
if ro_match:
    start = ro_match.end()
    # Trouver la fermeture '};'
    end = html.find('};', start)
    if end < 0:
        end = html.find('}', start)
    if end > start:
        segment = html[start:end]

        def replace_room(m):
            name = m.group(1).replace('images/', '', 1)
            if name in available:
                return m.group(0)
            sub = find_substitute(name)
            if sub:
                if (name, sub) not in html_changes:
                    html_changes.append((name, sub))
                return f"'images/{sub}'"
            return m.group(0)

        new_segment = re.sub(r"'(images/[^']+)'", replace_room, segment)
        if new_segment != segment:
            html = html[:start] + new_segment + html[end:]
            html_path.write_text(html, encoding='utf-8')
else:
    print("⚠  Aucun bloc ROOM_PHOTOS trouvé dans le HTML.\n")

# ============================================================
# 5. Rapport final
# ============================================================
print("─── Corrections CSS (reservation.css) ───")
if css_changes:
    for orig, sub in css_changes:
        print(f"   ✔ {orig}  →  {sub}")
else:
    print("   (aucune image manquante détectée dans le CSS)")

if css_unchanged_missing:
    print(f"   ⚠  {len(css_unchanged_missing)} image(s) sans substitut (laissée(s) telle(s)) :")
    for name in css_unchanged_missing:
        print(f"       • {name}")

print()
print("─── Corrections HTML (ROOM_PHOTOS) ───")
if html_changes:
    for orig, sub in html_changes:
        print(f"   ✔ {orig}  →  {sub}")
else:
    print("   (aucune image manquante détectée dans ROOM_PHOTOS)")

total = len(css_changes) + len(html_changes)
print()
if total == 0:
    print("ℹ  Aucune modification appliquée.")
else:
    print(f"✅ {total} référence(s) mise(s) à jour.")
PY_EOF

EXIT=$?

# ---- Gestion d'erreur ----
if [ "$EXIT" -ne 0 ]; then
    echo ""
    echo -e "${RED}⚠️  Erreur (code $EXIT) — les fichiers sont intacts.${NC}"
    echo -e "${YELLOW}   Backup : $BACKUP${NC}"
    exit "$EXIT"
fi

echo ""
echo -e "${GREEN}═══════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}  ✅ TERMINÉ${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════════${NC}"
echo -e "💾 Sauvegarde : $BACKUP"
echo ""
echo -e "${BLUE}🧪 Test :${NC}"
echo "   1. Ctrl + Shift + R sur reservation.html"
echo "   2. La pop-up Extras doit afficher des photos (plus de beige)"
echo "   3. Le hero doit afficher une image"
echo ""
echo -e "${BLUE}🔄 ROLLBACK :${NC}"
echo "   cp $BACKUP/$(basename "$CSS_FILE") $(dirname "$CSS_FILE")/"
echo "   cp $BACKUP/$(basename "$HTML_FILE") ."
echo ""
