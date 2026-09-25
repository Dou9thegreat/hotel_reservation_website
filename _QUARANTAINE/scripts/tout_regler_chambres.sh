#!/bin/bash
set -e

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; BLUE='\033[0;34m'; NC='\033[0m'

echo -e "${BLUE}=====================================================${NC}"
echo -e "${BLUE} CORRECTION COMPLÈTE chambres.html + reservation.html${NC}"
echo -e "${BLUE}=====================================================${NC}\n"

# ============================================================
# 0. SAUVEGARDE
# ============================================================
BACKUP=".backup_final_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP"
cp chambres.html reservation.html "$BACKUP/" 2>/dev/null || true
cp css/chambres.css "$BACKUP/" 2>/dev/null || true
echo -e "${GREEN}📦 Sauvegarde → $BACKUP${NC}\n"

# ============================================================
# 1. NETTOYAGE chambres.html (modale + data-book-room + prix)
# ============================================================
echo -e "${BLUE}━━━ [1/4] Nettoyage de chambres.html ━━━${NC}"

python3 << 'PYEOF'
import re
from pathlib import Path

f = Path('chambres.html')
c = f.read_text(encoding='utf-8')

# ---------- 1a. Supprimer le HTML de la modale ----------
c = re.sub(
    r'<!--\s*MODALE DE RÉSERVATION\s*-->\s*<div class="modal-overlay" id="reservationModal">.*?</div>\s*</div>\s*</div>\s*(?=</div><!--\s*/\.chambres-page)',
    '',
    c,
    flags=re.DOTALL
)
c = re.sub(
    r'<div class="modal-overlay" id="reservationModal">.*?(?=</div><!--\s*/\.chambres-page)',
    '',
    c,
    flags=re.DOTALL
)

# ---------- 1b. Supprimer le bloc JS de la modale ----------
c = re.sub(
    r'//\s*=+\s*MODALE RÉSERVATION\s*=+\s*.*?(?=//\s*=+\s*REVEAL\s*=+)',
    '',
    c,
    flags=re.DOTALL
)

# ---------- 1c. Ajouter data-book-room sur chaque bouton RÉSERVER ----------
def add_data_book(match):
    article = match.group(0)
    rid = re.search(r'data-room-id="([^"]+)"', article)
    if not rid:
        return article
    return re.sub(
        r'<button class="btn-reserver-room" type="button">RÉSERVER</button>',
        f'<button class="btn-reserver-room" type="button" data-book-room="{rid.group(1)}" data-book-tariff="0">RÉSERVER</button>',
        article
    )

c = re.sub(r'<article class="room-card[^>]*>.*?</article>', add_data_book, c, flags=re.DOTALL)

# ---------- 1d. Synchroniser les prix avec reservation.html ----------
# Prix cibles (Tarif Flexible de base)
PRIX = {
    'deluxe-ocean':       ('155 000', '155000'),
    'suite-ambassadeur':  ('350 000', '350000'),
    'superieure-ocean':   ('175 000', '175000'),
}

for rid, (prix_aff, prix_data) in PRIX.items():
    # Trouver l'article et remplacer son prix
    def replace_price(match):
        article = match.group(0)
        if f'data-room-id="{rid}"' not in article:
            return article
        # Remplacer data-price + affichage
        article = re.sub(r'<span class="price-value" data-price="\d+">[\d\s]+FCFA</span>',
                         f'<span class="price-value" data-price="{prix_data}">{prix_aff} FCFA</span>',
                         article)
        return article

    c = re.sub(r'<article class="room-card[^>]*>.*?</article>', replace_price, c, flags=re.DOTALL)

f.write_text(c, encoding='utf-8')
print("   ✔ Modale HTML supprimée")
print("   ✔ JS modale supprimé")
print("   ✔ data-book-room ajouté sur les boutons")
print("   ✔ Prix synchronisés avec reservation.html")
PYEOF

# ============================================================
# 2. NETTOYAGE css/chambres.css (suppr modale)
# ============================================================
echo -e "\n${BLUE}━━━ [2/4] Nettoyage de css/chambres.css ━━━${NC}"

