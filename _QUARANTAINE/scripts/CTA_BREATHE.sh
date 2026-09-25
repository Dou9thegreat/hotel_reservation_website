#!/bin/bash
set -e

BACKUP=".backup_BREATHE_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP"
cp css/footer-cta.css "$BACKUP/"
echo "📦 Sauvegarde → $BACKUP"

# Supprimer l'ancien bloc CTA Teranga Luxe
python3 << 'PYEOF'
import re
with open('css/footer-cta.css', 'r', encoding='utf-8') as f:
    c = f.read()
c = re.sub(
    r'/\* =+ \*/\n/\* CTA — BANDEAU RÉSERVATION · Design Teranga Luxe \*/.*$',
    '',
    c,
    flags=re.DOTALL
)
with open('css/footer-cta.css', 'w', encoding='utf-8') as f:
    f.write(c)
print("🧹 Ancien bloc retiré")
PYEOF

# Ajouter la version "Breathe" — plus aérée
cat >> css/footer-cta.css << 'CSS_EOF'

/* ============================================================= */
/* CTA — BANDEAU RÉSERVATION · Teranga Luxe (Breathe)            */
/* ============================================================= */

.booking-section {
    position: relative;
    background: #062F3D;
    background-image:
        radial-gradient(ellipse 1000px 500px at 12% 0%, rgba(197, 154, 103, .12), transparent 65%),
        radial-gradient(ellipse 900px 500px at 88% 100%, rgba(6, 198, 91, .07), transparent 65%);
    color: #ffffff;
    padding: 90px 0 84px;
    text-align: center;
    font-family: 'Montserrat', var(--font-sans);
    overflow: hidden;
}
.booking-section::before {
    content: "";
    position: absolute;
    inset: 0;
    background-image:
        repeating-linear-gradient(45deg, rgba(197,154,103,.045) 0 1px, transparent 1px 24px),
        repeating-linear-gradient(-45deg, rgba(197,154,103,.045) 0 1px, transparent 1px 24px);
    pointer-events: none;
    opacity: .55;
}
.booking-section .container {
    position: relative;
    z-index: 1;
    max-width: 1280px;
    margin: 0 auto;
    padding: 0 28px;
}

