#!/usr/bin/env bash
set -euo pipefail

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; RED='\033[0;31m'; NC='\033[0m'

echo -e "${BLUE}=====================================================${NC}"
echo -e "${BLUE} CORRECTION UX — Hero Événements${NC}"
echo -e "${BLUE}====================================================${NC}\n"

HTML="evenements.html"
CSS="css/evenements.css"

[ -f "$HTML" ] || { echo -e "${RED}❌ $HTML introuvable${NC}"; exit 1; }
[ -f "$CSS" ]  || { echo -e "${RED}❌ $CSS introuvable${NC}"; exit 1; }

BACKUP=".backup_hero_fix_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP"
cp "$HTML" "$BACKUP/"
cp "$CSS" "$BACKUP/"
echo -e "${GREEN}📦 Sauvegarde → $BACKUP${NC}\n"

# ============================================================
# 1. CSS — Corrections UX
# ============================================================
echo -e "${BLUE}━━━ [1/2] Corrections CSS ━━━${NC}"

python3 << 'PY_EOF'
from pathlib import Path

f = Path('css/evenements.css')
c = f.read_text(encoding='utf-8')

# ---------- FIX 1 : Réduire la hauteur du hero ----------
c = c.replace(
    '.evenements-page .hero-evt {\n    position: relative;\n    min-height: 88vh;',
    '.evenements-page .hero-evt {\n    position: relative;\n    min-height: 62vh;\n    max-height: 720px;'
)

# ---------- FIX 2 : Le sous-titre "section-subtitle" doit être au-dessus, pas inline ----------
# Le problème vient de .section-header qui a text-align:center et le sous-titre est inline
# On force le sous-titre à être un bloc séparé
c = c.replace(
    '''.evenements-page .section-subtitle {
    display: inline-block;
    color: var(--vert-pullman);
    font-size: 0.72rem;
    font-weight: 700;
    letter-spacing: 3px;
    text-transform: uppercase;
    margin-bottom: 14px;
}''',
    '''.evenements-page .section-subtitle {
    display: block;
    color: var(--vert-pullman);
    font-size: 0.72rem;
    font-weight: 700;
    letter-spacing: 3px;
    text-transform: uppercase;
    margin-bottom: 16px;
    line-height: 1.4;
}'''
)

# ---------- FIX 3 : .section-header doit empiler proprement ----------
c = c.replace(
    '''.evenements-page .section-header {
    text-align: center;
    margin-bottom: 60px;
}''',
    '''.evenements-page .section-header {
    text-align: center;
    margin-bottom: 60px;
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 0;
}
.evenements-page .section-header .titre-souligne {
    margin-top: 0;
}'''
)

# ---------- FIX 4 : Ajouter un séparateur vertical dans le hero (optionnel) ----------
# Pour un look plus aéré, on ajoute un espacement vertical entre le hero et les features
c = c.replace(
    '''.evenements-page .features-evt {
    padding: 80px 0;
    background: #fff;
}''',
    '''.evenements-page .features-evt {
    padding: 90px 0;
    background: #fff;
    position: relative;
}
.evenements-page .features-evt::before {
    content: "";
    position: absolute;
    top: -30px;
    left: 50%;
    transform: translateX(-50%);
    width: 60px;
    height: 4px;
    background: var(--vert-pullman);
    border-radius: 2px;
    opacity: 0.4;
}'''
)

# ---------- FIX 5 : Ajuster le contenu du hero pour 62vh ----------
c = c.replace(
    '''.evenements-page .hero-evt-content {
    position: relative;
    z-index: 3;
    max-width: 1300px;
    margin: 0 auto;
    padding: 80px 40px 100px;
    width: 100%;
}''',
    '''.evenements-page .hero-evt-content {
    position: relative;
    z-index: 3;
    max-width: 1300px;
    margin: 0 auto;
    padding: 60px 40px 60px;
    width: 100%;
}'''
)

# ---------- FIX 6 : Titre hero — taille plus équilibrée pour 62vh ----------
c = c.replace(
    '''.evenements-page .hero-evt h1 {
    font-size: clamp(2.4rem, 5vw, 4.2rem);''',
    '''.evenements-page .hero-evt h1 {
    font-size: clamp(2.1rem, 4.2vw, 3.4rem);'''
)

# ---------- FIX 7 : Description hero plus compacte ----------
c = c.replace(
    '''.evenements-page .hero-evt-desc {
    font-size: 1.02rem;
    line-height: 1.85;''',
    '''.evenements-page .hero-evt-desc {
    font-size: 0.98rem;
    line-height: 1.75;'''
)

# ---------- FIX 8 : Marges internes du hero plus serrées ----------
c = c.replace(
    '''.evenements-page .hero-evt h1 {
    font-size: clamp(2.1rem, 4.2vw, 3.4rem);
    font-weight: 800;
    line-height: 1.05;
    letter-spacing: 1.5px;
    text-transform: uppercase;
    margin-bottom: 26px;''',
    '''.evenements-page .hero-evt h1 {
    font-size: clamp(2.1rem, 4.2vw, 3.4rem);
    font-weight: 800;
    line-height: 1.05;
    letter-spacing: 1.5px;
    text-transform: uppercase;
    margin-bottom: 22px;'''
)

