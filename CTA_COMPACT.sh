#!/bin/bash
set -e

BACKUP=".backup_COMPACT_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP"
cp css/footer-cta.css "$BACKUP/"
echo "📦 Sauvegarde → $BACKUP"

# Retirer TOUS les blocs CTA précédents (Breathe v2 notamment)
python3 << 'PYEOF'
import re
with open('css/footer-cta.css', 'r', encoding='utf-8') as f:
    c = f.read()

# Retirer le bloc "Breathe" s'il existe
c = re.sub(
    r'/\* =+ \*/\n/\* CTA — BANDEAU RÉSERVATION · Teranga Luxe \(Breathe\) \*/.*$',
    '',
    c,
    flags=re.DOTALL
)

with open('css/footer-cta.css', 'w', encoding='utf-8') as f:
    f.write(c)
print("🧹 Ancien bloc 'Breathe' retiré")
PYEOF

# Ajouter la version COMPACTE — plus petite et raffinée
cat >> css/footer-cta.css << 'CSS_EOF'

/* ============================================================= */
/* CTA — BANDEAU RÉSERVATION · Teranga Compact                   */
/* Design raffiné, hauteur maîtrisée (~370px au lieu de 550px)   */
/* ============================================================= */

.booking-section {
    position: relative;
    background: #062F3D;
    background-image:
        radial-gradient(ellipse 800px 350px at 15% 0%, rgba(197, 154, 103, .10), transparent 60%),
        radial-gradient(ellipse 700px 350px at 85% 100%, rgba(6, 198, 91, .06), transparent 60%);
    color: #ffffff;
    padding: 52px 0 48px;
    text-align: center;
    font-family: 'Montserrat', var(--font-sans);
    overflow: hidden;
}
.booking-section::before {
    content: "";
    position: absolute;
    inset: 0;
    background-image:
        repeating-linear-gradient(45deg, rgba(197,154,103,.04) 0 1px, transparent 1px 20px),
        repeating-linear-gradient(-45deg, rgba(197,154,103,.04) 0 1px, transparent 1px 20px);
    pointer-events: none;
    opacity: .5;
}
.booking-section .container {
    position: relative;
    z-index: 1;
    max-width: 1200px;
    margin: 0 auto;
    padding: 0 24px;
}