python3 << 'PYEOF'
import re
from pathlib import Path

f = Path('css/chambres.css')
c = f.read_text(encoding='utf-8')

# Supprimer le bloc MODALE
c = re.sub(
    r'/\* =+ MODALE =+ \*/.*?(?=/\* =+ REVEAL =+ \*/)',
    '',
    c,
    flags=re.DOTALL
)
# Supprimer le bloc REVEAL s'il est orphelin (garder la structure propre)
f.write_text(c, encoding='utf-8')
print("   ✔ Styles de la modale supprimés")
PYEOF

# ============================================================
# 3. MISE À JOUR PRIX reservation.html (cohérence réaliste)
# ============================================================
echo -e "\n${BLUE}━━━ [3/4] Mise à jour des prix dans reservation.html ━━━${NC}"

python3 << 'PYEOF'
import re
from pathlib import Path

f = Path('reservation.html')
c = f.read_text(encoding='utf-8')

# Nouvelle table ROOMS — prix cohérents (Supérieure < Deluxe < Suite)
NEW_ROOMS = """const ROOMS = [
 {id:'classique-ville',name:'Chambre Classique Vue Ville',vue:'ville',lit:'king',surface:30,cap:2,
  desc:"Élégante et confortable, pensée pour un séjour urbain pratique au cœur de Dakar.",
  amen:['Lit King Size','Wi-Fi haut débit','Minibar','Climatisation'],scarcity:null,
  tariffs:[
    {name:'Tarif Flexible',sub:"Annulation gratuite jusqu'à 48h avant l'arrivée",price:115000,petitdej:0},
    {name:'Tarif Non-remboursable',sub:'Paiement immédiat, −15%',price:97750,old:115000,petitdej:0},
    {name:'Petit-déjeuner inclus',sub:'Buffet Teranga Lounge chaque matin',price:133000,petitdej:1}
  ]},
 {id:'classique-twin',name:'Chambre Classique Twin Vue Ville',vue:'ville',lit:'twin',surface:30,cap:2,
  desc:"Deux lits simples, idéale pour les collègues ou amis en voyage d'affaires.",
  amen:['2 lits simples','Wi-Fi haut débit','Minibar','Climatisation'],scarcity:'Plus que 3 chambres à ce tarif',
  tariffs:[
    {name:'Tarif Flexible',sub:"Annulation gratuite jusqu'à 48h avant l'arrivée",price:115000,petitdej:0},
    {name:'Petit-déjeuner inclus',sub:'Buffet Teranga Lounge chaque matin',price:133000,petitdej:1}
  ]},
 {id:'superieure-ocean',name:'Chambre Supérieure Vue Océan',vue:'ocean',lit:'king',surface:33,cap:2,
  desc:"Terrasse privative et lumière naturelle généreuse, face à l'île de Gorée.",
  amen:['Lit King Size','Terrasse','Baignoire','Coffre-fort'],scarcity:'Plus que 2 chambres à ce tarif',
  tariffs:[
    {name:'Tarif Flexible',sub:"Annulation gratuite jusqu'à 48h avant l'arrivée",price:155000,petitdej:0},
    {name:'Tarif Non-remboursable',sub:'Paiement immédiat, −15%',price:131750,old:155000,petitdej:0},
    {name:'Petit-déjeuner inclus',sub:'Buffet Teranga Lounge chaque matin',price:178250,petitdej:1}
  ]},
 {id:'deluxe-ocean',name:'Chambre Deluxe Vue Océan',vue:'ocean',lit:'king',surface:33,cap:2,
  desc:"Balcon privé et vue imprenable sur l'Atlantique depuis votre lit King Size.",
  amen:['Lit King Size','Balcon privé','Machine Illy','Wi-Fi haut débit'],scarcity:'Plus que 4 chambres à ce tarif',
  tariffs:[
    {name:'Tarif Flexible',sub:"Annulation gratuite jusqu'à 48h avant l'arrivée",price:185000,petitdej:0},
    {name:'Tarif Non-remboursable',sub:'Paiement immédiat, −15%',price:157250,old:185000,petitdej:0},
    {name:'Petit-déjeuner inclus',sub:'Buffet Teranga Lounge chaque matin',price:212750,petitdej:1}
  ]},
 {id:'suite-ambassadeur',name:'Suite Ambassadeur Pullman',vue:'ocean',lit:'king',surface:60,cap:2,
  desc:"Salon séparé, volumes généreux et services exclusifs pour un séjour d'exception.",
  amen:['Salon séparé','Canapé-lit','Baignoire & douche','Service Concierge'],scarcity:'Plus que 2 chambres à ce tarif',
  tariffs:[
    {name:'Tarif Flexible',sub:"Annulation gratuite jusqu'à 48h avant l'arrivée",price:350000,petitdej:0},
    {name:'Tarif Non-remboursable',sub:'Paiement immédiat, −15%',price:297500,old:350000,petitdej:0},
    {name:'Petit-déjeuner inclus',sub:'Buffet Teranga Lounge + service en chambre',price:402500,petitdej:1}
  ]}
];"""

