#!/usr/bin/env bash
set -euo pipefail

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; BLUE='\033[0;34m'; NC='\033[0m'

echo -e "${BLUE}=================================================${NC}"
echo -e "${BLUE} FIX HERO RESTAURANTS — 50/50 + Logos coins${NC}"
echo -e "${BLUE}=================================================${NC}\n"

HTML="restaurants.html"
CSS="css/restaurants.css"

[ -f "$HTML" ] || { echo -e "${RED}❌ $HTML introuvable${NC}"; exit 1; }
[ -f "$CSS" ]  || { echo -e "${RED}❌ $CSS introuvable${NC}"; exit 1; }

# Sauvegarde
BACKUP=".backup_hero_resto_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP"
cp "$HTML" "$BACKUP/"
cp "$CSS"  "$BACKUP/"
echo -e "${GREEN}📦 Sauvegarde → $BACKUP${NC}\n"

# ============================================================
# 1. REMPLACER LE HERO DANS LE HTML
# ============================================================
echo -e "${BLUE}━━━ [1/2] Mise à jour du HTML ━━━${NC}"

python3 << 'PYEOF'
import re
from pathlib import Path

f = Path('restaurants.html')
c = f.read_text(encoding='utf-8')

# ---------- Nouveau hero ----------
NEW_HERO = '''<!-- ============================================================
         HERO 50/50 — Deux images, deux logos en coins
         ============================================================ -->
    <section class="hero-resto">

        <!-- MOITIÉ GAUCHE — Jour / Beach Club -->
        <div class="hero-resto-half hero-resto-half--jour">
            <div class="hero-resto-bg" style="background-image: url('images/resto-feu-bois.jpg');"></div>
            <div class="hero-resto-overlay"></div>

            <!-- Logo Beach Club en haut à GAUCHE -->
            <div class="hero-resto-logo hero-resto-logo--jour">
                <img src="images/logo-beach-club.png" alt="Teranga Beach Club" class="hero-resto-logo-img">
            </div>
        </div>

        <!-- MOITIÉ DROITE — Nuit / Lounge -->
        <div class="hero-resto-half hero-resto-half--nuit">
            <div class="hero-resto-bg" style="background-image: url('images/resto-bar-nuit.jpg');"></div>
            <div class="hero-resto-overlay"></div>

            <!-- Logo Lounge en haut à DROITE -->
            <div class="hero-resto-logo hero-resto-logo--nuit">
                <img src="images/logo-lounge.png" alt="Teranga Lounge" class="hero-resto-logo-img">
            </div>
        </div>

        <!-- CONTENU CENTRAL SUPERPOSÉ -->
        <div class="hero-resto-stage">
            <span class="hero-resto-eyebrow">
                <span class="hero-resto-dot"></span>
                Restaurants &amp; Bars
                <span class="hero-resto-dot"></span>
            </span>

            <h1 class="hero-resto-title">
                Le feu de bois <em>le jour</em>.<br>
                Les néons du bar <em>la nuit</em>.
            </h1>

            <p class="hero-resto-sub">
                Deux façons de vivre l'océan de Dakar — une carte à midi les pieds
                dans le sable, une carte le soir face à la ville qui s'allume.
            </p>

            <div class="hero-resto-actions">
                <a href="#intro" class="hero-resto-btn hero-resto-btn--primary">
                    Découvrir nos tables
                    <i class="fa-solid fa-arrow-down"></i>
                </a>
                <a href="reservation.html" class="hero-resto-btn hero-resto-btn--ghost">
                    <i class="fa-regular fa-calendar"></i>
                    Réserver
                </a>
                <a href="pdf/menu-complet.pdf" target="_blank" rel="noopener" class="hero-resto-btn hero-resto-btn--ghost">
                    <i class="fa-solid fa-book-open"></i>
                    Menus
                </a>
            </div>
        </div>

        <a href="#intro" class="hero-resto-scroll" aria-label="Descendre">
            <i class="fa-solid fa-chevron-down"></i>
        </a>
    </section>'''

# ---------- Remplacer le hero existant ----------
pattern = re.compile(
    r'<!-- =+\s*\n\s*HERO.*?</section>',
    re.DOTALL
)

if pattern.search(c):
    c = pattern.sub(NEW_HERO, c, count=1)
    print("   ✔ Hero remplacé")
