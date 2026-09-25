#!/usr/bin/env bash
# =============================================================================
# improve_homepage.sh
#
# Améliore la page d'accueil (index.html) et corrige les liens morts :
#   1. Ajoute les ancres manquantes dans chambres.html
#   2. Corrige les liens des cartes Expériences (Beach Club)
#   3. Optimise les images (loading="lazy", alt, decoding)
#   4. Ajoute un badge "Le + demandé" sur la chambre Deluxe
#   5. Ajoute un bouton "Réserver" sur chaque carte chambre
#   6. Améliore le CTA "DÉCOUVRIR CETTE CHAMBRE"
#   7. Diagnostic complet des images manquantes
#
# Idempotent, sauvegarde automatique.
# =============================================================================
set -uo pipefail

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; BLUE='\033[0;34m'; NC='\033[0m'

BACKUP=".backup_home_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP"
for f in index.html chambres.html; do
    [ -f "$f" ] && cp "$f" "$BACKUP/"
done

echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  AMÉLIORATION PAGE D'ACCUEIL + CORRECTIONS${NC}"
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

# Mapping data-room-id → ancre à ajouter
anchors = {
    'deluxe-ocean':       'chambre-deluxe',
    'suite-ambassadeur':  'suite',
    'superieure-ocean':   'chambre-superieure',
}

for room_id, anchor in anchors.items():
    # Chercher <article ... data-room-id="XXX"> sans id
    pattern = re.compile(
        r'(<article\s+class="[^"]*"\s+)data-room-id="' + re.escape(room_id) + r'"'
    )
    def add_id(m):
        prefix = m.group(1)
        # Éviter de dupliquer
        if 'id="' in prefix:
            return m.group(0)
        return prefix + 'id="' + anchor + '" data-room-id="' + room_id + '"'
    html, n = pattern.subn(add_id, html, count=1)
    if n:
        print(f"   ✔ id=\"{anchor}\" ajouté (room {room_id})")

if html != original:
    p.write_text(html, encoding='utf-8')
else:
    print("   ℹ  Ancres déjà présentes ou non trouvées")
PY_EOF

# =============================================================================
# 2. CORRIGER LES LIENS DES EXPÉRIENCES DANS index.html
# =============================================================================
echo ""
echo -e "${BLUE}━━━ 2. Liens Expériences dans index.html ━━━${NC}"

python3 << 'PY_EOF'
import re
from pathlib import Path

p = Path('index.html')
if not p.exists():
    print("   ❌ index.html introuvable")
    exit()

html = p.read_text(encoding='utf-8')
original = html

# Corriger : Teranga Beach Club → experiences-restaurant.html#beach-club
pattern = re.compile(
    r'(<a\s+href="experiences-piscine\.html"\s+class="exp-btn[^"]*">VOIR LE BEACH CLUB)'
)
html, n = pattern.subn(
    r'<a href="experiences-restaurant.html#beach-club" class="exp-btn exp-btn--outline">VOIR LE BEACH CLUB',
    html, count=1
)
if n:
    print("   ✔ Lien 'VOIR LE BEACH CLUB' → experiences-restaurant.html#beach-club")
else:
    print("   ℹ  Lien Beach Club déjà correct")

if html != original:
    p.write_text(html, encoding='utf-8')
PY_EOF

# =============================================================================
# 3. AJOUTER lazy loading + alt améliorés aux images d'index.html
# =============================================================================
echo ""
echo -e "${BLUE}━━━ 3. Optimisation des images ━━━${NC}"

python3 << 'PY_EOF'
import re
from pathlib import Path

p = Path('index.html')
html = p.read_text(encoding='utf-8')
original = html
changes = 0

# Ajouter loading="lazy" + decoding="async" sur les <img> qui n'en ont pas
def add_lazy(m):
    global changes
    tag = m.group(0)
    # Ne pas toucher aux images du hero (déjà chargées en priorité)
    if 'hero-slider' in m.string[max(0, m.start()-200):m.start()]:
        return tag
    # Éviter les doublons
    if 'loading=' in tag:
        return tag
    changes += 1
    # Ajouter avant le >
    return tag.rstrip('>').rstrip() + ' loading="lazy" decoding="async">'

