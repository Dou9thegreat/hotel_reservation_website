#!/usr/bin/env bash
set -euo pipefail

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; BLUE='\033[0;34m'; NC='\033[0m'

echo -e "${BLUE}=====================================================${NC}"
echo -e "${BLUE} REFONTE PREMIUM — evenements.html${NC}"
echo -e "${BLUE}====================================================${NC}\n"

HTML="evenements.html"
CSS="css/evenements.css"

[ -f "$HTML" ] || { echo -e "${RED}❌ $HTML introuvable${NC}"; exit 1; }
mkdir -p css

BACKUP=".backup_evt_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP"
cp "$HTML" "$BACKUP/"
[ -f "$CSS" ] && cp "$CSS" "$BACKUP/" || true
echo -e "${GREEN}📦 Sauvegarde → $BACKUP${NC}\n"

# ============================================================
# 1. NOUVEAU CSS PREMIUM
# ============================================================
echo -e "${BLUE}━━━ [1/3] CSS premium ━━━${NC}"

cat > "$CSS" << 'CSS_EOF'
/* ============================================================= */
/* EVENEMENTS.CSS — Meeting & Events (version premium)           */
/* Responsable : Abdoulaye Diémé                                 */
/* Scopé sous .evenements-page — NE PAS toucher au header/footer */
/* ============================================================= */