else:
    # Fallback : chercher la balise <section class="hero-resto">
    pattern2 = re.compile(r'<section class="hero-resto">.*?</section>', re.DOTALL)
    if pattern2.search(c):
        c = pattern2.sub(NEW_HERO, c, count=1)
        print("   ✔ Hero remplacé (fallback)")
    else:
        print("   ⚠  Aucun hero trouvé — vérification manuelle requise")

f.write_text(c, encoding='utf-8')
PYEOF

# ============================================================
# 2. METTRE À JOUR LE CSS DU HERO
# ============================================================
echo -e "\n${BLUE}━━━ [2/2] Mise à jour du CSS ━━━${NC}"

python3 << 'PYEOF'
import re
from pathlib import Path

f = Path('css/restaurants.css')
c = f.read_text(encoding='utf-8')

# ---------- Nouveau CSS du hero ----------
NEW_HERO_CSS = '''/* ============================================================= */
/* 1. HERO 50/50 — Deux images + logos en coins                  */
/* ============================================================= */
.hero-resto {
    position: relative;
    height: 92vh;
    min-height: 680px;
    max-height: 960px;
    display: flex;
    overflow: hidden;
    background: #0A1E2D;
}

/* Moitiés 50/50 strictes */
.hero-resto-half {
    position: relative;
    flex: 0 0 50%;
    width: 50%;
    overflow: hidden;
    display: flex;
    align-items: flex-end;
    justify-content: center;
}

/* Image de fond */
.hero-resto-bg {
    position: absolute;
    inset: 0;
    background-size: cover;
    background-position: center;
    background-repeat: no-repeat;
    z-index: 1;
    animation: heroZoomOut 14s ease-out forwards;
    will-change: transform;
}

.hero-resto-half--jour .hero-resto-bg {
    background-color: #E85D2C;
}

.hero-resto-half--nuit .hero-resto-bg {
    background-color: #0A1E2D;
}

@keyframes heroZoomOut {
    from { transform: scale(1.1); }
    to   { transform: scale(1); }
}

/* ---------- Dégradés concentriques (vers le centre) ---------- */
.hero-resto-overlay {
    position: absolute;
    inset: 0;
    z-index: 2;
    pointer-events: none;
}

/* Dégradé côté Jour : du chaud à gauche → sombre vers la droite */
.hero-resto-half--jour .hero-resto-overlay {
    background:
        radial-gradient(ellipse 120% 100% at 0% 50%,
            rgba(232, 93, 44, 0.55) 0%,
            rgba(232, 93, 44, 0.25) 35%,
            rgba(10, 30, 45, 0.75) 70%,
            rgba(10, 30, 45, 0.95) 100%),
        linear-gradient(180deg,
            rgba(0, 0, 0, 0.20) 0%,
            transparent 30%,
            transparent 55%,
            rgba(0, 0, 0, 0.45) 100%);
}

/* Dégradé côté Nuit : sombre à gauche → bleu/néon vers la droite */
.hero-resto-half--nuit .hero-resto-overlay {
    background:
        radial-gradient(ellipse 120% 100% at 100% 50%,
            rgba(21, 94, 117, 0.55) 0%,
            rgba(10, 30, 45, 0.35) 35%,
            rgba(10, 30, 45, 0.85) 70%,
            rgba(10, 30, 45, 0.95) 100%),
        linear-gradient(180deg,
            rgba(0, 0, 0, 0.20) 0%,
            transparent 30%,
            transparent 55%,
            rgba(0, 0, 0, 0.45) 100%);
}

/* ---------- LOGOS restaurants en coins supérieurs ---------- */
.hero-resto-logo {
    position: absolute;
    top: 50px;
    z-index: 5;
    animation: logoFadeIn 1.2s ease-out 0.4s both;
}

.hero-resto-logo--jour {
    left: 50px;
}

.hero-resto-logo--nuit {
    right: 50px;
}

@keyframes logoFadeIn {
    from { opacity: 0; transform: translateY(-12px); }
    to   { opacity: 1; transform: translateY(0); }
}

.hero-resto-logo-img {
    display: block;
    height: 90px;
    width: auto;
    max-width: 200px;
    object-fit: contain;
    filter: drop-shadow(0 4px 20px rgba(0, 0, 0, 0.4));
    transition: transform 0.3s ease;
}

.hero-resto-logo-img:hover {
    transform: scale(1.05);
}

/* Fallback si les logos ne sont pas présents : afficher un texte stylisé */
.hero-resto-logo::after {
    content: "";
    display: block;
}

/* ---------- Voile central pour le titre ---------- */
.hero-resto::after {
    content: "";
    position: absolute;
    top: 0;
    bottom: 0;
    left: 50%;
    transform: translateX(-50%);
    width: 65%;
    background: radial-gradient(ellipse at center,
        rgba(10, 30, 45, 0.92) 0%,
        rgba(10, 30, 45, 0.75) 40%,
        rgba(10, 30, 45, 0.35) 70%,
        transparent 100%);
    z-index: 3;
    pointer-events: none;
}

/* ---------- Contenu central ---------- */
.hero-resto-stage {
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    z-index: 10;
    text-align: center;
    max-width: 720px;
    padding: 0 32px;
    width: 100%;
    color: #fff;
}

.hero-resto-eyebrow {
    display: inline-flex;
    align-items: center;
    gap: 14px;
    font-size: 0.72rem;
    font-weight: 800;
    letter-spacing: 3px;
    text-transform: uppercase;
    color: #C59A67;
    margin-bottom: 24px;
}

.hero-resto-dot {
    width: 5px;
    height: 5px;
    border-radius: 50%;
    background: #C59A67;
    opacity: 0.6;
}

.hero-resto-title {
    font-family: 'Playfair Display', Georgia, serif;
    font-size: clamp(1.9rem, 4.4vw, 3.6rem);
    font-weight: 700;
    line-height: 1.05;
    color: #fff;
    letter-spacing: -0.5px;
    margin: 0 0 22px;
    text-shadow: 0 8px 40px rgba(0, 0, 0, 0.7);
}

.hero-resto-title em {
    font-style: italic;
    color: #C59A67;
}

.hero-resto-sub {
    font-size: 0.98rem;
    line-height: 1.7;
    color: rgba(255, 255, 255, 0.85);
    max-width: 540px;
    margin: 0 auto 30px;
}

.hero-resto-actions {
    display: flex;
    gap: 12px;
    justify-content: center;
    flex-wrap: wrap;
}

.hero-resto-btn {
    display: inline-flex;
    align-items: center;
    gap: 10px;
    padding: 14px 26px;
    border-radius: 40px;
    font-size: 0.76rem;
    font-weight: 800;
    letter-spacing: 1.2px;
    text-transform: uppercase;
    text-decoration: none;
    transition: all 0.3s cubic-bezier(0.25, 1, 0.5, 1);
    border: none;
    font-family: inherit;
    cursor: pointer;
    white-space: nowrap;
}

.hero-resto-btn--primary {
    background: #C59A67;
    color: #fff;
    box-shadow: 0 10px 30px rgba(197, 154, 103, 0.4);
}

.hero-resto-btn--primary:hover {
    background: #B5885A;
    transform: translateY(-3px);
    box-shadow: 0 15px 40px rgba(197, 154, 103, 0.55);
}

.hero-resto-btn--ghost {
    background: rgba(255, 255, 255, 0.08);
    color: #fff;
    border: 1.5px solid rgba(255, 255, 255, 0.35);
    backdrop-filter: blur(10px);
    -webkit-backdrop-filter: blur(10px);
}

.hero-resto-btn--ghost:hover {
    background: rgba(255, 255, 255, 0.18);
    border-color: #fff;
    transform: translateY(-3px);
}

/* ---------- Chevron scroll ---------- */
.hero-resto-scroll {
    position: absolute;
    bottom: 26px;
    left: 50%;
    transform: translateX(-50%);
    z-index: 10;
    color: #fff;
    font-size: 1.2rem;
    animation: scrollBounce 2.2s ease-in-out infinite;
    cursor: pointer;
    background: rgba(255, 255, 255, 0.1);
    border: 1px solid rgba(255, 255, 255, 0.25);
    width: 46px;
    height: 46px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    backdrop-filter: blur(10px);
    -webkit-backdrop-filter: blur(10px);
    transition: background 0.3s;
    text-decoration: none;
}

.hero-resto-scroll:hover {
    background: rgba(255, 255, 255, 0.22);
}

@keyframes scrollBounce {
    0%, 100% { transform: translate(-50%, 0); }
    50%      { transform: translate(-50%, -8px); }
}

/* ---------- Responsive hero ---------- */
@media (max-width: 768px) {
    .hero-resto {
        height: auto;
        min-height: 100vh;
        max-height: none;
        flex-direction: column;
    }
    .hero-resto-half {
        flex: 0 0 auto;
        width: 100%;
        min-height: 44vh;
    }
    .hero-resto::after {
        display: none;
    }
    .hero-resto-stage {
        position: relative;
        top: auto;
        left: auto;
        transform: none;
        max-width: 100%;
        padding: 40px 24px;
        background: rgba(10, 30, 45, 0.92);
    }
    .hero-resto-title {
        font-size: 1.6rem;
    }
    .hero-resto-logo {
        top: 30px;
    }
    .hero-resto-logo--jour {
        left: 20px;
    }
    .hero-resto-logo--nuit {
        right: 20px;
    }
    .hero-resto-logo-img {
        height: 60px;
        max-width: 130px;
    }
    .hero-resto-actions {
        flex-direction: column;
        align-items: stretch;
    }
    .hero-resto-btn {
        justify-content: center;
    }
}

@media (prefers-reduced-motion: reduce) {
    .hero-resto-bg {
        animation: none;
    }
    .hero-resto-scroll {
        animation: none;
    }
    .hero-resto-logo {
        opacity: 1;
        animation: none;
    }
}'''