/* Titre plus grand */
.booking-section h2 {
    font-size: 42px;
    font-weight: 800;
    letter-spacing: 1.4px;
    color: #ffffff;
    margin: 0 0 18px;
    text-transform: uppercase;
    line-height: 1.15;
}
.booking-section h2 .highlight {
    color: #C59A67;
    font-style: italic;
    font-weight: 700;
    font-family: 'Playfair Display', Georgia, 'Times New Roman', serif;
    letter-spacing: .5px;
}
.booking-section p.subtitle {
    display: inline-block;
    font-size: 15px;
    color: #B5C4CA;
    margin: 0 0 54px;
    font-weight: 400;
    letter-spacing: .4px;
    position: relative;
    padding-bottom: 18px;
}
.booking-section p.subtitle::after {
    content: "";
    position: absolute;
    bottom: 0;
    left: 50%;
    transform: translateX(-50%);
    width: 64px;
    height: 2px;
    background: linear-gradient(90deg, transparent, #C59A67, transparent);
}

/* Widget plus large + champs plus hauts */
.booking-section .booking-widget {
    background: #ffffff;
    border-radius: 20px;
    display: grid;
    grid-template-columns: repeat(4, 1fr) auto;
    align-items: stretch;
    padding: 10px;
    margin: 0 auto 52px;
    max-width: 1280px;
    box-shadow:
        0 28px 70px rgba(0, 0, 0, .30),
        0 6px 18px rgba(0, 0, 0, .14),
        inset 0 1px 0 rgba(255, 255, 255, .9);
    border: 1px solid rgba(197, 154, 103, .25);
    position: relative;
}
.booking-section .booking-widget::before {
    content: "";
    position: absolute;
    top: -1px;
    left: 28%;
    right: 28%;
    height: 2px;
    background: linear-gradient(90deg, transparent, #C59A67 50%, transparent);
    border-radius: 2px;
}

/* Champ — plus haut, plus d'air */
.booking-section .widget-field {
    display: flex;
    align-items: center;
    gap: 18px;
    padding: 20px 26px;
    min-height: 90px;
    text-align: left;
    color: #0D2834;
    position: relative;
    transition: background .25s ease;
    border-radius: 14px;
}
.booking-section .widget-field:hover {
    background: linear-gradient(180deg, #FBF8F2 0%, #FFFFFF 100%);
}
.booking-section .widget-field:not(:last-of-type)::after {
    content: "";
    position: absolute;
    right: 0;
    top: 18%;
    bottom: 18%;
    width: 1px;
    background: linear-gradient(180deg,
        transparent,
        rgba(197, 154, 103, .38) 30%,
        rgba(197, 154, 103, .38) 70%,
        transparent);
}

/* Icône plus grande */
.booking-section .icon-field {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    width: 52px;
    height: 52px;
    border-radius: 14px;
    background: linear-gradient(145deg, #FBF6EE 0%, #F5EBD8 100%);
    color: #A47B3E;
    border: 1px solid rgba(197, 154, 103, .28);
    box-shadow:
        inset 0 1px 0 rgba(255, 255, 255, .9),
        0 3px 6px rgba(164, 123, 62, .10);
    flex-shrink: 0;
    transition: transform .25s ease, box-shadow .25s ease;
}
.booking-section .widget-field:hover .icon-field {
    transform: translateY(-2px);
    box-shadow:
        inset 0 1px 0 rgba(255, 255, 255, .9),
        0 6px 14px rgba(164, 123, 62, .22);
}
.booking-section .icon-field i,
.booking-section .icon-field svg {
    display: block;
    width: 22px;
    height: 22px;
    line-height: 1;
}

/* Texte champ — plus aéré */
.booking-section .field-info {
    flex: 1;
    min-width: 0;
    display: flex;
    flex-direction: column;
    gap: 7px;
}
.booking-section .widget-field label {
    display: block;
    font-size: 10.5px;
    font-weight: 700;
    color: #A47B3E;
    letter-spacing: 1.4px;
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
    font-size: 18px;
    font-weight: 500;
    color: #062F3D;
    cursor: pointer;
    line-height: 1.2;
    letter-spacing: .2px;
}
.booking-section .cta-date-input::placeholder {
    color: #B5C4CA;
    font-family: 'Montserrat', sans-serif;
    font-weight: 500;
    font-size: 15px;
}
.booking-section .widget-field select {
    appearance: none;
    -webkit-appearance: none;
    -moz-appearance: none;
    border: none;
    background-color: transparent;
    background-image: url("data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' width='14' height='14' viewBox='0 0 24 24' fill='none' stroke='%23A47B3E' stroke-width='2.5' stroke-linecap='round' stroke-linejoin='round'><polyline points='6 9 12 15 18 9'/></svg>");
    background-repeat: no-repeat;
    background-position: right 0 center;
    padding-right: 24px;
    font-family: 'Playfair Display', Georgia, 'Times New Roman', serif;
    font-size: 18px;
    font-weight: 500;
    color: #062F3D;
    cursor: pointer;
    outline: none;
    width: 100%;
    line-height: 1.2;
    letter-spacing: .2px;
}
.booking-section .widget-field select option {
    background: #ffffff;
    color: #062F3D;
    font-family: 'Montserrat', sans-serif;
    font-size: 14px;
}

/* Bouton plus imposant */
.booking-section .btn-submit {
    position: relative;
    background: linear-gradient(135deg, #C59A67 0%, #A47B3E 100%);
    color: #ffffff;
    border: none;
    padding: 0 44px;
    border-radius: 14px;
    font-family: 'Montserrat', sans-serif;
    font-weight: 800;
    font-size: 13px;
    letter-spacing: 1.6px;
    cursor: pointer;
    white-space: nowrap;
    text-transform: uppercase;
    box-shadow:
        0 12px 28px rgba(164, 123, 62, .38),
        inset 0 1px 0 rgba(255, 255, 255, .3);
    transition: transform .25s ease, box-shadow .25s ease;
    text-decoration: none;
    min-width: 240px;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 12px;
    overflow: hidden;
}
.booking-section .btn-submit::before {
    content: "";
    position: absolute;
    top: 0;
    left: -100%;
    width: 100%;
    height: 100%;
    background: linear-gradient(90deg, transparent, rgba(255, 255, 255, .28), transparent);
    transition: left .7s ease;
}
.booking-section .btn-submit:hover {
    transform: translateY(-3px);
    box-shadow:
        0 16px 36px rgba(164, 123, 62, .5),
        inset 0 1px 0 rgba(255, 255, 255, .4);
}
.booking-section .btn-submit:hover::before { left: 100%; }
.booking-section .btn-submit i,
.booking-section .btn-submit svg {
    display: block;
    width: 16px;
    height: 16px;
    transition: transform .25s ease;
}
.booking-section .btn-submit:hover i { transform: translateX(5px); }

/* Badges — plus espacés, plus aérés */
.booking-section .booking-features {
    display: flex;
    justify-content: center;
    align-items: center;
    gap: 72px;
    flex-wrap: wrap;
}
.booking-section .feature-item {
    display: inline-flex;
    align-items: center;
    gap: 14px;
    font-size: 11.5px;
    font-weight: 700;
    letter-spacing: 1.6px;
    text-transform: uppercase;
    color: rgba(255, 255, 255, .9);
    transition: color .25s ease;
}
.booking-section .feature-item:hover { color: #ffffff; }

.booking-section .icon-circle {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    width: 36px;
    height: 36px;
    border-radius: 50%;
    border: 1px solid rgba(56, 226, 143, .5);
    background: rgba(56, 226, 143, .07);
    color: #38E28F;
    font-size: 13px;
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
    width: 14px;
    height: 14px;
    line-height: 1;
}

/* ---------- RESPONSIVE ---------- */
@media (max-width: 1200px) {
    .booking-section h2 { font-size: 34px; }
    .booking-section .btn-submit { min-width: 200px; padding: 0 30px; }
    .booking-section .booking-features { gap: 48px; }
}
@media (max-width: 992px) {
    .booking-section { padding: 70px 0 62px; }
    .booking-section h2 { font-size: 28px; letter-spacing: 1px; }
    .booking-section p.subtitle { font-size: 14px; margin-bottom: 40px; }

    .booking-section .booking-widget {
        grid-template-columns: 1fr;
        gap: 6px;
        padding: 12px;
        border-radius: 18px;
    }
    .booking-section .widget-field {
        padding: 18px 20px;
        min-height: auto;
    }
    .booking-section .widget-field:not(:last-of-type)::after {
        top: auto;
        bottom: 0;
        left: 20px;
        right: 20px;
        width: auto;
        height: 1px;
        background: linear-gradient(90deg, transparent, rgba(197, 154, 103, .32), transparent);
    }
    .booking-section .btn-submit {
        width: 100%;
        padding: 22px 24px;
        margin-top: 6px;
        min-width: 0;
    }
    .booking-section .booking-features {
        gap: 26px;
        flex-direction: column;
    }
}
@media (max-width: 576px) {
    .booking-section { padding: 56px 0 52px; }
    .booking-section h2 { font-size: 22px; }
    .booking-section p.subtitle { font-size: 12.5px; margin-bottom: 32px; }
    .booking-section .icon-field { width: 46px; height: 46px; }
    .booking-section .cta-date-input,
    .booking-section .widget-field select { font-size: 16px; }
}
CSS_EOF

echo "✅ CTA 'Breathe' appliqué"
echo "💾 Sauvegarde : $BACKUP"
echo ""
echo "📌 Ctrl + F5 dans le navigateur"