/* Titre — plus petit */
.booking-section h2 {
    font-size: 26px;
    font-weight: 800;
    letter-spacing: 1px;
    color: #ffffff;
    margin: 0 0 8px;
    text-transform: uppercase;
    line-height: 1.2;
}
.booking-section h2 .highlight {
    color: #C59A67;
    font-style: italic;
    font-weight: 700;
    font-family: 'Playfair Display', Georgia, 'Times New Roman', serif;
    letter-spacing: .3px;
}
.booking-section p.subtitle {
    display: inline-block;
    font-size: 13px;
    color: #B5C4CA;
    margin: 0 0 28px;
    font-weight: 400;
    letter-spacing: .3px;
    position: relative;
    padding-bottom: 12px;
}
.booking-section p.subtitle::after {
    content: "";
    position: absolute;
    bottom: 0;
    left: 50%;
    transform: translateX(-50%);
    width: 44px;
    height: 2px;
    background: linear-gradient(90deg, transparent, #C59A67, transparent);
}

/* Widget — largeur max 1100px, padding réduit */
.booking-section .booking-widget {
    background: #ffffff;
    border-radius: 12px;
    display: grid;
    grid-template-columns: repeat(4, 1fr) auto;
    align-items: stretch;
    padding: 6px;
    margin: 0 auto 30px;
    max-width: 1100px;
    box-shadow:
        0 16px 40px rgba(0, 0, 0, .25),
        0 4px 12px rgba(0, 0, 0, .10),
        inset 0 1px 0 rgba(255, 255, 255, .9);
    border: 1px solid rgba(197, 154, 103, .22);
    position: relative;
}
.booking-section .booking-widget::before {
    content: "";
    position: absolute;
    top: -1px;
    left: 32%;
    right: 32%;
    height: 2px;
    background: linear-gradient(90deg, transparent, #C59A67 50%, transparent);
    border-radius: 2px;
}

/* Champ — compact */
.booking-section .widget-field {
    display: flex;
    align-items: center;
    gap: 11px;
    padding: 10px 16px;
    min-height: 62px;
    text-align: left;
    color: #0D2834;
    position: relative;
    transition: background .25s ease;
    border-radius: 8px;
}
.booking-section .widget-field:hover {
    background: linear-gradient(180deg, #FBF8F2 0%, #FFFFFF 100%);
}
.booking-section .widget-field:not(:last-of-type)::after {
    content: "";
    position: absolute;
    right: 0;
    top: 22%;
    bottom: 22%;
    width: 1px;
    background: linear-gradient(180deg,
        transparent,
        rgba(197, 154, 103, .35) 30%,
        rgba(197, 154, 103, .35) 70%,
        transparent);
}

/* Icône compacte (40px au lieu de 52px) */
.booking-section .icon-field {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    width: 40px;
    height: 40px;
    border-radius: 9px;
    background: linear-gradient(145deg, #FBF6EE 0%, #F5EBD8 100%);
    color: #A47B3E;
    border: 1px solid rgba(197, 154, 103, .25);
    box-shadow:
        inset 0 1px 0 rgba(255, 255, 255, .9),
        0 2px 3px rgba(164, 123, 62, .08);
    flex-shrink: 0;
    transition: transform .25s ease, box-shadow .25s ease;
}
.booking-section .widget-field:hover .icon-field {
    transform: translateY(-1px);
    box-shadow:
        inset 0 1px 0 rgba(255, 255, 255, .9),
        0 4px 8px rgba(164, 123, 62, .18);
}
.booking-section .icon-field i,
.booking-section .icon-field svg {
    display: block;
    width: 16px;
    height: 16px;
    line-height: 1;
}

/* Texte champ compact */
.booking-section .field-info {
    flex: 1;
    min-width: 0;
    display: flex;
    flex-direction: column;
    gap: 3px;
}
.booking-section .widget-field label {
    display: block;
    font-size: 9px;
    font-weight: 700;
    color: #A47B3E;
    letter-spacing: 1.1px;
    text-transform: uppercase;
    margin: 0;
    line-height: 1;
    opacity: .9;
}
.booking-section .cta-date-input {
    border: none;
    background: transparent;
    outline: none;
    padding: 0;
    width: 100%;
    font-family: 'Playfair Display', Georgia, 'Times New Roman', serif;
    font-size: 15px;
    font-weight: 500;
    color: #062F3D;
    cursor: pointer;
    line-height: 1.2;
    letter-spacing: .1px;
}
.booking-section .cta-date-input::placeholder {
    color: #B5C4CA;
    font-family: 'Montserrat', sans-serif;
    font-weight: 500;
    font-size: 13px;
}
.booking-section .widget-field select {
    appearance: none;
    -webkit-appearance: none;
    -moz-appearance: none;
    border: none;
    background-color: transparent;
    background-image: url("data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' width='11' height='11' viewBox='0 0 24 24' fill='none' stroke='%23A47B3E' stroke-width='2.5' stroke-linecap='round' stroke-linejoin='round'><polyline points='6 9 12 15 18 9'/></svg>");
    background-repeat: no-repeat;
    background-position: right 0 center;
    padding-right: 18px;
    font-family: 'Playfair Display', Georgia, 'Times New Roman', serif;
    font-size: 15px;
    font-weight: 500;
    color: #062F3D;
    cursor: pointer;
    outline: none;
    width: 100%;
    line-height: 1.2;
    letter-spacing: .1px;
}
.booking-section .widget-field select option {
    background: #ffffff;
    color: #062F3D;
    font-family: 'Montserrat', sans-serif;
    font-size: 13px;
}

/* Bouton compact */
.booking-section .btn-submit {
    position: relative;
    background: linear-gradient(135deg, #C59A67 0%, #A47B3E 100%);
    color: #ffffff;
    border: none;
    padding: 0 26px;
    border-radius: 9px;
    font-family: 'Montserrat', sans-serif;
    font-weight: 800;
    font-size: 11px;
    letter-spacing: 1.3px;
    cursor: pointer;
    white-space: nowrap;
    text-transform: uppercase;
    box-shadow:
        0 6px 16px rgba(164, 123, 62, .32),
        inset 0 1px 0 rgba(255, 255, 255, .3);
    transition: transform .25s ease, box-shadow .25s ease;
    text-decoration: none;
    min-width: 170px;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
    overflow: hidden;
}
.booking-section .btn-submit::before {
    content: "";
    position: absolute;
    top: 0;
    left: -100%;
    width: 100%;
    height: 100%;
    background: linear-gradient(90deg, transparent, rgba(255, 255, 255, .25), transparent);
    transition: left .6s ease;
}
.booking-section .btn-submit:hover {
    transform: translateY(-2px);
    box-shadow:
        0 10px 24px rgba(164, 123, 62, .45),
        inset 0 1px 0 rgba(255, 255, 255, .4);
}
.booking-section .btn-submit:hover::before { left: 100%; }
.booking-section .btn-submit i,
.booking-section .btn-submit svg {
    display: block;
    width: 13px;
    height: 13px;
    transition: transform .25s ease;
}
.booking-section .btn-submit:hover i { transform: translateX(4px); }

/* Badges compacts */
.booking-section .booking-features {
    display: flex;
    justify-content: center;
    align-items: center;
    gap: 34px;
    flex-wrap: wrap;
}
.booking-section .feature-item {
    display: inline-flex;
    align-items: center;
    gap: 9px;
    font-size: 10px;
    font-weight: 700;
    letter-spacing: 1.3px;
    text-transform: uppercase;
    color: rgba(255, 255, 255, .88);
    transition: color .25s ease;
}
.booking-section .feature-item:hover { color: #ffffff; }
.booking-section .icon-circle {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    width: 26px;
    height: 26px;
    border-radius: 50%;
    border: 1px solid rgba(56, 226, 143, .5);
    background: rgba(56, 226, 143, .07);
    color: #38E28F;
    font-size: 11px;
    flex-shrink: 0;
    transition: border-color .25s ease, background .25s ease, transform .25s ease;
}
.booking-section .feature-item:hover .icon-circle {
    border-color: rgba(56, 226, 143, .9);
    background: rgba(56, 226, 143, .15);
    transform: scale(1.08);
}
.booking-section .icon-circle i,
.booking-section .icon-circle svg {
    display: block;
    width: 11px;
    height: 11px;
    line-height: 1;
}

/* ---------- RESPONSIVE ---------- */
@media (max-width: 1100px) {
    .booking-section h2 { font-size: 22px; }
    .booking-section .booking-widget { max-width: 100%; }
    .booking-section .btn-submit { min-width: 150px; padding: 0 22px; }
    .booking-section .booking-features { gap: 24px; }
}
@media (max-width: 992px) {
    .booking-section { padding: 42px 0 38px; }
    .booking-section h2 { font-size: 20px; letter-spacing: .8px; }
    .booking-section p.subtitle { font-size: 12px; margin-bottom: 22px; }
    .booking-section .booking-widget {
        grid-template-columns: 1fr;
        gap: 4px;
        padding: 8px;
        border-radius: 10px;
    }
    .booking-section .widget-field {
        padding: 12px 14px;
        min-height: auto;
    }
    .booking-section .widget-field:not(:last-of-type)::after {
        top: auto;
        bottom: 0;
        left: 14px;
        right: 14px;
        width: auto;
        height: 1px;
        background: linear-gradient(90deg, transparent, rgba(197, 154, 103, .3), transparent);
    }
    .booking-section .btn-submit {
        width: 100%;
        padding: 14px 20px;
        margin-top: 3px;
        min-width: 0;
    }
    .booking-section .booking-features {
        gap: 16px;
        flex-direction: column;
    }
}
@media (max-width: 576px) {
    .booking-section { padding: 36px 0 34px; }
    .booking-section h2 { font-size: 17px; }
    .booking-section h2 .highlight { display: block; margin-top: 2px; }
    .booking-section p.subtitle { font-size: 11px; margin-bottom: 18px; }
    .booking-section .icon-field { width: 36px; height: 36px; }
    .booking-section .cta-date-input,
    .booking-section .widget-field select { font-size: 14px; }
}
CSS_EOF

echo "✅ CTA COMPACT appliqué"
echo "💾 Sauvegarde : $BACKUP"
echo ""
echo "📌 Ctrl + F5 dans le navigateur"
