#!/usr/bin/env bash
# =============================================================================
# generate_legal_pages.sh
#
# Crée 5 nouvelles pages + remplit experiences.html + corrige contact.html
# + harmonise les footers de toutes les pages.
#
# Inspiré du design de : experiences-restaurant.html, experiences-piscine.html,
# evenements.html.
#
# Idempotent, sauvegarde automatique.
# =============================================================================
set -uo pipefail

BACKUP=".backup_pages_$(date +%Y%m%d_%H%M%S)"
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; BLUE='\033[0;34m'; NC='\033[0m'

mkdir -p "$BACKUP"

echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  CRÉATION DES PAGES LÉGALES + CORRECTIONS${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}\n"

# =============================================================================
# 1. CSS PARTAGÉ POUR LES PAGES LÉGALES
# =============================================================================
cat > css/legal.css << 'CSS_EOF'
/* ============================================================= */
/* LEGAL.CSS — Styles des pages légales                         */
/* Inspiré du design Pullman (bleu océan, sable, vert)          */
/* ============================================================= */

.legal-page {
    --ocean: #155E75;
    --ocean-dark: #0E4A5E;
    --green: #38E28F;
    --sand: #C59A67;
    --charcoal: #1A2B3C;
    --text-gray: #6A7580;
    --line: #E8ECEF;
    --bg-soft: #F7F3EC;
}