# Remplacer l'ancien bloc ROOMS
pattern = re.compile(r'const ROOMS = \[.*?\n\];', re.DOTALL)
if pattern.search(c):
    c = pattern.sub(NEW_ROOMS, c, count=1)
    f.write_text(c, encoding='utf-8')
    print("   ✔ Table ROOMS mise à jour (prix cohérents)")
else:
    print("   ⚠️  Table ROOMS non trouvée — aucune modification")
PYEOF

# ============================================================
# 4. VÉRIFICATION FINALE
# ============================================================
echo -e "\n${BLUE}━━━ [4/4] VÉRIFICATION ━━━${NC}"

printf "   %-35s | %s\n" "Élément" "Valeur"
printf "   %-35s-|-%s\n" "-----------------------------------" "--------"

HTML=$(cat chambres.html)
MOD=$(echo "$HTML" | grep -c 'reservationModal' || echo 0)
DRB=$(echo "$HTML" | grep -o 'data-book-room' | wc -l)
BTN=$(echo "$HTML" | grep -o 'btn-reserver-room' | wc -l)
CSSM=$(grep -c 'modal-overlay' css/chambres.css || echo 0)

printf "   %-35s | %s\n" "chambres.html — Modale" "$MOD  (0 attendu)"
printf "   %-35s | %s\n" "chambres.html — Boutons RÉSERVER" "$BTN  (3 attendus)"
printf "   %-35s | %s\n" "chambres.html — data-book-room" "$DRB  (3 attendus)"
printf "   %-35s | %s\n" "chambres.css — Styles modale" "$CSSM  (0 attendu)"

# Vérifier les prix synchronisés
echo ""
echo -e "   ${BLUE}Prix affichés dans chambres.html :${NC}"
grep -o 'data-price="[0-9]*"' chambres.html | sort -u | sed 's/^/     /'
echo -e "   ${BLUE}Prix dans la table ROOMS de reservation.html :${NC}"
grep -o 'price:[0-9]*' reservation.html | sort -u | head -10 | sed 's/^/     /'

echo ""
echo -e "${GREEN}✅ TERMINÉ${NC}"
echo -e "${BLUE}💾 Sauvegarde : $BACKUP${NC}"
echo ""
echo -e "${BLUE}📌 Étapes suivantes :${NC}"
echo "   1. Ctrl + Shift + R dans le navigateur"
echo "   2. Ouvrez chambres.html"
echo "   3. Cliquez sur RÉSERVER dans une carte chambre"
echo "   4. → Redirection vers reservation.html?room=XXX"
echo "   5. → La chambre est pré-sélectionnée dans le panneau de droite"
echo ""
echo -e "${BLUE}🔄 Rollback :${NC}"
echo "   cp $BACKUP/chambres.html $BACKUP/reservation.html ."
echo "   cp $BACKUP/chambres.css css/"
echo ""
echo -e "${BLUE}🧹 Nettoyage après validation :${NC}"
echo "   rm -rf $BACKUP tout_regler_chambres.sh"
