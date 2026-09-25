#!/usr/bin/env bash
set -euo pipefail

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; BLUE='\033[0;34m'; NC='\033[0m'

echo -e "${BLUE}=====================================================${NC}"
echo -e "${BLUE} REFONTE SECTION CHAMBRES — index.html${NC}"
echo -e "${BLUE}====================================================${NC}\n"

HTML="index.html"
CSS="css/index.css"

[ -f "$HTML" ] || { echo -e "${RED}❌ $HTML introuvable${NC}"; exit 1; }
[ -f "$CSS" ]  || { echo -e "${RED}❌ $CSS introuvable${NC}"; exit 1; }

BACKUP=".backup_rooms_refonte_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP"
cp "$HTML" "$BACKUP/"
cp "$CSS"  "$BACKUP/"
echo -e "${GREEN}📦 Sauvegarde → $BACKUP${NC}\n"

# ============================================================
# 1. CSS — Nouvelle section Chambres premium
# ============================================================
echo -e "${BLUE}━━━ [1/2] Nouveau CSS ━━━${NC}"

python3 << 'PY_EOF'
import re
from pathlib import Path

css = Path('css/index.css')
c = css.read_text(encoding='utf-8')

# ---------- Supprimer tout le bloc "5. SECTION NOS CHAMBRES" existant ----------
# On repère le début et la fin du bloc
start_marker = '/* ============================================================= */\n/* 5. SECTION NOS CHAMBRES'
end_marker = '/* ============================================================= */\n/* 6. SECTION EXPÉRIENCES'

if start_marker in c and end_marker in c:
    start_idx = c.find(start_marker)
    end_idx = c.find(end_marker)
    c = c[:start_idx] + c[end_idx:]
    print("   ✔ Ancien bloc chambres supprimé")