# Uniquement les <img> (pas les <link> ou <source>)
html = re.sub(r'<img\s[^>]*?>', add_lazy, html)

print(f"   ✔ {changes} image(s) optimisée(s) (lazy loading)")

if html != original:
    p.write_text(html, encoding='utf-8')
PY_EOF

# =============================================================================
# 4. AJOUTER UN BADGE "Le + demandé" sur la chambre Deluxe
# =============================================================================
echo ""
echo -e "${BLUE}━━━ 4. Badges sur les chambres ━━━${NC}"

python3 << 'PY_EOF'
from pathlib import Path

p = Path('index.html')
html = p.read_text(encoding='utf-8')
original = html
changes = []

# Badge sur la première chambre (Deluxe)
old_deluxe = '''<article class="room-card gsap-reveal" id="chambre-deluxe">
                        <div class="room-image">'''
new_deluxe = '''<article class="room-card gsap-reveal" id="chambre-deluxe">
                        <div class="room-image">
                            <span class="room-badge room-badge--popular">Le + demandé</span>'''
if old_deluxe in html and 'room-badge--popular' not in html:
    html = html.replace(old_deluxe, new_deluxe, 1)
    changes.append("Badge 'Le + demandé' sur Deluxe")

# Badge sur la Suite
old_suite = '''<article class="room-card room-card--reverse gsap-reveal" id="suite">
                        <div class="room-image">'''
new_suite = '''<article class="room-card room-card--reverse gsap-reveal" id="suite">
                        <div class="room-image">
                            <span class="room-badge room-badge--premium">Premium</span>'''
if old_suite in html and 'room-badge--premium' not in html:
    html = html.replace(old_suite, new_suite, 1)
    changes.append("Badge 'Premium' sur Suite")

# Badge "Meilleur prix" sur Supérieure
old_sup = '''<article class="room-card gsap-reveal" id="chambre-superieure">
                        <div class="room-image">'''
new_sup = '''<article class="room-card gsap-reveal" id="chambre-superieure">
                        <div class="room-image">
                            <span class="room-badge room-badge--value">Meilleur prix</span>'''
if old_sup in html and 'room-badge--value' not in html:
    html = html.replace(old_sup, new_sup, 1)
    changes.append("Badge 'Meilleur prix' sur Supérieure")

if changes:
    for c in changes:
        print(f"   ✔ {c}")
    p.write_text(html, encoding='utf-8')
else:
    print("   ℹ  Badges déjà présents")
PY_EOF

# =============================================================================
# 5. AJOUTER UN BOUTON "RÉSERVER" à côté de "DÉCOUVRIR" sur chaque carte
# =============================================================================
echo ""
echo -e "${BLUE}━━━ 5. Bouton Réserver sur chaque chambre ━━━${NC}"

python3 << 'PY_EOF'
from pathlib import Path
import re

p = Path('index.html')
html = p.read_text(encoding='utf-8')
original = html

# Mapping chambre → data-book-room
room_map = {
    'chambre-deluxe':      'deluxe-ocean',
    'suite':               'suite-ambassadeur',
    'chambre-superieure':  'superieure-ocean',
}

# Pour chaque carte chambre, ajouter un bouton "Réserver" à côté de "Découvrir"
for anchor, room_id in room_map.items():
    # Chercher la ligne avec le bouton Découvrir de la bonne chambre
    # On cherche l'article par son id
    pattern = re.compile(
        r'(id="' + re.escape(anchor) + r'".*?<a\s+href="chambres\.html#[^"]*"\s+class="room-btn">[^<]*</a>)',
        re.DOTALL
    )
    def add_book_btn(m):
        existing = m.group(1)
        if 'data-book-room' in m.string[max(0, m.start()-500):m.start()]:
            return existing  # déjà ajouté
        new_btn = '\n                            <a href="reservation.html?room=' + room_id + '" class="room-btn room-btn--book">RÉSERVER <i class="fa-solid fa-arrow-right"></i></a>'
        return existing + new_btn
    html, n = pattern.subn(add_book_btn, html, count=1)
    if n:
        print(f"   ✔ Bouton Réserver ajouté sur '{anchor}'")

