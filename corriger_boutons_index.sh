#!/usr/bin/env bash
set -euo pipefail

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; BLUE='\033[0;34m'; NC='\033[0m'

echo -e "${BLUE}=====================================================${NC}"
echo -e "${BLUE} CORRECTION DES BOUTONS — index.html${NC}"
echo -e "${BLUE}====================================================${NC}\n"

HTML="index.html"
[ -f "$HTML" ] || { echo -e "${RED}❌ $HTML introuvable${NC}"; exit 1; }

BACKUP=".backup_idx_btns_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP"
cp "$HTML" "$BACKUP/"
echo -e "${GREEN}📦 Sauvegarde → $BACKUP${NC}\n"

# ============================================================
# Application des corrections via Python (regex fiables)
# ============================================================
echo -e "${BLUE}━━━ Application des corrections ━━━${NC}"

python3 - "$HTML" << 'PY_EOF'
import re
import sys
from pathlib import Path

f = Path(sys.argv[1])
c = f.read_text(encoding='utf-8')

changes = 0

def replace(old, new, count=1, label=''):
    global c, changes
    if old in c:
        c = c.replace(old, new, count)
        changes += count
        print(f"   ✔ {label}")
    else:
        print(f"   ⚠  Pattern non trouvé : {label}")

# ============================================================
# 1. Ajouter l'id "about" à la section Bienvenue
# ============================================================
replace(
    '<section class="about-section gsap-reveal">',
    '<section class="about-section gsap-reveal" id="about">',
    1,
    'id="about" ajouté à la section Bienvenue'
)

# ============================================================
# 2. Hero "DÉCOUVRIR L'HÔTEL" → ancre #about
# ============================================================
replace(
    '<a href="#" class="discover">DÉCOUVRIR L\'HÔTEL <span class="chevron-right">›</span></a>',
    '<a href="#about" class="discover">DÉCOUVRIR L\'HÔTEL <span class="chevron-right">›</span></a>',
    1,
    'Hero : DÉCOUVRIR L\'HÔTEL → #about'
)

# ============================================================
# 3. Section About "DÉCOUVRIR L'HÔTEL >" → ancre #rooms
# ============================================================
replace(
    '<a href="#" class="about-btn">DÉCOUVRIR L\'HÔTEL &gt;</a>',
    '<a href="#rooms" class="about-btn">DÉCOUVRIR L\'HÔTEL &gt;</a>',
    1,
    'About : DÉCOUVRIR L\'HÔTEL → #rooms'
)

# ============================================================
# 4. Ajouter les id aux 3 cartes chambres (pour ancres ciblées)
# ============================================================
# Deluxe (1ère room-card)
replace(
    '''<article class="room-card gsap-reveal">
                        <div class="room-image">
                            <img src="images/room-deluxe.png" alt="Chambre Deluxe Vue Océan">''',
    '''<article class="room-card gsap-reveal" id="chambre-deluxe">
                        <div class="room-image">
                            <img src="images/room-deluxe.png" alt="Chambre Deluxe Vue Océan">''',
    1,
    'id="chambre-deluxe" ajouté'
)

# Suite (2ème room-card)
replace(
    '''<article class="room-card room-card--reverse gsap-reveal">
                        <div class="room-image">
                            <img src="images/room-suite.png" alt="Suite Ambassadeur Pullman">''',
    '''<article class="room-card room-card--reverse gsap-reveal" id="suite">
                        <div class="room-image">
                            <img src="images/room-suite.png" alt="Suite Ambassadeur Pullman">''',
    1,
    'id="suite" ajouté'
)

# Supérieure (3ème room-card)
replace(
    '''<article class="room-card gsap-reveal">
                        <div class="room-image">
                            <img src="images/room-superior.png" alt="Chambre Supérieure Urbaine">''',
    '''<article class="room-card gsap-reveal" id="chambre-superieure">
                        <div class="room-image">
                            <img src="images/room-superior.png" alt="Chambre Supérieure Urbaine">''',
    1,
    'id="chambre-superieure" ajouté'
)

# ============================================================
# 5. Les 3 boutons "DÉCOUVRIR CETTE CHAMBRE" → chambres.html#...
# ============================================================
# Deluxe
replace(
    '''<a href="#" class="room-btn">DÉCOUVRIR CETTE CHAMBRE &rarr;</a>
                        </div>
                    </article>

                    <!-- 02 SUITE -->''',
    '''<a href="chambres.html#chambre-deluxe" class="room-btn">DÉCOUVRIR CETTE CHAMBRE &rarr;</a>
                        </div>
                    </article>

                    <!-- 02 SUITE -->''',
    1,
    'Room Deluxe → chambres.html#chambre-deluxe'
)