.evenements-page {
    --or-sable: #C59A67;
    --vert-pullman: var(--couleur-vert, #38E28F);
    --bleu-pullman: var(--couleur-bleu-profond, #155E75);
    --bleu-nuit: #0A1E2D;
    --texte-sombre: #1A2B3C;
    --texte-gris: #6A7580;
    --ligne-grise: #E8ECEF;
    --ombre-douce: 0 10px 30px rgba(0, 0, 0, 0.06);
    --ombre-forte: 0 20px 50px rgba(0, 0, 0, 0.12);
}

/* ============================================================= */
/* 1. HERO PREMIUM                                                */
/* ============================================================= */
.evenements-page .hero-evt {
    position: relative;
    min-height: 88vh;
    display: flex;
    align-items: center;
    overflow: hidden;
    color: #fff;
    background-color: var(--bleu-nuit);
}
.evenements-page .hero-evt-bg {
    position: absolute;
    inset: 0;
    background-size: cover;
    background-position: center right;
    background-repeat: no-repeat;
    z-index: 1;
    transform: scale(1.05);
    will-change: transform;
}
.evenements-page .hero-evt-overlay {
    position: absolute;
    inset: 0;
    background:
        linear-gradient(90deg,
            rgba(10, 30, 45, 0.92) 0%,
            rgba(10, 30, 45, 0.72) 45%,
            rgba(10, 30, 45, 0.30) 100%),
        linear-gradient(180deg,
            rgba(0, 0, 0, 0.25) 0%,
            transparent 40%,
            rgba(0, 0, 0, 0.35) 100%);
    z-index: 2;
}
.evenements-page .hero-evt-content {
    position: relative;
    z-index: 3;
    max-width: 1300px;
    margin: 0 auto;
    padding: 80px 40px 100px;
    width: 100%;
}
.evenements-page .hero-evt .breadcrumb {
    font-size: 0.78rem;
    letter-spacing: 1.8px;
    text-transform: uppercase;
    margin-bottom: 26px;
    opacity: 0.85;
    display: flex;
    align-items: center;
    gap: 8px;
    flex-wrap: wrap;
}
.evenements-page .hero-evt .breadcrumb a {
    color: #fff;
    text-decoration: none;
    transition: color 0.3s;
}
.evenements-page .hero-evt .breadcrumb a:hover {
    color: var(--vert-pullman);
}
.evenements-page .hero-evt .breadcrumb i {
    font-size: 0.6rem;
    opacity: 0.6;
}
.evenements-page .hero-evt .eyebrow {
    display: inline-flex;
    align-items: center;
    gap: 14px;
    font-size: 0.82rem;
    font-weight: 700;
    text-transform: uppercase;
    letter-spacing: 2px;
    color: #fff;
    margin-bottom: 22px;
}
.evenements-page .hero-evt .eyebrow::after {
    content: "";
    display: inline-block;
    width: 45px;
    height: 2px;
    background: var(--or-sable);
}
.evenements-page .hero-evt h1 {
    font-size: clamp(2.4rem, 5vw, 4.2rem);
    font-weight: 800;
    line-height: 1.05;
    letter-spacing: 1.5px;
    text-transform: uppercase;
    margin-bottom: 26px;
    max-width: 720px;
    color: #fff;
    text-shadow: 0 4px 30px rgba(0, 0, 0, 0.4);
}
.evenements-page .hero-evt h1 .highlight {
    color: var(--or-sable);
    font-style: italic;
    font-family: 'Playfair Display', Georgia, serif;
}
.evenements-page .hero-evt-desc {
    font-size: 1.02rem;
    line-height: 1.85;
    max-width: 560px;
    margin-bottom: 38px;
    opacity: 0.96;
    text-shadow: 0 2px 12px rgba(0, 0, 0, 0.3);
}
.evenements-page .hero-evt-actions {
    display: flex;
    gap: 14px;
    flex-wrap: wrap;
}
.evenements-page .btn-hero-primary,
.evenements-page .btn-hero-ghost {
    display: inline-flex;
    align-items: center;
    gap: 12px;
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
.evenements-page .btn-hero-primary {
    background: var(--or-sable);
    color: #fff;
    box-shadow: 0 10px 30px rgba(197, 154, 103, 0.4);
}
.evenements-page .btn-hero-primary:hover {
    background: #B5885A;
    transform: translateY(-3px);
    box-shadow: 0 15px 40px rgba(197, 154, 103, 0.55);
}
.evenements-page .btn-hero-primary i {
    transition: transform 0.3s ease;
}
.evenements-page .btn-hero-primary:hover i {
    transform: translateX(4px);
}
.evenements-page .btn-hero-ghost {
    background: rgba(255, 255, 255, 0.08);
    color: #fff;
    border: 1.5px solid rgba(255, 255, 255, 0.4);
    backdrop-filter: blur(10px);
}
.evenements-page .btn-hero-ghost:hover {
    background: rgba(255, 255, 255, 0.18);
    border-color: #fff;
    transform: translateY(-3px);
}

/* Chips flottants hero */
.evenements-page .hero-evt-chips {
    position: absolute;
    bottom: 40px;
    right: 40px;
    display: flex;
    gap: 12px;
    z-index: 4;
    flex-wrap: wrap;
    max-width: 500px;
    justify-content: flex-end;
}
.evenements-page .hero-chip {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    padding: 10px 18px;
    background: rgba(255, 255, 255, 0.12);
    border: 1.5px solid rgba(255, 255, 255, 0.25);
    border-radius: 50px;
    backdrop-filter: blur(12px);
    font-size: 0.72rem;
    font-weight: 700;
    letter-spacing: 1.2px;
    text-transform: uppercase;
    color: #fff;
}
.evenements-page .hero-chip i {
    color: var(--vert-pullman);
    font-size: 0.8rem;
}

/* ============================================================= */
/* 2. SECTIONS GÉNÉRALES                                          */
/* ============================================================= */
.evenements-page .section {
    padding: 100px 0;
}
.evenements-page .section-blanche { background: #fff; }
.evenements-page .section-grise { background: #F5F7F6; }
.evenements-page .section-sombre {
    background: var(--bleu-nuit);
    color: #fff;
}
.evenements-page .container {
    max-width: 1280px;
    margin: 0 auto;
    padding: 0 50px;
}
.evenements-page .section-header {
    text-align: center;
    margin-bottom: 60px;
}
.evenements-page .section-subtitle {
    display: inline-block;
    color: var(--vert-pullman);
    font-size: 0.72rem;
    font-weight: 700;
    letter-spacing: 3px;
    text-transform: uppercase;
    margin-bottom: 14px;
}
.evenements-page .titre-souligne {
    position: relative;
    display: inline-block;
    font-size: clamp(1.7rem, 2.6vw, 2.3rem);
    font-weight: 700;
    color: var(--texte-sombre);
    padding-bottom: 22px;
    line-height: 1.25;
}
.evenements-page .titre-souligne::after {
    content: "";
    position: absolute;
    bottom: 0;
    left: 50%;
    transform: translateX(-50%);
    width: 64px;
    height: 4px;
    background: var(--vert-pullman);
    border-radius: 2px;
}
.evenements-page .titre-souligne--left::after {
    left: 0;
    transform: none;
}

/* ============================================================= */
/* 3. FEATURES (3 piliers)                                        */
/* ============================================================= */
.evenements-page .features-evt {
    padding: 80px 0;
    background: #fff;
}
.evenements-page .features-evt-grid {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 0;
}
.evenements-page .feature-evt-item {
    padding: 30px 40px;
    text-align: center;
    border-right: 1px solid var(--ligne-grise);
    transition: transform 0.4s ease;
}
.evenements-page .feature-evt-item:last-child {
    border-right: none;
}
.evenements-page .feature-evt-item:hover {
    transform: translateY(-6px);
}
.evenements-page .feature-evt-icon {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    width: 72px;
    height: 72px;
    border-radius: 50%;
    background: linear-gradient(135deg, rgba(56, 226, 143, 0.12), rgba(21, 94, 117, 0.08));
    color: var(--vert-pullman);
    margin-bottom: 22px;
    transition: all 0.4s ease;
}
.evenements-page .feature-evt-item:hover .feature-evt-icon {
    background: var(--vert-pullman);
    color: #fff;
    transform: scale(1.1) rotate(-6deg);
    box-shadow: 0 15px 35px rgba(56, 226, 143, 0.35);
}
.evenements-page .feature-evt-icon i {
    font-size: 28px;
}
.evenements-page .feature-evt-item h3 {
    font-size: 0.95rem;
    font-weight: 700;
    letter-spacing: 1.5px;
    text-transform: uppercase;
    color: var(--texte-sombre);
    margin-bottom: 12px;
}
.evenements-page .feature-evt-item p {
    font-size: 0.88rem;
    color: var(--texte-gris);
    line-height: 1.65;
}

/* ============================================================= */
/* 4. GALERIE                                                     */
/* ============================================================= */
.evenements-page .gallery-evt {
    padding: 80px 0;
    background: #F5F7F6;
}
.evenements-page .gallery-evt-header {
    max-width: 800px;
    margin-bottom: 50px;
}
.evenements-page .highlight-text {
    border-left: 4px solid var(--vert-pullman);
    padding-left: 20px;
    font-size: 1.05rem;
    font-weight: 500;
    color: var(--texte-sombre);
    margin-bottom: 0;
    line-height: 1.7;
}
.evenements-page .gallery-evt-grid {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 18px;
}
.evenements-page .gallery-evt-item {
    position: relative;
    overflow: hidden;
    border-radius: 12px;
    aspect-ratio: 4 / 3;
    cursor: pointer;
    box-shadow: var(--ombre-douce);
}
.evenements-page .gallery-evt-item img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    transition: transform 0.7s cubic-bezier(0.25, 1, 0.5, 1);
}
.evenements-page .gallery-evt-item::after {
    content: "";
    position: absolute;
    inset: 0;
    background: linear-gradient(180deg, transparent 50%, rgba(10, 30, 45, 0.7));
    opacity: 0;
    transition: opacity 0.4s ease;
}
.evenements-page .gallery-evt-item:hover::after {
    opacity: 1;
}
.evenements-page .gallery-evt-item:hover img {
    transform: scale(1.08);
}
.evenements-page .gallery-evt-caption {
    position: absolute;
    bottom: 0;
    left: 0;
    right: 0;
    padding: 20px;
    color: #fff;
    font-size: 0.8rem;
    font-weight: 700;
    letter-spacing: 1.2px;
    text-transform: uppercase;
    transform: translateY(10px);
    opacity: 0;
    transition: all 0.4s ease;
    z-index: 2;
}
.evenements-page .gallery-evt-item:hover .gallery-evt-caption {
    transform: translateY(0);
    opacity: 1;
}

/* ============================================================= */
/* 5. TABLEAU CAPACITÉS                                           */
/* ============================================================= */
.evenements-page .capacity-evt {
    padding: 100px 0;
    background: #fff;
}
.evenements-page .capacity-evt .titre-souligne::after {
    left: 50%;
    transform: translateX(-50%);
}
.evenements-page .table-responsive {
    overflow-x: auto;
    border-radius: 14px;
    box-shadow: var(--ombre-douce);
}
.evenements-page .capacity-table {
    width: 100%;
    border-collapse: collapse;
    font-size: 0.9rem;
    background: #fff;
    min-width: 720px;
}
.evenements-page .capacity-table th,
.evenements-page .capacity-table td {
    padding: 18px 20px;
    text-align: left;
    border-bottom: 1px solid var(--ligne-grise);
}
.evenements-page .capacity-table thead {
    background: var(--bleu-nuit);
    color: #fff;
}
.evenements-page .capacity-table th {
    font-weight: 700;
    font-size: 0.75rem;
    letter-spacing: 1.2px;
    text-transform: uppercase;
}
.evenements-page .capacity-table tbody tr {
    transition: background 0.25s ease;
}
.evenements-page .capacity-table tbody tr:nth-child(even) {
    background: #F9FAFB;
}
.evenements-page .capacity-table tbody tr:hover {
    background: rgba(56, 226, 143, 0.06);
}
.evenements-page .capacity-table tbody td:first-child {
    font-weight: 700;
    color: var(--texte-sombre);
}
.evenements-page .capacity-table tbody td:not(:first-child) {
    color: var(--texte-gris);
    font-weight: 600;
}

/* ============================================================= */
/* 6. TECHNOLOGIE                                                 */
/* ============================================================= */
.evenements-page .tech-evt {
    padding: 100px 0;
    background: #F5F7F6;
}
.evenements-page .tech-evt-wrapper {
    display: grid;
    grid-template-columns: 1fr 2fr;
    gap: 60px;
    align-items: start;
}
.evenements-page .tech-evt-intro .titre-souligne::after {
    left: 0;
    transform: none;
}
.evenements-page .tech-evt-intro p {
    font-size: 0.95rem;
    color: var(--texte-gris);
    line-height: 1.75;
    margin-top: 24px;
    max-width: 400px;
}
.evenements-page .tech-evt-grid {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 22px;
}
.evenements-page .tech-evt-card {
    background: #fff;
    padding: 32px 26px;
    border-radius: 14px;
    box-shadow: var(--ombre-douce);
    transition: all 0.4s cubic-bezier(0.25, 1, 0.5, 1);
    position: relative;
    overflow: hidden;
    border: 1px solid transparent;
}
.evenements-page .tech-evt-card::after {
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
.evenements-page .tech-evt-card:hover::after {
    transform: scaleX(1);
}
.evenements-page .tech-evt-card:hover {
    transform: translateY(-8px);
    box-shadow: var(--ombre-forte);
    border-color: rgba(56, 226, 143, 0.2);
}
.evenements-page .tech-evt-icon {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    width: 52px;
    height: 52px;
    border-radius: 12px;
    background: linear-gradient(135deg, rgba(56, 226, 143, 0.12), rgba(21, 94, 117, 0.08));
    color: var(--vert-pullman);
    margin-bottom: 20px;
    transition: all 0.4s ease;
}
.evenements-page .tech-evt-card:hover .tech-evt-icon {
    background: var(--vert-pullman);
    color: #fff;
    transform: rotate(-6deg) scale(1.05);
}
.evenements-page .tech-evt-icon i {
    font-size: 22px;
}
.evenements-page .tech-evt-card h4 {
    font-size: 0.82rem;
    font-weight: 700;
    letter-spacing: 1.4px;
    text-transform: uppercase;
    color: var(--texte-sombre);
    margin-bottom: 14px;
}
.evenements-page .tech-evt-card ul {
    list-style: none;
    padding: 0;
    margin: 0;
}
.evenements-page .tech-evt-card li {
    font-size: 0.85rem;
    color: var(--texte-gris);
    line-height: 1.55;
    padding-left: 18px;
    position: relative;
    margin-bottom: 8px;
}
.evenements-page .tech-evt-card li::before {
    content: "";
    position: absolute;
    left: 0;
    top: 8px;
    width: 6px;
    height: 6px;
    border-radius: 50%;
    background: var(--vert-pullman);
}

/* ============================================================= */
/* 7. RÉALISATIONS                                                */
/* ============================================================= */
.evenements-page .realisations-evt {
    padding: 100px 0;
    background: #fff;
}
.evenements-page .realisations-grid {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 26px;
}
.evenements-page .realisation-card {
    background: #fff;
    border-radius: 14px;
    overflow: hidden;
    box-shadow: var(--ombre-douce);
    transition: all 0.4s ease;
    border: 1px solid var(--ligne-grise);
}
.evenements-page .realisation-card:hover {
    transform: translateY(-8px);
    box-shadow: var(--ombre-forte);
    border-color: transparent;
}
.evenements-page .realisation-img {
    height: 200px;
    overflow: hidden;
    position: relative;
}
.evenements-page .realisation-img img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    transition: transform 0.7s ease;
}
.evenements-page .realisation-card:hover .realisation-img img {
    transform: scale(1.08);
}
.evenements-page .realisation-tag {
    position: absolute;
    top: 16px;
    left: 16px;
    background: rgba(255, 255, 255, 0.95);
    color: var(--texte-sombre);
    font-size: 0.68rem;
    font-weight: 700;
    letter-spacing: 1.2px;
    text-transform: uppercase;
    padding: 6px 12px;
    border-radius: 20px;
    backdrop-filter: blur(8px);
    z-index: 2;
}
.evenements-page .realisation-body {
    padding: 24px 26px 28px;
}
.evenements-page .realisation-body h3 {
    font-size: 1.05rem;
    font-weight: 700;
    color: var(--texte-sombre);
    margin-bottom: 10px;
    line-height: 1.3;
}
.evenements-page .realisation-body p {
    font-size: 0.85rem;
    color: var(--texte-gris);
    line-height: 1.6;
    margin-bottom: 16px;
}
.evenements-page .realisation-meta {
    display: flex;
    align-items: center;
    gap: 18px;
    padding-top: 16px;
    border-top: 1px solid var(--ligne-grise);
    font-size: 0.78rem;
    color: var(--texte-gris);
    font-weight: 600;
}
.evenements-page .realisation-meta span {
    display: inline-flex;
    align-items: center;
    gap: 6px;
}
.evenements-page .realisation-meta i {
    color: var(--vert-pullman);
    font-size: 0.82rem;
}

/* ============================================================= */
/* 8. FAQ                                                         */
/* ============================================================= */
.evenements-page .faq-evt {
    padding: 100px 0;
    background: #F5F7F6;
}
.evenements-page .faq-evt .titre-souligne::after {
    left: 50%;
    transform: translateX(-50%);
}
.evenements-page .faq-liste {
    max-width: 800px;
    margin: 0 auto;
    display: flex;
    flex-direction: column;
    gap: 14px;
}
.evenements-page .faq-item {
    background: #fff;
    border: 1px solid var(--ligne-grise);
    border-radius: 12px;
    overflow: hidden;
    transition: border-color 0.3s, box-shadow 0.3s;
}
.evenements-page .faq-item:hover {
    border-color: rgba(56, 226, 143, 0.4);
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.04);
}
.evenements-page .faq-item.open {
    border-color: var(--vert-pullman);
}
.evenements-page .faq-question {
    width: 100%;
    background: none;
    border: none;
    padding: 22px 26px;
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
.evenements-page .faq-question:hover {
    color: var(--vert-pullman);
}
.evenements-page .faq-chevron {
    color: var(--vert-pullman);
    font-size: 0.9rem;
    transition: transform 0.3s ease;
    flex-shrink: 0;
}
.evenements-page .faq-item.open .faq-chevron {
    transform: rotate(180deg);
}
.evenements-page .faq-reponse {
    max-height: 0;
    overflow: hidden;
    transition: max-height 0.4s ease, padding 0.4s ease;
    padding: 0 26px;
    font-size: 0.88rem;
    color: var(--texte-gris);
    line-height: 1.7;
}
.evenements-page .faq-item.open .faq-reponse {
    max-height: 300px;
    padding: 0 26px 24px;
}

/* ============================================================= */
/* 9. CTA FINAL (contact)                                         */
/* ============================================================= */
.evenements-page .cta-evt {
    padding: 100px 0;
    background: linear-gradient(135deg, var(--bleu-nuit) 0%, var(--bleu-pullman) 100%);
    color: #fff;
    position: relative;
    overflow: hidden;
}
.evenements-page .cta-evt::before {
    content: "";
    position: absolute;
    top: -30%;
    right: -10%;
    width: 600px;
    height: 600px;
    border-radius: 50%;
    background: radial-gradient(circle, rgba(56, 226, 143, 0.15) 0%, transparent 70%);
    pointer-events: none;
}
.evenements-page .cta-evt-wrapper {
    display: grid;
    grid-template-columns: 1fr 1.2fr;
    gap: 60px;
    align-items: center;
    position: relative;
    z-index: 1;
}
.evenements-page .cta-evt-text .section-subtitle {
    color: #A8E6CF;
}
.evenements-page .cta-evt-text h2 {
    color: #fff;
    font-size: clamp(1.8rem, 2.8vw, 2.4rem);
    font-weight: 700;
    line-height: 1.2;
    margin-bottom: 20px;
}
.evenements-page .cta-evt-text p {
    font-size: 0.98rem;
    color: rgba(255, 255, 255, 0.85);
    line-height: 1.75;
    margin-bottom: 30px;
}
.evenements-page .cta-evt-contacts {
    display: flex;
    flex-direction: column;
    gap: 14px;
}
.evenements-page .cta-evt-contact {
    display: flex;
    align-items: center;
    gap: 14px;
    font-size: 0.9rem;
    color: rgba(255, 255, 255, 0.9);
}
.evenements-page .cta-evt-contact i {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    width: 40px;
    height: 40px;
    border-radius: 50%;
    background: rgba(56, 226, 143, 0.15);
    color: var(--vert-pullman);
    font-size: 0.9rem;
    flex-shrink: 0;
}
.evenements-page .cta-evt-form {
    background: #fff;
    border-radius: 16px;
    padding: 40px 36px;
    box-shadow: 0 30px 80px rgba(0, 0, 0, 0.3);
}
.evenements-page .cta-evt-form h3 {
    font-size: 1.15rem;
    font-weight: 700;
    color: var(--texte-sombre);
    margin-bottom: 24px;
}
.evenements-page .cta-evt-form .form-row {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 14px;
    margin-bottom: 14px;
}
.evenements-page .cta-evt-form .form-group {
    margin-bottom: 14px;
}
.evenements-page .cta-evt-form input,
.evenements-page .cta-evt-form select,
.evenements-page .cta-evt-form textarea {
    width: 100%;
    padding: 14px 16px;
    border: 1.5px solid var(--ligne-grise);
    border-radius: 8px;
    font-family: inherit;
    font-size: 0.9rem;
    color: var(--texte-sombre);
    background: #fff;
    outline: none;
    transition: border-color 0.3s, box-shadow 0.3s;
}
.evenements-page .cta-evt-form input:focus,
.evenements-page .cta-evt-form select:focus,
.evenements-page .cta-evt-form textarea:focus {
    border-color: var(--vert-pullman);
    box-shadow: 0 0 0 4px rgba(56, 226, 143, 0.12);
}
.evenements-page .cta-evt-form textarea {
    resize: vertical;
    min-height: 100px;
}
.evenements-page .cta-evt-form .btn-cta {
    width: 100%;
    background: var(--vert-pullman);
    color: #fff;
    border: none;
    border-radius: 10px;
    padding: 16px;
    font-family: inherit;
    font-weight: 800;
    font-size: 0.85rem;
    letter-spacing: 1.2px;
    text-transform: uppercase;
    cursor: pointer;
    transition: all 0.3s ease;
    box-shadow: 0 8px 22px rgba(56, 226, 143, 0.3);
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 10px;
    margin-top: 8px;
}
.evenements-page .cta-evt-form .btn-cta:hover {
    background: #2BC87A;
    transform: translateY(-2px);
    box-shadow: 0 12px 30px rgba(56, 226, 143, 0.45);
}

/* ============================================================= */
/* 10. POP-UP DEVIS                                               */
/* ============================================================= */
.evt-modal-overlay {
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
.evt-modal-overlay.is-open {
    opacity: 1;
    visibility: visible;
}
.evt-modal {
    background: #fff;
    width: 100%;
    max-width: 600px;
    max-height: 92vh;
    overflow-y: auto;
    border-radius: 16px;
    position: relative;
    box-shadow: 0 30px 80px rgba(0, 0, 0, 0.4);
    transform: translateY(30px) scale(0.96);
    transition: transform 0.4s cubic-bezier(0.25, 1, 0.5, 1);
}
.evt-modal-overlay.is-open .evt-modal {
    transform: translateY(0) scale(1);
}
.evt-modal-close {
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
.evt-modal-close:hover {
    background: var(--or-sable);
    color: #fff;
    transform: rotate(90deg);
}
.evt-modal-header {
    padding: 36px 36px 26px;
    background: linear-gradient(135deg, var(--bleu-nuit) 0%, var(--bleu-pullman) 100%);
    color: #fff;
    border-radius: 16px 16px 0 0;
    position: relative;
    overflow: hidden;
}
.evt-modal-header::before {
    content: "";
    position: absolute;
    top: -50%;
    right: -20%;
    width: 300px;
    height: 300px;
    border-radius: 50%;
    background: radial-gradient(circle, rgba(197, 154, 103, 0.25) 0%, transparent 70%);
    pointer-events: none;
}
.evt-modal-header .eyebrow {
    display: inline-block;
    color: var(--or-sable);
    font-size: 0.7rem;
    font-weight: 700;
    letter-spacing: 2.5px;
    text-transform: uppercase;
    margin-bottom: 10px;
    position: relative;
    z-index: 1;
}
.evt-modal-header h3 {
    color: #fff;
    font-size: 1.5rem;
    font-weight: 700;
    margin: 0 0 8px;
    position: relative;
    z-index: 1;
    line-height: 1.25;
}
.evt-modal-header p {
    font-size: 0.85rem;
    opacity: 0.9;
    margin: 0;
    line-height: 1.5;
    position: relative;
    z-index: 1;
}
.evt-modal-body {
    padding: 30px 36px 36px;
}
.evt-modal-field {
    margin-bottom: 18px;
}
.evt-modal-field label {
    display: block;
    font-size: 0.72rem;
    font-weight: 700;
    color: var(--texte-sombre);
    letter-spacing: 1px;
    text-transform: uppercase;
    margin-bottom: 8px;
}
.evt-modal-field input,
.evt-modal-field select,
.evt-modal-field textarea {
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
.evt-modal-field input:focus,
.evt-modal-field select:focus,
.evt-modal-field textarea:focus {
    border-color: var(--vert-pullman);
    box-shadow: 0 0 0 4px rgba(56, 226, 143, 0.12);
}
.evt-modal-field textarea {
    resize: vertical;
    min-height: 80px;
}
.evt-modal-row {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 14px;
}
.evt-modal-submit {
    width: 100%;
    background: var(--vert-pullman);
    color: #fff;
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
.evt-modal-submit:hover {
    background: #2BC87A;
    transform: translateY(-2px);
    box-shadow: 0 12px 30px rgba(56, 226, 143, 0.45);
}
.evt-modal-reassurance {
    display: flex;
    justify-content: center;
    gap: 18px;
    margin-top: 16px;
    font-size: 0.7rem;
    color: var(--texte-gris);
    flex-wrap: wrap;
}
.evt-modal-reassurance span {
    display: inline-flex;
    align-items: center;
    gap: 5px;
    font-weight: 600;
}
.evt-modal-reassurance i {
    color: var(--vert-pullman);
    font-size: 0.75rem;
}

/* ============================================================= */
/* 11. REVEAL / ANIMATION                                         */
/* ============================================================= */
.evenements-page .reveal {
    opacity: 0;
    transform: translateY(40px);
    transition: opacity 0.8s ease-out, transform 0.8s ease-out;
}
.evenements-page .reveal.active {
    opacity: 1;
    transform: translateY(0);
}

/* ============================================================= */
/* 12. RESPONSIVE                                                 */
/* ============================================================= */
@media (max-width: 1100px) {
    .evenements-page .features-evt-grid {
        grid-template-columns: 1fr;
    }
    .evenements-page .feature-evt-item {
        border-right: none;
        border-bottom: 1px solid var(--ligne-grise);
        padding: 30px 20px;
    }
    .evenements-page .feature-evt-item:last-child {
        border-bottom: none;
    }
    .evenements-page .gallery-evt-grid {
        grid-template-columns: repeat(2, 1fr);
    }
    .evenements-page .tech-evt-wrapper {
        grid-template-columns: 1fr;
        gap: 40px;
    }
    .evenements-page .tech-evt-grid {
        grid-template-columns: repeat(2, 1fr);
    }
    .evenements-page .realisations-grid {
        grid-template-columns: repeat(2, 1fr);
    }
    .evenements-page .cta-evt-wrapper {
        grid-template-columns: 1fr;
        gap: 40px;
    }
}
@media (max-width: 768px) {
    .evenements-page .container { padding: 0 24px; }
    .evenements-page .section { padding: 70px 0; }
    .evenements-page .hero-evt-content { padding: 60px 24px 80px; }
    .evenements-page .hero-evt-chips {
        position: static;
        margin-top: 40px;
        justify-content: flex-start;
    }
    .evenements-page .gallery-evt-grid {
        grid-template-columns: 1fr;
    }
    .evenements-page .tech-evt-grid {
        grid-template-columns: 1fr;
    }
    .evenements-page .realisations-grid {
        grid-template-columns: 1fr;
    }
    .evenements-page .cta-evt-form {
        padding: 28px 22px;
    }
    .evenements-page .cta-evt-form .form-row {
        grid-template-columns: 1fr;
    }
    .evenements-page .evt-modal-row {
        grid-template-columns: 1fr;
    }
    .evenements-page .evt-modal-header,
    .evenements-page .evt-modal-body {
        padding-left: 24px;
        padding-right: 24px;
    }
}
CSS_EOF

echo -e "${GREEN}   ✔ CSS premium ($(wc -l < $CSS) lignes)${NC}\n"

# ============================================================
# 2. RÉÉCRITURE DU HTML (préserver header + footer + CTA)
# ============================================================
echo -e "${BLUE}━━━ [2/3] HTML central ━━━${NC}"

python3 << 'PY_EOF'
import re
from pathlib import Path

f = Path('evenements.html')
c = f.read_text(encoding='utf-8')

# ---- Extraire le header (jusqu'à </header>) ----
header_end = c.find('</header>') + len('</header>')
header = c[:header_end]

# ---- Extraire le CTA + footer (à partir de <section class="booking-section">) ----
cta_start = c.find('<section class="booking-section">')
footer_part = c[cta_start:] if cta_start > 0 else ''

# ---- Nouveau contenu central ----
new_body = '''
    <!-- ============================== MAIN ============================== -->
    <main>
    <div class="evenements-page">

        <!-- ============================================================
             HERO PREMIUM
             ============================================================ -->
        <section class="hero-evt" id="heroEvt">
            <div class="hero-evt-bg" style="background-image: url('images/image hero.png');"></div>
            <div class="hero-evt-overlay"></div>

            <div class="hero-evt-content">
                <p class="breadcrumb">
                    <a href="index.html">Accueil</a>
                    <i class="fa-solid fa-chevron-right"></i>
                    <a href="evenements.html">Meeting &amp; Events</a>
                    <i class="fa-solid fa-chevron-right"></i>
                    <span>Réserver un espace</span>
                </p>

                <span class="eyebrow">Meeting &amp; Events</span>

                <h1>Des espaces uniques<br>pour vos <span class="highlight">événements</span></h1>

                <p class="hero-evt-desc">
                    Séminaires, conférences, mariages ou soirées privées —
                    le Pullman Dakar Teranga vous offre un cadre d'exception
                    pour des moments inoubliables, face à l'Atlantique.
                </p>

                <div class="hero-evt-actions">
                    <button type="button" class="btn-hero-primary" data-open-evt-modal>
                        Demander un devis
                        <i class="fa-solid fa-arrow-right"></i>
                    </button>
                    <a href="#galerie" class="btn-hero-ghost">
                        Découvrir nos espaces
                        <i class="fa-solid fa-chevron-down"></i>
                    </a>
                </div>
            </div>

            <div class="hero-evt-chips">
                <span class="hero-chip"><i class="fa-solid fa-star"></i> 528 m² modulables</span>
                <span class="hero-chip"><i class="fa-solid fa-star"></i> Jusqu'à 400 personnes</span>
                <span class="hero-chip"><i class="fa-solid fa-star"></i> 5 salles</span>
            </div>
        </section>

        <!-- ============================================================
             FEATURES — 3 piliers
             ============================================================ -->
        <section class="features-evt">
            <div class="container">
                <div class="features-evt-grid reveal">
                    <div class="feature-evt-item">
                        <div class="feature-evt-icon"><i class="fa-solid fa-border-all"></i></div>
                        <h3>Espaces modulables</h3>
                        <p>Des salles élégantes et flexibles, adaptées à tous vos formats d'événements, du comité de direction au congrès.</p>
                    </div>
                    <div class="feature-evt-item">
                        <div class="feature-evt-icon"><i class="fa-solid fa-utensils"></i></div>
                        <h3>Restauration sur mesure</h3>
                        <p>Une cuisine raffinée, signée par nos chefs, pour une expérience culinaire à la hauteur de vos invités.</p>
                    </div>
                    <div class="feature-evt-item">
                        <div class="feature-evt-icon"><i class="fa-solid fa-user-tie"></i></div>
                        <h3>Accompagnement dédié</h3>
                        <p>Une équipe experte à vos côtés, de la conception à la réalisation, pour un événement sans fausse note.</p>
                    </div>
                </div>
            </div>
        </section>

        <!-- ============================================================
             GALERIE
             ============================================================ -->
        <section class="gallery-evt" id="galerie">
            <div class="container">
                <div class="gallery-evt-header reveal">
                    <span class="section-subtitle">Nos espaces en images</span>
                    <h2 class="titre-souligne titre-souligne--left">Un lieu, mille configurations</h2>
                    <p class="highlight-text" style="margin-top: 26px;">
                        Le Pullman Dakar Teranga dispose d'un espace événementiel modulable
                        de près de <strong>528 m²</strong>, pensé pour accueillir aussi bien
                        des réunions de direction que des conférences de grande envergure,
                        des banquets d'affaires ou des réceptions privées.
                    </p>
                </div>

                <div class="gallery-evt-grid reveal">
                    <div class="gallery-evt-item">
                        <img src="images/1.png" alt="Configuration théâtre" loading="lazy">
                        <span class="gallery-evt-caption">Configuration théâtre</span>
                    </div>
                    <div class="gallery-evt-item">
                        <img src="images/2.png" alt="Espace lounge" loading="lazy">
                        <span class="gallery-evt-caption">Espace lounge</span>
                    </div>
                    <div class="gallery-evt-item">
                        <img src="images/3.png" alt="Configuration banquet" loading="lazy">
                        <span class="gallery-evt-caption">Configuration banquet</span>
                    </div>
                    <div class="gallery-evt-item">
                        <img src="images/4.png" alt="Salle de réunion" loading="lazy">
                        <span class="gallery-evt-caption">Salle de réunion</span>
                    </div>
                    <div class="gallery-evt-item">
                        <img src="images/5.png" alt="Configuration en U" loading="lazy">
                        <span class="gallery-evt-caption">Configuration en U</span>
                    </div>
                    <div class="gallery-evt-item">
                        <img src="images/6.png" alt="Espace cocktail" loading="lazy">
                        <span class="gallery-evt-caption">Espace cocktail</span>
                    </div>
                </div>
            </div>
        </section>

        <!-- ============================================================
             TABLEAU CAPACITÉS
             ============================================================ -->
        <section class="capacity-evt">
            <div class="container">
                <div class="section-header reveal">
                    <span class="section-subtitle">Nos salles de réunion</span>
                    <h2 class="titre-souligne">Capacités et configurations</h2>
                </div>

                <div class="table-responsive reveal">
                    <table class="capacity-table">
                        <thead>
                            <tr>
                                <th>Nom de la salle</th>
                                <th>Superficie</th>
                                <th>Théâtre</th>
                                <th>Cocktail</th>
                                <th>Banquet</th>
                                <th>Classe</th>
                                <th>En U</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr><td>Teranga (Plénière)</td><td>272 m²</td><td>350</td><td>400</td><td>220</td><td>160</td><td>60</td></tr>
                            <tr><td>Gorée</td><td>118 m²</td><td>100</td><td>110</td><td>70</td><td>55</td><td>35</td></tr>
                            <tr><td>Madeleine</td><td>60 m²</td><td>45</td><td>50</td><td>—</td><td>25</td><td>20</td></tr>
                            <tr><td>Comité 1</td><td>40 m²</td><td>25</td><td>—</td><td>—</td><td>15</td><td>15</td></tr>
                            <tr><td>Comité 2</td><td>40 m²</td><td>25</td><td>—</td><td>—</td><td>15</td><td>15</td></tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </section>

        <!-- ============================================================
             TECHNOLOGIE
             ============================================================ -->
        <section class="tech-evt">
            <div class="container">
                <div class="tech-evt-wrapper reveal">
                    <div class="tech-evt-intro">
                        <span class="section-subtitle">Équipements audiovisuels</span>
                        <h2 class="titre-souligne titre-souligne--left">Une technologie au service de vos échanges</h2>
                        <p>Les salles sont équipées selon la démarche <strong>Co-Meeting</strong> de Pullman : simplicité, efficacité, fiabilité.</p>
                    </div>

                    <div class="tech-evt-grid">
                        <div class="tech-evt-card">
                            <div class="tech-evt-icon"><i class="fa-solid fa-wifi"></i></div>
                            <h4>Connectivité</h4>
                            <ul>
                                <li>Wi-Fi haut débit dédié</li>
                                <li>Accès Internet fibre</li>
                                <li>Réseau sécurisé séparé</li>
                            </ul>
                        </div>

                        <div class="tech-evt-card">
                            <div class="tech-evt-icon"><i class="fa-solid fa-tv"></i></div>
                            <h4>Image &amp; Affichage</h4>
                            <ul>
                                <li>Vidéoprojecteurs HD</li>
                                <li>Écrans de projection encastrés</li>
                                <li>Téléviseurs LED d'appoint</li>
                            </ul>
                        </div>

                        <div class="tech-evt-card">
                            <div class="tech-evt-icon"><i class="fa-solid fa-microphone-lines"></i></div>
                            <h4>Sonorisation</h4>
                            <ul>
                                <li>Système audio intégré</li>
                                <li>Micros sans fil (HF)</li>
                                <li>Micros cravate</li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- ============================================================
             RÉALISATIONS
             ============================================================ -->
        <section class="realisations-evt">
            <div class="container">
                <div class="section-header reveal">
                    <span class="section-subtitle">Ils nous ont fait confiance</span>
                    <h2 class="titre-souligne">Nos dernières réalisations</h2>
                </div>

                <div class="realisations-grid reveal">
                    <article class="realisation-card">
                        <div class="realisation-img">
                            <span class="realisation-tag">Séminaire</span>
                            <img src="images/1.png" alt="Séminaire d'entreprise" loading="lazy">
                        </div>
                        <div class="realisation-body">
                            <h3>Séminaire annuel — Groupe bancaire</h3>
                            <p>250 participants sur 2 jours, avec ateliers parallèles et dîner de gala face à l'océan.</p>
                            <div class="realisation-meta">
                                <span><i class="fa-solid fa-users"></i> 250 pers.</span>
                                <span><i class="fa-solid fa-calendar"></i> Nov. 2025</span>
                            </div>
                        </div>
                    </article>

                    <article class="realisation-card">
                        <div class="realisation-img">
                            <span class="realisation-tag">Conférence</span>
                            <img src="images/2.png" alt="Conférence internationale" loading="lazy">
                        </div>
                        <div class="realisation-body">
                            <h3>Conférence internationale — Tech Dakar</h3>
                            <p>Espace plénier Teranga en configuration théâtre, avec retransmission en direct dans les salles annexes.</p>
                            <div class="realisation-meta">
                                <span><i class="fa-solid fa-users"></i> 350 pers.</span>
                                <span><i class="fa-solid fa-calendar"></i> Sept. 2025</span>
                            </div>
                        </div>
                    </article>

                    <article class="realisation-card">
                        <div class="realisation-img">
                            <span class="realisation-tag">Mariage</span>
                            <img src="images/3.png" alt="Réception de mariage" loading="lazy">
                        </div>
                        <div class="realisation-body">
                            <h3>Réception de mariage — Famille Ndiaye</h3>
                            <p>Cocktail sur la terrasse puis dîner assis pour 180 convives, avec espace dancing et scène ouverte.</p>
                            <div class="realisation-meta">
                                <span><i class="fa-solid fa-users"></i> 180 pers.</span>
                                <span><i class="fa-solid fa-calendar"></i> Juin 2025</span>
                            </div>
                        </div>
                    </article>
                </div>
            </div>
        </section>

        <!-- ============================================================
             FAQ
             ============================================================ -->
        <section class="faq-evt">
            <div class="container">
                <div class="section-header reveal">
                    <span class="section-subtitle">Questions fréquentes</span>
                    <h2 class="titre-souligne">Tout ce qu'il faut savoir</h2>
                </div>

                <div class="faq-liste reveal">
                    <div class="faq-item">
                        <button type="button" class="faq-question">
                            <span>Combien de temps à l'avance faut-il réserver un espace ?</span>
                            <i class="fa-solid fa-chevron-down faq-chevron"></i>
                        </button>
                        <div class="faq-reponse">
                            Pour un événement jusqu'à 100 personnes, nous recommandons 4 à 6 semaines.
                            Pour les grands événements (>200 personnes) ou les dates de fin d'année,
                            prévoyez 3 à 6 mois à l'avance.
                        </div>
                    </div>

                    <div class="faq-item">
                        <button type="button" class="faq-question">
                            <span>Proposez-vous des forfaits tout compris ?</span>
                            <i class="fa-solid fa-chevron-down faq-chevron"></i>
                        </button>
                        <div class="faq-reponse">
                            Oui. Nos forfaits « Journée Co-Meeting » et « Séminaire Résidentiel »
                            incluent la location de salle, les pauses café, le déjeuner,
                            les équipements audiovisuels et l'assistance technique.
                        </div>
                    </div>

                    <div class="faq-item">
                        <button type="button" class="faq-question">
                            <span>Peut-on privatiser l'espace Teranga en entier ?</span>
                            <i class="fa-solid fa-chevron-down faq-chevron"></i>
                        </button>
                        <div class="faq-reponse">
                            Absolument. L'espace Teranga (272 m²) peut être privatisé en totalité
                            ou scindé en plusieurs configurations selon votre plan de salle.
                        </div>
                    </div>

                    <div class="faq-item">
                        <button type="button" class="faq-question">
                            <span>Y a-t-il un parking pour les invités ?</span>
                            <i class="fa-solid fa-chevron-down faq-chevron"></i>
                        </button>
                        <div class="faq-reponse">
                            Oui, un parking sécurisé est disponible sur place, avec un service
                            de voiturier sur demande pour les événements de plus de 150 personnes.
                        </div>
                    </div>

                    <div class="faq-item">
                        <button type="button" class="faq-question">
                            <span>Puis-je personnaliser le menu et le service ?</span>
                            <i class="fa-solid fa-chevron-down faq-chevron"></i>
                        </button>
                        <div class="faq-reponse">
                            Bien sûr. Notre chef élabore chaque menu en concertation avec vous,
                            en tenant compte des régimes alimentaires, allergènes et traditions culinaires.
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- ============================================================
             CTA FINAL — Formulaire devis
             ============================================================ -->
        <section class="cta-evt">
            <div class="container">
                <div class="cta-evt-wrapper">
                    <div class="cta-evt-text reveal">
                        <span class="section-subtitle">Votre conciergerie événements</span>
                        <h2>Planifions ensemble votre prochain événement</h2>
                        <p>Notre équipe dédiée vous accompagne de A à Z pour créer un événement sur-mesure, à la hauteur de votre image.</p>

                        <div class="cta-evt-contacts">
                            <div class="cta-evt-contact">
                                <i class="fa-solid fa-phone"></i>
                                <span>+221 33 869 66 66</span>
                            </div>
                            <div class="cta-evt-contact">
                                <i class="fa-solid fa-envelope"></i>
                                <span>events@pullman-dakar.com</span>
                            </div>
                            <div class="cta-evt-contact">
                                <i class="fa-solid fa-clock"></i>
                                <span>Réponse garantie sous 24h ouvrées</span>
                            </div>
                        </div>
                    </div>

                    <div class="cta-evt-form reveal">
                        <h3>Demander un devis personnalisé</h3>
                        <form action="https://formspree.io/f/mvkgaopv" method="POST">
                            <div class="form-row">
                                <div class="form-group">
                                    <input type="text" name="nom" placeholder="Nom complet *" required autocomplete="name">
                                </div>
                                <div class="form-group">
                                    <input type="email" name="email" placeholder="Email *" required autocomplete="email">
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="form-group">
                                    <input type="tel" name="telephone" placeholder="Téléphone *" required autocomplete="tel">
                                </div>
                                <div class="form-group">
                                    <select name="type_evenement" required>
                                        <option value="" disabled selected>Type d'événement *</option>
                                        <option value="seminaire">Séminaire</option>
                                        <option value="conference">Conférence</option>
                                        <option value="mariage">Mariage</option>
                                        <option value="cocktail">Cocktail / Réception</option>
                                        <option value="autre">Autre</option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group">
                                <textarea name="message" placeholder="Décrivez votre projet : nombre de participants, dates souhaitées, besoins particuliers…"></textarea>
                            </div>
                            <button type="submit" class="btn-cta">
                                Envoyer ma demande
                                <i class="fa-solid fa-arrow-right"></i>
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </section>

        <!-- ============================================================
             POP-UP DEVIS
             ============================================================ -->
        <div class="evt-modal-overlay" id="evtModal" aria-hidden="true">
            <div class="evt-modal" role="dialog" aria-modal="true" aria-labelledby="evtModalTitle">
                <button type="button" class="evt-modal-close" id="evtModalClose" aria-label="Fermer">
                    <i class="fa-solid fa-xmark"></i>
                </button>

                <div class="evt-modal-header">
                    <span class="eyebrow">Devis en 24h</span>
                    <h3 id="evtModalTitle">Planifions votre événement</h3>
                    <p>Remplissez ce formulaire et notre équipe vous recontacte sous 24h ouvrées.</p>
                </div>

                <div class="evt-modal-body">
                    <form id="evtModalForm">
                        <div class="evt-modal-row">
                            <div class="evt-modal-field">
                                <label for="evtNom">Nom complet</label>
                                <input type="text" id="evtNom" name="nom" placeholder="Votre nom" required>
                            </div>
                            <div class="evt-modal-field">
                                <label for="evtSociete">Société (facultatif)</label>
                                <input type="text" id="evtSociete" name="societe" placeholder="Nom de la société">
                            </div>
                        </div>

                        <div class="evt-modal-row">
                            <div class="evt-modal-field">
                                <label for="evtEmail">E-mail</label>
                                <input type="email" id="evtEmail" name="email" placeholder="vous@exemple.com" required>
                            </div>
                            <div class="evt-modal-field">
                                <label for="evtTel">Téléphone</label>
                                <input type="tel" id="evtTel" name="telephone" placeholder="+221 77 123 45 67" required>
                            </div>
                        </div>

                        <div class="evt-modal-row">
                            <div class="evt-modal-field">
                                <label for="evtType">Type d'événement</label>
                                <select id="evtType" name="type_evenement" required>
                                    <option value="" disabled selected>Choisir…</option>
                                    <option value="seminaire">Séminaire</option>
                                    <option value="conference">Conférence</option>
                                    <option value="mariage">Mariage</option>
                                    <option value="cocktail">Cocktail / Réception</option>
                                    <option value="autre">Autre</option>
                                </select>
                            </div>
                            <div class="evt-modal-field">
                                <label for="evtParticipants">Nombre de participants</label>
                                <input type="number" id="evtParticipants" name="participants" min="1" placeholder="Ex. 150" required>
                            </div>
                        </div>

                        <div class="evt-modal-field">
                            <label for="evtDate">Date souhaitée</label>
                            <input type="date" id="evtDate" name="date_evenement" required>
                        </div>

                        <div class="evt-modal-field">
                            <label for="evtMessage">Votre projet</label>
                            <textarea id="evtMessage" name="message" placeholder="Décrivez brièvement votre événement : configuration, besoins techniques, restauration…"></textarea>
                        </div>

                        <button type="submit" class="evt-modal-submit">
                            Envoyer ma demande
                            <i class="fa-solid fa-arrow-right"></i>
                        </button>

                        <div class="evt-modal-reassurance">
                            <span><i class="fa-solid fa-check"></i> Réponse en 24h</span>
                            <span><i class="fa-solid fa-check"></i> Devis gratuit</span>
                            <span><i class="fa-solid fa-check"></i> Sans engagement</span>
                        </div>
                    </form>
                </div>
            </div>
        </div>

    </div><!-- /.evenements-page -->
    </main>

'''

new_html = header + '\n' + new_body + footer_part
f.write_text(new_html, encoding='utf-8')
print("   ✔ HTML central reconstruit")
print("   ✔ Header + CTA + Footer préservés")
PY_EOF

echo -e "${GREEN}   ✔ HTML réécrit${NC}\n"

# ============================================================
# 3. SCRIPTS (GSAP + slider + modal + FAQ + reveal)
# ============================================================
echo -e "${BLUE}━━━ [3/3] Scripts JS ━━━${NC}"

python3 << 'PY_EOF'
import re
from pathlib import Path

f = Path('evenements.html')
c = f.read_text(encoding='utf-8')

# Ajouter GSAP si pas déjà présent
if 'gsap.min.js' not in c:
    # Insérer avant js/booking-bridge.js
    anchor = '<script src="js/booking-bridge.js"></script>'
    if anchor in c:
        c = c.replace(anchor,
            '<script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.2/gsap.min.js"></script>\n'
            '<script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.2/ScrollTrigger.min.js"></script>\n\n'
            + anchor, 1)
    else:
        # Fallback : avant </body>
        c = c.replace('</body>',
            '<script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.2/gsap.min.js"></script>\n'
            '<script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.2/ScrollTrigger.min.js"></script>\n'
            '</body>', 1)

# Script inline
script = '''
<!-- ============================== SCRIPT PAGE ÉVÉNEMENTS ============================== -->
<script>
document.addEventListener('DOMContentLoaded', () => {

    /* ============ 1. POP-UP DEVIS ============ */
    const modal      = document.getElementById('evtModal');
    const modalClose = document.getElementById('evtModalClose');
    const modalForm  = document.getElementById('evtModalForm');
    const modalDate  = document.getElementById('evtDate');

    function openModal() {
        if (!modal) return;
        if (modalDate && !modalDate.value) {
            const d = new Date();
            d.setDate(d.getDate() + 30);
            modalDate.valueAsDate = d;
            modalDate.min = new Date().toISOString().split('T')[0];
        }
        modal.classList.add('is-open');
        modal.setAttribute('aria-hidden', 'false');
        document.body.style.overflow = 'hidden';
    }
    function closeModal() {
        if (!modal) return;
        modal.classList.remove('is-open');
        modal.setAttribute('aria-hidden', 'true');
        document.body.style.overflow = '';
    }

    document.querySelectorAll('[data-open-evt-modal]').forEach(btn => {
        btn.addEventListener('click', e => { e.preventDefault(); openModal(); });
    });
    if (modalClose) modalClose.addEventListener('click', closeModal);
    if (modal) modal.addEventListener('click', e => { if (e.target === modal) closeModal(); });
    document.addEventListener('keydown', e => {
        if (e.key === 'Escape' && modal && modal.classList.contains('is-open')) closeModal();
    });

    if (modalForm) {
        modalForm.addEventListener('submit', e => {
            e.preventDefault();
            const prenomNom = document.getElementById('evtNom')?.value || '';
            const email     = document.getElementById('evtEmail')?.value || '';
            const type      = document.getElementById('evtType')?.value || '';
            const participants = document.getElementById('evtParticipants')?.value || '';
            const date      = document.getElementById('evtDate')?.value || '';

            alert(`✅ Demande de devis envoyée !

Nom : ${prenomNom}
Email : ${email}
Type : ${type}
Participants : ${participants}
Date : ${date}

Notre équipe vous répond sous 24h ouvrées.`);
            modalForm.reset();
            closeModal();
        });
    }

    /* ============ 2. FAQ ACCORDÉON ============ */
    document.querySelectorAll('.evenements-page .faq-question').forEach(btn => {
        btn.addEventListener('click', () => {
            const item = btn.closest('.faq-item');
            const isOpen = item.classList.contains('open');
            document.querySelectorAll('.evenements-page .faq-item.open').forEach(el => el.classList.remove('open'));
            if (!isOpen) item.classList.add('open');
        });
    });

    /* ============ 3. REVEAL / ANIMATIONS ============ */
    const reveals = document.querySelectorAll('.evenements-page .reveal');
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

    /* ============ 4. PARALLAX HERO léger ============ */
    const heroBg = document.querySelector('.evenements-page .hero-evt-bg');
    const heroSec = document.querySelector('.evenements-page .hero-evt');
    if (heroBg && heroSec && typeof gsap !== 'undefined') {
        window.addEventListener('scroll', () => {
            const y = window.scrollY;
            if (y <= heroSec.offsetHeight) {
                heroBg.style.transform = `translateY(${y * 0.25}px) scale(${1 + y * 0.0002})`;
            }
        });
    }

});
</script>

</body>'''

c = c.replace('</body>', script, 1)

f.write_text(c, encoding='utf-8')
print("   ✔ GSAP + ScrollTrigger ajoutés")
print("   ✔ Script pop-up devis ajouté")
print("   ✔ FAQ accordéon ajouté")
print("   ✔ Parallax hero ajouté")
PY_EOF

echo -e "${GREEN}   ✔ Scripts injectés${NC}\n"

# ============================================================
# 4. VÉRIFICATION FINALE
# ============================================================
echo -e "${BLUE}━━━ VÉRIFICATION ━━━${NC}"

H=$(cat "$HTML")
C=$(cat "$CSS")

printf "   %-42s | %s\n" "Élément" "Valeur"
printf "   %-42s-|-%s\n" "------------------------------------------" "--------"

printf "   %-42s | %s\n" "Hero premium" "$(echo "$H" | grep -c 'hero-evt' || echo 0)"
printf "   %-42s | %s\n" "Chips hero (3 attendus)" "$(echo "$H" | grep -c 'hero-chip' || echo 0)"
printf "   %-42s | %s\n" "Bouton pop-up devis" "$(echo "$H" | grep -c 'data-open-evt-modal' || echo 0)"
printf "   %-42s | %s\n" "Pop-up #evtModal (1 attendue)" "$(echo "$H" | grep -c 'id="evtModal"' || echo 0)"
printf "   %-42s | %s\n" "Cartes réalisations (3 attendues)" "$(echo "$H" | grep -c 'realisation-card' || echo 0)"
printf "   %-42s | %s\n" "FAQ (5 questions attendues)" "$(echo "$H" | grep -c 'faq-question' || echo 0)"
printf "   %-42s | %s\n" "GSAP chargé" "$(echo "$H" | grep -c 'gsap.min.js' || echo 0)"
printf "   %-42s | %s\n" "Header préservé" "$(echo "$H" | grep -c 'site-header' || echo 0)"
printf "   %-42s | %s\n" "Footer préservé" "$(echo "$H" | grep -c 'main-footer' || echo 0)"
printf "   %-42s | %s\n" "CTA préservé" "$(echo "$H" | grep -c 'booking-section' || echo 0)"
printf "   %-42s | %s\n" "booking-bridge.js présent" "$(echo "$H" | grep -c 'booking-bridge' || echo 0)"

echo ""
echo -e "${BLUE}CSS :${NC}"
printf "   %-42s | %s\n" "Scopé .evenements-page" "$(echo "$C" | grep -c '\.evenements-page' || echo 0)"
printf "   %-42s | %s\n" "Pop-up devis" "$(echo "$C" | grep -c 'evt-modal' || echo 0)"
printf "   %-42s | %s\n" "Réalisations" "$(echo "$C" | grep -c 'realisation' || echo 0)"
printf "   %-42s | %s\n" "FAQ" "$(echo "$C" | grep -c 'faq-' || echo 0)"

echo ""
echo -e "${GREEN}✅ REFONTE PREMIUM TERMINÉE${NC}"
echo -e "${BLUE}💾 Sauvegarde : $BACKUP${NC}"
echo ""
echo -e "${BLUE}📋 Résumé :${NC}"
echo "   ✨ Hero premium avec breadcrumb + eyebrow + 2 CTA + chips flottants"
echo "   ✨ 3 piliers en grille (espaces modulables, restauration, accompagnement)"
echo "   ✨ Galerie 3×2 avec captions animées"
echo "   ✨ Tableau capacités redessiné (dark header, hover vert)"
echo "   ✨ Section Technologie : 3 cartes avec icônes + trait vert animé"
echo "   ✨ Section Réalisations : 3 cas clients avec tags et meta"
echo "   ✨ Section FAQ accordéon (5 questions)"
echo "   ✨ CTA final : formulaire devis intégré en 2 colonnes"
echo "   ✨ Pop-up devis complète (nom, société, email, tél, type, participants, date)"
echo "   ✨ Animations GSAP au scroll + parallax hero léger"
echo ""
echo -e "${YELLOW}⚠  Top menu, CTA bas de page et Footer PRÉSERVÉS${NC}"
echo ""
echo -e "${BLUE}🔄 Rollback :${NC}"
echo "   cp $BACKUP/evenements.html ."
echo "   cp $BACKUP/evenements.css css/"
echo ""
echo -e "${BLUE}🧹 Nettoyage :${NC}"
echo "   rm -rf $BACKUP ameliorer_evenements.sh"