if html != original:
    p.write_text(html, encoding='utf-8')
PY_EOF

# =============================================================================
# 6. STYLES POUR LES BADGES ET BOUTONS (à la fin de index.css)
# =============================================================================
echo ""
echo -e "${BLUE}━━━ 6. Styles dans index.css ━━━${NC}"

cat >> css/index.css << 'CSS_EOF'

/* ============================================================= */
/* 12. AMÉLIORATIONS PAGE D'ACCUEIL (badges + boutons)           */
/* ============================================================= */

/* Badges sur les cartes chambres */
.room-image {
    position: relative;
}
.room-badge {
    position: absolute;
    top: 20px;
    left: 20px;
    z-index: 3;
    padding: 8px 16px;
    border-radius: 30px;
    font-family: 'Montserrat', sans-serif;
    font-size: 10px;
    font-weight: 800;
    letter-spacing: 1.2px;
    text-transform: uppercase;
    color: #fff;
    box-shadow: 0 6px 18px rgba(0,0,0,0.25);
    backdrop-filter: blur(6px);
    -webkit-backdrop-filter: blur(6px);
}
.room-badge--popular {
    background: linear-gradient(135deg, #FF7A3D 0%, #E85D2C 100%);
}
.room-badge--premium {
    background: linear-gradient(135deg, #C59A67 0%, #A47B3E 100%);
}
.room-badge--value {
    background: linear-gradient(135deg, #38E28F 0%, #28B876 100%);
    color: #0A1E2D;
}
.room-badge::before {
    content: "★";
    margin-right: 6px;
    font-size: 9px;
}

/* Groupe de boutons sur les cartes chambres */
.room-content .room-btn {
    margin-right: 10px;
    margin-top: 8px;
}
.room-btn--book {
    background: transparent;
    border: 1.5px solid #C59A67;
    color: #C59A67;
    box-shadow: none;
}
.room-btn--book:hover {
    background: #C59A67;
    color: #fff;
    transform: translateY(-2px);
    box-shadow: 0 6px 16px rgba(197, 154, 103, 0.4);
}
.room-btn--book i {
    font-size: 10px;
    transition: transform 0.25s ease;
}
.room-btn--book:hover i {
    transform: translateX(3px);
}

/* Ajustement mobile */
@media (max-width: 768px) {
    .room-content .room-btn {
        display: block;
        width: 100%;
        text-align: center;
        margin-right: 0;
        margin-bottom: 10px;
    }
}

/* Amélioration des cartes expériences */
.exp-card {
    transition: transform 0.4s ease, box-shadow 0.4s ease;
    border-radius: 12px;
    overflow: hidden;
    background: #fff;
    padding: 0 0 20px;
}
.exp-card:hover {
    transform: translateY(-6px);
    box-shadow: 0 20px 50px rgba(0, 0, 0, 0.12);
}
.exp-img-wrapper {
    position: relative;
    border-radius: 12px 12px 0 0;
    overflow: hidden;
    margin-bottom: 20px;
}
.exp-img-wrapper::after {
    content: "";
    position: absolute;
    inset: 0;
    background: linear-gradient(180deg, transparent 50%, rgba(0,0,0,0.3));
    pointer-events: none;
    opacity: 0;
    transition: opacity 0.4s ease;
}
.exp-card:hover .exp-img-wrapper::after {
    opacity: 1;
}
.exp-title,
.exp-desc,
.exp-btn {
    padding-left: 24px;
    padding-right: 24px;
}

/* Badges "populaire" sur certaines cartes expériences */
.exp-card--popular {
    position: relative;
}
.exp-card--popular::before {
    content: "★ POPULAIRE";
    position: absolute;
    top: 16px;
    right: 16px;
    z-index: 3;
    background: linear-gradient(135deg, #FF7A3D, #E85D2C);
    color: #fff;
    font-family: 'Montserrat', sans-serif;
    font-size: 9px;
    font-weight: 800;
    letter-spacing: 1.2px;
    padding: 6px 12px;
    border-radius: 20px;
    box-shadow: 0 6px 15px rgba(232, 93, 44, 0.35);
}
CSS_EOF

echo -e "${GREEN}   ✔ Styles ajoutés à css/index.css${NC}"

# =============================================================================
# 7. AJOUTER LES BADGES "POPULAIRE" AUX CARTES EXPÉRIENCES
# =============================================================================
echo ""
echo -e "${BLUE}━━━ 7. Badges Populaires sur Expériences ━━━${NC}"

python3 << 'PY_EOF'
from pathlib import Path

p = Path('index.html')
html = p.read_text(encoding='utf-8')
original = html
changes = []

# Piscine + Plage
old = '<article class="exp-card gsap-reveal">\n                        <div class="exp-img-wrapper">\n                            <img src="images/exp-piscine.jpeg"'
new = '<article class="exp-card exp-card--popular gsap-reveal">\n                        <div class="exp-img-wrapper">\n                            <img src="images/exp-piscine.jpeg"'
if old in html and 'exp-card--popular' not in html:
    html = html.replace(old, new, 1)
    changes.append("Badge Populaire → Piscine & Plage")

# Pullman Spa
old2 = '<article class="exp-card gsap-reveal">\n                        <div class="exp-img-wrapper">\n                            <img src="images/exp-spa.jpeg"'
new2 = '<article class="exp-card exp-card--popular gsap-reveal">\n                        <div class="exp-img-wrapper">\n                            <img src="images/exp-spa.jpeg"'
if old2 in html:
    html = html.replace(old2, new2, 1)
    changes.append("Badge Populaire → Pullman Spa")

if changes:
    for c in changes:
        print(f"   ✔ {c}")
    p.write_text(html, encoding='utf-8')
else:
    print("   ℹ  Badges déjà présents ou non trouvés")
PY_EOF

# =============================================================================
# 8. DIAGNOSTIC COMPLET DES IMAGES DANS index.html
# =============================================================================
echo ""
echo -e "${BLUE}━━━ 8. Diagnostic des images ━━━${NC}"

python3 << 'PY_EOF'
import re
from pathlib import Path

html = Path('index.html').read_text(encoding='utf-8')

# Trouver tous les src="images/..."
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
    print("\n   ❌ Images MANQUANTES dans index.html :")
    for img in missing:
        print(f"      • {img}")
    print("\n   💡 Suggestions : copiez ces fichiers dans images/ ou changez les chemins.")
else:
    print("\n   🎉 Toutes les images sont présentes !")
PY_EOF

# =============================================================================
# 9. VÉRIFICATION FINALE
# =============================================================================
echo ""
echo -e "${BLUE}━━━ 9. Vérification finale ━━━${NC}"

check() {
    local label="$1"; local pattern="$2"; local file="$3"
    if grep -q "$pattern" "$file" 2>/dev/null; then
        echo -e "   ${GREEN}✔${NC} $label"
    else
        echo -e "   ${YELLOW}⚠${NC}  $label"
    fi
}

check "chambres.html : ancre #chambre-deluxe"  'id="chambre-deluxe"'  chambres.html
check "chambres.html : ancre #suite"           'id="suite"'           chambres.html
check "chambres.html : ancre #chambre-superieure" 'id="chambre-superieure"' chambres.html
check "index.html : lien Beach Club corrigé"   'experiences-restaurant.html#beach-club' index.html
check "index.html : badge 'Le + demandé'"      'room-badge--popular'  index.html
check "index.html : bouton Réserver chambre"   'room-btn--book'       index.html
check "index.html : badges populaires exp."    'exp-card--popular'    index.html

echo ""
echo -e "${GREEN}═══════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}  ✅ TERMINÉ${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BLUE}🧪 TEST :${NC}"
echo "   1. Ctrl + Shift + R sur index.html"
echo "   2. Cliquez sur 'DÉCOUVRIR CETTE CHAMBRE' → doit scroller vers la chambre"
echo "   3. Vérifiez les badges sur les cartes chambres et expériences"
echo "   4. Cliquez sur 'VOIR LE BEACH CLUB' → doit aller vers restaurant#beach-club"
echo ""
echo -e "${BLUE}🔄 ROLLBACK :${NC}"
echo "   cp $BACKUP/index.html ."
echo "   cp $BACKUP/chambres.html ."
echo ""
