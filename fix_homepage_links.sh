#!/usr/bin/env bash
# =============================================================================
# fix_homepage_links.sh
#
# Corrige UNIQUEMENT les liens et problèmes fonctionnels :
#   1. Ajoute les ancres manquantes dans chambres.html (#chambre-deluxe, etc.)
#   2. Corrige le lien "VOIR LE BEACH CLUB" dans index.html
#   3. Ajoute loading="lazy" sur les images d'index.html (performance)
#   4. Diagnostic des images manquantes
#
# ❌ AUCUNE modification de design (badges, boutons, styles...)
#
# Idempotent, sauvegarde automatique.
# =============================================================================
set -uo pipefail

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; BLUE='\033[0;34m'; NC='\033[0m'

BACKUP=".backup_links_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP"
for f in index.html chambres.html; do
    [ -f "$f" ] && cp "$f" "$BACKUP/"
done

echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  CORRECTION DES LIENS — Page d'accueil + Chambres${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}\n"
echo -e "${GREEN}📦 Sauvegarde → $BACKUP${NC}\n"

# =============================================================================
# 1. AJOUTER LES ANCRES MANQUANTES DANS chambres.html
# =============================================================================
echo -e "${BLUE}━━━ 1. Ancres dans chambres.html ━━━${NC}"

python3 << 'PY_EOF'
import re
from pathlib import Path

p = Path('chambres.html')
if not p.exists():
    print("   ❌ chambres.html introuvable")
    exit()

html = p.read_text(encoding='utf-8')
original = html

anchors = {
    'deluxe-ocean':      'chambre-deluxe',
    'suite-ambassadeur': 'suite',
    'superieure-ocean':  'chambre-superieure',
}

for room_id, anchor in anchors.items():
    # Vérifier si l'ancre existe déjà
    if f'id="{anchor}"' in html:
        print(f"   ℹ  id=\"{anchor}\" déjà présent")
        continue

    pattern = re.compile(
        r'(<article\s+class="[^"]*"\s+)data-room-id="' + re.escape(room_id) + r'"'
    )
    def add_id(m):
        prefix = m.group(1)
        return prefix + 'id="' + anchor + '" data-room-id="' + room_id + '"'
    html, n = pattern.subn(add_id, html, count=1)
    if n:
        print(f"   ✔ id=\"{anchor}\" ajouté (room {room_id})")
    else:
        print(f"   ⚠  Room {room_id} introuvable dans chambres.html")

if html != original:
    p.write_text(html, encoding='utf-8')
PY_EOF

# =============================================================================
# 2. CORRIGER LE LIEN "VOIR LE BEACH CLUB" DANS index.html
# =============================================================================
echo ""
echo -e "${BLUE}━━━ 2. Lien Beach Club dans index.html ━━━${NC}"

python3 << 'PY_EOF'
import re
from pathlib import Path

p = Path('index.html')
if not p.exists():
    print("   ❌ index.html introuvable")
    exit()

html = p.read_text(encoding='utf-8')
original = html

# Le Beach Club est un restaurant, pas un spa
# Chercher le lien qui contient "VOIR LE BEACH CLUB"
pattern = re.compile(
    r'<a\s+href="experiences-piscine\.html"(\s+class="[^"]*")>VOIR LE BEACH CLUB',
    re.DOTALL
)
def fix_link(m):
    classes = m.group(1)
    return f'<a href="experiences-restaurant.html#beach-club"{classes}>VOIR LE BEACH CLUB'

html, n = pattern.subn(fix_link, html, count=1)
if n:
    print("   ✔ Lien 'VOIR LE BEACH CLUB' → experiences-restaurant.html#beach-club")
else:
    # Le lien est peut-être déjà correct
    if 'experiences-restaurant.html#beach-club' in html:
        print("   ℹ  Lien déjà correct")
    else:
        print("   ⚠  Lien 'VOIR LE BEACH CLUB' introuvable")

if html != original:
    p.write_text(html, encoding='utf-8')
PY_EOF

# =============================================================================
# 3. AJOUTER loading="lazy" SUR LES IMAGES D'index.html (sans changer le design)
# =============================================================================
echo ""
echo -e "${BLUE}━━━ 3. Optimisation du chargement des images ━━━${NC}"