# Supprimer l'ancien bloc hero (de "1. HERO" jusqu'au "2. INTRO" ou similaire)
start_patterns = [
    r'/\* =+ \*/\s*\n/\* 1\. HERO.*?(?=/\* =+ \*/\s*\n/\* 2\.)',
    r'/\* =+ \*/\s*\n/\* 1\. HERO 50/50.*?(?=/\* =+ \*/\s*\n/\* 2\.)',
    r'/\* =+ \*/\s*\n/\* 1\. HERO.*?(?=/\* =+ \*/\s*\n/\* 2\. INTRO)',
]

removed = False
for pat in start_patterns:
    if re.search(pat, c, re.DOTALL):
        c = re.sub(pat, NEW_HERO_CSS + '\n\n', c, count=1, flags=re.DOTALL)
        print("   ✔ Ancien CSS hero remplacé")
        removed = True
        break

if not removed:
    # Fallback : insérer après la ligne "restaurants-page .container"
    anchor = '/* ============================================================= */\n/* 2. INTRO'
    if anchor in c:
        c = c.replace(anchor, NEW_HERO_CSS + '\n\n' + anchor, 1)
        print("   ✔ Nouveau CSS hero inséré avant la section INTRO")
    else:
        c = NEW_HERO_CSS + '\n\n' + c
        print("   ✔ Nouveau CSS hero ajouté en début de fichier")

