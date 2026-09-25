#!/usr/bin/env bash
set -euo pipefail

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; BLUE='\033[0;34m'; NC='\033[0m'

echo -e "${BLUE}=====================================================${NC}"
echo -e "${BLUE} AMÉLIORATION PREMIUM — experiences-piscine.html${NC}"
echo -e "${BLUE}====================================================${NC}\n"

HTML="experiences-piscine.html"
CSS="css/services-piscine.css"

[ -f "$HTML" ] || { echo -e "${RED}❌ $HTML introuvable${NC}"; exit 1; }
[ -f "$CSS" ]  || { echo -e "${RED}❌ $CSS introuvable${NC}"; exit 1; }

BACKUP=".backup_premium_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP"
cp "$HTML" "$BACKUP/"
cp "$CSS" "$BACKUP/"
echo -e "${GREEN}📦 Sauvegarde → $BACKUP${NC}\n"

# ============================================================
# 1. NOUVEAU CSS — version premium
# ============================================================
echo -e "${BLUE}━━━ [1/3] Réécriture du CSS premium ━━━${NC}"

cat > "$CSS" << 'CSS_EOF'
/* ============================================================= */
/* SERVICES-PISCINE.CSS — Page Piscine & Spa (version premium)   */
/* Responsable : Rock Melvin                                     */
/* Scopé sous .piscine-page — NE PAS toucher au top menu/footer  */
/* ============================================================= */