# Suite
replace(
    '''<a href="#" class="room-btn">DÉCOUVRIR CETTE CHAMBRE &rarr;</a>
                        </div>
                    </article>

                    <!-- 03 SUPÉRIEURE -->''',
    '''<a href="chambres.html#suite" class="room-btn">DÉCOUVRIR CETTE CHAMBRE &rarr;</a>
                        </div>
                    </article>

                    <!-- 03 SUPÉRIEURE -->''',
    1,
    'Room Suite → chambres.html#suite'
)

# Supérieure (le dernier, avant la bannière)
replace(
    '''<a href="#" class="room-btn">DÉCOUVRIR CETTE CHAMBRE &rarr;</a>
                        </div>
                    </article>
                </div>''',
    '''<a href="chambres.html#chambre-superieure" class="room-btn">DÉCOUVRIR CETTE CHAMBRE &rarr;</a>
                        </div>
                    </article>
                </div>''',
    1,
    'Room Supérieure → chambres.html#chambre-superieure'
)

# ============================================================
# 6. Bannière "RÉSERVER UNE EXPÉRIENCE" → chambres.html
# ============================================================
replace(
    '<a href="#" class="banner-btn">RÉSERVER UNE EXPÉRIENCE &rarr;</a>',
    '<a href="chambres.html" class="banner-btn">RÉSERVER UNE EXPÉRIENCE &rarr;</a>',
    1,
    'Bannière → chambres.html'
)

# ============================================================
# 7. Les 6 cartes Expériences
# ============================================================

# Piscine & Plage Privée → experiences-piscine.html
replace(
    '''<a href="#" class="exp-btn exp-btn--outline">RÉSERVER UNE EXPÉRIENCE</a>
                    </article>

                    <article class="exp-card gsap-reveal">
                        <div class="exp-img-wrapper">
                            <img src="images/exp-spa.jpeg"''',
    '''<a href="experiences-piscine.html" class="exp-btn exp-btn--outline">RÉSERVER UNE EXPÉRIENCE</a>
                    </article>

                    <article class="exp-card gsap-reveal">
                        <div class="exp-img-wrapper">
                            <img src="images/exp-spa.jpeg"''',
    1,
    'Exp Piscine → experiences-piscine.html'
)

# Pullman Spa → experiences-piscine.html
replace(
    '''<a href="#" class="exp-btn exp-btn--outline">DÉCOUVRIR LE SPA</a>
                    </article>

                    <article class="exp-card gsap-reveal">
                        <div class="exp-img-wrapper">
                            <img src="images/exp-beachclub.jpeg"''',
    '''<a href="experiences-piscine.html" class="exp-btn exp-btn--outline">DÉCOUVRIR LE SPA</a>
                    </article>

                    <article class="exp-card gsap-reveal">
                        <div class="exp-img-wrapper">
                            <img src="images/exp-beachclub.jpeg"''',
    1,
    'Exp Spa → experiences-piscine.html'
)

# Beach Club → experiences-piscine.html
replace(
    '''<a href="#" class="exp-btn exp-btn--outline">VOIR LE BEACH CLUB</a>
                    </article>

                    <article class="exp-card gsap-reveal">
                        <div class="exp-img-wrapper">
                            <img src="images/exp-lounge.jpeg"''',
    '''<a href="experiences-piscine.html" class="exp-btn exp-btn--outline">VOIR LE BEACH CLUB</a>
                    </article>

                    <article class="exp-card gsap-reveal">
                        <div class="exp-img-wrapper">
                            <img src="images/exp-lounge.jpeg"''',
    1,
    'Exp Beach Club → experiences-piscine.html'
)

# Lounge → experiences-restaurant.html
replace(
    '''<a href="#" class="exp-btn exp-btn--outline">DÉCOUVRIR LE LOUNGE</a>
                    </article>

                    <article class="exp-card gsap-reveal">
                        <div class="exp-img-wrapper">
                            <img src="images/exp-art.jpeg"''',
    '''<a href="experiences-restaurant.html" class="exp-btn exp-btn--outline">DÉCOUVRIR LE LOUNGE</a>
                    </article>

                    <article class="exp-card gsap-reveal">
                        <div class="exp-img-wrapper">
                            <img src="images/exp-art.jpeg"''',
    1,
    'Exp Lounge → experiences-restaurant.html'
)

# Art & Culture → galerie.html
replace(
    '''<a href="#" class="exp-btn exp-btn--outline">DÉCOUVRIR LA CULTURE</a>
                    </article>

                    <article class="exp-card gsap-reveal">
                        <div class="exp-img-wrapper">
                            <img src="images/exp-events.jpeg"''',
    '''<a href="galerie.html" class="exp-btn exp-btn--outline">DÉCOUVRIR LA CULTURE</a>
                    </article>

                    <article class="exp-card gsap-reveal">
                        <div class="exp-img-wrapper">
                            <img src="images/exp-events.jpeg"''',
    1,
    'Exp Art → galerie.html'
)