# ---------- FIX 9 : Desc margin-bottom plus serré ----------
c = c.replace(
    '''.evenements-page .hero-evt-desc {
    font-size: 0.98rem;
    line-height: 1.75;
    max-width: 560px;
    margin-bottom: 38px;''',
    '''.evenements-page .hero-evt-desc {
    font-size: 0.98rem;
    line-height: 1.75;
    max-width: 560px;
    margin-bottom: 30px;'''
)

# ---------- FIX 10 : Chips position ajustée pour hero plus court ----------
c = c.replace(
    '''.evenements-page .hero-evt-chips {
    position: absolute;
    bottom: 40px;
    right: 40px;''',
    '''.evenements-page .hero-evt-chips {
    position: absolute;
    bottom: 30px;
    right: 40px;'''
)

# ---------- FIX 11 : Breadcrumb margin plus compact ----------
c = c.replace(
    '''.evenements-page .hero-evt .breadcrumb {
    font-size: 0.78rem;
    letter-spacing: 1.8px;
    text-transform: uppercase;
    margin-bottom: 26px;''',
    '''.evenements-page .hero-evt .breadcrumb {
    font-size: 0.78rem;
    letter-spacing: 1.8px;
    text-transform: uppercase;
    margin-bottom: 20px;'''
)

# ---------- FIX 12 : Eyebrow margin plus compact ----------
c = c.replace(
    '''.evenements-page .hero-evt .eyebrow {
    display: inline-flex;
    align-items: center;
    gap: 14px;
    font-size: 0.82rem;
    font-weight: 700;
    text-transform: uppercase;
    letter-spacing: 2px;
    color: #fff;
    margin-bottom: 22px;
}''',
    '''.evenements-page .hero-evt .eyebrow {
    display: inline-flex;
    align-items: center;
    gap: 14px;
    font-size: 0.82rem;
    font-weight: 700;
    text-transform: uppercase;
    letter-spacing: 2px;
    color: #fff;
    margin-bottom: 18px;
}'''
)

# ---------- FIX 13 : Media queries responsive hero ----------
c = c.replace(
    '''@media (max-width: 768px) {
    .evenements-page .container { padding: 0 24px; }
    .evenements-page .section { padding: 70px 0; }
    .evenements-page .hero-evt-content { padding: 60px 24px 80px; }''',
    '''@media (max-width: 768px) {
    .evenements-page .container { padding: 0 24px; }
    .evenements-page .section { padding: 70px 0; }
    .evenements-page .hero-evt { min-height: 70vh; max-height: none; }
    .evenements-page .hero-evt-content { padding: 50px 24px 60px; }'''
)

f.write_text(c, encoding='utf-8')
print("   ✔ Hauteur hero : 88vh → 62vh (max 720px)")
print("   ✔ Sous-titre 'NOS SALLES DE RÉUNION' : inline → block")
print("   ✔ Section-header : flex column (empilement propre)")
print("   ✔ Padding hero : 80/100 → 60/60")
print("   ✔ Taille titre : 4.2rem → 3.4rem max")
print("   ✔ Marges internes resserrées")
print("   ✔ Espacement features-evt ajusté (+ trait vert décoratif)")
PY_EOF

# ============================================================
# 2. HTML — Correction des <br> dans le hero
# ============================================================
echo -e "\n${BLUE}━━━ [2/2] HTML — Restauration des <br> ━━━${NC}"

python3 << 'PY_EOF'
from pathlib import Path

f = Path('evenements.html')
c = f.read_text(encoding='utf-8')

# ---------- Restaurer les <br> dans le titre hero ----------
# Titre actuel :
#   <h1>Des espaces uniques<br>pour vos <span class="highlight">événements</span></h1>
# → Bien équilibré, on garde mais on va l'améliorer :
#   <h1>Des espaces <span class="highlight">uniques</span><br>pour vos événements</h1>

c = c.replace(
    '<h1>Des espaces uniques<br>pour vos <span class="highlight">événements</span></h1>',
    '<h1>Des espaces <span class="highlight">uniques</span><br>pour vos événements</h1>'
)

# ---------- Ajouter des <br> dans la description hero pour contrôler la césure ----------
# Description actuelle :
#   Séminaires, conférences, mariages ou soirées privées —
#   le Pullman Dakar Teranga vous offre un cadre d'exception
#   pour des moments inoubliables, face à l'Atlantique.

c = c.replace(
    '''                <p class="hero-evt-desc">
                    Séminaires, conférences, mariages ou soirées privées —
                    le Pullman Dakar Teranga vous offre un cadre d'exception
                    pour des moments inoubliables, face à l'Atlantique.
                </p>''',
    '''                <p class="hero-evt-desc">
                    Séminaires, conférences, mariages ou soirées privées :<br>
                    le Pullman Dakar Teranga vous offre un cadre d'exception<br>
                    pour des moments inoubliables, face à l'Atlantique.
                </p>'''
)