f.write_text(c, encoding='utf-8')
PYEOF

# ============================================================
# 3. VÉRIFICATION
# ============================================================
echo -e "\n${BLUE}━━━ VÉRIFICATION ━━━${NC}"

printf "   %-42s | %s\n" "Élément" "Valeur"
printf "   %-42s-|-%s\n" "------------------------------------------" "--------"

printf "   %-42s | %s\n" "Hero : moitiés 50/50 (2 attendues)" "$(grep -c 'hero-resto-half' "$HTML")"
printf "   %-42s | %s\n" "Images hero (2 attendues)" "$(grep -o 'hero-resto-bg' "$HTML" | wc -l)"
printf "   %-42s | %s\n" "Logos en coins (2 attendus)" "$(grep -o 'hero-resto-logo--' "$HTML" | wc -l)"
printf "   %-42s | %s\n" "Dégradés concentriques CSS" "$(grep -c 'radial-gradient' "$CSS")"

echo ""
echo -e "${GREEN}✅ TERMINÉ${NC}"
echo -e "${BLUE}💾 Sauvegarde : $BACKUP${NC}"
echo ""
echo -e "${BLUE}📌 Étapes suivantes :${NC}"
echo "   1. Préparez ces 2 images de logos :"
echo "      • images/logo-beach-club.png   (fond transparent, ~400px de large)"
echo "      • images/logo-lounge.png        (fond transparent, ~400px de large)"
echo ""
echo "   2. Préparez ces 2 images de fond :"
echo "      • images/resto-feu-bois.jpg    (feu de bois, 16:9)"
echo "      • images/resto-bar-nuit.jpg     (bar de nuit, 16:9)"
echo ""
echo "   3. Ctrl + Shift + R dans le navigateur"
echo ""
echo -e "${BLUE}🔄 Rollback :${NC}"
echo "   cp $BACKUP/restaurants.html ."
echo "   cp $BACKUP/restaurants.css css/"
echo ""
echo -e "${BLUE}🧹 Nettoyage :${NC}"
echo "   rm -rf $BACKUP fix_hero_resto.sh"