# Meeting & Events → evenements.html
replace(
    '<a href="#" class="exp-btn exp-btn--filled">ORGANISER UN ÉVÉNEMENT</a>',
    '<a href="evenements.html" class="exp-btn exp-btn--filled">ORGANISER UN ÉVÉNEMENT</a>',
    1,
    'Exp Events → evenements.html'
)

# ============================================================
# 8. Bouton "VOIR SUR INSTAGRAM" → galerie.html
# ============================================================
# Le bouton contient la classe .btn-gallery, on le cible spécifiquement
replace(
    '<a href="https://www.instagram.com/pullmandakarteranga/?hl=fr" target="_blank" rel="noopener noreferrer" class="btn-gallery">VOIR SUR INSTAGRAM</a>',
    '<a href="galerie.html" class="btn-gallery">VOIR NOTRE GALERIE</a>',
    1,
    'Bouton "VOIR SUR INSTAGRAM" → galerie.html'
)

# ============================================================
# 9. Ajouter une ancre "rooms" (au cas où elle manquerait)
# ============================================================
if 'id="rooms"' not in c:
    replace(
        '<section class="rooms-section">',
        '<section class="rooms-section" id="rooms">',
        1,
        'id="rooms" ajouté à la section Chambres'
    )

# ============================================================
# Écriture finale
# ============================================================
f.write_text(c, encoding='utf-8')
print()
print(f"   ✅ {changes} modifications appliquées")
PY_EOF

# ============================================================
# Vérification
# ============================================================
echo ""
echo -e "${BLUE}━━━ VÉRIFICATION ━━━${NC}"

H=$(cat "$HTML")

printf "   %-45s | %s\n" "Élément" "Valeur"
printf "   %-45s-|-%s\n" "---------------------------------------------" "--------"

printf "   %-45s | %s\n" "Boutons encore en href='#'" "$(echo "$H" | grep -o 'href="#"' | wc -l)"
printf "   %-45s | %s\n" "Ancre #about existe" "$(echo "$H" | grep -c 'id="about"' || echo 0)"
printf "   %-45s | %s\n" "Ancre #rooms existe" "$(echo "$H" | grep -c 'id="rooms"' || echo 0)"
printf "   %-45s | %s\n" "Liens chambres.html#..." "$(echo "$H" | grep -o 'chambres.html#' | wc -l)"
printf "   %-45s | %s\n" "Liens experiences-piscine.html" "$(echo "$H" | grep -c 'experiences-piscine.html' || echo 0)"
printf "   %-45s | %s\n" "Liens experiences-restaurant.html" "$(echo "$H" | grep -c 'experiences-restaurant.html' || echo 0)"
printf "   %-45s | %s\n" "Liens evenements.html" "$(echo "$H" | grep -c 'evenements.html' || echo 0)"
printf "   %-45s | %s\n" "Liens galerie.html" "$(echo "$H" | grep -c 'galerie.html' || echo 0)"
printf "   %-45s | %s\n" "Liens Instagram (images galerie)" "$(echo "$H" | grep -c 'instagram.com' || echo 0)"

echo ""
if [ "$(echo "$H" | grep -o 'href="#"' | wc -l)" -le 2 ]; then
    echo -e "${GREEN}✅ CORRECTION RÉUSSIE${NC}"
else
    echo -e "${YELLOW}⚠  Il reste encore des href='#' — vérifiez manuellement${NC}"
fi

echo -e "${BLUE}💾 Sauvegarde : $BACKUP${NC}"
echo ""
echo -e "${BLUE}📋 Résumé des destinations :${NC}"
echo "   Hero DÉCOUVRIR L'HÔTEL           → #about (scroll local)"
echo "   About DÉCOUVRIR L'HÔTEL          → #rooms (scroll local)"
echo "   Room Deluxe DÉCOUVRIR            → chambres.html#chambre-deluxe"
echo "   Room Suite DÉCOUVRIR             → chambres.html#suite"
echo "   Room Supérieure DÉCOUVRIR        → chambres.html#chambre-superieure"
echo "   Bannière RÉSERVER UNE EXPÉRIENCE → chambres.html"
echo "   Exp Piscine / Spa / Beach Club   → experiences-piscine.html"
echo "   Exp Lounge                       → experiences-restaurant.html"
echo "   Exp Art & Culture                → galerie.html"
echo "   Exp Meeting & Events             → evenements.html"
echo "   Bouton 'VOIR NOTRE GALERIE'      → galerie.html"
echo "   Images galerie (6 cards)         → Instagram (inchangé)"
echo ""
echo -e "${BLUE}🔄 Rollback :${NC}"
echo "   cp $BACKUP/index.html ."
echo ""
echo -e "${BLUE}🧹 Nettoyage :${NC}"
echo "   rm -rf $BACKUP corriger_boutons_index.sh"