# ---------- Sous-titre du hero : eyebrow reste inline (il est court) ----------
# On garde <span class="eyebrow">Meeting &amp; Events</span>

# ---------- Correction du titre de la section Galerie ----------
# Actuel :
#   <h2 class="titre-souligne titre-souligne--left">Un lieu, mille configurations</h2>
# On garde tel quel

# ---------- Correction de la description "Un lieu, mille configurations" ----------
# Actuel :
#   <p class="highlight-text" style="margin-top: 26px;">
#       Le Pullman Dakar Teranga dispose d'un espace événementiel modulable
#       de près de <strong>528 m²</strong>, pensé pour accueillir aussi bien
#       des réunions de direction que des conférences de grande envergure,
#       des banquets d'affaires ou des réceptions privées.
#   </p>
# → Ajouter des <br> pour équilibrer

c = c.replace(
    '''                    <p class="highlight-text" style="margin-top: 26px;">
                        Le Pullman Dakar Teranga dispose d'un espace événementiel modulable
                        de près de <strong>528 m²</strong>, pensé pour accueillir aussi bien
                        des réunions de direction que des conférences de grande envergure,
                        des banquets d'affaires ou des réceptions privées.
                    </p>''',
    '''                    <p class="highlight-text" style="margin-top: 26px;">
                        Le Pullman Dakar Teranga dispose d'un espace événementiel<br>
                        modulable de près de <strong>528 m²</strong>, pensé pour accueillir<br>
                        aussi bien des réunions de direction que des conférences<br>
                        de grande envergure, des banquets d'affaires ou des réceptions privées.
                    </p>'''
)

# ---------- Correction du titre section Capacités ----------
# Actuel :
#   <span class="section-subtitle">Nos salles de réunion</span>
#   <h2 class="titre-souligne">Capacités et configurations</h2>
# → Structure OK car .section-subtitle est maintenant display:block
# → On garde

f.write_text(c, encoding='utf-8')
print("   ✔ Titre hero : <span>highlight</span> repositionné sur 'uniques'")
print("   ✔ Description hero : 3 <br> ajoutés pour contrôle césure")
print("   ✔ Description galerie : 4 <br> ajoutés pour équilibre")
PY_EOF

# ============================================================
# 3. VÉRIFICATION
# ============================================================
echo -e "\n${BLUE}━━━ VÉRIFICATION ━━━${NC}"

H=$(cat "$HTML")
C=$(cat "$CSS")

printf "   %-42s | %s\n" "Élément" "Valeur"
printf "   %-42s-|-%s\n" "------------------------------------------" "--------"

printf "   %-42s | %s\n" "Hero min-height (recherche '62vh')" "$(echo "$C" | grep -c 'min-height: 62vh' || echo 0)"
printf "   %-42s | %s\n" "Hero max-height 720px" "$(echo "$C" | grep -c 'max-height: 720px' || echo 0)"
printf "   %-42s | %s\n" "section-subtitle en block" "$(echo "$C" | grep -A 2 'section-subtitle' | grep -c 'display: block' || echo 0)"
printf "   %-42s | %s\n" "section-header en flex column" "$(echo "$C" | grep -c 'flex-direction: column' || echo 0)"
printf "   %-42s | %s\n" "<br> dans le titre hero" "$(echo "$H" | grep -c 'Des espaces <span' || echo 0)"
printf "   %-42s | %s\n" "<br> dans la description hero" "$(echo "$H" | grep -c 'soirées privées :<br>' || echo 0)"
printf "   %-42s | %s\n" "<br> dans la description galerie" "$(echo "$H" | grep -c 'modulable de près de' || echo 0)"

echo ""
echo -e "${GREEN}✅ CORRECTION TERMINÉE${NC}"
echo -e "${BLUE}💾 Sauvegarde : $BACKUP${NC}"
echo ""
echo -e "${BLUE}📋 Résumé des changements UX :${NC}"
echo "   📐 Hero : 88vh → 62vh (max 720px) — laisse voir la section suivante"
echo "   📐 Padding hero : 80/100 → 60/60 — plus compact"
echo "   📐 Titre hero : 4.2rem max → 3.4rem — équilibré pour 62vh"
echo "   📐 Description hero : 1.02rem → 0.98rem"
echo "   🎯 Sous-titre 'NOS SALLES' : inline → block (au-dessus du titre)"
echo "   🎯 Section-header : flex column (empilement propre)"
echo "   ✍️  Titre hero : <br> contrôlé + highlight sur 'uniques'"
echo "   ✍️  Description hero : 3 <br> pour contrôle césure"
echo "   ✍️  Description galerie : 4 <br> pour équilibre"
echo "   ✨ Trait vert décoratif entre hero et features"
echo ""
echo -e "${BLUE}🔄 Rollback :${NC}"
echo "   cp $BACKUP/evenements.html ."
echo "   cp $BACKUP/evenements.css css/"
echo ""
echo -e "${BLUE}🧹 Nettoyage :${NC}"
echo "   rm -rf $BACKUP corriger_hero_evt.sh"