# ---------- Nouveau CSS premium ----------
NEW_CSS = '''/* ============================================================= */
/* 5. SECTION NOS CHAMBRES — VERSION PREMIUM                      */
/* ============================================================= */
.rooms-section {
    position: relative;
    background: linear-gradient(180deg, #0A1E2D 0%, #123143 100%);
    padding: 110px 0 100px;
    color: #fff;
    overflow: hidden;
}

/* Motif losange subtil en fond */
.rooms-section::before {
    content: "";
    position: absolute;
    inset: 0;
    background-image:
        repeating-linear-gradient(45deg, rgba(197, 154, 103, 0.03) 0 1px, transparent 1px 30px),
        repeating-linear-gradient(-45deg, rgba(197, 154, 103, 0.03) 0 1px, transparent 1px 30px);
    pointer-events: none;
    opacity: .6;
}

.rooms-container {
    position: relative;
    z-index: 1;
    width: min(1240px, calc(100% - 48px));
    margin: 0 auto;
}

/* ---------- Header ---------- */
.rooms-header {
    text-align: center;
    margin-bottom: 70px;
}

.rooms-section .section-tag {
    display: inline-flex;
    align-items: center;
    gap: 14px;
    font-size: 0.72rem;
    font-weight: 700;
    color: var(--primary-green, #38E28F);
    letter-spacing: 3px;
    text-transform: uppercase;
    margin: 0 0 16px 0;
}

.rooms-section .section-tag::before,
.rooms-section .section-tag::after {
    content: "";
    display: inline-block;
    width: 40px;
    height: 1px;
    background: var(--primary-green, #38E28F);
    opacity: .5;
}

.rooms-section .section-title {
    font-family: 'Playfair Display', var(--font-serif, Georgia, serif);
    font-size: clamp(2rem, 4vw, 3.2rem);
    font-weight: 700;
    color: #fff;
    margin: 0 0 18px 0;
    letter-spacing: -0.5px;
    line-height: 1.15;
}

.rooms-section .section-title em {
    font-style: italic;
    color: #C59A67;
    font-weight: 400;
}

.rooms-section .section-subtitle {
    font-size: 1rem;
    font-weight: 400;
    color: rgba(255, 255, 255, 0.7);
    line-height: 1.7;
    max-width: 600px;
    margin: 0 auto;
}

/* ---------- Grille asymétrique ---------- */
.rooms-list {
    display: grid;
    grid-template-columns: 1.2fr 1fr;
    grid-template-rows: repeat(2, 340px);
    gap: 24px;
    margin-bottom: 60px;
}

/* La première carte (Deluxe) prend toute la hauteur */
.rooms-list > .room-card:first-child {
    grid-row: 1 / span 2;
}

/* Cartes 2 et 3 (Suite + Supérieure) empilées à droite */
.rooms-list > .room-card:nth-child(2),
.rooms-list > .room-card:nth-child(3) {
    grid-column: 2;
}

/* ---------- Carte chambre ---------- */
.room-card {
    position: relative;
    border-radius: 20px;
    overflow: hidden;
    background: #0A1E2D;
    cursor: pointer;
    transition: transform 0.5s cubic-bezier(0.25, 1, 0.5, 1),
                box-shadow 0.5s ease;
    display: flex;
    flex-direction: column;
    box-shadow: 0 15px 40px rgba(0, 0, 0, 0.3);
}

.room-card:hover {
    transform: translateY(-8px);
    box-shadow: 0 30px 60px rgba(0, 0, 0, 0.5);
}

/* ---------- Image en background ---------- */
.room-card .room-image {
    position: absolute;
    inset: 0;
    width: 100%;
    height: 100%;
    z-index: 1;
}

.room-card .room-image img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    display: block;
    transition: transform 1.2s cubic-bezier(0.25, 1, 0.5, 1);
}

.room-card:hover .room-image img {
    transform: scale(1.08);
}

/* Overlay dégradé */
.room-card::after {
    content: "";
    position: absolute;
    inset: 0;
    background: linear-gradient(180deg,
        rgba(10, 30, 45, 0.05) 0%,
        rgba(10, 30, 45, 0.30) 45%,
        rgba(10, 30, 45, 0.92) 100%);
    z-index: 2;
    pointer-events: none;
    transition: background 0.5s ease;
}

.room-card:hover::after {
    background: linear-gradient(180deg,
        rgba(10, 30, 45, 0.15) 0%,
        rgba(10, 30, 45, 0.55) 45%,
        rgba(10, 30, 45, 0.96) 100%);
}

/* ---------- Badge flottant ---------- */
.room-card .room-badge {
    position: absolute;
    top: 22px;
    left: 22px;
    z-index: 4;
    display: inline-flex;
    align-items: center;
    gap: 6px;
    padding: 7px 14px;
    background: #C59A67;
    color: #fff;
    font-size: 0.68rem;
    font-weight: 800;
    letter-spacing: 1.5px;
    text-transform: uppercase;
    border-radius: 30px;
    box-shadow: 0 6px 20px rgba(197, 154, 103, 0.4);
}

.room-card .room-badge--green {
    background: var(--primary-green, #38E28F);
    color: #0A1E2D;
    box-shadow: 0 6px 20px rgba(56, 226, 143, 0.4);
}

.room-card .room-badge--dark {
    background: rgba(255, 255, 255, 0.15);
    backdrop-filter: blur(12px);
    border: 1px solid rgba(255, 255, 255, 0.3);
    color: #fff;
}

.room-card .room-badge i {
    font-size: 0.75rem;
}

/* ---------- Contenu sur l'image ---------- */
.room-card .room-content {
    position: relative;
    z-index: 3;
    margin-top: auto;
    padding: 30px 28px 28px;
    display: flex;
    flex-direction: column;
    gap: 14px;
}

/* Catégorie */
.room-card .room-category {
    display: flex;
    align-items: center;
    gap: 10px;
    font-size: 0.72rem;
    font-weight: 700;
    letter-spacing: 2px;
    text-transform: uppercase;
    color: var(--primary-green, #38E28F);
}

.room-card .room-category::before {
    content: "";
    width: 24px;
    height: 2px;
    background: var(--primary-green, #38E28F);
}

/* Titre */
.room-card .room-name {
    font-family: 'Playfair Display', Georgia, serif;
    font-size: clamp(1.4rem, 2.4vw, 2rem);
    font-weight: 700;
    color: #fff;
    line-height: 1.15;
    margin: 0;
    letter-spacing: -0.3px;
}

/* Description */
.room-card .room-desc {
    font-size: 0.85rem;
    line-height: 1.6;
    color: rgba(255, 255, 255, 0.75);
    margin: 0;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
    overflow: hidden;
}

/* ---------- Équipements ---------- */
.room-card .room-icons {
    display: flex;
    gap: 14px;
    flex-wrap: wrap;
    padding: 14px 0;
    border-top: 1px solid rgba(255, 255, 255, 0.12);
    border-bottom: 1px solid rgba(255, 255, 255, 0.12);
}

.room-card .room-icon-item {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    font-size: 0.72rem;
    color: rgba(255, 255, 255, 0.7);
    font-weight: 500;
}

.room-card .room-icon-item i {
    color: #C59A67;
    font-size: 0.85rem;
}

/* ---------- Bloc prix + CTA ---------- */
.room-card .room-footer {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 16px;
    margin-top: 4px;
}

.room-card .room-price {
    display: flex;
    flex-direction: column;
    gap: 2px;
}

.room-card .room-price .price-label {
    font-size: 0.68rem;
    font-weight: 600;
    letter-spacing: 1.2px;
    text-transform: uppercase;
    color: rgba(255, 255, 255, 0.55);
}

.room-card .room-price .price-value {
    font-family: 'Playfair Display', Georgia, serif;
    font-size: 1.55rem;
    font-weight: 700;
    color: #fff;
    line-height: 1;
}

.room-card .room-price .price-value .currency {
    font-family: 'Montserrat', sans-serif;
    font-size: 0.75rem;
    font-weight: 600;
    opacity: 0.7;
    margin-left: 4px;
}

.room-card .room-price .price-unit {
    font-size: 0.68rem;
    color: rgba(255, 255, 255, 0.55);
    font-weight: 500;
}

/* Bouton */
.room-card .room-btn {
    display: inline-flex;
    align-items: center;
    gap: 10px;
    background: var(--primary-green, #38E28F);
    color: #0A1E2D;
    font-size: 0.75rem;
    font-weight: 800;
    letter-spacing: 1px;
    text-transform: uppercase;
    padding: 13px 22px;
    border-radius: 40px;
    text-decoration: none;
    box-shadow: 0 8px 22px rgba(56, 226, 143, 0.3);
    transition: all 0.3s cubic-bezier(0.25, 1, 0.5, 1);
    white-space: nowrap;
    flex-shrink: 0;
}

.room-card .room-btn:hover {
    background: #2BC87A;
    transform: translateY(-2px);
    box-shadow: 0 12px 30px rgba(56, 226, 143, 0.5);
}

.room-card .room-btn i {
    transition: transform 0.3s ease;
    font-size: 0.75rem;
}

.room-card .room-btn:hover i {
    transform: translateX(4px);
}

/* ---------- Bannière finale ---------- */
.experience-banner {
    position: relative;
    border-radius: 20px;
    padding: 40px 50px;
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 30px;
    color: #fff;
    box-shadow: 0 20px 50px rgba(0, 0, 0, 0.3);
    background-image:
        linear-gradient(135deg, rgba(10, 30, 45, 0.85), rgba(21, 94, 117, 0.7)),
        url('../images/img1.png');
    background-size: cover;
    background-position: center;
    overflow: hidden;
    flex-wrap: wrap;
}

.experience-banner::before {
    content: "";
    position: absolute;
    top: -50%;
    right: -10%;
    width: 400px;
    height: 400px;
    border-radius: 50%;
    background: radial-gradient(circle, rgba(197, 154, 103, 0.15) 0%, transparent 70%);
    pointer-events: none;
}

.banner-content {
    position: relative;
    z-index: 1;
}

.banner-sub {
    display: block;
    font-size: 0.7rem;
    font-weight: 800;
    color: #C59A67;
    letter-spacing: 2.5px;
    text-transform: uppercase;
    margin-bottom: 10px;
}

.banner-title {
    font-family: 'Playfair Display', Georgia, serif;
    font-size: clamp(1.4rem, 2.4vw, 1.9rem);
    font-weight: 700;
    line-height: 1.2;
    color: #fff;
    margin: 0;
}

.banner-btn {
    position: relative;
    z-index: 1;
    display: inline-flex;
    align-items: center;
    gap: 12px;
    background: #C59A67;
    color: #fff;
    font-size: 0.8rem;
    font-weight: 800;
    letter-spacing: 1.2px;
    text-transform: uppercase;
    padding: 18px 32px;
    border-radius: 40px;
    text-decoration: none;
    box-shadow: 0 10px 30px rgba(197, 154, 103, 0.4);
    transition: all 0.3s cubic-bezier(0.25, 1, 0.5, 1);
    white-space: nowrap;
}

.banner-btn:hover {
    background: #B5885A;
    transform: translateY(-3px);
    box-shadow: 0 15px 40px rgba(197, 154, 103, 0.55);
}

.banner-btn i {
    transition: transform 0.3s ease;
}

.banner-btn:hover i {
    transform: translateX(4px);
}

/* ---------- Responsive ---------- */
@media (max-width: 1024px) {
    .rooms-list {
        grid-template-columns: 1fr;
        grid-template-rows: repeat(3, 400px);
    }
    .rooms-list > .room-card:first-child {
        grid-row: auto;
    }
    .rooms-list > .room-card:nth-child(2),
    .rooms-list > .room-card:nth-child(3) {
        grid-column: 1;
    }
}

@media (max-width: 640px) {
    .rooms-section { padding: 70px 0 60px; }
    .rooms-list {
        grid-template-rows: repeat(3, 480px);
        gap: 18px;
    }
    .room-card .room-content { padding: 24px 22px; }
    .room-card .room-footer {
        flex-direction: column;
        align-items: stretch;
        gap: 14px;
    }
    .room-card .room-btn {
        width: 100%;
        justify-content: center;
    }
    .experience-banner { padding: 30px 24px; }
}

'''