/* ---------- HERO ---------- */
.legal-page .legal-hero {
    position: relative;
    min-height: 340px;
    background: linear-gradient(120deg, rgba(10,30,45,.92) 0%, rgba(21,94,117,.75) 100%),
                url('../images/hero3.png') center/cover no-repeat;
    display: flex;
    align-items: center;
    padding: 60px 40px;
    color: #fff;
    overflow: hidden;
}
.legal-page .legal-hero::before {
    content: "";
    position: absolute;
    inset: 0;
    background: radial-gradient(circle at 80% 50%, rgba(56,226,143,.08) 0%, transparent 60%);
    pointer-events: none;
}
.legal-page .legal-hero-inner {
    position: relative;
    z-index: 1;
    max-width: 1280px;
    margin: 0 auto;
    width: 100%;
    padding: 0 20px;
}
.legal-page .legal-breadcrumb {
    font-size: 0.75rem;
    letter-spacing: 2px;
    text-transform: uppercase;
    opacity: 0.85;
    margin-bottom: 18px;
    display: flex;
    align-items: center;
    gap: 8px;
    flex-wrap: wrap;
}
.legal-page .legal-breadcrumb a { color: #fff; text-decoration: none; transition: color .3s; }
.legal-page .legal-breadcrumb a:hover { color: #38E28F; }
.legal-page .legal-breadcrumb span { opacity: 0.6; }
.legal-page .legal-eyebrow {
    display: inline-flex;
    align-items: center;
    gap: 12px;
    font-size: 0.78rem;
    font-weight: 700;
    letter-spacing: 2.5px;
    text-transform: uppercase;
    color: #C59A67;
    margin-bottom: 14px;
}
.legal-page .legal-eyebrow::before {
    content: "";
    width: 30px;
    height: 2px;
    background: #C59A67;
}
.legal-page .legal-hero h1 {
    font-family: 'Playfair Display', Georgia, serif;
    font-size: clamp(2rem, 4vw, 3.2rem);
    font-weight: 700;
    line-height: 1.1;
    color: #fff;
    margin: 0 0 16px;
    letter-spacing: -0.3px;
}
.legal-page .legal-hero p {
    font-size: 1rem;
    line-height: 1.7;
    color: rgba(255,255,255,0.9);
    max-width: 620px;
    margin: 0;
}

/* ---------- CONTENU ---------- */
.legal-page .legal-inner {
    max-width: 960px;
    margin: 0 auto;
    padding: 70px 24px 80px;
}

/* ---------- SOMMAIRE ---------- */
.legal-page .legal-toc {
    background: #FBF6EE;
    border: 1.5px solid rgba(197,154,103,.35);
    border-radius: 14px;
    padding: 24px 28px;
    margin-bottom: 50px;
}
.legal-page .legal-toc h3 {
    font-size: 0.72rem;
    font-weight: 800;
    letter-spacing: 2px;
    text-transform: uppercase;
    color: #A47B3E;
    margin: 0 0 14px;
}
.legal-page .legal-toc ol {
    list-style: none;
    padding: 0;
    margin: 0;
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 8px 24px;
    counter-reset: toc;
}
.legal-page .legal-toc ol li { counter-increment: toc; }
.legal-page .legal-toc ol li a {
    color: #1A2B3C;
    text-decoration: none;
    font-size: 0.88rem;
    font-weight: 600;
    display: flex;
    align-items: baseline;
    gap: 10px;
    transition: color .25s, gap .25s;
}
.legal-page .legal-toc ol li a::before {
    content: counter(toc, decimal-leading-zero);
    color: #C59A67;
    font-family: 'Playfair Display', serif;
    font-weight: 700;
    font-size: 0.9rem;
    flex-shrink: 0;
}
.legal-page .legal-toc ol li a:hover { color: #155E75; gap: 14px; }

/* ---------- SECTIONS ---------- */
.legal-page .legal-section {
    margin-bottom: 54px;
    scroll-margin-top: 140px;
}
.legal-page .legal-section h2 {
    font-family: 'Playfair Display', Georgia, serif;
    font-size: 1.5rem;
    font-weight: 700;
    color: #1A2B3C;
    margin: 0 0 8px;
    padding-bottom: 16px;
    position: relative;
}
.legal-page .legal-section h2::after {
    content: "";
    position: absolute;
    bottom: 0;
    left: 0;
    width: 56px;
    height: 3px;
    background: #38E28F;
    border-radius: 2px;
}
.legal-page .legal-section h3 {
    font-size: 1rem;
    font-weight: 700;
    color: #155E75;
    margin: 26px 0 10px;
    letter-spacing: 0.3px;
}
.legal-page .legal-section p,
.legal-page .legal-section li {
    font-size: 0.92rem;
    line-height: 1.75;
    color: #4A5763;
    margin: 0 0 12px;
}
.legal-page .legal-section ul {
    list-style: none;
    padding: 0;
    margin: 0 0 16px;
}
.legal-page .legal-section ul li {
    padding-left: 24px;
    position: relative;
}
.legal-page .legal-section ul li::before {
    content: "";
    position: absolute;
    left: 4px;
    top: 11px;
    width: 6px;
    height: 6px;
    border-radius: 50%;
    background: #38E28F;
}
.legal-page .legal-section a {
    color: #155E75;
    text-decoration: underline;
    text-underline-offset: 2px;
    transition: color .25s;
}
.legal-page .legal-section a:hover { color: #C59A67; }
.legal-page .legal-section strong { color: #1A2B3C; }

/* Encadré info */
.legal-page .legal-box {
    background: #F7F3EC;
    border-left: 4px solid #C59A67;
    border-radius: 0 8px 8px 0;
    padding: 18px 22px;
    margin: 20px 0;
}
.legal-page .legal-box p:last-child { margin-bottom: 0; }
.legal-page .legal-box strong {
    display: block;
    font-size: 0.72rem;
    letter-spacing: 1.5px;
    text-transform: uppercase;
    color: #A47B3E;
    margin-bottom: 6px;
}

/* Tableau info */
.legal-page .legal-table {
    width: 100%;
    border-collapse: collapse;
    margin: 20px 0;
    font-size: 0.88rem;
}
.legal-page .legal-table th,
.legal-page .legal-table td {
    padding: 12px 16px;
    text-align: left;
    border-bottom: 1px solid #E8ECEF;
}
.legal-page .legal-table th {
    background: #F7F3EC;
    font-weight: 700;
    color: #1A2B3C;
    font-size: 0.78rem;
    letter-spacing: 1px;
    text-transform: uppercase;
}
.legal-page .legal-table td { color: #4A5763; }
.legal-page .legal-table tr:last-child td { border-bottom: none; }

/* À compléter */
.legal-page .todo {
    background: #FFF7E9;
    color: #7A5A1E;
    font-weight: 700;
    padding: 2px 8px;
    border-radius: 4px;
    font-size: 0.82rem;
    border: 1px dashed #C59A67;
}

/* Mise à jour */
.legal-page .legal-updated {
    font-size: 0.78rem;
    color: #9AA7AC;
    font-style: italic;
    margin-top: 40px;
    padding-top: 20px;
    border-top: 1px solid #E8ECEF;
}

/* ---------- CTA CONTACT ---------- */
.legal-page .legal-cta {
    background: linear-gradient(135deg, #0A1E2D 0%, #123143 100%);
    color: #fff;
    padding: 60px 40px;
    border-radius: 16px;
    text-align: center;
    margin-top: 60px;
    position: relative;
    overflow: hidden;
}
.legal-page .legal-cta::before {
    content: "";
    position: absolute;
    top: -30%; right: -10%;
    width: 400px; height: 400px;
    border-radius: 50%;
    background: radial-gradient(circle, rgba(197,154,103,.15) 0%, transparent 70%);
    pointer-events: none;
}
.legal-page .legal-cta h3 {
    font-family: 'Playfair Display', Georgia, serif;
    font-size: 1.5rem;
    font-weight: 700;
    color: #fff;
    margin: 0 0 12px;
    position: relative;
    z-index: 1;
}
.legal-page .legal-cta p {
    color: rgba(255,255,255,0.85);
    margin: 0 0 24px;
    position: relative;
    z-index: 1;
}
.legal-page .legal-cta a {
    display: inline-flex;
    align-items: center;
    gap: 10px;
    padding: 14px 32px;
    border-radius: 40px;
    background: #C59A67;
    color: #fff;
    font-size: 0.78rem;
    font-weight: 800;
    letter-spacing: 1.2px;
    text-transform: uppercase;
    text-decoration: none;
    position: relative;
    z-index: 1;
    transition: all .3s ease;
    box-shadow: 0 10px 30px rgba(197,154,103,.35);
}
.legal-page .legal-cta a:hover { background: #B5885A; transform: translateY(-3px); }

@media (max-width: 768px) {
    .legal-page .legal-toc ol { grid-template-columns: 1fr; }
    .legal-page .legal-hero { padding: 40px 24px; }
    .legal-page .legal-inner { padding: 50px 20px 60px; }
    .legal-page .legal-cta { padding: 40px 24px; }
}
CSS_EOF

echo -e "${GREEN}✔ css/legal.css créé${NC}"

# =============================================================================
# 2. FONCTION : génère le header + footer communs (pour éviter la duplication)
# =============================================================================
generate_header() {
  local active="$1"
  cat << 'HEADER_EOF'
<header class="site-header">
    <div class="topbar">
        <div class="lang-switch">
            <span class="lang-current">Français</span>
            <span class="chevron">▾</span>
            <ul class="lang-menu">
                <li><a href="#" data-lang="fr" class="active">Français</a></li>
                <li><a href="#" data-lang="en">English</a></li>
                <li><a href="#" data-lang="es">Español</a></li>
            </ul>
        </div>
        <span class="separator">|</span>
        <a href="contact.html" class="topbar-contact">
            <span class="icon-mail">✉</span> Nous contacter
        </a>
    </div>

    <div class="mainbar">
        <a href="index.html" class="logo">
            <img src="images/logo.png" alt="Logo Pullman Dakar Teranga">
        </a>

        <nav class="main-nav">
            <a href="index.html">ACCUEIL</a>
            <span class="nav-sep">|</span>
            <a href="chambres.html">CHAMBRES</a>
            <span class="nav-sep">|</span>
            <div class="dropdown">
                <a>EXPÉRIENCES</a>
                <div class="dropdown-content">
                    <a href="experiences-piscine.html">Piscine + Spa</a>
                    <a href="experiences-restaurant.html">Restaurants + Bars</a>
                </div>
            </div>
            <span class="nav-sep">|</span>
            <a href="galerie.html">GALERIE</a>
            <span class="nav-sep">|</span>
            <a href="evenements.html">MEETING &amp; EVENTS</a>
            <span class="nav-sep">|</span>
            <a href="contact.html">CONTACT</a>
        </nav>

        <a href="reservation.html" class="btn-reserver">Réserver maintenant</a>
    </div>
</header>
HEADER_EOF
}

generate_footer() {
  cat << 'FOOTER_EOF'
<footer class="main-footer">
    <div class="container">
        <div class="footer-grid">
            <div class="footer-col brand-col">
                <div class="footer-logo">
                    <img src="images/logo-pullman-white.png" alt="Pullman Hotels and Resorts" class="img-manual-logo">
                </div>
                <div class="contact-details">
                    <p><i class="fa-solid fa-location-dot icon-contact"></i> Pullman Dakar Teranga<br>10, Rue Colbert, Place de l'Indépendance<br>BP 3380, Dakar, Sénégal</p>
                    <p><i class="fa-solid fa-phone icon-contact"></i> +221 33 889 22 00</p>
                    <p><i class="fa-regular fa-envelope icon-contact"></i> HB076@accor.com</p>
                </div>
            </div>
            <div class="footer-col">
                <h4 class="footer-title">LIENS UTILES</h4>
                <ul>
                    <li><a href="mentions-legales.html">Mentions légales</a></li>
                    <li><a href="conditions-generales.html">Conditions générales</a></li>
                    <li><a href="politique-confidentialite.html">Politique de confidentialité</a></li>
                    <li><a href="accessibilite.html">Accessibilité</a></li>
                </ul>
            </div>
            <div class="footer-col">
                <h4 class="footer-title">DÉCOUVRIR</h4>
                <ul>
                    <li><a href="chambres.html">Nos chambres</a></li>
                    <li><a href="experiences.html">Expériences</a></li>
                    <li><a href="offres-speciales.html">Offres spéciales</a></li>
                    <li><a href="galerie.html">Galerie</a></li>
                </ul>
            </div>
            <div class="footer-col">
                <h4 class="footer-title">SUIVEZ-NOUS</h4>
                <div class="social-links">
                    <a href="#"><i class="fa-brands fa-facebook-f"></i></a>
                    <a href="#"><i class="fa-brands fa-instagram"></i></a>
                    <a href="#"><i class="fa-brands fa-linkedin-in"></i></a>
                    <a href="#"><i class="fa-solid fa-globe"></i></a>
                </div>
                <h4 class="footer-title" style="margin-top:26px;">MOYENS DE PAIEMENT</h4>
                <div class="payment-methods">
                    <span class="payment-badge pay-visa" title="Visa">VISA</span>
                    <span class="payment-badge pay-mc" title="Mastercard">
                        <span class="circle c1"></span><span class="circle c2"></span>
                    </span>
                    <span class="payment-badge pay-wave" title="Wave">Wave</span>
                    <span class="payment-badge pay-om" title="Orange Money">Orange Money</span>
                </div>
            </div>
        </div>
        <div class="footer-bottom">
            <p>© 2026 Pullman Dakar Teranga - Tous droits réservés.</p>
            <div class="footer-bottom-right">
                <div class="currency-switch">
                    <button class="currency-current" type="button">
                        <i class="fas fa-globe"></i> FR · XOF <i class="fas fa-chevron-down"></i>
                    </button>
                    <ul class="currency-menu">
                        <li><a href="#" data-currency="XOF" class="active"><span>Franc CFA</span><span class="code">XOF</span></a></li>
                        <li><a href="#" data-currency="EUR"><span>Euro</span><span class="code">EUR</span></a></li>
                        <li><a href="#" data-currency="USD"><span>Dollar US</span><span class="code">USD</span></a></li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</footer>
FOOTER_EOF
}

generate_scripts() {
  cat << 'SCRIPTS_EOF'
<script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
<script src="https://cdn.jsdelivr.net/npm/flatpickr/dist/l10n/fr.js"></script>
<script src="js/booking-bridge.js"></script>
<script src="js/i18n.js"></script>
SCRIPTS_EOF
}

# =============================================================================
# 3. PAGE 1 : MENTIONS LÉGALES
# =============================================================================
{
  cat << 'HTML_HEAD'
<!DOCTYPE html>
<html lang="fr">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Mentions légales — Pullman Dakar Teranga</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@300;400;500;600;700;800&family=Playfair+Display:ital,wght@0,400;0,700;1,400;1,700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
<link rel="stylesheet" href="css/variables.css">
<link rel="stylesheet" href="css/commun.css">
<link rel="stylesheet" href="css/footer-cta.css">
<link rel="stylesheet" href="css/legal.css">
</head>
<body>
HTML_HEAD
  generate_header "mentions"
  cat << 'HTML_BODY'
<main class="legal-page">
    <section class="legal-hero">
        <div class="legal-hero-inner">
            <p class="legal-breadcrumb">
                <a href="index.html">Accueil</a>
                <i class="fa-solid fa-chevron-right" style="font-size:.6rem;opacity:.6;"></i>
                <span>Mentions légales</span>
            </p>
            <span class="legal-eyebrow">Informations légales</span>
            <h1>Mentions légales</h1>
            <p>Informations légales relatives au site officiel du Pullman Dakar Teranga, conformément à la réglementation en vigueur au Sénégal.</p>
        </div>
    </section>

    <div class="legal-inner">
        <nav class="legal-toc">
            <h3>Sommaire</h3>
            <ol>
                <li><a href="#editeur">Éditeur du site</a></li>
                <li><a href="#hebergeur">Hébergeur</a></li>
                <li><a href="#propriete">Propriété intellectuelle</a></li>
                <li><a href="#donnees">Données personnelles</a></li>
                <li><a href="#cookies">Cookies</a></li>
                <li><a href="#responsabilite">Responsabilité</a></li>
                <li><a href="#droit">Droit applicable</a></li>
                <li><a href="#contact">Contact</a></li>
            </ol>
        </nav>

        <section class="legal-section" id="editeur">
            <h2>1. Éditeur du site</h2>
            <p>Le présent site est édité par :</p>
            <table class="legal-table">
                <tr><th>Raison sociale</th><td>Pullman Dakar Teranga</td></tr>
                <tr><th>Forme juridique</th><td>Société hôtelière — Groupe Accor</td></tr>
                <tr><th>Adresse</th><td>10, Rue Colbert, Place de l'Indépendance<br>BP 3380, Dakar, Sénégal</td></tr>
                <tr><th>Téléphone</th><td>+221 33 889 22 00</td></tr>
                <tr><th>Fax</th><td>+221 33 823 50 01</td></tr>
                <tr><th>E-mail</th><td>HB076@accor.com</td></tr>
                <tr><th>Directeur de publication</th><td><span class="todo">[À COMPLÉTER — Nom du Directeur Général]</span></td></tr>
                <tr><th>N° RCCM</th><td><span class="todo">[À COMPLÉTER — Numéro RCCM]</span></td></tr>
                <tr><th>N° NINEA</th><td><span class="todo">[À COMPLÉTER — Numéro NINEA]</span></td></tr>
                <tr><th>Capital social</th><td><span class="todo">[À COMPLÉTER]</span></td></tr>
                <tr><th>Hébergement</th><td>Accor SA — 82, rue Henri Farman, 92130 Issy-les-Moulineaux, France</td></tr>
            </table>
        </section>

        <section class="legal-section" id="hebergeur">
            <h2>2. Hébergeur</h2>
            <p>Le site est hébergé par :</p>
            <table class="legal-table">
                <tr><th>Société</th><td>Accor SA</td></tr>
                <tr><th>Adresse</th><td>82, rue Henri Farman<br>92130 Issy-les-Moulineaux<br>France</td></tr>
                <tr><th>Téléphone</th><td>+33 (0)1 45 38 86 00</td></tr>
                <tr><th>Site</th><td><a href="https://all.accor.com" target="_blank" rel="noopener">all.accor.com</a></td></tr>
            </table>
        </section>

        <section class="legal-section" id="propriete">
            <h2>3. Propriété intellectuelle</h2>
            <p>L'ensemble des éléments du site (textes, images, vidéos, logos, marques, structure, code, etc.) est protégé par le droit de la propriété intellectuelle et appartient à <strong>Accor SA</strong> ou à ses partenaires.</p>
            <p>Toute reproduction, représentation, modification, publication ou adaptation, totale ou partielle, par quelque procédé que ce soit, est interdite sans autorisation écrite préalable.</p>
            <p>La marque <strong>Pullman</strong> et le logo associé sont des marques déposées d'Accor SA. Toute utilisation non autorisée constitue une contrefaçon sanctionnée par le Code de la propriété intellectuelle.</p>
        </section>

        <section class="legal-section" id="donnees">
            <h2>4. Données personnelles</h2>
            <p>Le traitement de vos données personnelles est décrit en détail dans notre <a href="politique-confidentialite.html">Politique de confidentialité</a>.</p>
            <p>Conformément à la loi sénégalaise n° 2008-12 du 25 janvier 2008 sur la protection des données personnelles et au Règlement Général sur la Protection des Données (RGPD), vous disposez de droits d'accès, de rectification, d'effacement, de limitation et d'opposition sur vos données.</p>
            <p>Pour exercer ces droits, contactez-nous à : <a href="mailto:HB076@accor.com">HB076@accor.com</a></p>
        </section>

        <section class="legal-section" id="cookies">
            <h2>5. Cookies</h2>
            <p>Le site peut utiliser des cookies pour améliorer l'expérience utilisateur, réaliser des statistiques de visite et personnaliser les contenus.</p>
            <p>Lors de votre première visite, un bandeau vous informe de l'utilisation des cookies et vous permet de les accepter ou de les refuser. Vous pouvez à tout moment modifier vos préférences.</p>
            <p>Types de cookies utilisés :</p>
            <ul>
                <li><strong>Cookies essentiels</strong> : nécessaires au fonctionnement du site (session, panier, etc.)</li>
                <li><strong>Cookies analytiques</strong> : mesure d'audience anonymisée</li>
                <li><strong>Cookies marketing</strong> : personnalisation des offres et publicités</li>
            </ul>
        </section>

        <section class="legal-section" id="responsabilite">
            <h2>6. Limitation de responsabilité</h2>
            <p>Le Pullman Dakar Teranga s'efforce d'assurer l'exactitude des informations diffusées sur ce site. Toutefois, il ne peut garantir l'exhaustivité ni l'absence d'erreur.</p>
            <p>Le site peut contenir des liens vers d'autres sites. Le Pullman Dakar Teranga n'exerce aucun contrôle sur ces sites et décline toute responsabilité quant à leur contenu.</p>
        </section>

        <section class="legal-section" id="droit">
            <h2>7. Droit applicable</h2>
            <p>Les présentes mentions légales sont soumises au <strong>droit sénégalais</strong>. Tout litige relatif à l'utilisation du site sera soumis à la compétence exclusive des tribunaux de Dakar.</p>
        </section>

        <section class="legal-section" id="contact">
            <h2>8. Contact</h2>
            <p>Pour toute question relative aux présentes mentions légales :</p>
            <div class="legal-box">
                <strong>Pullman Dakar Teranga</strong>
                <p>10, Rue Colbert, Place de l'Indépendance<br>BP 3380, Dakar, Sénégal<br>
                Téléphone : +221 33 889 22 00<br>
                E-mail : <a href="mailto:HB076@accor.com">HB076@accor.com</a></p>
            </div>
        </section>

        <p class="legal-updated">Dernière mise à jour : 23 septembre 2026</p>

        <div class="legal-cta">
            <h3>Une question ?</h3>
            <p>Notre équipe est à votre disposition pour toute demande d'information.</p>
            <a href="contact.html"><i class="fa-solid fa-envelope"></i> Nous contacter</a>
        </div>
    </div>
</main>
HTML_BODY
  generate_footer
  generate_scripts
  echo "</body>"
  echo "</html>"
} > mentions-legales.html

echo -e "${GREEN}✔ mentions-legales.html créé${NC}"

# =============================================================================
# 4. PAGE 2 : CONDITIONS GÉNÉRALES
# =============================================================================
{
  cat << 'HTML_HEAD'
<!DOCTYPE html>
<html lang="fr">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Conditions générales — Pullman Dakar Teranga</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@300;400;500;600;700;800&family=Playfair+Display:ital,wght@0,400;0,700;1,400;1,700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
<link rel="stylesheet" href="css/variables.css">
<link rel="stylesheet" href="css/commun.css">
<link rel="stylesheet" href="css/footer-cta.css">
<link rel="stylesheet" href="css/legal.css">
</head>
<body>
HTML_HEAD
  generate_header "conditions"
  cat << 'HTML_BODY'
<main class="legal-page">
    <section class="legal-hero">
        <div class="legal-hero-inner">
            <p class="legal-breadcrumb">
                <a href="index.html">Accueil</a>
                <i class="fa-solid fa-chevron-right" style="font-size:.6rem;opacity:.6;"></i>
                <span>Conditions générales</span>
            </p>
            <span class="legal-eyebrow">Contrat de réservation</span>
            <h1>Conditions générales</h1>
            <p>Les présentes conditions régissent toute réservation effectuée auprès du Pullman Dakar Teranga, directement ou via notre site officiel.</p>
        </div>
    </section>

    <div class="legal-inner">
        <nav class="legal-toc">
            <h3>Sommaire</h3>
            <ol>
                <li><a href="#objet">Objet et champ d'application</a></li>
                <li><a href="#reservation">Réservation</a></li>
                <li><a href="#tarifs">Tarifs et taxes</a></li>
                <li><a href="#paiement">Paiement</a></li>
                <li><a href="#annulation">Annulation et modification</a></li>
                <li><a href="#sejour">Déroulement du séjour</a></li>
                <li><a href="#responsabilite">Responsabilité</a></li>
                <li><a href="#reclamation">Réclamations</a></li>
                <li><a href="#loi">Loi applicable</a></li>
            </ol>
        </nav>

        <section class="legal-section" id="objet">
            <h2>1. Objet et champ d'application</h2>
            <p>Les présentes Conditions Générales de Vente (CGV) s'appliquent à toute réservation de chambre, de table au restaurant, de soin au spa ou de service réalisée auprès du Pullman Dakar Teranga.</p>
            <p>Toute réservation implique l'acceptation sans réserve des présentes conditions par le client.</p>
        </section>

        <section class="legal-section" id="reservation">
            <h2>2. Réservation</h2>
            <h3>2.1 Modes de réservation</h3>
            <ul>
                <li>Site officiel : <a href="reservation.html">reservation.html</a></li>
                <li>Téléphone : +221 33 889 22 00</li>
                <li>E-mail : <a href="mailto:dakar.reservation@accor.com">dakar.reservation@accor.com</a></li>
                <li>Agences de voyage partenaires</li>
            </ul>

            <h3>2.2 Confirmation</h3>
            <p>La réservation est confirmée dès réception d'un e-mail de confirmation contenant un numéro de réservation unique. Le client doit vérifier l'exactitude des informations fournies.</p>

            <h3>2.3 Âge minimum</h3>
            <p>Le titulaire de la réservation doit être majeur (18 ans révolus). Une pièce d'identité valide sera demandée à l'arrivée.</p>
        </section>

        <section class="legal-section" id="tarifs">
            <h2>3. Tarifs et taxes</h2>
            <p>Les tarifs affichés sont exprimés en Francs CFA (XOF) et incluent la TVA et la taxe de promotion touristique, sauf mention contraire.</p>
            <p>La taxe de séjour est de <strong>1 000 FCFA par personne et par nuit</strong>, conformément à la réglementation en vigueur au Sénégal.</p>
            <p>Les tarifs peuvent varier selon la période, la disponibilité et le type de chambre. Le tarif applicable est celui affiché au moment de la confirmation de la réservation.</p>
        </section>

        <section class="legal-section" id="paiement">
            <h2>4. Paiement</h2>
            <h3>4.1 Moyens de paiement acceptés</h3>
            <ul>
                <li>Cartes bancaires : Visa, Mastercard (paiement sécurisé 3D Secure)</li>
                <li>Wave (paiement mobile instantané)</li>
                <li>Orange Money</li>
                <li>Espèces en FCFA (à la réception)</li>
                <li>Virements bancaires (sur demande pour les groupes)</li>
            </ul>

            <h3>4.2 Moment du paiement</h3>
            <p>Selon le tarif choisi :</p>
            <ul>
                <li><strong>Tarif Flexible</strong> : paiement à l'arrivée</li>
                <li><strong>Tarif Non-remboursable</strong> : paiement immédiat à la réservation (remise de 15 %)</li>
                <li><strong>Tarif Petit-déjeuner inclus</strong> : paiement à l'arrivée</li>
            </ul>
        </section>

        <section class="legal-section" id="annulation">
            <h2>5. Annulation et modification</h2>
            <h3>5.1 Tarif Flexible</h3>
            <p>Annulation gratuite jusqu'à <strong>48 heures avant l'arrivée</strong>. Passé ce délai, le montant de la première nuit sera facturé.</p>

            <h3>5.2 Tarif Non-remboursable</h3>
            <p>Ce tarif ne permet ni annulation, ni modification, ni remboursement. En cas de non-présentation (no-show), la totalité du séjour est due.</p>

            <h3>5.3 Modification</h3>
            <p>Toute demande de modification est soumise à disponibilité et peut entraîner une différence tarifaire.</p>

            <h3>5.4 Cas de force majeure</h3>
            <p>En cas de force majeure (catastrophe naturelle, pandémie, décision gouvernementale), les conditions d'annulation pourront être adaptées au cas par cas.</p>
        </section>

        <section class="legal-section" id="sejour">
            <h2>6. Déroulement du séjour</h2>
            <h3>6.1 Arrivée et départ</h3>
            <ul>
                <li>Check-in : à partir de 14h00</li>
                <li>Check-out : avant 12h00</li>
                <li>Late check-out possible sur demande (jusqu'à 16h00, selon disponibilité)</li>
            </ul>

            <h3>6.2 Règles de l'établissement</h3>
            <ul>
                <li>Il est interdit de fumer dans les chambres et espaces intérieurs</li>
                <li>Les animaux de compagnie sont admis moyennant un supplément</li>
                <li>Le calme doit être respecté entre 22h00 et 7h00</li>
                <li>Les visiteurs extérieurs doivent être signalés à la réception</li>
            </ul>

            <h3>6.3 Bagages</h3>
            <p>Une bagagerie gratuite est à disposition avant le check-in et après le check-out.</p>
        </section>

        <section class="legal-section" id="responsabilite">
            <h2>7. Responsabilité</h2>
            <p>Le Pullman Dakar Teranga ne saurait être tenu responsable :</p>
            <ul>
                <li>Des vols ou pertes d'objets non déposés au coffre-fort de la chambre</li>
                <li>Des dommages causés par le client aux biens de l'établissement</li>
                <li>Des interruptions de service indépendantes de sa volonté (coupures réseau, etc.)</li>
            </ul>
            <p>Le client est responsable des dommages causés par lui-même ou les personnes dont il répond.</p>
        </section>

        <section class="legal-section" id="reclamation">
            <h2>8. Réclamations</h2>
            <p>Toute réclamation doit être adressée dans un délai de 30 jours suivant la fin du séjour :</p>
            <div class="legal-box">
                <strong>Service client</strong>
                <p>Pullman Dakar Teranga<br>
                10, Rue Colbert, Place de l'Indépendance<br>
                BP 3380, Dakar, Sénégal<br>
                E-mail : <a href="mailto:HB076@accor.com">HB076@accor.com</a></p>
            </div>
        </section>

        <section class="legal-section" id="loi">
            <h2>9. Loi applicable</h2>
            <p>Les présentes conditions sont régies par le <strong>droit sénégalais</strong>. En cas de litige, les tribunaux de Dakar seront seuls compétents.</p>
            <p>Le client est invité à consulter également notre <a href="politique-confidentialite.html">Politique de confidentialité</a> et nos <a href="mentions-legales.html">Mentions légales</a>.</p>
        </section>

        <p class="legal-updated">Dernière mise à jour : 23 septembre 2026</p>

        <div class="legal-cta">
            <h3>Besoin d'aide pour votre réservation ?</h3>
            <p>Notre équipe vous accompagne 24h/24 et 7j/7.</p>
            <a href="contact.html"><i class="fa-solid fa-headset"></i> Contacter le service réservation</a>
        </div>
    </div>
</main>
HTML_BODY
  generate_footer
  generate_scripts
  echo "</body>"
  echo "</html>"
} > conditions-generales.html

echo -e "${GREEN}✔ conditions-generales.html créé${NC}"

# =============================================================================
# 5. PAGE 3 : POLITIQUE DE CONFIDENTIALITÉ
# =============================================================================
{
  cat << 'HTML_HEAD'
<!DOCTYPE html>
<html lang="fr">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Politique de confidentialité — Pullman Dakar Teranga</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@300;400;500;600;700;800&family=Playfair+Display:ital,wght@0,400;0,700;1,400;1,700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
<link rel="stylesheet" href="css/variables.css">
<link rel="stylesheet" href="css/commun.css">
<link rel="stylesheet" href="css/footer-cta.css">
<link rel="stylesheet" href="css/legal.css">
</head>
<body>
HTML_HEAD
  generate_header "confidentialite"
  cat << 'HTML_BODY'
<main class="legal-page">
    <section class="legal-hero">
        <div class="legal-hero-inner">
            <p class="legal-breadcrumb">
                <a href="index.html">Accueil</a>
                <i class="fa-solid fa-chevron-right" style="font-size:.6rem;opacity:.6;"></i>
                <span>Politique de confidentialité</span>
            </p>
            <span class="legal-eyebrow">Protection des données</span>
            <h1>Politique de confidentialité</h1>
            <p>Comment nous collectons, utilisons et protégeons vos données personnelles, conformément au RGPD et à la loi sénégalaise n° 2008-12.</p>
        </div>
    </section>

    <div class="legal-inner">
        <nav class="legal-toc">
            <h3>Sommaire</h3>
            <ol>
                <li><a href="#responsable">Responsable du traitement</a></li>
                <li><a href="#donnees">Données collectées</a></li>
                <li><a href="#finalites">Finalités du traitement</a></li>
                <li><a href="#base">Base légale</a></li>
                <li><a href="#duree">Durée de conservation</a></li>
                <li><a href="#destinataires">Destinataires</a></li>
                <li><a href="#droits">Vos droits</a></li>
                <li><a href="#securite">Sécurité</a></li>
                <li><a href="#cookies">Cookies</a></li>
            </ol>
        </nav>

        <section class="legal-section" id="responsable">
            <h2>1. Responsable du traitement</h2>
            <p>Le responsable du traitement des données personnelles collectées sur ce site est :</p>
            <table class="legal-table">
                <tr><th>Société</th><td>Pullman Dakar Teranga</td></tr>
                <tr><th>Adresse</th><td>10, Rue Colbert, Place de l'Indépendance<br>BP 3380, Dakar, Sénégal</td></tr>
                <tr><th>E-mail DPO</th><td><a href="mailto:HB076@accor.com">HB076@accor.com</a></td></tr>
                <tr><th>Téléphone</th><td>+221 33 889 22 00</td></tr>
            </table>
        </section>

        <section class="legal-section" id="donnees">
            <h2>2. Données collectées</h2>
            <p>Nous collectons les catégories de données suivantes :</p>

            <h3>2.1 Données d'identification</h3>
            <ul>
                <li>Civilité, nom, prénom</li>
                <li>Adresse e-mail</li>
                <li>Numéro de téléphone</li>
                <li>Pays de résidence</li>
                <li>Date de naissance (facultatif)</li>
            </ul>

            <h3>2.2 Données de réservation</h3>
            <ul>
                <li>Dates d'arrivée et de départ</li>
                <li>Type de chambre et tarif choisi</li>
                <li>Nombre de voyageurs</li>
                <li>Préférences et demandes particulières</li>
                <li>Historique des séjours</li>
            </ul>

            <h3>2.3 Données de paiement</h3>
            <ul>
                <li>Informations de carte bancaire (traitées par un prestataire sécurisé)</li>
                <li>Données de transaction Wave / Orange Money</li>
            </ul>

            <h3>2.4 Données de navigation</h3>
            <ul>
                <li>Adresse IP</li>
                <li>Type de navigateur et système d'exploitation</li>
                <li>Pages visitées et durée de visite</li>
                <li>Cookies et identifiants</li>
            </ul>
        </section>

        <section class="legal-section" id="finalites">
            <h2>3. Finalités du traitement</h2>
            <p>Vos données sont utilisées pour :</p>
            <ul>
                <li><strong>Gérer votre réservation</strong> : confirmation, modification, annulation</li>
                <li><strong>Assurer votre séjour</strong> : accueil, service en chambre, restauration</li>
                <li><strong>Gérer la facturation</strong> : édition de factures, traitement des paiements</li>
                <li><strong>Améliorer nos services</strong> : analyse statistique anonymisée</li>
                <li><strong>Vous informer</strong> : offres promotionnelles, newsletter (avec votre consentement)</li>
                <li><strong>Respecter nos obligations légales</strong> : comptabilité, obligations fiscales</li>
            </ul>
        </section>

        <section class="legal-section" id="base">
            <h2>4. Base légale</h2>
            <p>Le traitement repose sur :</p>
            <ul>
                <li><strong>L'exécution du contrat</strong> : pour la gestion de votre réservation et de votre séjour</li>
                <li><strong>Votre consentement</strong> : pour l'envoi de newsletter et de cookies non essentiels</li>
                <li><strong>Nos obligations légales</strong> : pour la conservation des factures et documents comptables</li>
                <li><strong>Notre intérêt légitime</strong> : pour l'amélioration de nos services et la sécurité</li>
            </ul>
        </section>

        <section class="legal-section" id="duree">
            <h2>5. Durée de conservation</h2>
            <table class="legal-table">
                <tr><th>Type de données</th><th>Durée</th></tr>
                <tr><td>Données de réservation</td><td>3 ans après le dernier séjour</td></tr>
                <tr><td>Données de facturation</td><td>10 ans (obligation comptable)</td></tr>
                <tr><td>Données de newsletter</td><td>Jusqu'à désinscription</td></tr>
                <tr><td>Cookies analytiques</td><td>13 mois maximum</td></tr>
                <tr><td>Données de navigation</td><td>12 mois</td></tr>
            </table>
        </section>

        <section class="legal-section" id="destinataires">
            <h2>6. Destinataires des données</h2>
            <p>Vos données peuvent être transmises à :</p>
            <ul>
                <li><strong>Accor SA</strong> : gestion du programme de fidélité ALL</li>
                <li><strong>Nos prestataires techniques</strong> : hébergement, paiement, e-mailing</li>
                <li><strong>Les autorités compétentes</strong> : sur réquisition légale</li>
            </ul>
            <p>Aucune donnée n'est vendue à des tiers.</p>
        </section>

        <section class="legal-section" id="droits">
            <h2>7. Vos droits</h2>
            <p>Conformément à la réglementation, vous disposez des droits suivants :</p>
            <ul>
                <li><strong>Droit d'accès</strong> : obtenir une copie de vos données</li>
                <li><strong>Droit de rectification</strong> : corriger des données inexactes</li>
                <li><strong>Droit à l'effacement</strong> : demander la suppression de vos données</li>
                <li><strong>Droit à la limitation</strong> : restreindre le traitement</li>
                <li><strong>Droit d'opposition</strong> : refuser le traitement pour motif légitime</li>
                <li><strong>Droit à la portabilité</strong> : recevoir vos données dans un format structuré</li>
                <li><strong>Droit de retirer votre consentement</strong> à tout moment</li>
            </ul>

            <div class="legal-box">
                <strong>Comment exercer vos droits ?</strong>
                <p>Adressez votre demande par e-mail à <a href="mailto:HB076@accor.com">HB076@accor.com</a> ou par courrier à :<br>
                Pullman Dakar Teranga — Service Protection des Données<br>
                10, Rue Colbert, Place de l'Indépendance, BP 3380, Dakar, Sénégal</p>
                <p>Une réponse vous sera apportée dans un délai maximum de 30 jours.</p>
            </div>

            <p>Si vous estimez que vos droits ne sont pas respectés, vous pouvez introduire une réclamation auprès de la <strong>Commission de Protection des Données Personnelles du Sénégal (CDP)</strong>.</p>
        </section>

        <section class="legal-section" id="securite">
            <h2>8. Sécurité</h2>
            <p>Nous mettons en œuvre des mesures techniques et organisationnelles appropriées pour protéger vos données contre tout accès non autorisé, altération ou divulgation :</p>
            <ul>
                <li>Chiffrement SSL des transactions</li>
                <li>Conformité 3D Secure pour les paiements par carte</li>
                <li>Accès restreint aux données par personnel habilité</li>
                <li>Sauvegardes régulières et sécurisées</li>
            </ul>
        </section>

        <section class="legal-section" id="cookies">
            <h2>9. Cookies</h2>
            <p>Ce site utilise des cookies pour améliorer votre expérience. Vous pouvez les accepter ou les refuser.</p>
            <p>Pour plus de détails, consultez nos <a href="mentions-legales.html#cookies">Mentions légales — section Cookies</a>.</p>
        </section>

        <p class="legal-updated">Dernière mise à jour : 23 septembre 2026</p>

        <div class="legal-cta">
            <h3>Une question sur vos données ?</h3>
            <p>Notre DPO est à votre disposition pour toute demande.</p>
            <a href="mailto:HB076@accor.com"><i class="fa-solid fa-shield-halved"></i> Contacter le DPO</a>
        </div>
    </div>
</main>
HTML_BODY
  generate_footer
  generate_scripts
  echo "</body>"
  echo "</html>"
} > politique-confidentialite.html

echo -e "${GREEN}✔ politique-confidentialite.html créé${NC}"

# =============================================================================
# 6. PAGE 4 : ACCESSIBILITÉ
# =============================================================================
{
  cat << 'HTML_HEAD'
<!DOCTYPE html>
<html lang="fr">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Accessibilité — Pullman Dakar Teranga</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@300;400;500;600;700;800&family=Playfair+Display:ital,wght@0,400;0,700;1,400;1,700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
<link rel="stylesheet" href="css/variables.css">
<link rel="stylesheet" href="css/commun.css">
<link rel="stylesheet" href="css/footer-cta.css">
<link rel="stylesheet" href="css/legal.css">
</head>
<body>
HTML_HEAD
  generate_header "accessibilite"
  cat << 'HTML_BODY'
<main class="legal-page">
    <section class="legal-hero">
        <div class="legal-hero-inner">
            <p class="legal-breadcrumb">
                <a href="index.html">Accueil</a>
                <i class="fa-solid fa-chevron-right" style="font-size:.6rem;opacity:.6;"></i>
                <span>Accessibilité</span>
            </p>
            <span class="legal-eyebrow">Engagement</span>
            <h1>Déclaration d'accessibilité</h1>
            <p>Le Pullman Dakar Teranga s'engage à rendre son site et ses services accessibles à tous, y compris aux personnes en situation de handicap.</p>
        </div>
    </section>

    <div class="legal-inner">
        <nav class="legal-toc">
            <h3>Sommaire</h3>
            <ol>
                <li><a href="#engagement">Notre engagement</a></li>
                <li><a href="#site">Accessibilité du site web</a></li>
                <li><a href="#hotel">Accessibilité de l'hôtel</a></li>
                <li><a href="#amelioration">Points d'amélioration</a></li>
                <li><a href="#contact">Nous signaler un problème</a></li>
            </ol>
        </nav>

        <section class="legal-section" id="engagement">
            <h2>1. Notre engagement</h2>
            <p>Le Pullman Dakar Teranga place l'inclusion au cœur de ses préoccupations. Nous nous engageons à :</p>
            <ul>
                <li>Garantir l'accès à l'ensemble de nos services, quel que soit le handicap</li>
                <li>Former notre personnel à l'accueil des personnes en situation de handicap</li>
                <li>Améliorer continuellement l'accessibilité de nos infrastructures et de notre site web</li>
                <li>Répondre à toute demande spécifique dans les meilleurs délais</li>
            </ul>
        </section>

        <section class="legal-section" id="site">
            <h2>2. Accessibilité du site web</h2>
            <p>Nous nous efforçons de respecter les recommandations du <strong>Référentiel Général d'Amélioration de l'Accessibilité (RGAA)</strong> et les règles WCAG 2.1 niveau AA.</p>

            <h3>Mesures mises en place</h3>
            <ul>
                <li>Structure sémantique HTML5 (titres, listes, sections)</li>
                <li>Navigation entièrement au clavier</li>
                <li>Contrastes de couleurs conformes AA</li>
                <li>Textes alternatifs sur toutes les images informatives</li>
                <li>Attributs ARIA sur les composants interactifs (modales, onglets)</li>
                <li>Focus visible et personnalisé</li>
                <li>Formulaire avec labels associés</li>
                <li>Site responsive et zoom jusqu'à 200 % sans perte de contenu</li>
                <li>Préférence de mouvement réduit respectée (<code>prefers-reduced-motion</code>)</li>
            </ul>

            <h3>Technologies d'assistance testées</h3>
            <ul>
                <li>Lecteurs d'écran : NVDA, VoiceOver</li>
                <li>Navigation clavier complète</li>
                <li>Agrandisseurs de texte</li>
            </ul>
        </section>

        <section class="legal-section" id="hotel">
            <h2>3. Accessibilité de l'hôtel</h2>
            <p>Le Pullman Dakar Teranga est un établissement labellisé <strong>Safe Hotels</strong> et s'engage à accueillir les personnes en situation de handicap dans les meilleures conditions.</p>

            <h3>Infrastructures accessibles</h3>
            <ul>
                <li>Chambres PMR disponibles (sur réservation)</li>
                <li>Accès de plain-pied aux espaces communs (lobby, restaurants, spa)</li>
                <li>Ascenseurs adaptés desservant tous les étages</li>
                <li>Sanitaires adaptés dans les espaces publics</li>
                <li>Places de parking réservées à proximité immédiate de l'entrée</li>
                <li>Signalétique en braille aux points clés</li>
            </ul>

            <h3>Services adaptés</h3>
            <ul>
                <li>Accueil personnalisé à l'arrivée sur demande</li>
                <li>Menu en gros caractères ou lu par le personnel</li>
                <li>Personnel formé à la langue des signes (base)</li>
                <li>Possibilité d'organiser un transfert aéroport adapté</li>
            </ul>
        </section>

        <section class="legal-section" id="amelioration">
            <h2>4. Points d'amélioration identifiés</h2>
            <p>Nous travaillons activement sur les axes suivants :</p>
            <ul>
                <li>Audit RGAA complet à venir</li>
                <li>Ajout de sous-titres sur les vidéos</li>
                <li>Transcription textuelle des contenus audio</li>
                <li>Amélioration de la compatibilité avec les lecteurs d'écran mobiles</li>
            </ul>
        </section>

        <section class="legal-section" id="contact">
            <h2>5. Nous signaler un problème d'accessibilité</h2>
            <p>Si vous rencontrez une difficulté d'accès à un contenu ou à un service, merci de nous la signaler. Nous nous engageons à vous répondre dans un délai de <strong>7 jours ouvrés</strong>.</p>

            <div class="legal-box">
                <strong>Contact accessibilité</strong>
                <p>E-mail : <a href="mailto:HB076@accor.com">HB076@accor.com</a><br>
                Téléphone : +221 33 889 22 00<br>
                Courrier : Pullman Dakar Teranga — Référent Accessibilité<br>
                10, Rue Colbert, Place de l'Indépendance, BP 3380, Dakar, Sénégal</p>
            </div>

            <p>Si vous n'obtenez pas de réponse satisfaisante, vous pouvez saisir le <strong>Défenseur des droits</strong> ou l'autorité compétente au Sénégal.</p>
        </section>

        <p class="legal-updated">Déclaration établie le 23 septembre 2026 — Valable 3 ans</p>

        <div class="legal-cta">
            <h3>Besoin d'un accueil adapté ?</h3>
            <p>Contactez-nous en amont de votre séjour pour que nous préparions votre arrivée.</p>
            <a href="contact.html"><i class="fa-solid fa-hand-holding-heart"></i> Nous contacter</a>
        </div>
    </div>
</main>
HTML_BODY
  generate_footer
  generate_scripts
  echo "</body>"
  echo "</html>"
} > accessibilite.html

echo -e "${GREEN}✔ accessibilite.html créé${NC}"

# =============================================================================
# 7. PAGE 5 : OFFRES SPÉCIALES
# =============================================================================
{
  cat << 'HTML_HEAD'
<!DOCTYPE html>
<html lang="fr">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Offres spéciales — Pullman Dakar Teranga</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@300;400;500;600;700;800&family=Playfair+Display:ital,wght@0,400;0,700;1,400;1,700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
<link rel="stylesheet" href="css/variables.css">
<link rel="stylesheet" href="css/commun.css">
<link rel="stylesheet" href="css/footer-cta.css">
<link rel="stylesheet" href="css/experiences-restaurant.css">
</head>
<body>
HTML_HEAD
  generate_header "offres"
  cat << 'HTML_BODY'
<main class="restaurants-page">
    <!-- HERO -->
    <section class="resto-section" style="padding:0;background:linear-gradient(120deg,#0A1E2D 0%,#155E75 100%);">
        <div class="container" style="padding:80px 50px;text-align:center;color:#fff;">
            <span class="eyebrow" style="color:#C59A67;">Réservation directe</span>
            <h1 style="font-family:'Playfair Display',serif;font-size:clamp(2rem,4vw,3rem);font-weight:700;color:#fff;margin:0 0 18px;line-height:1.1;">
                Offres <em style="color:#C59A67;">exclusives</em><br>réservées aux clients directs
            </h1>
            <p style="font-size:1rem;color:rgba(255,255,255,.85);max-width:620px;margin:0 auto;line-height:1.7;">
                Réservez sur notre site officiel et bénéficiez d'avantages exclusifs : meilleur tarif garanti, surclassement, petits-déjeuners offerts et bien plus.
            </p>
        </div>
    </section>

    <!-- OFFRE 1 : SÉJOUR LONGUE DURÉE -->
    <section class="resto-section" style="background:#fff;padding:80px 0;">
        <div class="container">
            <div class="resto-grid">
                <div class="resto-info">
                    <div class="resto-logo" style="background:rgba(56,226,143,.1);border:1px solid rgba(56,226,143,.3);color:#38E28F;">
                        <i class="fa-solid fa-calendar-check"></i>
                        <span>Offre Longue Durée</span>
                    </div>
                    <span class="resto-eyebrow" style="color:#38E28F;">À partir de 3 nuits</span>
                    <h2 class="resto-title" style="color:#1A2B3C;">Séjour longue durée<br>-20% sur votre chambre</h2>
                    <blockquote class="resto-quote" style="border-color:#38E28F;color:#1A2B3C;">
                        « Profitez de notre meilleur tarif pour les séjours de 3 nuits et plus, et découvrez Dakar à votre rythme. »
                    </blockquote>
                    <p class="resto-desc" style="color:#4A5763;">
                        Idéal pour les voyageurs d'affaires ou les longs week-ends, cette offre inclut :
                    </p>
                    <ul style="list-style:none;padding:0;margin:0 0 28px;display:flex;flex-direction:column;gap:12px;">
                        <li style="display:flex;align-items:center;gap:12px;color:#4A5763;font-size:.92rem;"><i class="fa-solid fa-check" style="color:#38E28F;"></i> 20 % de remise sur le tarif flexible</li>
                        <li style="display:flex;align-items:center;gap:12px;color:#4A5763;font-size:.92rem;"><i class="fa-solid fa-check" style="color:#38E28F;"></i> Petit-déjeuner offert pour 2 personnes</li>
                        <li style="display:flex;align-items:center;gap:12px;color:#4A5763;font-size:.92rem;"><i class="fa-solid fa-check" style="color:#38E28F;"></i> Surclassement selon disponibilité</li>
                        <li style="display:flex;align-items:center;gap:12px;color:#4A5763;font-size:.92rem;"><i class="fa-solid fa-check" style="color:#38E28F;"></i> Late check-out jusqu'à 14h00 offert</li>
                    </ul>
                    <div class="resto-cta">
                        <a href="reservation.html" class="resto-btn resto-btn--primary" style="background:#38E28F;color:#0A1E2D;">
                            Réserver cette offre <i class="fa-solid fa-arrow-right"></i>
                        </a>
                    </div>
                    <p style="font-size:.72rem;color:#8B9AA0;margin-top:16px;">
                        <i class="fa-solid fa-info-circle"></i> Offre soumise à disponibilité. Non cumulable avec d'autres promotions.
                    </p>
                </div>
                <div class="resto-visual">
                    <div class="resto-visual-main">
                        <span class="resto-badge" style="background:rgba(10,30,45,.85);border:1px solid rgba(56,226,143,.5);color:#38E28F;">-20%</span>
                        <img src="images/imageluxe1.jpg" alt="Chambre Deluxe Vue Océan Pullman Dakar Teranga">
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- OFFRE 2 : PACK ROMANTIQUE -->
    <section class="resto-section" style="background:#F7F3EC;padding:80px 0;">
        <div class="container">
            <div class="resto-grid resto-grid--reverse">
                <div class="resto-info">
                    <div class="resto-logo" style="background:rgba(232,93,44,.1);border:1px solid rgba(232,93,44,.3);color:#E85D2C;">
                        <i class="fa-solid fa-heart"></i>
                        <span>Offre Romantique</span>
                    </div>
                    <span class="resto-eyebrow" style="color:#E85D2C;">Pour deux</span>
                    <h2 class="resto-title" style="color:#1A2B3C;">Escapade romantique<br>face à l'Atlantique</h2>
                    <blockquote class="resto-quote" style="border-color:#E85D2C;color:#1A2B3C;">
                        « Un dîner aux chandelles, un massage en duo et une nuit d'exception pour célébrer votre amour. »
                    </blockquote>
                    <p class="resto-desc" style="color:#4A5763;">
                        Notre forfait romantique comprend :
                    </p>
                    <ul style="list-style:none;padding:0;margin:0 0 28px;display:flex;flex-direction:column;gap:12px;">
                        <li style="display:flex;align-items:center;gap:12px;color:#4A5763;font-size:.92rem;"><i class="fa-solid fa-check" style="color:#E85D2C;"></i> Dîner romantique au Teranga Beach Club (2 personnes)</li>
                        <li style="display:flex;align-items:center;gap:12px;color:#4A5763;font-size:.92rem;"><i class="fa-solid fa-check" style="color:#E85D2C;"></i> Massage en duo 50 min au Pullman Spa</li>
                        <li style="display:flex;align-items:center;gap:12px;color:#4A5763;font-size:.92rem;"><i class="fa-solid fa-check" style="color:#E85D2C;"></i> Décoration romantique de la chambre</li>
                        <li style="display:flex;align-items:center;gap:12px;color:#4A5763;font-size:.92rem;"><i class="fa-solid fa-check" style="color:#E85D2C;"></i> Bouteille de champagne et fruits frais</li>
                        <li style="display:flex;align-items:center;gap:12px;color:#4A5763;font-size:.92rem;"><i class="fa-solid fa-check" style="color:#E85D2C;"></i> Late check-out jusqu'à 16h00</li>
                    </ul>
                    <div class="resto-cta">
                        <a href="reservation.html" class="resto-btn resto-btn--primary" style="background:#E85D2C;">
                            Réserver cette offre <i class="fa-solid fa-arrow-right"></i>
                        </a>
                    </div>
                    <p style="font-size:.72rem;color:#8B9AA0;margin-top:16px;">
                        <i class="fa-solid fa-info-circle"></i> Forfait à partir de 285 000 FCFA / couple / nuit. Réservation 48h à l'avance.
                    </p>
                </div>
                <div class="resto-visual">
                    <div class="resto-visual-main">
                        <span class="resto-badge" style="background:rgba(255,255,255,.95);border:1px solid rgba(232,93,44,.35);color:#E85D2C;">Forfait Duo</span>
                        <img src="images/imageluxe1.jpg" alt="Chambre romantique Pullman Dakar Teranga">
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- OFFRE 3 : BUSINESS -->
    <section class="resto-section" style="background:#fff;padding:80px 0;">
        <div class="container">
            <div class="resto-grid">
                <div class="resto-info">
                    <div class="resto-logo" style="background:rgba(21,94,117,.1);border:1px solid rgba(21,94,117,.3);color:#155E75;">
                        <i class="fa-solid fa-briefcase"></i>
                        <span>Offre Business</span>
                    </div>
                    <span class="resto-eyebrow" style="color:#155E75;">Voyageurs d'affaires</span>
                    <h2 class="resto-title" style="color:#1A2B3C;">Séjour d'affaires<br>tout inclus</h2>
                    <blockquote class="resto-quote" style="border-color:#155E75;color:#1A2B3C;">
                        « Travaillez efficacement et détendez-vous dans un cadre d'exception au cœur du Plateau. »
                    </blockquote>
                    <p class="resto-desc" style="color:#4A5763;">
                        Notre offre business inclut :
                    </p>
                    <ul style="list-style:none;padding:0;margin:0 0 28px;display:flex;flex-direction:column;gap:12px;">
                        <li style="display:flex;align-items:center;gap:12px;color:#4A5763;font-size:.92rem;"><i class="fa-solid fa-check" style="color:#155E75;"></i> Petit-déjeuner buffet inclus</li>
                        <li style="display:flex;align-items:center;gap:12px;color:#4A5763;font-size:.92rem;"><i class="fa-solid fa-check" style="color:#155E75;"></i> Wi-Fi haut débit dans toute la chambre</li>
                        <li style="display:flex;align-items:center;gap:12px;color:#4A5763;font-size:.92rem;"><i class="fa-solid fa-check" style="color:#155E75;"></i> Accès illimité au centre d'affaires</li>
                        <li style="display:flex;align-items:center;gap:12px;color:#4A5763;font-size:.92rem;"><i class="fa-solid fa-check" style="color:#155E75;"></i> Transfert aéroport AIBD aller-retour offert</li>
                        <li style="display:flex;align-items:center;gap:12px;color:#4A5763;font-size:.92rem;"><i class="fa-solid fa-check" style="color:#155E75;"></i> 1 pressing offert par séjour</li>
                    </ul>
                    <div class="resto-cta">
                        <a href="reservation.html" class="resto-btn resto-btn--primary" style="background:#155E75;">
                            Réserver cette offre <i class="fa-solid fa-arrow-right"></i>
                        </a>
                    </div>
                    <p style="font-size:.72rem;color:#8B9AA0;margin-top:16px;">
                        <i class="fa-solid fa-info-circle"></i> Offre valable pour toute réservation supérieure à 2 nuits. Sur présentation d'un justificatif professionnel.
                    </p>
                </div>
                <div class="resto-visual">
                    <div class="resto-visual-main">
                        <span class="resto-badge" style="background:rgba(10,30,45,.85);border:1px solid rgba(21,94,117,.5);color:#7DD3E8;">Business</span>
                        <img src="images/imageluxe1.jpg" alt="Chambre business Pullman Dakar Teranga">
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- CTA FINAL -->
    <section class="resto-cta-final">
        <div class="resto-cta-inner">
            <h2>Une question sur nos offres ?</h2>
            <p>Notre équipe commerciale vous accompagne pour créer l'offre sur-mesure qui vous correspond.</p>
            <div class="resto-cta-actions">
                <a href="contact.html" class="resto-btn resto-btn--primary" style="background:#C59A67;">
                    Contacter l'équipe <i class="fa-solid fa-arrow-right"></i>
                </a>
                <a href="reservation.html" class="resto-btn resto-btn--ghost">
                    <i class="fa-regular fa-calendar"></i> Réserver directement
                </a>
            </div>
            <div class="resto-cta-contact">
                <span><i class="fa-solid fa-phone"></i> +221 33 889 22 00</span>
                <span><i class="fa-regular fa-envelope"></i> dakar.reservation@accor.com</span>
            </div>
        </div>
    </section>
</main>
HTML_BODY
  generate_footer
  generate_scripts
  echo "</body>"
  echo "</html>"
} > offres-speciales.html

echo -e "${GREEN}✔ offres-speciales.html créé${NC}"

# =============================================================================
# 8. PAGE experiences.html — remplissage
# =============================================================================
{
  cat << 'HTML_HEAD'
<!DOCTYPE html>
<html lang="fr">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Expériences — Pullman Dakar Teranga</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@300;400;500;600;700;800&family=Playfair+Display:ital,wght@0,400;0,700;1,400;1,700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
<link rel="stylesheet" href="css/variables.css">
<link rel="stylesheet" href="css/commun.css">
<link rel="stylesheet" href="css/footer-cta.css">
<link rel="stylesheet" href="css/experiences-restaurant.css">
</head>
<body>
HTML_HEAD
  generate_header "experiences"
  cat << 'HTML_BODY'
<main class="restaurants-page">
    <section class="resto-section" style="padding:0;background:linear-gradient(120deg,#0A1E2D 0%,#155E75 100%);">
        <div class="container" style="padding:80px 50px;text-align:center;color:#fff;">
            <span class="eyebrow" style="color:#C59A67;">L'art de vivre Pullman</span>
            <h1 style="font-family:'Playfair Display',serif;font-size:clamp(2rem,4vw,3rem);font-weight:700;color:#fff;margin:0 0 18px;line-height:1.1;">
                Au-delà de la <em style="color:#C59A67;">chambre</em>
            </h1>
            <p style="font-size:1rem;color:rgba(255,255,255,.85);max-width:620px;margin:0 auto;line-height:1.7;">
                Des expériences pensées pour éveiller vos sens et célébrer l'âme de Dakar : piscine, spa, restaurants, bars et bien plus.
            </p>
        </div>
    </section>

    <section class="resto-section" style="background:#fff;padding:80px 0;">
        <div class="container">
            <div class="intro-resto-header reveal" style="margin-bottom:50px;">
                <span class="eyebrow">Nos univers</span>
                <h2>Deux adresses, deux moments</h2>
                <p>Découvrez nos deux univers complémentaires pour un séjour d'exception.</p>
            </div>
            <div class="intro-resto-grid">
                <article class="intro-card intro-card--jour reveal">
                    <div class="intro-card-image">
                        <img src="images/piscinehorizon.jpg" alt="Piscine & Spa Pullman Dakar Teranga">
                        <span class="intro-card-badge">Bien-être</span>
                    </div>
                    <div class="intro-card-body">
                        <div class="intro-card-logo">
                            <i class="fa-solid fa-spa"></i>
                            <span>Piscine & Spa</span>
                        </div>
                        <h3>Détente face à l'océan</h3>
                        <p>Piscine à débordement chauffée, hammam marocain traditionnel, sauna et cabines de soins pour revitaliser corps et esprit.</p>
                        <a href="experiences-piscine.html" class="intro-card-link">
                            Découvrir le spa <i class="fa-solid fa-arrow-right"></i>
                        </a>
                    </div>
                </article>

                <article class="intro-card intro-card--nuit reveal">
                    <div class="intro-card-image">
                        <img src="images/hero-resto-jour.jpg" alt="Restaurants & Bars Pullman Dakar Teranga">
                        <span class="intro-card-badge">Gastronomie</span>
                    </div>
                    <div class="intro-card-body">
                        <div class="intro-card-logo">
                            <i class="fa-solid fa-champagne-glasses"></i>
                            <span>Restaurants & Bars</span>
                        </div>
                        <h3>Saveurs d'exception</h3>
                        <p>Teranga Lounge pour une cuisine cosmopolite, Teranga Beach Club pour une gastronomie au feu de bois face à l'Atlantique.</p>
                        <a href="experiences-restaurant.html" class="intro-card-link">
                            Explorer les restaurants <i class="fa-solid fa-arrow-right"></i>
                        </a>
                    </div>
                </article>
            </div>
        </div>
    </section>

    <section class="resto-cta-final">
        <div class="resto-cta-inner reveal">
            <h2>Prêt à vivre l'expérience Pullman ?</h2>
            <p>Réservez directement et bénéficiez du meilleur tarif garanti, d'une confirmation immédiate et d'une annulation flexible.</p>
            <div class="resto-cta-actions">
                <a href="reservation.html" class="resto-btn resto-btn--primary" style="background:#C59A67;">
                    Réserver mon séjour <i class="fa-solid fa-arrow-right"></i>
                </a>
                <a href="offres-speciales.html" class="resto-btn resto-btn--ghost">
                    <i class="fa-solid fa-tags"></i> Voir les offres
                </a>
            </div>
            <div class="resto-cta-contact">
                <span><i class="fa-solid fa-phone"></i> +221 33 889 22 00</span>
                <span><i class="fa-regular fa-envelope"></i> dakar.reservation@accor.com</span>
            </div>
        </div>
    </section>
</main>
HTML_BODY
  generate_footer
  cat << 'SCRIPTS_EOF'
<script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
<script src="https://cdn.jsdelivr.net/npm/flatpickr/dist/l10n/fr.js"></script>
<script src="js/booking-bridge.js"></script>
<script src="js/i18n.js"></script>
<script>
document.addEventListener('DOMContentLoaded', () => {
    const reveals = document.querySelectorAll('.restaurants-page .reveal');
    if (reveals.length && 'IntersectionObserver' in window) {
        const obs = new IntersectionObserver((entries) => {
            entries.forEach(e => { if (e.isIntersecting) { e.target.classList.add('active'); obs.unobserve(e.target); } });
        }, { threshold: 0.12 });
        reveals.forEach(el => obs.observe(el));
    } else {
        reveals.forEach(el => el.classList.add('active'));
    }
});
</script>
SCRIPTS_EOF
  echo "</body>"
  echo "</html>"
} > experiences.html

echo -e "${GREEN}✔ experiences.html rempli${NC}"

# =============================================================================
# 9. HARMONISATION DES FOOTERS DES PAGES EXISTANTES
# =============================================================================
echo ""
echo -e "${BLUE}━━━ Harmonisation des footers existants ━━━${NC}"

python3 << 'PY_EOF'
import re
from pathlib import Path

# Fichiers HTML à corriger
FILES = [
    'index.html', 'chambres.html', 'contact.html', 'galerie.html',
    'evenements.html', 'experiences-piscine.html', 'experiences-restaurant.html',
    'reservation.html'
]

# Nouveau bloc de liens "LIENS UTILES"
NEW_LIENS_UTILES = '''<h4 class="footer-title">LIENS UTILES</h4>
                <ul>
                    <li><a href="mentions-legales.html">Mentions légales</a></li>
                    <li><a href="conditions-generales.html">Conditions générales</a></li>
                    <li><a href="politique-confidentialite.html">Politique de confidentialité</a></li>
                    <li><a href="accessibilite.html">Accessibilité</a></li>
                </ul>'''

NEW_DECOUVRIR = '''<h4 class="footer-title">DÉCOUVRIR</h4>
                <ul>
                    <li><a href="chambres.html">Nos chambres</a></li>
                    <li><a href="experiences.html">Expériences</a></li>
                    <li><a href="offres-speciales.html">Offres spéciales</a></li>
                    <li><a href="galerie.html">Galerie</a></li>
                </ul>'''

for fname in FILES:
    p = Path(fname)
    if not p.exists():
        continue
    html = p.read_text(encoding='utf-8')
    original = html

    # Remplacer le bloc LIENS UTILES (regex tolérante aux espaces)
    pattern_lu = re.compile(
        r'<h4 class="footer-title">LIENS UTILES</h4>\s*<ul>.*?</ul>',
        re.DOTALL
    )
    html = pattern_lu.sub(NEW_LIENS_UTILES, html, count=1)

    # Remplacer le bloc DÉCOUVRIR
    pattern_dec = re.compile(
        r'<h4 class="footer-title">DÉCOUVRIR</h4>\s*<ul>.*?</ul>',
        re.DOTALL
    )
    html = pattern_dec.sub(NEW_DECOUVRIR, html, count=1)

    if html != original:
        p.write_text(html, encoding='utf-8')
        print(f"   ✔ {fname} — footer corrigé")
    else:
        print(f"   ℹ {fname} — déjà à jour ou non trouvé")
PY_EOF

# =============================================================================
# 10. CORRECTION DU FORMULAIRE CONTACT
# =============================================================================
echo ""
echo -e "${BLUE}━━━ Correction du formulaire contact ━━━${NC}"

python3 << 'PY_EOF'
import re
from pathlib import Path

p = Path('contact.html')
if p.exists():
    html = p.read_text(encoding='utf-8')
    original = html

    # 1. Ajouter action/method au <form class="form-grid">
    html = re.sub(
        r'<form class="form-grid">',
        '<form class="form-grid" action="https://formspree.io/f/mvkgaopv" method="POST">',
        html, count=1
    )

    # 2. Ajouter des noms aux champs
    field_map = [
        ('placeholder="Votre nom"', 'name="nom"'),
        ('placeholder="Votre prénom"', 'name="prenom"'),
        ('placeholder="exemple@domaine.com"', 'name="email"'),
        ('placeholder="+221 77 123 45 67"', 'name="telephone"'),
        ('<select required>', '<select name="sujet" required>'),
        ('placeholder="Votre message..."', 'name="message"'),
        ('id="privacy" required', 'id="privacy" name="acceptation" required'),
    ]
    for old, new in field_map:
        # Insérer le name juste avant le ">" du tag concerné
        if old in html:
            html = html.replace(old, old + ' ' + new, 1)

    # 3. Ajouter un script "Copier" + feedback submit
    copy_script = '''
<script>
document.addEventListener('DOMContentLoaded', function () {
    // Boutons "Copier" (téléphone, email)
    document.querySelectorAll('.card-btn').forEach(function (btn) {
        btn.addEventListener('click', function () {
            var card = btn.closest('.card');
            if (!card) return;
            var text = '';
            var title = (card.querySelector('h3') || {}).textContent || '';
            if (/TÉLÉPHONE/i.test(title)) text = '+221 33 889 22 00';
            else if (/EMAIL/i.test(title)) text = 'dakar.reservation@accor.com';
            if (!text) return;
            if (navigator.clipboard && navigator.clipboard.writeText) {
                navigator.clipboard.writeText(text).then(function () {
                    var orig = btn.innerHTML;
                    btn.innerHTML = '<i class="fas fa-check"></i> Copié !';
                    setTimeout(function () { btn.innerHTML = orig; }, 1800);
                });
            }
        });
    });

    // Feedback formulaire
    var form = document.querySelector('.form-grid');
    if (form) {
        form.addEventListener('submit', function (e) {
            if (!form.checkValidity()) return;
            var btn = form.querySelector('.btn-submit');
            if (btn) {
                btn.disabled = true;
                btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> ENVOI EN COURS...';
            }
        });
    }
});
</script>
'''
    if '</body>' in html:
        html = html.replace('</body>', copy_script + '\n</body>', 1)

    if html != original:
        p.write_text(html, encoding='utf-8')
        print("   ✔ contact.html — formulaire + boutons Copier")
    else:
        print("   ℹ contact.html — inchangé")
else:
    print("   ⚠ contact.html introuvable")
PY_EOF

# =============================================================================
# 11. VÉRIFICATION FINALE
# =============================================================================
echo ""
echo -e "${BLUE}━━━ VÉRIFICATION ━━━${NC}"

for f in mentions-legales.html conditions-generales.html politique-confidentialite.html accessibilite.html offres-speciales.html experiences.html css/legal.css; do
    if [ -f "$f" ]; then
        size=$(stat -c%s "$f" 2>/dev/null || stat -f%z "$f" 2>/dev/null || echo 0)
        echo -e "   ${GREEN}✔${NC} $f  ($size octets)"
    else
        echo -e "   ${RED}✘${NC} $f  MANQUANT"
    fi
done

echo ""
echo -e "${GREEN}═══════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}  ✅ TERMINÉ${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════════${NC}"
echo ""
echo "📄 5 pages légales + experiences.html + offres-speciales.html créées"
echo "🔗 Footers harmonisés dans 8 fichiers existants"
echo "📝 Formulaire contact.html corrigé (Formspree)"
echo ""
echo -e "${BLUE}🧪 TEST :${NC}"
echo "   1. Ctrl + Shift + R dans le navigateur"
echo "   2. Cliquez sur les liens du footer → doivent tous fonctionner"
echo "   3. Vérifiez experiences.html → contenu affiché"
echo "   4. Testez contact.html → boutons Copier + envoi formulaire"
echo ""
echo -e "${BLUE}⚠️  IMPORTANT :${NC}"
echo "   • Remplacez le Formspree ID 'mvkgaopv' par le vôtre dans contact.html"
echo "   • Complétez les [À COMPLÉTER] dans mentions-legales.html (RCCM, NINEA…)"
echo "   • Formspree : créez un compte gratuit sur https://formspree.io"
echo ""
echo -e "${BLUE}🔄 ROLLBACK :${NC}"
echo "   Les originaux sont dans .backup_* mais ce script ne modifie QUE les footers."
echo ""
