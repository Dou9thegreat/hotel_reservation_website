#!/bin/bash
set -e

echo "==================================================="
echo "  Refonte CTA — Design Teranga Luxe"
echo "==================================================="

BACKUP=".backup_LUXE_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP"
cp css/footer-cta.css "$BACKUP/" 2>/dev/null || true
echo "📦 Sauvegarde → $BACKUP"

# ============================================================
# 1) Supprimer TOUS les anciens blocs CTA
# ============================================================
python3 << 'PYEOF'
import re
with open('css/footer-cta.css', 'r', encoding='utf-8') as f:
    content = f.read()

# Supprimer le bloc CTA v1 (bandeau réservation)
content = re.sub(
    r'/\* -+ CTA \(bandeau réservation\) -+ \*/.*?(?=/\* =+ \*/\n/\* FOOTER)',
    '',
    content,
    flags=re.DOTALL
)

# Supprimer le bloc CTA v2 (raffiné)
content = re.sub(
    r'/\* =+ \*/\n/\* CTA — BANDEAU RÉSERVATION \(v2 raffiné\) \*/.*?(?=/\* =+ \*/\n/\* FOOTER)',
    '',
    content,
    flags=re.DOTALL
)

# Nettoyer les media queries résiduelles du CTA
content = re.sub(
    r'@media \(max-width: 992px\) \{\s*\.booking-section[^}]*\}.*?(?=@media|$)',
    '',
    content,
    flags=re.DOTALL
)
content = re.sub(
    r'@media \(max-width: 576px\) \{\s*\.booking-section[^}]*\}',
    '',
    content,
    flags=re.DOTALL
)

with open('css/footer-cta.css', 'w', encoding='utf-8') as f:
    f.write(content)
print("🧹 Anciens blocs CTA supprimés")
PYEOF

# ============================================================
# 2) Ajouter le NOUVEAU design "Teranga Luxe"
# ============================================================
cat >> css/footer-cta.css << 'CSS_EOF'

/* ============================================================= */
/* CTA — BANDEAU RÉSERVATION · Design Teranga Luxe               */
/* Palette : Or/sable signature + Vert Pullman + Bleu profond    */
/* ============================================================= */

/* ---------- SECTION ---------- */
.booking-section {
    position: relative;
    background: #062F3D;
    background-image:
        radial-gradient(ellipse 900px 400px at 15% 0%, rgba(197, 154, 103, .10), transparent 60%),
        radial-gradient(ellipse 700px 400px at 85% 100%, rgba(6, 198, 91, .06), transparent 60%);
    color: #ffffff;
    padding: 64px 0 58px;
    text-align: center;
    font-family: 'Montserrat', var(--font-sans);
    overflow: hidden;
}

/* Motif losange discret (identité Pullman) */
.booking-section::before {
    content: "";
    position: absolute;
    inset: 0;
    background-image:
        repeating-linear-gradient(
            45deg,
            rgba(197, 154, 103, .04) 0 1px,
            transparent 1px 22px
        ),
        repeating-linear-gradient(
            -45deg,
            rgba(197, 154, 103, .04) 0 1px,
            transparent 1px 22px
        );
    pointer-events: none;
    opacity: .6;
}

.booking-section .container {
    position: relative;
    z-index: 1;
    max-width: 1180px;
    margin: 0 auto;
    padding: 0 24px;
}