# Insérer avant le bloc "6. SECTION EXPÉRIENCES"
end_marker = '/* ============================================================= */\n/* 6. SECTION EXPÉRIENCES'
idx = c.find(end_marker)
if idx > 0:
    c = c[:idx] + NEW_CSS + c[idx:]
    print("   ✔ Nouveau CSS chambres inséré")
else:
    # Fallback : à la fin du fichier
    c += NEW_CSS
    print("   ✔ Nouveau CSS ajouté en fin de fichier")

css.write_text(c, encoding='utf-8')
PY_EOF

echo -e "${GREEN}   ✔ CSS refondu${NC}\n"

# ============================================================
# 2. HTML — Nouvelle structure de la section Chambres
# ============================================================
echo -e "${BLUE}━━━ [2/2] Nouvelle structure HTML ━━━${NC}"

python3 << 'PY_EOF'
import re
from pathlib import Path

f = Path('index.html')
c = f.read_text(encoding='utf-8')

# ---------- Nouveau bloc HTML de la section Chambres ----------
NEW_HTML = '''<!-- SECTION NOS CHAMBRES -->
        <section class="rooms-section" id="rooms">
            <div class="rooms-container">
                <div class="rooms-header gsap-reveal">
                    <span class="section-tag">NOS CHAMBRES</span>
                    <h2 class="section-title">L'élégance commence ici,<br>face à <em>l'Atlantique</em></h2>
                    <p class="section-subtitle">
                        Découvrez des chambres pensées pour le confort, la lumière<br>
                        et l'art de vivre face à l'océan.
                    </p>
                </div>

                <div class="rooms-list">

                    <!-- 01 DELUXE (grande carte) -->
                    <article class="room-card gsap-reveal" id="chambre-deluxe">
                        <div class="room-badge">
                            <i class="fa-solid fa-crown"></i>
                            Coup de cœur
                        </div>

                        <div class="room-image">
                            <img src="images/room-deluxe.png" alt="Chambre Deluxe Vue Océan">
                        </div>

                        <div class="room-content">
                            <div class="room-category">Deluxe · Vue Océan</div>
                            <h3 class="room-name">Chambre Deluxe<br>Vue Océan</h3>
                            <p class="room-desc">
                                Pour les voyageurs qui veulent se réveiller avec l'horizon de l'Atlantique.
                                Balcon privé, lit King Size et machine à café Illy.
                            </p>

                            <div class="room-icons">
                                <span class="room-icon-item"><i class="fa-solid fa-bed"></i> King Size</span>
                                <span class="room-icon-item"><i class="fa-solid fa-water"></i> Vue Océan</span>
                                <span class="room-icon-item"><i class="fa-solid fa-wifi"></i> Wi-Fi</span>
                                <span class="room-icon-item"><i class="fa-solid fa-mug-hot"></i> Machine Illy</span>
                            </div>

                            <div class="room-footer">
                                <div class="room-price">
                                    <span class="price-label">À partir de</span>
                                    <span class="price-value">155 000 <span class="currency">FCFA</span></span>
                                    <span class="price-unit">par nuit</span>
                                </div>
                                <a href="chambres.html#chambre-deluxe" class="room-btn">
                                    Découvrir
                                    <i class="fa-solid fa-arrow-right"></i>
                                </a>
                            </div>
                        </div>
                    </article>

                    <!-- 02 SUITE -->
                    <article class="room-card gsap-reveal" id="suite">
                        <div class="room-badge room-badge--green">
                            <i class="fa-solid fa-star"></i>
                            Prestige
                        </div>

                        <div class="room-image">
                            <img src="images/room-suite.png" alt="Suite Ambassadeur Pullman">
                        </div>

                        <div class="room-content">
                            <div class="room-category">Suite · Prestige</div>
                            <h3 class="room-name">Suite Ambassadeur<br>Pullman</h3>

                            <div class="room-icons">
                                <span class="room-icon-item"><i class="fa-solid fa-couch"></i> Salon</span>
                                <span class="room-icon-item"><i class="fa-solid fa-bath"></i> Baignoire</span>
                                <span class="room-icon-item"><i class="fa-solid fa-bell-concierge"></i> Concierge</span>
                            </div>

                            <div class="room-footer">
                                <div class="room-price">
                                    <span class="price-label">À partir de</span>
                                    <span class="price-value">355 000 <span class="currency">FCFA</span></span>
                                    <span class="price-unit">par nuit</span>
                                </div>
                                <a href="chambres.html#suite" class="room-btn">
                                    Découvrir
                                    <i class="fa-solid fa-arrow-right"></i>
                                </a>
                            </div>
                        </div>
                    </article>

                    <!-- 03 SUPÉRIEURE -->
                    <article class="room-card gsap-reveal" id="chambre-superieure">
                        <div class="room-badge room-badge--dark">
                            <i class="fa-solid fa-bolt"></i>
                            Nouveau
                        </div>

                        <div class="room-image">
                            <img src="images/room-superior.png" alt="Chambre Supérieure Urbaine">
                        </div>

                        <div class="room-content">
                            <div class="room-category">Supérieure · Urbaine</div>
                            <h3 class="room-name">Chambre Supérieure<br>Urbaine</h3>

                            <div class="room-icons">
                                <span class="room-icon-item"><i class="fa-solid fa-bed"></i> Queen Size</span>
                                <span class="room-icon-item"><i class="fa-solid fa-shower"></i> Douche</span>
                                <span class="room-icon-item"><i class="fa-solid fa-snowflake"></i> Clim.</span>
                            </div>

                            <div class="room-footer">
                                <div class="room-price">
                                    <span class="price-label">À partir de</span>
                                    <span class="price-value">115 000 <span class="currency">FCFA</span></span>
                                    <span class="price-unit">par nuit</span>
                                </div>
                                <a href="chambres.html#chambre-superieure" class="room-btn">
                                    Découvrir
                                    <i class="fa-solid fa-arrow-right"></i>
                                </a>
                            </div>
                        </div>
                    </article>

                </div>

                <!-- Bannière d'expérience -->
                <div class="experience-banner gsap-reveal">
                    <div class="banner-content">
                        <span class="banner-sub">PULLMAN DAKAR TERANGA</span>
                        <h3 class="banner-title">Trouvez la chambre<br>qui vous ressemble</h3>
                    </div>
                    <a href="chambres.html" class="banner-btn">
                        Réserver une chambre
                        <i class="fa-solid fa-arrow-right"></i>
                    </a>
                </div>
            </div>
        </section>'''