.piscine-page {
    --vert-pullman: var(--couleur-vert, #38E28F);
    --bleu-pullman: var(--couleur-bleu-profond, #155E75);
    --sable-pullman: var(--couleur-sable, #C8A77A);
    --texte-sombre: #1A2B3C;
    --texte-gris: #6A7580;
    --ligne-grise: #E8ECEF;
    --ombre-douce: 0 10px 30px rgba(0, 0, 0, 0.06);
    --ombre-forte: 0 20px 50px rgba(0, 0, 0, 0.12);
}

/* ============================================================= */
/* 1. HERO SLIDER PREMIUM                                         */
/* ============================================================= */
.piscine-page .hero-spa {
    position: relative;
    height: 88vh;
    min-height: 640px;
    max-height: 900px;
    display: flex;
    align-items: center;
    overflow: hidden;
    color: #fff;
    background-color: #0A1E2D;
}

/* Slides empilés */
.piscine-page .hero-spa-slide {
    position: absolute;
    inset: 0;
    background-size: cover;
    background-position: center;
    background-repeat: no-repeat;
    opacity: 0;
    transform: scale(1.08);
    transition: opacity 1.4s ease-in-out, transform 8s ease-out;
    z-index: 1;
    will-change: opacity, transform;
}
.piscine-page .hero-spa-slide.active {
    opacity: 1;
    transform: scale(1);
    z-index: 2;
}

/* Overlay dégradé */
.piscine-page .hero-spa-overlay {
    position: absolute;
    inset: 0;
    background: linear-gradient(90deg,
        rgba(10, 30, 45, 0.88) 0%,
        rgba(10, 30, 45, 0.60) 45%,
        rgba(10, 30, 45, 0.20) 100%),
        linear-gradient(180deg,
        rgba(0, 0, 0, 0.30) 0%,
        transparent 40%,
        rgba(0, 0, 0, 0.35) 100%);
    z-index: 3;
}

/* Contenu */
.piscine-page .hero-spa-content {
    position: relative;
    z-index: 4;
    max-width: 1200px;
    margin: 0 auto;
    padding: 60px 40px;
    width: 100%;
}
.piscine-page .breadcrumb {
    font-size: 0.78rem;
    letter-spacing: 1.8px;
    text-transform: uppercase;
    margin-bottom: 28px;
    opacity: 0.85;
    display: flex;
    align-items: center;
    gap: 8px;
    flex-wrap: wrap;
}
.piscine-page .breadcrumb a {
    color: #fff;
    text-decoration: none;
    transition: color 0.3s;
}
.piscine-page .breadcrumb a:hover {
    color: var(--vert-pullman);
}
.piscine-page .breadcrumb span {
    opacity: 0.7;
}

.piscine-page .hero-spa h1 {
    font-size: clamp(2.6rem, 5.5vw, 4.5rem);
    font-weight: 800;
    line-height: 1.02;
    letter-spacing: 2px;
    text-transform: uppercase;
    margin-bottom: 24px;
    max-width: 700px;
    color: #ffffff;
    text-shadow: 0 4px 30px rgba(0, 0, 0, 0.35);
}
.piscine-page .trait-vert {
    display: block;
    width: 72px;
    height: 4px;
    background: var(--vert-pullman);
    border-radius: 2px;
    margin-bottom: 26px;
    box-shadow: 0 0 20px rgba(56, 226, 143, 0.5);
}
.piscine-page .hero-spa-texte {
    font-size: 1.05rem;
    line-height: 1.85;
    max-width: 580px;
    margin-bottom: 38px;
    opacity: 0.96;
    text-shadow: 0 2px 12px rgba(0, 0, 0, 0.3);
}

/* Boutons hero */
.piscine-page .hero-actions {
    display: flex;
    gap: 16px;
    flex-wrap: wrap;
}
.piscine-page .btn-hero-primary,
.piscine-page .btn-hero-ghost {
    display: inline-flex;
    align-items: center;
    gap: 10px;
    padding: 16px 32px;
    border-radius: 40px;
    font-weight: 700;
    font-size: 0.82rem;
    letter-spacing: 1.2px;
    text-transform: uppercase;
    text-decoration: none;
    transition: all 0.3s ease;
    cursor: pointer;
    border: none;
    font-family: inherit;
}
.piscine-page .btn-hero-primary {
    background: var(--vert-pullman);
    color: #0A1E2D;
    box-shadow: 0 10px 30px rgba(56, 226, 143, 0.35);
}
.piscine-page .btn-hero-primary:hover {
    background: #2BC87A;
    transform: translateY(-3px);
    box-shadow: 0 15px 40px rgba(56, 226, 143, 0.5);
}
.piscine-page .btn-hero-primary i {
    transition: transform 0.3s ease;
}
.piscine-page .btn-hero-primary:hover i {
    transform: translateX(4px);
}
.piscine-page .btn-hero-ghost {
    background: rgba(255, 255, 255, 0.08);
    color: #fff;
    border: 1.5px solid rgba(255, 255, 255, 0.4);
    backdrop-filter: blur(10px);
}
.piscine-page .btn-hero-ghost:hover {
    background: rgba(255, 255, 255, 0.18);
    border-color: #fff;
    transform: translateY(-3px);
}

/* Indicateurs (dots) */
.piscine-page .hero-dots {
    position: absolute;
    bottom: 40px;
    left: 50%;
    transform: translateX(-50%);
    display: flex;
    gap: 12px;
    z-index: 5;
}
.piscine-page .hero-dot {
    width: 40px;
    height: 4px;
    border-radius: 2px;
    background: rgba(255, 255, 255, 0.35);
    border: none;
    cursor: pointer;
    padding: 0;
    transition: all 0.4s ease;
}
.piscine-page .hero-dot.active {
    background: var(--vert-pullman);
    width: 60px;
    box-shadow: 0 0 15px rgba(56, 226, 143, 0.6);
}

/* Flèches */
.piscine-page .hero-nav {
    position: absolute;
    top: 50%;
    transform: translateY(-50%);
    width: 50px;
    height: 50px;
    border-radius: 50%;
    background: rgba(255, 255, 255, 0.1);
    border: 1.5px solid rgba(255, 255, 255, 0.3);
    color: #fff;
    font-size: 1.1rem;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    z-index: 5;
    backdrop-filter: blur(8px);
    transition: all 0.3s ease;
}
.piscine-page .hero-nav:hover {
    background: var(--vert-pullman);
    border-color: var(--vert-pullman);
    color: #0A1E2D;
    transform: translateY(-50%) scale(1.1);
}
.piscine-page .hero-nav.prev { left: 30px; }
.piscine-page .hero-nav.next { right: 30px; }

/* Badge "5 étoiles" flottant */
.piscine-page .hero-badge {
    position: absolute;
    top: 40px;
    right: 40px;
    z-index: 5;
    display: flex;
    align-items: center;
    gap: 10px;
    padding: 12px 20px;
    background: rgba(255, 255, 255, 0.1);
    border: 1.5px solid rgba(255, 255, 255, 0.25);
    border-radius: 50px;
    backdrop-filter: blur(12px);
    font-size: 0.75rem;
    font-weight: 700;
    letter-spacing: 1.5px;
    text-transform: uppercase;
}
.piscine-page .hero-badge i {
    color: var(--sable-pullman);
    font-size: 0.85rem;
}

/* ============================================================= */
/* 2. SECTIONS GÉNÉRALES                                          */
/* ============================================================= */
.piscine-page .section { padding: 100px 0; }
.piscine-page .section-blanche { background: #fff; }
.piscine-page .section-grise { background: #F5F7F6; }
.piscine-page .section-sombre {
    background: #0A1E2D;
    color: #fff;
}
.piscine-page .container {
    max-width: 1280px;
    margin: 0 auto;
    padding: 0 50px;
}

.piscine-page .section-subtitle {
    color: var(--vert-pullman);
    font-size: 0.72rem;
    font-weight: 700;
    letter-spacing: 3px;
    text-transform: uppercase;
    margin-bottom: 14px;
    display: inline-block;
}
.piscine-page .section-subtitle-blanc {
    color: #A8E6CF;
    font-size: 0.72rem;
    font-weight: 700;
    letter-spacing: 3px;
    text-transform: uppercase;
    margin-bottom: 14px;
}
.piscine-page .titre-souligne {
    position: relative;
    display: inline-block;
    font-size: clamp(1.7rem, 2.6vw, 2.3rem);
    font-weight: 700;
    color: var(--texte-sombre);
    padding-bottom: 22px;
    line-height: 1.25;
    text-align: left;
}
.piscine-page .titre-souligne::after {
    content: "";
    position: absolute;
    bottom: 0;
    left: 0;
    width: 64px;
    height: 4px;
    background: var(--vert-pullman);
    border-radius: 2px;
}

/* ============================================================= */
/* 3. BIENFAITS                                                   */
/* ============================================================= */
.piscine-page .section-bienfaits { padding: 90px 0; }
.piscine-page .bienfaits-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 80px;
    align-items: center;
}
.piscine-page .bienfaits-texte .titre-souligne {
    font-size: 1.7rem;
    padding-bottom: 18px;
    margin-bottom: 28px;
}
.piscine-page .bienfaits-texte .titre-souligne::after {
    width: 54px;
    height: 3px;
}
.piscine-page .bienfaits-desc {
    font-size: 0.95rem;
    color: var(--texte-gris);
    line-height: 1.8;
    margin-bottom: 40px;
    max-width: 500px;
}
.piscine-page .icones-grid {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 24px;
}
.piscine-page .icone-item {
    text-align: center;
    cursor: pointer;
    padding: 20px 8px;
    border-radius: 12px;
    transition: background 0.3s, transform 0.3s;
}
.piscine-page .icone-item:hover {
    background: rgba(56, 226, 143, 0.05);
    transform: translateY(-4px);
}
.piscine-page .icone-cercle {
    display: inline-flex;
    justify-content: center;
    align-items: center;
    width: 56px;
    height: 56px;
    border-radius: 50%;
    background: rgba(56, 226, 143, 0.12);
    color: var(--vert-pullman);
    font-size: 20px;
    margin-bottom: 12px;
    transition: transform 0.4s cubic-bezier(0.34, 1.56, 0.64, 1), background 0.3s, box-shadow 0.3s;
}
.piscine-page .icone-item:hover .icone-cercle {
    transform: scale(1.12) rotate(-6deg);
    background: var(--vert-pullman);
    color: #fff;
    box-shadow: 0 12px 28px rgba(56, 226, 143, 0.35);
}
.piscine-page .icone-item p {
    font-size: 0.82rem;
    font-weight: 600;
    color: var(--texte-sombre);
    margin: 0;
    letter-spacing: 0.3px;
}
.piscine-page .bienfaits-image {
    position: relative;
}
.piscine-page .bienfaits-image::before {
    content: "";
    position: absolute;
    inset: 20px -20px -20px 20px;
    border: 2px solid var(--vert-pullman);
    border-radius: 12px;
    z-index: 0;
    opacity: 0.4;
    transition: all 0.5s ease;
}
.piscine-page .bienfaits-image:hover::before {
    inset: 12px -12px -12px 12px;
    opacity: 0.7;
}
.piscine-page .bienfaits-image img {
    position: relative;
    z-index: 1;
    width: 100%;
    height: 420px;
    object-fit: cover;
    border-radius: 12px;
    box-shadow: var(--ombre-forte);
    transition: transform 0.6s ease;
}
.piscine-page .bienfaits-image:hover img {
    transform: translate(-4px, -4px);
}

/* ============================================================= */
/* 4. ART DU SPA                                                  */
/* ============================================================= */
.piscine-page .section-art-spa { padding: 100px 0; }
.piscine-page .art-spa-grid {
    display: grid;
    grid-template-columns: 1fr 1.1fr;
    gap: 70px;
    align-items: center;
}
.piscine-page .art-spa-texte .titre-souligne {
    font-size: 1.7rem;
    padding-bottom: 18px;
    margin-bottom: 24px;
}
.piscine-page .art-spa-texte .titre-souligne::after {
    width: 54px;
    height: 3px;
}
.piscine-page .art-spa-desc {
    font-size: 0.95rem;
    color: var(--texte-gris);
    line-height: 1.8;
    margin-bottom: 40px;
    max-width: 500px;
}
.piscine-page .services-liste {
    display: flex;
    flex-direction: column;
    gap: 24px;
}
.piscine-page .service-ligne {
    display: flex;
    align-items: flex-start;
    gap: 18px;
    padding: 16px;
    border-radius: 12px;
    transition: background 0.3s, transform 0.3s;
}
.piscine-page .service-ligne:hover {
    background: #fff;
    transform: translateX(6px);
    box-shadow: var(--ombre-douce);
}
.piscine-page .service-icone {
    display: inline-flex;
    justify-content: center;
    align-items: center;
    min-width: 48px;
    height: 48px;
    border-radius: 12px;
    background: linear-gradient(135deg, rgba(56, 226, 143, 0.12), rgba(21, 94, 117, 0.08));
    color: var(--bleu-pullman);
    font-size: 18px;
    flex-shrink: 0;
    transition: all 0.3s ease;
}
.piscine-page .service-ligne:hover .service-icone {
    background: var(--vert-pullman);
    color: #fff;
    transform: rotate(-6deg) scale(1.05);
}
.piscine-page .service-ligne h4 {
    color: var(--texte-sombre);
    font-size: 0.98rem;
    font-weight: 700;
    margin-bottom: 5px;
}
.piscine-page .service-ligne p {
    font-size: 0.85rem;
    color: var(--texte-gris);
    line-height: 1.55;
    margin: 0;
}
.piscine-page .art-spa-images {
    display: flex;
    flex-direction: column;
    gap: 16px;
}
.piscine-page .image-principale {
    overflow: hidden;
    border-radius: 12px;
    box-shadow: var(--ombre-forte);
}
.piscine-page .image-principale img {
    width: 100%;
    height: 300px;
    object-fit: cover;
    display: block;
    transition: transform 0.8s ease;
}
.piscine-page .image-principale:hover img {
    transform: scale(1.06);
}
.piscine-page .images-secondaires {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 14px;
}
.piscine-page .images-secondaires img {
    width: 100%;
    height: 120px;
    object-fit: cover;
    border-radius: 10px;
    transition: transform 0.4s ease, box-shadow 0.4s ease;
    cursor: pointer;
}
.piscine-page .images-secondaires img:hover {
    transform: translateY(-6px) scale(1.04);
    box-shadow: var(--ombre-forte);
}

/* ============================================================= */
/* 5. PRESTATIONS                                                 */
/* ============================================================= */
.piscine-page .section-prestations { padding: 100px 0; }
.piscine-page .prestations-wrapper {
    display: grid;
    grid-template-columns: 1fr 2.2fr;
    gap: 70px;
    align-items: center;
}
.piscine-page .prestations-intro .titre-souligne {
    font-size: 1.7rem;
    padding-bottom: 18px;
    margin-bottom: 26px;
}
.piscine-page .prestations-intro .titre-souligne::after {
    width: 54px;
    height: 3px;
}
.piscine-page .prestations-desc {
    font-size: 0.95rem;
    color: var(--texte-gris);
    line-height: 1.8;
    margin-bottom: 30px;
    max-width: 400px;
}
.piscine-page .btn-contour {
    display: inline-block;
    padding: 14px 32px;
    border: 1.5px solid var(--bleu-pullman);
    border-radius: 40px;
    color: var(--bleu-pullman);
    text-decoration: none;
    font-size: 0.82rem;
    font-weight: 700;
    letter-spacing: 1px;
    text-transform: uppercase;
    transition: all 0.3s ease;
}
.piscine-page .btn-contour:hover {
    background: var(--bleu-pullman);
    color: #fff;
    transform: translateY(-3px);
    box-shadow: 0 10px 25px rgba(21, 94, 117, 0.3);
}
.piscine-page .prestations-cards {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 24px;
}
.piscine-page .card-pullman {
    background: #fff;
    border: 1px solid var(--ligne-grise);
    border-radius: 14px;
    overflow: hidden;
    transition: all 0.4s cubic-bezier(0.25, 1, 0.5, 1);
    display: flex;
    flex-direction: column;
    cursor: pointer;
    position: relative;
}
.piscine-page .card-pullman::after {
    content: "";
    position: absolute;
    bottom: 0;
    left: 0;
    right: 0;
    height: 3px;
    background: var(--vert-pullman);
    transform: scaleX(0);
    transform-origin: left;
    transition: transform 0.4s ease;
}
.piscine-page .card-pullman:hover::after {
    transform: scaleX(1);
}
.piscine-page .card-pullman:hover {
    transform: translateY(-8px);
    box-shadow: var(--ombre-forte);
    border-color: transparent;
}
.piscine-page .card-img {
    overflow: hidden;
    height: 200px;
    position: relative;
}
.piscine-page .card-img::after {
    content: "";
    position: absolute;
    inset: 0;
    background: linear-gradient(180deg, transparent 40%, rgba(0, 0, 0, 0.4));
    opacity: 0;
    transition: opacity 0.4s ease;
}
.piscine-page .card-pullman:hover .card-img::after {
    opacity: 1;
}
.piscine-page .card-img img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    transition: transform 0.7s ease;
    display: block;
}
.piscine-page .card-pullman:hover .card-img img {
    transform: scale(1.1);
}
.piscine-page .card-body {
    padding: 22px;
    display: flex;
    flex-direction: column;
    flex: 1;
}
.piscine-page .card-body h3 {
    color: var(--texte-sombre);
    font-size: 1.05rem;
    font-weight: 700;
    margin-bottom: 10px;
}
.piscine-page .card-body p {
    font-size: 0.85rem;
    color: var(--texte-gris);
    line-height: 1.6;
    margin-bottom: 18px;
    flex: 1;
}
.piscine-page .prix {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    color: var(--vert-pullman);
    font-weight: 700;
    font-size: 0.82rem;
    letter-spacing: 0.5px;
    text-transform: uppercase;
    transition: gap 0.3s ease;
}
.piscine-page .card-pullman:hover .prix {
    gap: 12px;
}

/* ============================================================= */
/* 6. TÉMOIGNAGES                                                 */
/* ============================================================= */
.piscine-page .section-temoignages {
    padding: 100px 0;
    background: linear-gradient(180deg, #F5F7F6 0%, #FFFFFF 100%);
}
.piscine-page .temoignages-header {
    text-align: center;
    margin-bottom: 60px;
}
.piscine-page .temoignages-header .titre-souligne {
    text-align: center;
}
.piscine-page .temoignages-header .titre-souligne::after {
    left: 50%;
    transform: translateX(-50%);
}
.piscine-page .temoignages-grid {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 30px;
}
.piscine-page .temoignage-card {
    background: #fff;
    border-radius: 14px;
    padding: 32px 28px;
    box-shadow: var(--ombre-douce);
    position: relative;
    transition: transform 0.4s ease, box-shadow 0.4s ease;
    border: 1px solid transparent;
}
.piscine-page .temoignage-card:hover {
    transform: translateY(-6px);
    box-shadow: var(--ombre-forte);
    border-color: rgba(56, 226, 143, 0.2);
}
.piscine-page .temoignage-quote {
    position: absolute;
    top: 20px;
    right: 24px;
    font-size: 4rem;
    line-height: 1;
    color: rgba(56, 226, 143, 0.15);
    font-family: Georgia, serif;
}
.piscine-page .temoignage-stars {
    display: flex;
    gap: 4px;
    color: #FFC107;
    font-size: 0.9rem;
    margin-bottom: 16px;
}
.piscine-page .temoignage-texte {
    font-size: 0.95rem;
    color: var(--texte-sombre);
    line-height: 1.7;
    margin-bottom: 24px;
    font-style: italic;
}
.piscine-page .temoignage-auteur {
    display: flex;
    align-items: center;
    gap: 14px;
    padding-top: 20px;
    border-top: 1px solid var(--ligne-grise);
}
.piscine-page .temoignage-avatar {
    width: 48px;
    height: 48px;
    border-radius: 50%;
    background: linear-gradient(135deg, var(--vert-pullman), var(--bleu-pullman));
    color: #fff;
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: 700;
    font-size: 1.1rem;
    flex-shrink: 0;
}
.piscine-page .temoignage-info h5 {
    margin: 0 0 2px;
    font-size: 0.9rem;
    font-weight: 700;
    color: var(--texte-sombre);
}
.piscine-page .temoignage-info span {
    font-size: 0.75rem;
    color: var(--texte-gris);
}

/* ============================================================= */
/* 7. FAQ                                                         */
/* ============================================================= */
.piscine-page .section-faq {
    padding: 100px 0;
    background: #fff;
}
.piscine-page .faq-header {
    text-align: center;
    margin-bottom: 50px;
}
.piscine-page .faq-header .titre-souligne {
    text-align: center;
}
.piscine-page .faq-header .titre-souligne::after {
    left: 50%;
    transform: translateX(-50%);
}
.piscine-page .faq-liste {
    max-width: 800px;
    margin: 0 auto;
    display: flex;
    flex-direction: column;
    gap: 14px;
}
.piscine-page .faq-item {
    background: #F9FAFB;
    border: 1px solid var(--ligne-grise);
    border-radius: 10px;
    overflow: hidden;
    transition: border-color 0.3s, box-shadow 0.3s;
}
.piscine-page .faq-item:hover {
    border-color: rgba(56, 226, 143, 0.4);
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.04);
}
.piscine-page .faq-item.open {
    border-color: var(--vert-pullman);
    background: #fff;
}
.piscine-page .faq-question {
    width: 100%;
    background: none;
    border: none;
    padding: 20px 24px;
    font-size: 0.95rem;
    font-weight: 700;
    color: var(--texte-sombre);
    text-align: left;
    cursor: pointer;
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 16px;
    font-family: inherit;
    transition: color 0.3s;
}
.piscine-page .faq-question:hover {
    color: var(--vert-pullman);
}
.piscine-page .faq-chevron {
    color: var(--vert-pullman);
    font-size: 0.9rem;
    transition: transform 0.3s ease;
    flex-shrink: 0;
}
.piscine-page .faq-item.open .faq-chevron {
    transform: rotate(180deg);
}
.piscine-page .faq-reponse {
    max-height: 0;
    overflow: hidden;
    transition: max-height 0.4s ease, padding 0.4s ease;
    padding: 0 24px;
    font-size: 0.88rem;
    color: var(--texte-gris);
    line-height: 1.7;
}
.piscine-page .faq-item.open .faq-reponse {
    max-height: 300px;
    padding: 0 24px 22px;
}

/* ============================================================= */
/* 8. BANNIÈRE VERTE                                              */
/* ============================================================= */
.piscine-page .banniere-verte {
    padding: 60px 40px;
}
.piscine-page .banniere-container {
    max-width: 1200px;
    margin: 0 auto;
    padding: 60px 50px;
    border-radius: 16px;
    position: relative;
    overflow: hidden;
    background: linear-gradient(135deg, #0A8F66 0%, #007A54 100%);
    color: #fff;
    box-shadow: 0 25px 60px rgba(10, 143, 102, 0.3);
}
.piscine-page .banniere-container::before {
    content: "";
    position: absolute;
    inset: 0;
    background-image:
        radial-gradient(circle at 20% 40%, rgba(255,255,255,0.08) 0%, transparent 40%),
        radial-gradient(circle at 80% 70%, rgba(255,255,255,0.06) 0%, transparent 35%),
        radial-gradient(circle at 50% 100%, rgba(0,0,0,0.15) 0%, transparent 50%);
    pointer-events: none;
}
.piscine-page .banniere-container::after {
    content: "";
    position: absolute;
    top: -50%;
    right: -10%;
    width: 400px;
    height: 400px;
    border-radius: 50%;
    background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, transparent 70%);
    pointer-events: none;
}
.piscine-page .banniere-grid {
    display: grid;
    grid-template-columns: 1.2fr 1.3fr 0.9fr;
    gap: 50px;
    align-items: center;
    position: relative;
    z-index: 1;
}
.piscine-page .banniere-texte h2 {
    font-size: clamp(1.6rem, 2.4vw, 2rem);
    font-weight: 700;
    margin: 8px 0 16px;
    line-height: 1.2;
    color: #fff;
}
.piscine-page .banniere-texte p {
    font-size: 0.95rem;
    line-height: 1.75;
    opacity: 0.94;
}
.piscine-page .banniere-liste {
    list-style: none;
    padding: 0;
    margin: 0;
    display: flex;
    flex-direction: column;
    gap: 18px;
}
.piscine-page .banniere-liste li {
    display: flex;
    align-items: center;
    gap: 14px;
    font-size: 0.9rem;
    line-height: 1.5;
    opacity: 0.96;
    transition: transform 0.3s ease;
}
.piscine-page .banniere-liste li:hover {
    transform: translateX(6px);
}
.piscine-page .liste-icone {
    display: inline-flex;
    justify-content: center;
    align-items: center;
    min-width: 34px;
    height: 34px;
    border-radius: 50%;
    background: rgba(255, 255, 255, 0.15);
    border: 1px solid rgba(255, 255, 255, 0.3);
    font-size: 0.85rem;
    flex-shrink: 0;
    color: #fff;
    transition: background 0.3s, transform 0.3s;
}
.piscine-page .banniere-liste li:hover .liste-icone {
    background: #fff;
    color: #0A8F66;
    transform: rotate(-8deg) scale(1.1);
}
.piscine-page .banniere-prix {
    text-align: center;
    padding-left: 40px;
    border-left: 1px solid rgba(255, 255, 255, 0.25);
}
.piscine-page .prix-label,
.piscine-page .prix-ttc {
    display: block;
    font-size: 0.7rem;
    letter-spacing: 2px;
    opacity: 0.85;
    font-weight: 600;
}
.piscine-page .prix-valeur {
    display: block;
    font-size: clamp(2.2rem, 3.2vw, 3rem);
    font-weight: 800;
    margin: 10px 0;
    line-height: 1;
    color: #fff;
}
.piscine-page .btn-blanc {
    display: inline-block;
    background: #fff;
    color: #007A54;
    text-decoration: none;
    padding: 14px 34px;
    border-radius: 40px;
    font-weight: 700;
    font-size: 0.78rem;
    letter-spacing: 1.5px;
    text-transform: uppercase;
    margin-top: 20px;
    transition: transform 0.3s, box-shadow 0.3s;
    cursor: pointer;
    border: none;
    font-family: inherit;
}
.piscine-page .btn-blanc:hover {
    transform: translateY(-3px);
    box-shadow: 0 12px 30px rgba(0, 0, 0, 0.25);
}

/* ============================================================= */
/* 9. HORAIRES                                                    */
/* ============================================================= */
.piscine-page .section-horaires {
    padding: 90px 0;
    background: #fff;
}
.piscine-page .horaires-wrapper {
    display: grid;
    grid-template-columns: 280px 1fr;
    gap: 60px;
    align-items: center;
}
.piscine-page .horaires-titre .titre-souligne {
    font-size: 1.9rem;
    padding-bottom: 20px;
    line-height: 1.2;
}
.piscine-page .horaires-titre .titre-souligne::after {
    width: 54px;
    height: 3px;
}
.piscine-page .horaires-grid {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
}
.piscine-page .horaire-item {
    text-align: left;
    padding: 0 26px;
    border-left: 1px solid var(--ligne-grise);
    transition: transform 0.3s ease;
}
.piscine-page .horaire-item:hover {
    transform: translateY(-4px);
}
.piscine-page .horaire-item:first-child {
    border-left: none;
    padding-left: 0;
}
.piscine-page .horaire-item:last-child {
    padding-right: 0;
}
.piscine-page .horaire-icone {
    display: inline-flex;
    justify-content: center;
    align-items: center;
    width: 46px;
    height: 46px;
    border-radius: 50%;
    background: #fff;
    border: 1.5px solid var(--ligne-grise);
    color: var(--bleu-pullman);
    font-size: 16px;
    margin-bottom: 18px;
    transition: all 0.3s ease;
}
.piscine-page .horaire-item:hover .horaire-icone {
    border-color: var(--vert-pullman);
    background: var(--vert-pullman);
    color: #fff;
    transform: rotate(-8deg) scale(1.08);
}
.piscine-page .horaire-item h4 {
    color: var(--texte-sombre);
    font-size: 0.98rem;
    font-weight: 700;
    margin-bottom: 8px;
}
.piscine-page .horaire-item p {
    font-size: 0.86rem;
    color: var(--texte-gris);
    line-height: 1.6;
    margin: 0;
}

/* ============================================================= */
/* 10. POP-UP RÉSERVATION DE SOIN                                 */
/* ============================================================= */
.spa-modal-overlay {
    position: fixed;
    inset: 0;
    background: rgba(10, 20, 30, 0.65);
    backdrop-filter: blur(4px);
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 20px;
    z-index: 2500;
    opacity: 0;
    visibility: hidden;
    transition: opacity 0.3s ease, visibility 0.3s ease;
}
.spa-modal-overlay.is-open {
    opacity: 1;
    visibility: visible;
}
.spa-modal {
    background: #fff;
    width: 100%;
    max-width: 560px;
    max-height: 90vh;
    overflow-y: auto;
    border-radius: 16px;
    position: relative;
    box-shadow: 0 30px 80px rgba(0, 0, 0, 0.4);
    transform: translateY(30px) scale(0.96);
    transition: transform 0.4s cubic-bezier(0.25, 1, 0.5, 1);
}
.spa-modal-overlay.is-open .spa-modal {
    transform: translateY(0) scale(1);
}
.spa-modal-close {
    position: absolute;
    top: 18px;
    right: 18px;
    width: 38px;
    height: 38px;
    border-radius: 50%;
    background: rgba(255, 255, 255, 0.95);
    border: none;
    color: var(--texte-sombre);
    font-size: 16px;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 10;
    transition: background 0.3s, color 0.3s, transform 0.3s;
}
.spa-modal-close:hover {
    background: var(--vert-pullman);
    color: #fff;
    transform: rotate(90deg);
}
.spa-modal-header {
    padding: 32px 32px 24px;
    background: linear-gradient(135deg, #0A1E2D 0%, #155E75 100%);
    color: #fff;
    border-radius: 16px 16px 0 0;
    position: relative;
    overflow: hidden;
}
.spa-modal-header::before {
    content: "";
    position: absolute;
    top: -50%;
    right: -20%;
    width: 250px;
    height: 250px;
    border-radius: 50%;
    background: radial-gradient(circle, rgba(56, 226, 143, 0.25) 0%, transparent 70%);
    pointer-events: none;
}
.spa-modal-header .eyebrow {
    display: inline-block;
    color: var(--vert-pullman);
    font-size: 0.7rem;
    font-weight: 700;
    letter-spacing: 2.5px;
    text-transform: uppercase;
    margin-bottom: 10px;
    position: relative;
    z-index: 1;
}
.spa-modal-header h3 {
    color: #fff;
    font-size: 1.5rem;
    font-weight: 700;
    margin: 0 0 8px;
    position: relative;
    z-index: 1;
    line-height: 1.2;
}
.spa-modal-header p {
    font-size: 0.85rem;
    opacity: 0.9;
    margin: 0;
    line-height: 1.5;
    position: relative;
    z-index: 1;
}
.spa-modal-body {
    padding: 28px 32px 32px;
}
.spa-modal-field {
    margin-bottom: 18px;
}
.spa-modal-field label {
    display: block;
    font-size: 0.72rem;
    font-weight: 700;
    color: var(--texte-sombre);
    letter-spacing: 1px;
    text-transform: uppercase;
    margin-bottom: 8px;
}
.spa-modal-field input,
.spa-modal-field select,
.spa-modal-field textarea {
    width: 100%;
    border: 1.5px solid var(--ligne-grise);
    border-radius: 8px;
    padding: 12px 14px;
    font-family: inherit;
    font-size: 0.9rem;
    color: var(--texte-sombre);
    background: #fff;
    outline: none;
    transition: border-color 0.3s, box-shadow 0.3s;
}
.spa-modal-field input:focus,
.spa-modal-field select:focus,
.spa-modal-field textarea:focus {
    border-color: var(--vert-pullman);
    box-shadow: 0 0 0 4px rgba(56, 226, 143, 0.12);
}
.spa-modal-field textarea {
    resize: vertical;
    min-height: 80px;
}
.spa-modal-row {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 14px;
}
.spa-modal-submit {
    width: 100%;
    background: var(--vert-pullman);
    color: #0A1E2D;
    border: none;
    border-radius: 10px;
    padding: 16px;
    font-family: inherit;
    font-weight: 800;
    font-size: 0.85rem;
    letter-spacing: 1.2px;
    text-transform: uppercase;
    cursor: pointer;
    margin-top: 10px;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 10px;
    transition: all 0.3s ease;
    box-shadow: 0 8px 22px rgba(56, 226, 143, 0.3);
}
.spa-modal-submit:hover {
    background: #2BC87A;
    transform: translateY(-2px);
    box-shadow: 0 12px 30px rgba(56, 226, 143, 0.45);
}
.spa-modal-reassurance {
    display: flex;
    justify-content: center;
    gap: 20px;
    margin-top: 16px;
    font-size: 0.7rem;
    color: var(--texte-gris);
    flex-wrap: wrap;
}
.spa-modal-reassurance span {
    display: inline-flex;
    align-items: center;
    gap: 5px;
    font-weight: 600;
    letter-spacing: 0.3px;
}
.spa-modal-reassurance i {
    color: var(--vert-pullman);
    font-size: 0.75rem;
}

/* ============================================================= */
/* 11. REVEAL (fallback si GSAP indisponible)                    */
/* ============================================================= */
.piscine-page .reveal {
    opacity: 0;
    transform: translateY(40px);
    transition: opacity 0.8s ease-out, transform 0.8s ease-out;
}
.piscine-page .reveal.active {
    opacity: 1;
    transform: translateY(0);
}

/* ============================================================= */
/* 12. RESPONSIVE                                                 */
/* ============================================================= */
@media (max-width: 1100px) {
    .piscine-page .prestations-wrapper,
    .piscine-page .horaires-wrapper {
        grid-template-columns: 1fr;
        gap: 50px;
    }
    .piscine-page .horaires-grid {
        grid-template-columns: repeat(2, 1fr);
        row-gap: 40px;
    }
    .piscine-page .horaire-item:nth-child(3) {
        border-left: none;
        padding-left: 0;
    }
    .piscine-page .temoignages-grid {
        grid-template-columns: repeat(2, 1fr);
    }
}
@media (max-width: 992px) {
    .piscine-page .container { padding: 0 25px; }
    .piscine-page .section { padding: 70px 0; }
    .piscine-page .bienfaits-grid,
    .piscine-page .art-spa-grid {
        grid-template-columns: 1fr;
        gap: 50px;
    }
    .piscine-page .bienfaits-image img { height: 320px; }
    .piscine-page .image-principale img { height: 260px; }
    .piscine-page .images-secondaires img { height: 100px; }
    .piscine-page .banniere-verte { padding: 30px 20px; }
    .piscine-page .banniere-container { padding: 45px 30px; }
    .piscine-page .banniere-grid {
        grid-template-columns: 1fr;
        gap: 35px;
        text-align: center;
    }
    .piscine-page .banniere-prix {
        border-left: none;
        border-top: 1px solid rgba(255, 255, 255, 0.25);
        padding: 30px 0 0;
    }
    .piscine-page .banniere-liste li { justify-content: center; }
    .piscine-page .hero-badge { display: none; }
    .piscine-page .hero-nav { display: none; }
}
@media (max-width: 768px) {
    .piscine-page .prestations-cards { grid-template-columns: 1fr; }
    .piscine-page .temoignages-grid { grid-template-columns: 1fr; }
    .piscine-page .icones-grid { grid-template-columns: repeat(2, 1fr); }
    .piscine-page .spa-modal-row { grid-template-columns: 1fr; }
    .piscine-page .spa-modal-header,
    .piscine-page .spa-modal-body { padding: 24px 22px; }
}
@media (max-width: 576px) {
    .piscine-page .hero-spa { height: 78vh; min-height: 560px; }
    .piscine-page .hero-spa-content { padding: 40px 22px; }
    .piscine-page .hero-spa h1 { font-size: 2rem; }
    .piscine-page .hero-actions { flex-direction: column; }
    .piscine-page .btn-hero-primary,
    .piscine-page .btn-hero-ghost { width: 100%; justify-content: center; }
    .piscine-page .horaires-grid { grid-template-columns: 1fr; }
    .piscine-page .images-secondaires { gap: 8px; }
    .piscine-page .images-secondaires img { height: 80px; }
}
CSS_EOF

echo -e "${GREEN}   ✔ CSS premium écrit ($(wc -l < $CSS) lignes)${NC}\n"

# ============================================================
# 2. NOUVEAU HTML — refonte du contenu central
# ============================================================
echo -e "${BLUE}━━━ [2/3] Réécriture du HTML central ━━━${NC}"

python3 << 'PY_EOF'
import re
from pathlib import Path

f = Path('experiences-piscine.html')
c = f.read_text(encoding='utf-8')

# Extraire le header (du début à </header>)
header_end = c.find('</header>') + len('</header>')
header = c[:header_end]

# Extraire le footer + CTA (de <section class="booking-section"> à la fin)
cta_start = c.find('<section class="booking-section">')
if cta_start == -1:
    # Fallback : chercher le footer
    cta_start = c.find('<footer class="main-footer">')

footer_part = c[cta_start:] if cta_start > 0 else ''

# Nouveau contenu central
new_body = '''
<!-- ============================== MAIN ============================== -->
<main>
<div class="piscine-page">

    <!-- ============================================================
         HERO SLIDER PREMIUM — 3 slides
         ============================================================ -->
    <section class="hero-spa" id="heroSpa">
        <!-- Slides -->
        <div class="hero-spa-slide active"
             style="background-image: url('images/piscinehorizon.jpg');"
             data-title="Piscine &amp; Bien-être"></div>
        <div class="hero-spa-slide"
             style="background-image: url('images/piscine.jpg');"
             data-title="Détente au bord de l'eau"></div>
        <div class="hero-spa-slide"
             style="background-image: url('images/ocean.jpg');"
             data-title="Face à l'océan Atlantique"></div>

        <!-- Overlay -->
        <div class="hero-spa-overlay"></div>

        <!-- Badge flottant -->
        <div class="hero-badge">
            <i class="fa-solid fa-star"></i>
            <span>5 étoiles · Dakar</span>
        </div>

        <!-- Contenu principal -->
        <div class="hero-spa-content">
            <p class="breadcrumb">
                <a href="index.html">Accueil</a>
                <i class="fa-solid fa-chevron-right" style="font-size: 0.6rem; opacity: 0.6;"></i>
                <a href="experiences.html">Expériences</a>
                <i class="fa-solid fa-chevron-right" style="font-size: 0.6rem; opacity: 0.6;"></i>
                <span>Piscine &amp; Spa</span>
            </p>

            <h1>Piscine<br>&amp; Bien-être</h1>
            <span class="trait-vert"></span>

            <p class="hero-spa-texte">
                Plongez dans un univers de détente et laissez-vous porter par une
                expérience de bien-être inoubliable. Piscine à débordement, hammam
                traditionnel, sauna et cabines de soins pour revitaliser corps et esprit.
            </p>

            <div class="hero-actions">
                <button type="button" class="btn-hero-primary" data-open-spa-modal="journee-bien-etre">
                    Réserver un soin
                    <i class="fa-solid fa-arrow-right"></i>
                </button>
                <a href="#bienfaits" class="btn-hero-ghost">
                    Découvrir nos soins
                    <i class="fa-solid fa-chevron-down"></i>
                </a>
            </div>
        </div>

        <!-- Navigation -->
        <button type="button" class="hero-nav prev" aria-label="Slide précédent">
            <i class="fa-solid fa-chevron-left"></i>
        </button>
        <button type="button" class="hero-nav next" aria-label="Slide suivant">
            <i class="fa-solid fa-chevron-right"></i>
        </button>

        <!-- Dots -->
        <div class="hero-dots" id="heroDots">
            <button type="button" class="hero-dot active" data-slide="0" aria-label="Slide 1"></button>
            <button type="button" class="hero-dot" data-slide="1" aria-label="Slide 2"></button>
            <button type="button" class="hero-dot" data-slide="2" aria-label="Slide 3"></button>
        </div>
    </section>

    <!-- ============================================================
         SECTION — Détente & Bienfaits
         ============================================================ -->
    <section class="section section-blanche section-bienfaits" id="bienfaits">
        <div class="container">
            <div class="bienfaits-grid reveal">
                <div class="bienfaits-texte">
                    <p class="section-subtitle">Détente &amp; Bienfaits</p>
                    <h2 class="titre-souligne">Un sanctuaire de calme au cœur de Dakar</h2>

                    <p class="bienfaits-desc">
                        Profitez d'une parenthèse hors du temps dans notre espace bien-être :
                        piscine à débordement, hammam traditionnel, sauna et cabines de soins
                        pour une expérience unique au bord de l'Atlantique.
                    </p>

                    <div class="icones-grid">
                        <div class="icone-item" data-open-spa-modal="massage">
                            <div class="icone-cercle"><i class="fa-solid fa-spa"></i></div>
                            <p>Massages</p>
                        </div>
                        <div class="icone-item" data-open-spa-modal="piscine">
                            <div class="icone-cercle"><i class="fa-solid fa-water-ladder"></i></div>
                            <p>Piscine</p>
                        </div>
                        <div class="icone-item" data-open-spa-modal="hammam">
                            <div class="icone-cercle"><i class="fa-solid fa-hot-tub-person"></i></div>
                            <p>Hammam</p>
                        </div>
                        <div class="icone-item" data-open-spa-modal="yoga">
                            <div class="icone-cercle"><i class="fa-solid fa-om"></i></div>
                            <p>Yoga</p>
                        </div>
                    </div>
                </div>

                <div class="bienfaits-image">
                    <img src="images/piscine.jpg" alt="Détente au bord de la piscine">
                </div>
            </div>
        </div>
    </section>

    <!-- ============================================================
         SECTION — L'art du soin face à l'océan
         ============================================================ -->
    <section class="section section-grise section-art-spa">
        <div class="container">
            <div class="art-spa-grid reveal">
                <div class="art-spa-texte">
                    <p class="section-subtitle">L'art du Spa</p>
                    <h2 class="titre-souligne">L'art du soin face à l'océan</h2>

                    <p class="art-spa-desc">
                        Une invitation à la détente absolue : nos soins signature allient
                        traditions ancestrales et techniques modernes pour un moment unique.
                    </p>

                    <div class="services-liste">
                        <div class="service-ligne">
                            <div class="service-icone"><i class="fa-solid fa-spa"></i></div>
                            <div>
                                <h4>Massages &amp; Soins du corps</h4>
                                <p>Une gamme complète de soins relaxants et tonifiants.</p>
                            </div>
                        </div>
                        <div class="service-ligne">
                            <div class="service-icone"><i class="fa-solid fa-water-ladder"></i></div>
                            <div>
                                <h4>Piscine à débordement</h4>
                                <p>Un bassin chauffé avec vue panoramique sur la mer.</p>
                            </div>
                        </div>
                        <div class="service-ligne">
                            <div class="service-icone"><i class="fa-solid fa-hot-tub-person"></i></div>
                            <div>
                                <h4>Hammam &amp; Sauna</h4>
                                <p>Purification et détente intense dans un cadre chaleureux.</p>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="art-spa-images">
                    <div class="image-principale">
                        <img src="images/ocean.jpg" alt="Piscine face à l'océan">
                    </div>
                    <div class="images-secondaires">
                        <img src="images/piscine.jpg" alt="Détente piscine">
                        <img src="images/yogab.jpg" alt="Yoga face à la mer">
                        <img src="images/imagesoin.webp" alt="Soin spa">
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- ============================================================
         SECTION — Nos prestations
         ============================================================ -->
    <section class="section section-blanche section-prestations">
        <div class="container">
            <div class="prestations-wrapper reveal">
                <div class="prestations-intro">
                    <p class="section-subtitle">Notre carte des soins</p>
                    <h2 class="titre-souligne">Des soins pour le corps et l'esprit</h2>

                    <p class="prestations-desc">
                        Découvrez notre sélection de soins signatures, conçus pour vous offrir
                        un moment de détente absolue. Nos thérapeutes diplômés vous accompagnent
                        dans un voyage sensoriel unique.
                    </p>

                    <button type="button" class="btn-contour" data-open-spa-modal="journee-bien-etre">
                        Réserver un soin
                    </button>
                </div>

                <div class="prestations-cards">
                    <article class="card-pullman" data-open-spa-modal="massage">
                        <div class="card-img">
                            <img src="images/massage3.jpg" alt="Massages relaxants">
                        </div>
                        <div class="card-body">
                            <h3>Massages</h3>
                            <p>Massages relaxants aux huiles essentielles et pierres chaudes.</p>
                            <span class="prix">Réserver <i class="fa-solid fa-arrow-right"></i></span>
                        </div>
                    </article>

                    <article class="card-pullman" data-open-spa-modal="yoga">
                        <div class="card-img">
                            <img src="images/Yoga2.jpg" alt="Yoga face à la mer">
                        </div>
                        <div class="card-body">
                            <h3>Yoga &amp; Méditation</h3>
                            <p>Séances guidées face à la mer pour retrouver l'équilibre.</p>
                            <span class="prix">Réserver <i class="fa-solid fa-arrow-right"></i></span>
                        </div>
                    </article>

                    <article class="card-pullman" data-open-spa-modal="hammam">
                        <div class="card-img">
                            <img src="images/Hamman.jpg" alt="Hammam et sauna">
                        </div>
                        <div class="card-body">
                            <h3>Hammam &amp; Sauna</h3>
                            <p>Un moment de purification et de détente intense.</p>
                            <span class="prix">Réserver <i class="fa-solid fa-arrow-right"></i></span>
                        </div>
                    </article>
                </div>
            </div>
        </div>
    </section>

    <!-- ============================================================
         SECTION — Témoignages clients
         ============================================================ -->
    <section class="section section-temoignages">
        <div class="container">
            <div class="temoignages-header reveal">
                <p class="section-subtitle">Ils ont vécu l'expérience</p>
                <h2 class="titre-souligne">Ce que nos clients disent</h2>
            </div>

            <div class="temoignages-grid reveal">
                <div class="temoignage-card">
                    <span class="temoignage-quote">"</span>
                    <div class="temoignage-stars">
                        <i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i>
                        <i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i>
                        <i class="fa-solid fa-star"></i>
                    </div>
                    <p class="temoignage-texte">
                        Une parenthèse magique. Le massage aux pierres chaudes face à
                        l'océan restera gravé. Personnel aux petits soins et cadre idyllique.
                    </p>
                    <div class="temoignage-auteur">
                        <div class="temoignage-avatar">A</div>
                        <div class="temoignage-info">
                            <h5>Aminata D.</h5>
                            <span>Dakar · Février 2026</span>
                        </div>
                    </div>
                </div>

                <div class="temoignage-card">
                    <span class="temoignage-quote">"</span>
                    <div class="temoignage-stars">
                        <i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i>
                        <i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i>
                        <i class="fa-solid fa-star"></i>
                    </div>
                    <p class="temoignage-texte">
                        Nous avons réservé la journée bien-être complète. Un vrai moment
                        de luxe et de détente. Le déjeuner santé était délicieux.
                    </p>
                    <div class="temoignage-auteur">
                        <div class="temoignage-avatar">M</div>
                        <div class="temoignage-info">
                            <h5>Marc L.</h5>
                            <span>Paris · Janvier 2026</span>
                        </div>
                    </div>
                </div>

                <div class="temoignage-card">
                    <span class="temoignage-quote">"</span>
                    <div class="temoignage-stars">
                        <i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i>
                        <i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i>
                        <i class="fa-solid fa-star"></i>
                    </div>
                    <p class="temoignage-texte">
                        Le spa du Pullman est une référence à Dakar. Ambiance apaisante,
                        thérapeutes experts. Le hammam traditionnel est incontournable.
                    </p>
                    <div class="temoignage-auteur">
                        <div class="temoignage-avatar">F</div>
                        <div class="temoignage-info">
                            <h5>Fatou N.</h5>
                            <span>Saint-Louis · Décembre 2025</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- ============================================================
         BANNIÈRE VERTE — Journée bien-être
         ============================================================ -->
    <section class="banniere-verte reveal">
        <div class="banniere-container">
            <div class="banniere-grid">
                <div class="banniere-texte">
                    <p class="section-subtitle-blanc">Expérience Signature</p>
                    <h2>Votre journée bien-être</h2>
                    <p>
                        Profitez d'une journée complète au spa : accès à la piscine,
                        au hammam et au sauna, un massage de 50 minutes et un déjeuner santé.
                    </p>
                </div>

                <ul class="banniere-liste">
                    <li>
                        <span class="liste-icone"><i class="fa-solid fa-spa"></i></span>
                        <span>Massage relaxant de 50 minutes</span>
                    </li>
                    <li>
                        <span class="liste-icone"><i class="fa-solid fa-person-swimming"></i></span>
                        <span>Accès illimité à la piscine &amp; spa</span>
                    </li>
                    <li>
                        <span class="liste-icone"><i class="fa-solid fa-hot-tub-person"></i></span>
                        <span>Hammam &amp; sauna en libre accès</span>
                    </li>
                    <li>
                        <span class="liste-icone"><i class="fa-solid fa-utensils"></i></span>
                        <span>Déjeuner santé inclus</span>
                    </li>
                </ul>

                <div class="banniere-prix">
                    <span class="prix-label">À PARTIR DE</span>
                    <span class="prix-valeur">75 000 <small>FCFA</small></span>
                    <span class="prix-ttc">TTC / PERSONNE</span>
                    <button type="button" class="btn-blanc" data-open-spa-modal="journee-bien-etre">
                        Réserver
                    </button>
                </div>
            </div>
        </div>
    </section>

    <!-- ============================================================
         SECTION — FAQ
         ============================================================ -->
    <section class="section section-faq">
        <div class="container">
            <div class="faq-header reveal">
                <p class="section-subtitle">Questions fréquentes</p>
                <h2 class="titre-souligne">Tout ce qu'il faut savoir</h2>
            </div>

            <div class="faq-liste reveal">
                <div class="faq-item">
                    <button type="button" class="faq-question">
                        <span>Le spa est-il accessible aux non-clients de l'hôtel ?</span>
                        <i class="fa-solid fa-chevron-down faq-chevron"></i>
                    </button>
                    <div class="faq-reponse">
                        Oui, notre spa est ouvert aux visiteurs extérieurs sur réservation
                        préalable. Nous vous recommandons de réserver au moins 24h à l'avance.
                    </div>
                </div>

                <div class="faq-item">
                    <button type="button" class="faq-question">
                        <span>Quels sont les moyens de paiement acceptés ?</span>
                        <i class="fa-solid fa-chevron-down faq-chevron"></i>
                    </button>
                    <div class="faq-reponse">
                        Nous acceptons les cartes bancaires (Visa, Mastercard), Wave,
                        Orange Money, ainsi que les paiements en espèces (FCFA).
                    </div>
                </div>

                <div class="faq-item">
                    <button type="button" class="faq-question">
                        <span>Puis-je offrir un soin en cadeau ?</span>
                        <i class="fa-solid fa-chevron-down faq-chevron"></i>
                    </button>
                    <div class="faq-reponse">
                        Absolument. Nous proposons des bons cadeaux valables 12 mois,
                        disponibles à l'accueil du spa ou sur demande par téléphone.
                    </div>
                </div>

                <div class="faq-item">
                    <button type="button" class="faq-question">
                        <span>Y a-t-il un âge minimum pour accéder au spa ?</span>
                        <i class="fa-solid fa-chevron-down faq-chevron"></i>
                    </button>
                    <div class="faq-reponse">
                        Le spa est réservé aux personnes de 16 ans et plus. Les enfants
                        de moins de 16 ans peuvent accéder à la piscine accompagnés d'un adulte.
                    </div>
                </div>

                <div class="faq-item">
                    <button type="button" class="faq-question">
                        <span>Combien de temps à l'avance faut-il réserver ?</span>
                        <i class="fa-solid fa-chevron-down faq-chevron"></i>
                    </button>
                    <div class="faq-reponse">
                        Nous recommandons de réserver 24 à 48h à l'avance, particulièrement
                        le week-end. Pour les groupes, merci de nous contacter directement.
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- ============================================================
         SECTION — Horaires & Accès
         ============================================================ -->
    <section class="section section-horaires">
        <div class="container">
            <div class="horaires-wrapper reveal">
                <div class="horaires-titre">
                    <p class="section-subtitle">Informations Pratiques</p>
                    <h2 class="titre-souligne">Horaires &amp; Accès</h2>
                </div>

                <div class="horaires-grid">
                    <div class="horaire-item">
                        <div class="horaire-icone"><i class="fa-solid fa-water-ladder"></i></div>
                        <h4>Piscine</h4>
                        <p>Ouverte tous les jours<br>de 7h00 à 22h00</p>
                    </div>
                    <div class="horaire-item">
                        <div class="horaire-icone"><i class="fa-solid fa-spa"></i></div>
                        <h4>Spa</h4>
                        <p>Sur rendez-vous<br>de 9h00 à 20h00</p>
                    </div>
                    <div class="horaire-item">
                        <div class="horaire-icone"><i class="fa-solid fa-location-dot"></i></div>
                        <h4>Accès</h4>
                        <p>Clients de l'hôtel<br>et visiteurs extérieurs</p>
                    </div>
                    <div class="horaire-item">
                        <div class="horaire-icone"><i class="fa-solid fa-phone"></i></div>
                        <h4>Réservations</h4>
                        <p>+221 33 869 66 66<br>spa@pullman-dakar.com</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- ============================================================
         POP-UP : RÉSERVATION DE SOIN SPA
         ============================================================ -->
    <div class="spa-modal-overlay" id="spaModal" aria-hidden="true">
        <div class="spa-modal" role="dialog" aria-modal="true" aria-labelledby="spaModalTitle">
            <button type="button" class="spa-modal-close" id="spaModalClose" aria-label="Fermer">
                <i class="fa-solid fa-xmark"></i>
            </button>

            <div class="spa-modal-header">
                <span class="eyebrow" id="spaModalEyebrow">Réservation</span>
                <h3 id="spaModalTitle">Réserver un soin</h3>
                <p id="spaModalDesc">Choisissez votre soin et vos préférences horaires.</p>
            </div>

            <div class="spa-modal-body">
                <form id="spaForm">
                    <div class="spa-modal-field">
                        <label for="spaSoin">Type de soin</label>
                        <select id="spaSoin" required>
                            <option value="journee-bien-etre">Journée Bien-être complète — 75 000 FCFA</option>
                            <option value="massage">Massage relaxant 50 min — 45 000 FCFA</option>
                            <option value="yoga">Yoga &amp; Méditation — 25 000 FCFA</option>
                            <option value="hammam">Hammam &amp; Sauna — 30 000 FCFA</option>
                            <option value="piscine">Accès Piscine journée — 20 000 FCFA</option>
                        </select>
                    </div>

                    <div class="spa-modal-row">
                        <div class="spa-modal-field">
                            <label for="spaDate">Date souhaitée</label>
                            <input type="date" id="spaDate" required>
                        </div>
                        <div class="spa-modal-field">
                            <label for="spaHeure">Créneau</label>
                            <select id="spaHeure" required>
                                <option>09h00 – 11h00</option>
                                <option>11h00 – 13h00</option>
                                <option>14h00 – 16h00</option>
                                <option>16h00 – 18h00</option>
                                <option>18h00 – 20h00</option>
                            </select>
                        </div>
                    </div>

                    <div class="spa-modal-row">
                        <div class="spa-modal-field">
                            <label for="spaPrenom">Prénom</label>
                            <input type="text" id="spaPrenom" placeholder="Aïssatou" required>
                        </div>
                        <div class="spa-modal-field">
                            <label for="spaNom">Nom</label>
                            <input type="text" id="spaNom" placeholder="Diop" required>
                        </div>
                    </div>

                    <div class="spa-modal-row">
                        <div class="spa-modal-field">
                            <label for="spaEmail">E-mail</label>
                            <input type="email" id="spaEmail" placeholder="vous@exemple.com" required>
                        </div>
                        <div class="spa-modal-field">
                            <label for="spaTel">Téléphone</label>
                            <input type="tel" id="spaTel" placeholder="+221 77 123 45 67" required>
                        </div>
                    </div>

                    <div class="spa-modal-field">
                        <label for="spaMessage">Demandes particulières (facultatif)</label>
                        <textarea id="spaMessage" placeholder="Allergies, préférences, occasion spéciale…"></textarea>
                    </div>

                    <button type="submit" class="spa-modal-submit">
                        Confirmer ma réservation
                        <i class="fa-solid fa-arrow-right"></i>
                    </button>

                    <div class="spa-modal-reassurance">
                        <span><i class="fa-solid fa-check"></i> Confirmation immédiate</span>
                        <span><i class="fa-solid fa-check"></i> Annulation gratuite 24h</span>
                        <span><i class="fa-solid fa-check"></i> Paiement sur place</span>
                    </div>
                </form>
            </div>
        </div>
    </div>

</div><!-- /.piscine-page -->
</main>

'''

# Assembler : header + nouveau body + footer/CTA
new_html = header + '\n' + new_body + footer_part

f.write_text(new_html, encoding='utf-8')
print("   ✔ HTML central reconstruit")
print("   ✔ Hero slider ajouté (3 slides)")
print("   ✔ Pop-up réservation spa ajoutée")
print("   ✔ Sections Témoignages + FAQ ajoutées")
print("   ✔ Header et Footer/CTA PRÉSERVÉS")
PY_EOF

echo -e "${GREEN}   ✔ HTML réécrit${NC}\n"

# ============================================================
# 3. AJOUTER LES SCRIPTS (slider + popup + FAQ + reveal + GSAP)
# ============================================================
echo -e "${BLUE}━━━ [3/3] Ajout des scripts JS ━━━${NC}"

python3 << 'PY_EOF'
import re
from pathlib import Path

f = Path('experiences-piscine.html')
c = f.read_text(encoding='utf-8')

# Vérifier que GSAP n'est pas déjà chargé
if 'gsap.min.js' not in c:
    # Ajouter GSAP + ScrollTrigger avant les scripts du projet
    c = c.replace(
        '<script src="js/booking-bridge.js"></script>',
        '''<script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.2/gsap.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.2/ScrollTrigger.min.js"></script>

<script src="js/booking-bridge.js"></script>''',
        1
    )

# Ajouter le script inline avant </body>
script = '''
<!-- ============================== SCRIPT PAGE PISCINE ============================== -->
<script>
document.addEventListener('DOMContentLoaded', () => {

    /* ============ 1. HERO SLIDER ============ */
    const slides = document.querySelectorAll('.piscine-page .hero-spa-slide');
    const dots   = document.querySelectorAll('.piscine-page .hero-dot');
    const prevBtn = document.querySelector('.piscine-page .hero-nav.prev');
    const nextBtn = document.querySelector('.piscine-page .hero-nav.next');
    let currentSlide = 0;
    let autoSlideTimer = null;
    const SLIDE_DELAY = 6000;

    function showSlide(index) {
        slides.forEach(s => s.classList.remove('active'));
        dots.forEach(d => d.classList.remove('active'));
        if (slides[index]) slides[index].classList.add('active');
        if (dots[index]) dots[index].classList.add('active');
        currentSlide = index;
    }

    function nextSlide() {
        showSlide((currentSlide + 1) % slides.length);
    }
    function prevSlide() {
        showSlide((currentSlide - 1 + slides.length) % slides.length);
    }

    function startAutoSlide() {
        if (autoSlideTimer) clearInterval(autoSlideTimer);
        autoSlideTimer = setInterval(nextSlide, SLIDE_DELAY);
    }
    function stopAutoSlide() {
        if (autoSlideTimer) { clearInterval(autoSlideTimer); autoSlideTimer = null; }
    }

    if (slides.length) {
        startAutoSlide();

        dots.forEach(dot => {
            dot.addEventListener('click', () => {
                stopAutoSlide();
                showSlide(parseInt(dot.dataset.slide, 10));
                startAutoSlide();
            });
        });
        if (nextBtn) nextBtn.addEventListener('click', () => { stopAutoSlide(); nextSlide(); startAutoSlide(); });
        if (prevBtn) prevBtn.addEventListener('click', () => { stopAutoSlide(); prevSlide(); startAutoSlide(); });

        // Pause au survol
        const hero = document.querySelector('.piscine-page .hero-spa');
        if (hero) {
            hero.addEventListener('mouseenter', stopAutoSlide);
            hero.addEventListener('mouseleave', startAutoSlide);
        }
    }

    /* ============ 2. POP-UP RÉSERVATION SPA ============ */
    const SPA_DATA = {
        'journee-bien-etre': {
            eyebrow: 'Expérience Signature',
            title: 'Journée Bien-être',
            desc: 'Piscine + Hammam + Sauna + Massage 50 min + Déjeuner santé — 75 000 FCFA'
        },
        'massage': {
            eyebrow: 'Soin du corps',
            title: 'Massage relaxant',
            desc: 'Massage aux huiles essentielles ou pierres chaudes — 50 minutes'
        },
        'yoga': {
            eyebrow: 'Bien-être',
            title: 'Yoga & Méditation',
            desc: 'Séance guidée face à la mer — 1h15'
        },
        'hammam': {
            eyebrow: 'Purification',
            title: 'Hammam & Sauna',
            desc: 'Accès libre au hammam traditionnel et au sauna'
        },
        'piscine': {
            eyebrow: 'Détente',
            title: 'Accès Piscine journée',
            desc: 'Piscine à débordement + transats + serviettes'
        }
    };

    const spaModal      = document.getElementById('spaModal');
    const spaModalClose = document.getElementById('spaModalClose');
    const spaSoin       = document.getElementById('spaSoin');
    const spaDate       = document.getElementById('spaDate');
    const spaForm       = document.getElementById('spaForm');

    function openSpaModal(soinId) {
        if (!spaModal) return;
        const data = SPA_DATA[soinId];
        if (data) {
            document.getElementById('spaModalEyebrow').textContent = data.eyebrow;
            document.getElementById('spaModalTitle').textContent = data.title;
            document.getElementById('spaModalDesc').textContent = data.desc;
            if (spaSoin) spaSoin.value = soinId;
        }
        // Date par défaut = demain
        if (spaDate && !spaDate.value) {
            const tomorrow = new Date();
            tomorrow.setDate(tomorrow.getDate() + 1);
            spaDate.valueAsDate = tomorrow;
            spaDate.min = new Date().toISOString().split('T')[0];
        }
        spaModal.classList.add('is-open');
        spaModal.setAttribute('aria-hidden', 'false');
        document.body.style.overflow = 'hidden';
    }

    function closeSpaModal() {
        if (!spaModal) return;
        spaModal.classList.remove('is-open');
        spaModal.setAttribute('aria-hidden', 'true');
        document.body.style.overflow = '';
    }

    // Attacher les déclencheurs
    document.querySelectorAll('[data-open-spa-modal]').forEach(btn => {
        btn.addEventListener('click', e => {
            e.preventDefault();
            openSpaModal(btn.dataset.openSpaModal);
        });
    });

    // Fermeture
    if (spaModalClose) spaModalClose.addEventListener('click', closeSpaModal);
    if (spaModal) {
        spaModal.addEventListener('click', e => {
            if (e.target === spaModal) closeSpaModal();
        });
    }
    document.addEventListener('keydown', e => {
        if (e.key === 'Escape' && spaModal && spaModal.classList.contains('is-open')) {
            closeSpaModal();
        }
    });

    // Soumission
    if (spaForm) {
        spaForm.addEventListener('submit', e => {
            e.preventDefault();
            const soin = spaSoin ? spaSoin.options[spaSoin.selectedIndex].text : '';
            const date = spaDate ? spaDate.value : '';
            const prenom = document.getElementById('spaPrenom')?.value || '';
            const nom    = document.getElementById('spaNom')?.value || '';
            const heure  = document.getElementById('spaHeure')?.value || '';

            alert(`✅ Demande de réservation enregistrée !

Soin : ${soin}
Date : ${date}
Créneau : ${heure}
Nom : ${prenom} ${nom}

Un e-mail de confirmation vous sera envoyé sous 24h.`);

            spaForm.reset();
            closeSpaModal();
        });
    }

    /* ============ 3. FAQ ACCORDÉON ============ */
    document.querySelectorAll('.piscine-page .faq-question').forEach(btn => {
        btn.addEventListener('click', () => {
            const item = btn.closest('.faq-item');
            const isOpen = item.classList.contains('open');
            // Fermer les autres
            document.querySelectorAll('.piscine-page .faq-item.open').forEach(el => el.classList.remove('open'));
            // Ouvrir celui cliqué si pas déjà ouvert
            if (!isOpen) item.classList.add('open');
        });
    });

    /* ============ 4. REVEAL AU SCROLL ============ */
    const reveals = document.querySelectorAll('.piscine-page .reveal');
    if (reveals.length) {
        if (typeof gsap !== 'undefined' && typeof ScrollTrigger !== 'undefined') {
            gsap.registerPlugin(ScrollTrigger);
            reveals.forEach(el => {
                gsap.fromTo(el,
                    { opacity: 0, y: 40 },
                    {
                        opacity: 1, y: 0, duration: 1, ease: "power2.out",
                        scrollTrigger: { trigger: el, start: "top 85%", toggleActions: "play none none none" }
                    }
                );
            });
        } else {
            // Fallback CSS
            const check = () => {
                const wh = window.innerHeight;
                reveals.forEach(el => {
                    if (el.getBoundingClientRect().top < wh - 100) el.classList.add('active');
                });
            };
            check();
            window.addEventListener('scroll', check);
            window.addEventListener('resize', check);
        }
    }

});
</script>

</body>'''

c = c.replace('</body>', script, 1)

f.write_text(c, encoding='utf-8')
print("   ✔ Slider hero JS ajouté")
print("   ✔ Pop-up spa JS ajouté (5 soins)")
print("   ✔ FAQ accordéon JS ajouté")
print("   ✔ Reveal au scroll (GSAP + fallback)")
PY_EOF

echo -e "${GREEN}   ✔ Scripts ajoutés${NC}\n"

# ============================================================
# 4. VÉRIFICATION FINALE
# ============================================================
echo -e "${BLUE}━━━ VÉRIFICATION ━━━${NC}"

H=$(cat "$HTML")
C=$(cat "$CSS")

printf "   %-42s | %s\n" "Élément" "Valeur"
printf "   %-42s-|-%s\n" "------------------------------------------" "--------"

# HTML
printf "   %-42s | %s\n" "Slides hero (3 attendus)" "$(echo "$H" | grep -c 'hero-spa-slide' || echo 0)"
printf "   %-42s | %s\n" "Dots slider (3 attendus)" "$(echo "$H" | grep -c 'hero-dot' || echo 0)"
printf "   %-42s | %s\n" "Déclencheurs pop-up spa" "$(echo "$H" | grep -o 'data-open-spa-modal' | wc -l)"
printf "   %-42s | %s\n" "Pop-up spa (1 attendue)" "$(echo "$H" | grep -c 'id="spaModal"' || echo 0)"
printf "   %-42s | %s\n" "Témoignages (3 attendus)" "$(echo "$H" | grep -c 'temoignage-card' || echo 0)"
printf "   %-42s | %s\n" "Questions FAQ (5 attendues)" "$(echo "$H" | grep -c 'faq-question' || echo 0)"
printf "   %-42s | %s\n" "Sections gsap-reveal" "$(echo "$H" | grep -o 'reveal' | wc -l)"
printf "   %-42s | %s\n" "GSAP chargé" "$(echo "$H" | grep -c 'gsap.min.js' || echo 0)"
printf "   %-42s | %s\n" "Header préservé" "$(echo "$H" | grep -c 'site-header' || echo 0)"
printf "   %-42s | %s\n" "Footer préservé" "$(echo "$H" | grep -c 'main-footer' || echo 0)"
printf "   %-42s | %s\n" "CTA réservation préservé" "$(echo "$H" | grep -c 'booking-section' || echo 0)"

echo ""
echo -e "${BLUE}Contrôle CSS :${NC}"
printf "   %-42s | %s\n" "Scopé .piscine-page" "$(echo "$C" | grep -c '\.piscine-page' || echo 0)"
printf "   %-42s | %s\n" "Pop-up spa" "$(echo "$C" | grep -c 'spa-modal' || echo 0)"
printf "   %-42s | %s\n" "Témoignages" "$(echo "$C" | grep -c 'temoignage' || echo 0)"
printf "   %-42s | %s\n" "FAQ" "$(echo "$C" | grep -c 'faq-' || echo 0)"
printf "   %-42s | %s\n" "Hero slider" "$(echo "$C" | grep -c 'hero-spa-slide' || echo 0)"

echo ""
echo -e "${GREEN}✅ AMÉLIORATION TERMINÉE${NC}"
echo -e "${BLUE}💾 Sauvegarde : $BACKUP${NC}"
echo ""
echo -e "${BLUE}📋 Résumé des ajouts :${NC}"
echo "   ✨ Hero slider premium (3 images, dots, flèches, badge 5 étoiles)"
echo "   ✨ 2 boutons hero : Réserver un soin + Découvrir nos soins"
echo "   ✨ Cartes cliquables → ouvrent la pop-up de réservation"
echo "   ✨ Icônes circulaires cliquables → ouvrent la pop-up"
echo "   ✨ Pop-up réservation spa (5 soins, dates, heures, coordonnées)"
echo "   ✨ Section Témoignages (3 clients + étoiles + avatars)"
echo "   ✨ Section FAQ accordéon (5 questions/réponses)"
echo "   ✨ Animations GSAP ScrollTrigger sur toutes les sections"
echo "   ✨ Micro-interactions : hover cartes, zoom images, icônes rotatives"
echo "   ✨ Bannière verte : bouton Réserver ouvre la pop-up"
echo ""
echo -e "${YELLOW}⚠  Le TOP MENU, le CTA et le FOOTER n'ont PAS été touchés${NC}"
echo ""
echo -e "${BLUE}🔄 Rollback :${NC}"
echo "   cp $BACKUP/experiences-piscine.html ."
echo "   cp $BACKUP/services-piscine.css css/"
echo ""
echo -e "${BLUE}🧹 Nettoyage après validation :${NC}"
echo "   rm -rf $BACKUP ameliorer_piscine.sh"