/* ---------- TITRE ---------- */
.booking-section h2 {
    font-family: 'Montserrat', sans-serif;
    font-size: 34px;
    font-weight: 800;
    letter-spacing: 1.2px;
    color: #ffffff;
    margin: 0 0 14px;
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
    font-size: 13.5px;
    color: #B5C4CA;
    margin: 0 0 42px;
    font-weight: 400;
    letter-spacing: .3px;
    position: relative;
    padding-bottom: 14px;
}
.booking-section p.subtitle::after {
    content: "";
    position: absolute;
    bottom: 0;
    left: 50%;
    transform: translateX(-50%);
    width: 52px;
    height: 2px;
    background: linear-gradient(90deg, transparent, #C59A67, transparent);
}

/* ---------- WIDGET PRINCIPAL ---------- */
.booking-section .booking-widget {
    background: #ffffff;
    border-radius: 18px;
    display: grid;
    grid-template-columns: repeat(4, 1fr) auto;
    align-items: stretch;
    padding: 8px;
    margin: 0 0 40px;
    box-shadow:
        0 24px 60px rgba(0, 0, 0, .28),
        0 4px 12px rgba(0, 0, 0, .12),
        inset 0 1px 0 rgba(255, 255, 255, .9);
    border: 1px solid rgba(197, 154, 103, .22);
    position: relative;
}
/* Petit liseré or en haut du widget */
.booking-section .booking-widget::before {
    content: "";
    position: absolute;
    top: -1px;
    left: 30%;
    right: 30%;
    height: 2px;
    background: linear-gradient(90deg, transparent, #C59A67 50%, transparent);
    border-radius: 2px;
}

/* ---------- CHAMP ---------- */
.booking-section .widget-field {
    display: flex;
    align-items: center;
    gap: 14px;
    padding: 14px 22px;
    text-align: left;
    color: #0D2834;
    position: relative;
    transition: background .25s ease;
    border-radius: 12px;
}
.booking-section .widget-field:hover {
    background: linear-gradient(180deg, #FBF8F2 0%, #FFFFFF 100%);
}
/* Séparateur vertical en dégradé or */
.booking-section .widget-field:not(:last-of-type)::after {
    content: "";
    position: absolute;
    right: 0;
    top: 20%;
    bottom: 20%;
    width: 1px;
    background: linear-gradient(180deg,
        transparent,
        rgba(197, 154, 103, .35) 30%,
        rgba(197, 154, 103, .35) 70%,
        transparent);
}

/* ---------- ICÔNE — carré arrondi (pas cercle) ---------- */
.booking-section .icon-field {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    width: 44px;
    height: 44px;
    border-radius: 12px;
    background: linear-gradient(145deg, #FBF6EE 0%, #F5EBD8 100%);
    color: #A47B3E;
    border: 1px solid rgba(197, 154, 103, .25);
    box-shadow:
        inset 0 1px 0 rgba(255, 255, 255, .9),
        0 2px 4px rgba(164, 123, 62, .08);
    flex-shrink: 0;
    transition: transform .25s ease, box-shadow .25s ease;
}
.booking-section .widget-field:hover .icon-field {
    transform: translateY(-1px);
    box-shadow:
        inset 0 1px 0 rgba(255, 255, 255, .9),
        0 4px 10px rgba(164, 123, 62, .18);
}
.booking-section .icon-field i,
.booking-section .icon-field svg {
    display: block;
    width: 18px;
    height: 18px;
    line-height: 1;
}

/* ---------- CONTENU DU CHAMP ---------- */
.booking-section .field-info {
    flex: 1;
    min-width: 0;
    display: flex;
    flex-direction: column;
    gap: 5px;
}

.booking-section .widget-field label {
    display: block;
    font-size: 10px;
    font-weight: 700;
    color: #A47B3E;
    letter-spacing: 1.2px;
    text-transform: uppercase;
    margin: 0;
    line-height: 1;
    opacity: .85;
}

.booking-section .cta-date-input {
    border: none;
    background: transparent;
    outline: none;
    padding: 0;
    width: 100%;
    font-family: 'Playfair Display', Georgia, 'Times New Roman', serif;
    font-size: 16px;
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
    font-size: 14px;
}

.booking-section .widget-field select {
    appearance: none;
    -webkit-appearance: none;
    -moz-appearance: none;
    border: none;
    background-color: transparent;
    background-image: url("data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 24 24' fill='none' stroke='%23A47B3E' stroke-width='2.5' stroke-linecap='round' stroke-linejoin='round'><polyline points='6 9 12 15 18 9'/></svg>");
    background-repeat: no-repeat;
    background-position: right 0 center;
    padding-right: 22px;
    font-family: 'Playfair Display', Georgia, 'Times New Roman', serif;
    font-size: 16px;
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

/* ---------- BOUTON OR SIGNATURE ---------- */
.booking-section .btn-submit {
    position: relative;
    background: linear-gradient(135deg, #C59A67 0%, #A47B3E 100%);
    color: #ffffff;
    border: none;
    padding: 0 34px;
    border-radius: 12px;
    font-family: 'Montserrat', sans-serif;
    font-weight: 800;
    font-size: 12px;
    letter-spacing: 1.5px;
    cursor: pointer;
    white-space: nowrap;
    text-transform: uppercase;
    box-shadow:
        0 10px 24px rgba(164, 123, 62, .35),
        inset 0 1px 0 rgba(255, 255, 255, .3);
    transition: transform .25s ease, box-shadow .25s ease;
    text-decoration: none;
    min-width: 210px;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 10px;
    overflow: hidden;
}
/* Effet de brillance */
.booking-section .btn-submit::before {
    content: "";
    position: absolute;
    top: 0;
    left: -100%;
    width: 100%;
    height: 100%;
    background: linear-gradient(90deg,
        transparent,
        rgba(255, 255, 255, .25),
        transparent);
    transition: left .6s ease;
}
.booking-section .btn-submit:hover {
    transform: translateY(-2px);
    box-shadow:
        0 14px 32px rgba(164, 123, 62, .48),
        inset 0 1px 0 rgba(255, 255, 255, .4);
}
.booking-section .btn-submit:hover::before {
    left: 100%;
}
.booking-section .btn-submit i,
.booking-section .btn-submit svg {
    display: block;
    width: 14px;
    height: 14px;
    transition: transform .25s ease;
}
.booking-section .btn-submit:hover i {
    transform: translateX(4px);
}

/* ---------- BADGES DE RÉASSURANCE ---------- */
.booking-section .booking-features {
    display: flex;
    justify-content: center;
    align-items: center;
    gap: 56px;
    flex-wrap: wrap;
}

.booking-section .feature-item {
    display: inline-flex;
    align-items: center;
    gap: 14px;
    font-size: 11px;
    font-weight: 700;
    letter-spacing: 1.5px;
    text-transform: uppercase;
    color: rgba(255, 255, 255, .88);
    position: relative;
    transition: color .25s ease;
}
.booking-section .feature-item:hover {
    color: #ffffff;
}
/* Tiret or avant chaque badge */
.booking-section .feature-item::before {
    content: "";
    width: 22px;
    height: 1px;
    background: #C59A67;
    opacity: .7;
    flex-shrink: 0;
    transition: width .25s ease, opacity .25s ease;
}
.booking-section .feature-item:hover::before {
    width: 32px;
    opacity: 1;
}

/* Icône circulaire verte — discret, fin */
.booking-section .icon-circle {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    width: 32px;
    height: 32px;
    border-radius: 50%;
    border: 1px solid rgba(56, 226, 143, .45);
    background: rgba(56, 226, 143, .06);
    color: #38E28F;
    font-size: 12px;
    flex-shrink: 0;
    transition: border-color .25s ease, background .25s ease, transform .25s ease;
}
.booking-section .feature-item:hover .icon-circle {
    border-color: rgba(56, 226, 143, .8);
    background: rgba(56, 226, 143, .12);
    transform: scale(1.06);
}
.booking-section .icon-circle i,
.booking-section .icon-circle svg {
    display: block;
    width: 13px;
    height: 13px;
    line-height: 1;
}

/* ---------- RESPONSIVE ---------- */
@media (max-width: 1100px) {
    .booking-section h2 { font-size: 28px; }
    .booking-section .btn-submit { min-width: 180px; padding: 0 26px; }
    .booking-section .booking-features { gap: 40px; }
}

@media (max-width: 992px) {
    .booking-section { padding: 52px 0 48px; }
    .booking-section h2 { font-size: 24px; letter-spacing: 1px; }
    .booking-section p.subtitle { margin-bottom: 34px; }

    .booking-section .booking-widget {
        grid-template-columns: 1fr;
        gap: 4px;
        padding: 10px;
        border-radius: 16px;
    }
    .booking-section .widget-field {
        padding: 14px 18px;
    }
    .booking-section .widget-field:not(:last-of-type)::after {
        top: auto;
        bottom: 0;
        left: 18px;
        right: 18px;
        width: auto;
        height: 1px;
        background: linear-gradient(90deg,
            transparent,
            rgba(197, 154, 103, .3),
            transparent);
    }
    .booking-section .btn-submit {
        width: 100%;
        padding: 18px 24px;
        margin-top: 4px;
        min-width: 0;
    }
    .booking-section .booking-features {
        gap: 22px;
        flex-direction: column;
    }
    .booking-section .feature-item::before {
        width: 16px;
    }
}

@media (max-width: 576px) {
    .booking-section { padding: 42px 0 40px; }
    .booking-section h2 { font-size: 20px; }
    .booking-section h2 .highlight { display: block; margin-top: 4px; }
    .booking-section p.subtitle { font-size: 12px; margin-bottom: 28px; }
    .booking-section .icon-field { width: 40px; height: 40px; }
    .booking-section .cta-date-input,
    .booking-section .widget-field select { font-size: 15px; }
}
CSS_EOF

echo "🎨 Design Teranga Luxe ajouté"

# ============================================================
# 3) Ajouter l'icône flèche au bouton (HTML) sur toutes les pages
# ============================================================
PAGES="index.html chambres.html contact.html galerie.html evenements.html experiences.html experiences-piscine.html experiences-restaurant.html reservation.html"

for f in $PAGES; do
    [ ! -f "$f" ] && continue
    # Ajouter la flèche dans le bouton (si pas déjà présente)
    perl -0777 -i -pe '
        s|<button type="submit" class="btn-submit">Réserver maintenant</button>|<button type="submit" class="btn-submit">Réserver maintenant <i class="fa-solid fa-arrow-right"></i></button>|g;
    ' "$f"
    echo "  ✅ $f"
done

echo ""
echo "==================================================="
echo "✅ TERMINÉ — Design Teranga Luxe appliqué"
echo "💾 Sauvegarde : $BACKUP"
echo ""
echo "📌 PROCHAINE ÉTAPE : Ctrl+F5 dans le navigateur"
echo "==================================================="