# ---------- Remplacer l'ancien bloc ----------
pattern = re.compile(
    r'<!-- SECTION NOS CHAMBRES -->\s*<section class="rooms-section">.*?</section>\s*(?=<!-- SECTION EXPÉRIENCES -->)',
    re.DOTALL
)

if pattern.search(c):
    c = pattern.sub(NEW_HTML + '\n\n        ', c, count=1)
    print("   ✔ Bloc HTML chambres remplacé")
else:
    print("   ⚠  Pattern de la section chambres introuvable")

f.write_text(c, encoding='utf-8')
PY_EOF

echo -e "${GREEN}   ✔ HTML refondu${NC}\n"

# ============================================================
# 3. Vérification
# ============================================================
echo -e "${BLUE}━━━ VÉRIFICATION ━━━${NC}"

H=$(cat "$HTML")
C=$(cat "$CSS")

printf "   %-45s | %s\n" "Élément" "Valeur"
printf "   %-45s-|-%s\n" "---------------------------------------------" "--------"

printf "   %-45s | %s\n" "Nouveau CSS .rooms-list en grid" "$(echo "$C" | grep -c 'grid-template-columns: 1.2fr 1fr' || echo 0)"
printf "   %-45s | %s\n" "CSS .room-badge présent" "$(echo "$C" | grep -c 'room-badge' || echo 0)"
printf "   %-45s | %s\n" "CSS .room-icon-item présent" "$(echo "$C" | grep -c 'room-icon-item' || echo 0)"
printf "   %-45s | %s\n" "CSS .room-footer présent" "$(echo "$C" | grep -c 'room-footer' || echo 0)"
printf "   %-45s | %s\n" "HTML .room-badge (3 attendus)" "$(echo "$H" | grep -o 'class="room-badge' | wc -l)"
printf "   %-45s | %s\n" "HTML .room-icon-item (10+ attendus)" "$(echo "$H" | grep -o 'room-icon-item' | wc -l)"
printf "   %-45s | %s\n" "HTML .room-footer (3 attendus)" "$(echo "$H" | grep -o 'class="room-footer"' | wc -l)"
printf "   %-45s | %s\n" "Boutons Découvrir (3 attendus)" "$(echo "$H" | grep -o 'class="room-btn"' | wc -l)"
printf "   %-45s | %s\n" "Liens chambres.html#..." "$(echo "$H" | grep -o 'chambres.html#' | wc -l)"

