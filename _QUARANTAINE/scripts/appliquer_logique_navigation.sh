#!/bin/bash
set -e

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; NC='\033[0m'

echo -e "${BLUE}=================================================${NC}"
echo -e "${BLUE} APPLIQUER LOGIQUE DE NAVIGATION — chambres.html${NC}"
echo -e "${BLUE}=================================================${NC}\n"

BACKUP=".backup_nav_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP"
cp chambres.html "$BACKUP/"
echo -e "${GREEN}📦 Sauvegarde → $BACKUP${NC}\n"

python3 << 'PYEOF'
import re
from pathlib import Path

f = Path('chambres.html')
c = f.read_text(encoding='utf-8')

# ---------- 1. Ajouter l'id à la section CTA ----------
c = c.replace(
    '<section class="booking-section">',
    '<section class="booking-section" id="cta-reservation">',
    1
)

# ---------- 2. Barre de recherche : chaque item devient un lien ancre ----------
c = c.replace(
    '''<div class="search-item">
                <i class="fa-regular fa-calendar"></i>
                <span>6 mars &rarr; 7 mars</span>
            </div>''',
    '''<a href="#cta-reservation" class="search-item">
                <i class="fa-regular fa-calendar"></i>
                <span>6 mars &rarr; 7 mars</span>
            </a>'''
)

c = c.replace(
    '''<div class="search-item">
                <i class="fa-solid fa-user-group"></i>
                <span>1 chambre, 1 adulte</span>
            </div>''',
    '''<a href="#cta-reservation" class="search-item">
                <i class="fa-solid fa-user-group"></i>
                <span>1 chambre, 1 adulte</span>
            </a>'''
)

c = c.replace(
    '''<div class="search-item">
                <i class="fa-solid fa-tag"></i>
                <span>CODE PROMO</span>
            </div>''',
    '''<a href="#cta-reservation" class="search-item">
                <i class="fa-solid fa-tag"></i>
                <span>CODE PROMO</span>
            </a>'''
)

# ---------- 3. Bouton MODIFIER LA RECHERCHE → CTA ----------
c = c.replace(
    '<button class="btn-modifier" type="button">MODIFIER LA RECHERCHE</button>',
    '<a href="#cta-reservation" class="btn-modifier">MODIFIER LA RECHERCHE</a>'
)

# ---------- 4. VOIR TOUS LES TARIFS → reservation.html?room=XXX ----------
def fix_voir_tarifs(match):
    article = match.group(0)
    rid = re.search(r'data-room-id="([^"]+)"', article)
    if not rid:
        return article
    url = f'reservation.html?room={rid.group(1)}'
    return article.replace(
        '<a href="#" class="btn-tarifs">',
        f'<a href="{url}" class="btn-tarifs">'
    )

c = re.sub(r'<article class="room-card[^>]*>.*?</article>', fix_voir_tarifs, c, flags=re.DOTALL)

# ---------- 5. RÉSERVER : data-book-room → réservation directe ----------
def fix_reserver(match):
    article = match.group(0)
    rid = re.search(r'data-room-id="([^"]+)"', article)
    if not rid:
        return article
    return re.sub(
        r'<button class="btn-reserver-room" type="button">RÉSERVER</button>',
        f'<button class="btn-reserver-room" type="button" data-book-room="{rid.group(1)}" data-book-tariff="0">RÉSERVER</button>',
        article
    )

c = re.sub(r'<article class="room-card[^>]*>.*?</article>', fix_reserver, c, flags=re.DOTALL)

f.write_text(c, encoding='utf-8')

print("   ✔ Section CTA identifiée (id=cta-reservation)")
print("   ✔ 3 items de la barre de recherche → ancre CTA")
print("   ✔ MODIFIER LA RECHERCHE → ancre CTA")
print("   ✔ VOIR TOUS LES TARIFS → reservation.html?room=XXX")
print("   ✔ RÉSERVER → data-book-room activé")
PYEOF

# ---------- Vérification ----------
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

check "Ancres #cta-reservation (4 attendues)" 'href="#cta-reservation"' 4
check "id=cta-reservation (1 attendu)" 'id="cta-reservation"' 1
check "VOIR TARIFS → reservation.html?room=" 'href="reservation.html?room=' 3
check "data-book-room (3 attendus)" 'data-book-room=' 3
check "href='#' restants" 'href="#" class="btn-tarifs"' 0

echo ""
echo -e "${GREEN}✅ TERMINÉ${NC}"
echo -e "${BLUE}💾 Sauvegarde : $BACKUP${NC}"
echo ""
echo -e "${BLUE}📌 Test :${NC}"
echo "   1. Ctrl + Shift + R"
echo "   2. Cliquez sur '6 mars → 7 mars' → scroll vers CTA bas"
echo "   3. Cliquez sur 'MODIFIER LA RECHERCHE' → scroll vers CTA bas"
echo "   4. Cliquez sur 'VOIR TOUS LES TARIFS' → reservation.html?room=XXX"
echo "   5. Cliquez sur 'RÉSERVER' → reservation.html?room=XXX&tariff=0"
echo ""
echo -e "${BLUE}🔄 Rollback :${NC}  cp $BACKUP/chambres.html ."