python3 << 'PY_EOF'
import re
from pathlib import Path

p = Path('index.html')
html = p.read_text(encoding='utf-8')
original = html
changes = 0

# Trouver les positions des images du hero (à ne pas toucher)
hero_positions = []
hero_pattern = re.compile(r'<section\s+class="hero"[^>]*>.*?</section>', re.DOTALL)
for m in hero_pattern.finditer(html):
    hero_positions.append((m.start(), m.end()))

def is_in_hero(pos):
    return any(start <= pos <= end for start, end in hero_positions)

# Ajouter loading="lazy" + decoding="async" sur les <img> hors hero
def add_lazy(m):
    global changes
    tag = m.group(0)
    pos = m.start()
    # Ne pas toucher aux images du hero
    if is_in_hero(pos):
        return tag
    # Éviter les doublons
    if 'loading=' in tag:
        return tag
    changes += 1
    return tag.rstrip('>').rstrip() + ' loading="lazy" decoding="async">'

html = re.sub(r'<img\s[^>]*?>', add_lazy, html)

print(f"   ✔ {changes} image(s) optimisée(s)")
if html != original:
    p.write_text(html, encoding='utf-8')
PY_EOF

# =============================================================================
# 4. DIAGNOSTIC DES IMAGES DANS index.html
# =============================================================================
echo ""
echo -e "${BLUE}━━━ 4. Diagnostic des images ━━━${NC}"

python3 << 'PY_EOF'
import re
from pathlib import Path

html = Path('index.html').read_text(encoding='utf-8')

pattern = re.compile(r'src="(images/[^"]+)"')
images = sorted(set(pattern.findall(html)))

images_dir = Path('images')
missing = []
present = []

for img in images:
    name = img.replace('images/', '', 1)
    if (images_dir / name).exists():
        present.append(img)
    else:
        missing.append(img)

print(f"   📊 Total : {len(images)} images référencées")
print(f"   ✅ Présentes : {len(present)}")
print(f"   ❌ Manquantes : {len(missing)}")

if missing:
    print("\n   ❌ Images manquantes dans index.html :")
    for img in missing:
        print(f"      • {img}")

    # Sauvegarder dans un fichier pour référence
    Path('.missing_images.txt').write_text('\n'.join(missing), encoding='utf-8')
    print(f"\n   💡 Liste sauvegardée dans .missing_images.txt")
else:
    print("\n   🎉 Toutes les images sont présentes !")
PY_EOF

# =============================================================================
# 5. VÉRIFICATION FINALE
# =============================================================================
echo ""
echo -e "${BLUE}━━━ 5. Vérification finale ━━━${NC}"

check() {
    local label="$1"; local pattern="$2"; local file="$3"
    if grep -q "$pattern" "$file" 2>/dev/null; then
        echo -e "   ${GREEN}✔${NC} $label"
    else
        echo -e "   ${YELLOW}⚠${NC}  $label"
    fi
}

check "chambres.html : ancre #chambre-deluxe"      'id="chambre-deluxe"'      chambres.html
check "chambres.html : ancre #suite"               'id="suite"'               chambres.html
check "chambres.html : ancre #chambre-superieure"  'id="chambre-superieure"'  chambres.html
check "index.html : lien Beach Club corrigé"       'experiences-restaurant.html#beach-club'  index.html

echo ""
echo -e "${GREEN}═══════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}  ✅ TERMINÉ${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BLUE}🧪 TEST :${NC}"
echo "   1. Ctrl + Shift + R sur index.html"
echo "   2. Cliquez sur 'DÉCOUVRIR CETTE CHAMBRE' (chaque carte)"
echo "      → Doit scroller vers la chambre correspondante sur chambres.html"
echo "   3. Cliquez sur 'VOIR LE BEACH CLUB'"
echo "      → Doit aller vers experiences-restaurant.html#beach-club"
echo ""
echo -e "${BLUE}🔄 ROLLBACK :${NC}"
echo "   cp $BACKUP/index.html ."
echo "   cp $BACKUP/chambres.html ."
echo ""