echo ""
echo -e "${GREEN}✅ REFONTE TERMINÉE${NC}"
echo -e "${BLUE}💾 Sauvegarde : $BACKUP${NC}"
echo ""
echo -e "${BLUE}📋 Ce qui change :${NC}"
echo "   ✨ Fond sombre premium (contraste avec le blanc autour)"
echo "   ✨ Layout asymétrique : 1 grande carte + 2 petites"
echo "   ✨ Images en background plein cadre + overlay dégradé"
echo "   ✨ Badges flottants : 'Coup de cœur', 'Prestige', 'Nouveau'"
echo "   ✨ Icônes Font Awesome (remplace les PNG au filtre CSS bizarre)"
echo "   ✨ Bloc prix + bouton dans un footer structuré"
echo "   ✨ Hiérarchie typo corrigée (titre > desc > prix)"
echo "   ✨ Animation hover : zoom image + lift carte + glow bouton"
echo "   ✨ Bannière finale redesignée (or + glassmorphism)"
echo "   ✨ Ancres id='chambre-deluxe', 'suite', 'chambre-superieure'"
echo ""
echo -e "${BLUE}🔄 Rollback :${NC}"
echo "   cp $BACKUP/index.html ."
echo "   cp $BACKUP/index.css css/"
echo ""
echo -e "${BLUE}🧹 Nettoyage :${NC}"
echo "   rm -rf $BACKUP refonte_section_chambres.sh"
