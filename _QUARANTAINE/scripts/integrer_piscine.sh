#!/usr/bin/env bash
set -euo pipefail

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; BLUE='\033[0;34m'; NC='\033[0m'

echo -e "${BLUE}=====================================================${NC}"
echo -e "${BLUE} INTÉGRATION experiences-piscine.html${NC}"
echo -e "${BLUE}=====================================================${NC}\n"

# ============================================================
# 0. Préparation
# ============================================================
BACKUP=".backup_piscine_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP"

# Sauvegarder les fichiers cibles s'ils existent
for f in experiences-piscine.html css/services-piscine.css css/experiences-piscine.css; do
    [ -f "$f" ] && cp "$f" "$BACKUP/" 2>/dev/null || true
done

# Créer le dossier css s'il n'existe pas
mkdir -p css

echo -e "${GREEN}📦 Sauvegarde → $BACKUP${NC}\n"

# ============================================================
# 1. LIRE LE CONTENU SOURCE
# ============================================================
# Le HTML et le CSS sont fournis dans le contexte de la conversation.
# On les recrée ici proprement, alignés sur la charte Pullman.

echo -e "${BLUE}━━━ [1/3] Création du HTML corrigé ━━━${NC}"

cat > experiences-piscine.html << 'HTML_EOF'
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <title>Pullman Dakar Teranga — Piscine & Spa</title>

    <!-- FontAwesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

    <!-- Flatpickr CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">

    <!-- CSS du site -->
    <link rel="stylesheet" href="css/variables.css">
    <link rel="stylesheet" href="css/commun.css">
    <link rel="stylesheet" href="css/footer-cta.css">
    <link rel="stylesheet" href="css/services-piscine.css">
</head>
<body>

<!-- ============================== HEADER SITE ============================== -->
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
                <a class="active">EXPÉRIENCES</a>
                <div class="dropdown-content">
                    <a href="experiences-piscine.html">Piscine + Spa</a>
                    <a href="experiences-restaurant.html">Restaurant + Wifi</a>
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

<!-- ============================== MAIN ============================== -->
<main>
<div class="piscine-page">

    <!-- ============================================================
         HERO — Bannière "Piscine & Bien-être"
         ============================================================ -->
    <section class="hero-spa">
        <div class="hero-spa-bg"></div>
        <div class="hero-spa-overlay"></div>

        <div class="hero-spa-content">
            <p class="breadcrumb">
                <a href="index.html">Accueil</a> ›
                <a href="experiences.html">Expériences</a> ›
                <span>Piscine &amp; Spa</span>
            </p>

            <h1>Piscine<br>&amp; Bien-être</h1>
            <span class="trait-vert"></span>

            <p class="hero-spa-texte">
                Plongez dans un univers de détente et laissez-vous porter par une
                expérience de bien-être inoubliable. Notre spa vous propose des soins
                relaxants, des massages et des installations de dernière génération
                pour revitaliser corps et esprit.
            </p>
        </div>
    </section>

    <!-- ============================================================
         SECTION — Détente & Bienfaits
         ============================================================ -->
    <section class="section section-blanche section-bienfaits">
        <div class="container">
            <div class="bienfaits-grid">

                <!-- Colonne gauche -->
                <div class="bienfaits-texte">
                    <p class="section-subtitle">Détente &amp; Bienfaits</p>
                    <h2 class="titre-souligne">Un sanctuaire de calme au cœur de Dakar</h2>

                    <p class="bienfaits-desc">
                        Profitez d'une parenthèse hors du temps dans notre espace bien-être :
                        piscine à débordement, hammam traditionnel, sauna et cabines de soins
                        pour une expérience unique.
                    </p>

                    <div class="icones-grid">
                        <div class="icone-item">
                            <div class="icone-cercle">
                                <i class="fa-solid fa-spa"></i>
                            </div>
                            <p>Massages</p>
                        </div>

                        <div class="icone-item">
                            <div class="icone-cercle">
                                <i class="fa-solid fa-water-ladder"></i>
                            </div>
                            <p>Piscine</p>
                        </div>

                        <div class="icone-item">
                            <div class="icone-cercle">
                                <i class="fa-solid fa-hot-tub-person"></i>
                            </div>
                            <p>Hammam</p>
                        </div>

                        <div class="icone-item">
                            <div class="icone-cercle">
                                <i class="fa-solid fa-om"></i>
                            </div>
                            <p>Yoga</p>
                        </div>
                    </div>
                </div>

                <!-- Colonne droite : Image -->
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
            <div class="art-spa-grid">

                <!-- Colonne gauche -->
                <div class="art-spa-texte">
                    <p class="section-subtitle">L'art du Spa</p>
                    <h2 class="titre-souligne">L'art du soin face à l'océan</h2>

                    <p class="art-spa-desc">
                        Une invitation à la détente absolue : nos soins signature allient
                        traditions ancestrales et techniques modernes pour un moment unique.
                    </p>

                    <div class="services-liste">

                        <div class="service-ligne">
                            <div class="service-icone">
                                <i class="fa-solid fa-spa"></i>
                            </div>
                            <div>
                                <h4>Massages &amp; Soins du corps</h4>
                                <p>Une gamme complète de soins relaxants et tonifiants.</p>
                            </div>
                        </div>

                        <div class="service-ligne">
                            <div class="service-icone">
                                <i class="fa-solid fa-water-ladder"></i>
                            </div>
                            <div>
                                <h4>Piscine à débordement</h4>
                                <p>Un bassin chauffé avec vue panoramique sur la mer.</p>
                            </div>
                        </div>

                        <div class="service-ligne">
                            <div class="service-icone">
                                <i class="fa-solid fa-hot-tub-person"></i>
                            </div>
                            <div>
                                <h4>Hammam &amp; Sauna</h4>
                                <p>Purification et détente intense dans un cadre chaleureux.</p>
                            </div>
                        </div>

                    </div>
                </div>

                <!-- Colonne droite : Images -->
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
            <div class="prestations-wrapper">

                <div class="prestations-intro">
                    <p class="section-subtitle">Notre carte des soins</p>
                    <h2 class="titre-souligne">Des soins pour le corps et l'esprit</h2>

                    <p class="prestations-desc">
                        Découvrez notre sélection de soins signatures, conçus pour vous offrir
                        un moment de détente absolue. Nos thérapeutes diplômés vous accompagnent
                        dans un voyage sensoriel unique.
                    </p>

                    <a href="reservation.html" class="btn-contour">Réserver un soin</a>
                </div>

                <div class="prestations-cards">
                    <article class="card-pullman">
                        <div class="card-img">
                            <img src="images/massage3.jpg" alt="Massages relaxants">
                        </div>
                        <div class="card-body">
                            <h3>Massages</h3>
                            <p>Massages relaxants aux huiles essentielles et pierres chaudes.</p>
                            <span class="prix">En savoir plus →</span>
                        </div>
                    </article>

                    <article class="card-pullman">
                        <div class="card-img">
                            <img src="images/Yoga2.jpg" alt="Yoga face à la mer">
                        </div>
                        <div class="card-body">
                            <h3>Yoga &amp; Méditation</h3>
                            <p>Séances guidées face à la mer pour retrouver l'équilibre.</p>
                            <span class="prix">En savoir plus →</span>
                        </div>
                    </article>

                    <article class="card-pullman">
                        <div class="card-img">
                            <img src="images/Hamman.jpg" alt="Hammam et sauna">
                        </div>
                        <div class="card-body">
                            <h3>Hammam &amp; Sauna</h3>
                            <p>Un moment de purification et de détente intense.</p>
                            <span class="prix">En savoir plus →</span>
                        </div>
                    </article>
                </div>

            </div>
        </div>
    </section>

    <!-- ============================================================
         BANNIÈRE VERTE — "Votre journée bien-être"
         ============================================================ -->
    <section class="banniere-verte">
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
                    <a href="reservation.html" class="btn-blanc">Réserver</a>
                </div>

            </div>
        </div>
    </section>

    <!-- ============================================================
         SECTION — Horaires & Accès
         ============================================================ -->
    <section class="section section-blanche section-horaires">
        <div class="container">
            <div class="horaires-wrapper">

                <div class="horaires-titre">
                    <p class="section-subtitle">Informations Pratiques</p>
                    <h2 class="titre-souligne">Horaires &amp; Accès</h2>
                </div>

                <div class="horaires-grid">

                    <div class="horaire-item">
                        <div class="horaire-icone">
                            <i class="fa-solid fa-water-ladder"></i>
                        </div>
                        <h4>Piscine</h4>
                        <p>Ouverte tous les jours<br>de 7h00 à 22h00</p>
                    </div>

                    <div class="horaire-item">
                        <div class="horaire-icone">
                            <i class="fa-solid fa-spa"></i>
                        </div>
                        <h4>Spa</h4>
                        <p>Sur rendez-vous<br>de 9h00 à 20h00</p>
                    </div>

                    <div class="horaire-item">
                        <div class="horaire-icone">
                            <i class="fa-solid fa-location-dot"></i>
                        </div>
                        <h4>Accès</h4>
                        <p>Clients de l'hôtel<br>et visiteurs extérieurs</p>
                    </div>

                    <div class="horaire-item">
                        <div class="horaire-icone">
                            <i class="fa-solid fa-phone"></i>
                        </div>
                        <h4>Réservations</h4>
                        <p>+221 33 869 66 66<br>spa@pullman-dakar.com</p>
                    </div>

                </div>
            </div>
        </div>
    </section>

</div><!-- /.piscine-page -->
</main>

<!-- ============================== CTA SITE ============================== -->
<section class="booking-section">
    <div class="container">
        <h2>PRÊT POUR VOTRE PROCHAINE <span class="highlight">ÉVASION</span> ?</h2>
        <p class="subtitle">Réservez maintenant et vivez l'expérience Pullman Dakar Teranga.</p>

        <div class="booking-widget">
            <div class="widget-field">
                <span class="icon-field"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M2 4v16"></path><path d="M2 8h18a2 2 0 0 1 2 2v10"></path><path d="M2 17h20"></path><path d="M6 8v9"></path></svg></span>
                <div class="field-info">
                    <label>Chambre</label>
                    <select id="cta-chambre" class="cta-select">
                        <option value="1 chambre">1 chambre</option>
                        <option value="2 chambres">2 chambres</option>
                        <option value="3 chambres">3 chambres</option>
                    </select>
                </div>
            </div>
            <div class="widget-field">
                <span class="icon-field"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg></span>
                <div class="field-info">
                    <label>Arrivée</label>
                    <input type="text" id="cta-checkin" class="cta-date-input" placeholder="Sélectionner" readonly>
                </div>
            </div>
            <div class="widget-field">
                <span class="icon-field"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line><path d="m9 16 2 2 4-4"></path></svg></span>
                <div class="field-info">
                    <label>Départ</label>
                    <input type="text" id="cta-checkout" class="cta-date-input" placeholder="Sélectionner" readonly>
                </div>
            </div>
            <div class="widget-field">
                <span class="icon-field"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M22 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg></span>
                <div class="field-info">
                    <label>Hôtes</label>
                    <select id="cta-hotes" class="cta-select">
                        <option value="1 personne">1 personne</option>
                        <option value="2 personnes" selected>2 personnes</option>
                        <option value="3 personnes">3 personnes</option>
                        <option value="4 personnes">4 personnes</option>
                    </select>
                </div>
            </div>
            <button type="button" class="btn-submit">
                VÉRIFIER LES<br>DISPONIBILITÉS
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><line x1="5" y1="12" x2="19" y2="12"></line><polyline points="12 5 19 12 12 19"></polyline></svg>
            </button>
        </div>

        <div class="booking-features">
            <div class="feature-item">
                <span class="icon-circle"><i class="fas fa-certificate"></i></span>
                <span>Meilleur tarif garanti</span>
            </div>
            <div class="feature-item">
                <span class="icon-circle"><i class="fas fa-calendar-check"></i></span>
                <span>Annulation flexible</span>
            </div>
            <div class="feature-item">
                <span class="icon-circle"><i class="fas fa-lock"></i></span>
                <span>Paiement sécurisé</span>
            </div>
        </div>
    </div>
</section>

<!-- ============================== FOOTER ============================== -->
<footer class="main-footer">
    <div class="container">
        <div class="footer-grid">
            <div class="footer-col brand-col">
                <div class="footer-logo">
                    <img src="images/logo-pullman-white.png" alt="Pullman Hotels and Resorts" class="img-manual-logo">
                </div>
                <div class="contact-details">
                    <p><i class="fa-solid fa-location-dot icon-contact"></i> Pullman Dakar Teranga<br>Route de la Corniche Ouest<br>BP 8181, Dakar, Sénégal</p>
                    <p><i class="fa-solid fa-phone icon-contact"></i> +221 33 869 66 66</p>
                    <p><i class="fa-regular fa-envelope icon-contact"></i> HB076@accor.com</p>
                </div>
            </div>
            <div class="footer-col">
                <h4 class="footer-title">LIENS UTILES</h4>
                <ul>
                    <li><a href="#">Mentions légales</a></li>
                    <li><a href="#">Conditions générales</a></li>
                    <li><a href="#">Politique de confidentialité</a></li>
                    <li><a href="#">Accessibilité</a></li>
                </ul>
            </div>
            <div class="footer-col">
                <h4 class="footer-title">DÉCOUVRIR</h4>
                <ul>
                    <li><a href="chambres.html">Nos chambres</a></li>
                    <li><a href="experiences.html">Expériences</a></li>
                    <li><a href="#">Offres spéciales</a></li>
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

<!-- ============================== SCRIPTS ============================== -->
<script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
<script src="https://cdn.jsdelivr.net/npm/flatpickr/dist/l10n/fr.js"></script>

<script src="js/booking-bridge.js"></script>
<script src="js/i18n.js"></script>

</body>
</html>
HTML_EOF

echo -e "${GREEN}   ✔ experiences-piscine.html créé${NC}\n"

# ============================================================
# 2. CSS ALIGNÉ SUR LA CHARTE PULLMAN
# ============================================================
echo -e "${BLUE}━━━ [2/3] Création du CSS aligné ━━━${NC}"

cat > css/services-piscine.css << 'CSS_EOF'
/* ============================================================= */
/* SERVICES-PISCINE.CSS — Page Piscine & Spa                     */
/* Responsable : Rock Melvin                                     */
/* Tous les sélecteurs sont scopés sous .piscine-page            */
/* Couleurs alignées sur la charte Pullman (variables.css)       */
/* ============================================================= */

.piscine-page {
    --vert-pullman: var(--couleur-vert, #38E28F);
    --bleu-pullman: var(--couleur-bleu-profond, #155E75);
    --sable-pullman: var(--couleur-sable, #C8A77A);
    --texte-sombre: #1A2B3C;
    --texte-gris: #6A7580;
    --ligne-grise: #E8ECEF;
}

/* ================= HERO ================= */
.piscine-page .hero-spa {
    position: relative;
    min-height: 620px;
    display: flex;
    align-items: center;
    overflow: hidden;
    color: #fff;
}
.piscine-page .hero-spa-bg {
    position: absolute;
    inset: 0;
    background-image: url('../images/piscinehorizon.jpg');
    background-size: cover;
    background-position: center;
    background-repeat: no-repeat;
    z-index: 1;
    transform: scale(1.05);
}
.piscine-page .hero-spa-overlay {
    position: absolute;
    inset: 0;
    background: linear-gradient(90deg,
        rgba(10, 30, 45, 0.85) 0%,
        rgba(10, 30, 45, 0.55) 45%,
        rgba(10, 30, 45, 0.15) 100%);
    z-index: 2;
}
.piscine-page .hero-spa-content {
    position: relative;
    z-index: 3;
    max-width: 1200px;
    margin: 0 auto;
    padding: 60px 40px;
    width: 100%;
}
.piscine-page .breadcrumb {
    font-size: 0.8rem;
    letter-spacing: 1.5px;
    text-transform: uppercase;
    margin-bottom: 25px;
    opacity: 0.85;
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
    font-size: clamp(2.5rem, 5vw, 4rem);
    font-weight: 800;
    line-height: 1.05;
    letter-spacing: 2px;
    text-transform: uppercase;
    margin-bottom: 20px;
    max-width: 650px;
    color: #ffffff;
}
.piscine-page .trait-vert {
    display: block;
    width: 65px;
    height: 4px;
    background: var(--vert-pullman);
    border-radius: 2px;
    margin-bottom: 25px;
}
.piscine-page .hero-spa-texte {
    font-size: 1rem;
    line-height: 1.85;
    max-width: 560px;
    margin-bottom: 35px;
    opacity: 0.95;
}

/* ================= SECTIONS ================= */
.piscine-page .section {
    padding: 100px 0;
}
.piscine-page .section-blanche {
    background: #ffffff;
}
.piscine-page .section-grise {
    background: #F5F7F6;
}
.piscine-page .container {
    max-width: 1280px;
    margin: 0 auto;
    padding: 0 50px;
}

.piscine-page .section-subtitle {
    color: var(--vert-pullman);
    font-size: 0.75rem;
    font-weight: 700;
    letter-spacing: 3px;
    text-transform: uppercase;
    margin-bottom: 12px;
}
.piscine-page .section-subtitle-blanc {
    color: #A8E6CF;
    font-size: 0.75rem;
    font-weight: 700;
    letter-spacing: 3px;
    text-transform: uppercase;
    margin-bottom: 12px;
}
.piscine-page .titre-souligne {
    position: relative;
    display: inline-block;
    font-size: clamp(1.6rem, 2.5vw, 2.2rem);
    font-weight: 700;
    color: var(--texte-sombre);
    padding-bottom: 22px;
    line-height: 1.3;
    text-align: left;
}
.piscine-page .titre-souligne::after {
    content: "";
    position: absolute;
    bottom: 0;
    left: 0;
    width: 60px;
    height: 4px;
    background: var(--vert-pullman);
    border-radius: 2px;
}

/* ================= BIENFAITS ================= */
.piscine-page .section-bienfaits {
    padding: 70px 0;
    background: #fff;
}
.piscine-page .bienfaits-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 70px;
    align-items: center;
}
.piscine-page .bienfaits-texte .titre-souligne {
    font-size: 1.6rem;
    padding-bottom: 16px;
    margin-bottom: 25px;
}
.piscine-page .bienfaits-texte .titre-souligne::after {
    width: 50px;
    height: 3px;
}
.piscine-page .bienfaits-desc {
    font-size: 0.9rem;
    color: var(--texte-gris);
    line-height: 1.75;
    margin-bottom: 35px;
    max-width: 480px;
}
.piscine-page .icones-grid {
    display: flex;
    gap: 30px;
    flex-wrap: wrap;
}
.piscine-page .icone-item {
    text-align: center;
    min-width: 70px;
}
.piscine-page .icone-cercle {
    display: inline-flex;
    justify-content: center;
    align-items: center;
    width: 50px;
    height: 50px;
    border-radius: 50%;
    background: rgba(56, 226, 143, 0.12);
    color: var(--vert-pullman);
    font-size: 18px;
    margin-bottom: 10px;
    transition: transform 0.3s, background 0.3s;
}
.piscine-page .icone-item:hover .icone-cercle {
    transform: translateY(-3px);
    background: rgba(56, 226, 143, 0.2);
}
.piscine-page .icone-item p {
    font-size: 0.8rem;
    font-weight: 600;
    color: var(--texte-sombre);
    margin: 0;
    letter-spacing: 0.3px;
}
.piscine-page .bienfaits-image img {
    width: 100%;
    height: 380px;
    object-fit: cover;
    border-radius: 10px;
}

/* ================= ART DU SPA ================= */
.piscine-page .section-art-spa {
    padding: 80px 0;
    background: #F5F7F6;
}
.piscine-page .art-spa-grid {
    display: grid;
    grid-template-columns: 1fr 1.1fr;
    gap: 60px;
    align-items: center;
}
.piscine-page .art-spa-texte .titre-souligne {
    font-size: 1.6rem;
    padding-bottom: 16px;
    margin-bottom: 22px;
}
.piscine-page .art-spa-texte .titre-souligne::after {
    width: 50px;
    height: 3px;
}
.piscine-page .art-spa-desc {
    font-size: 0.9rem;
    color: var(--texte-gris);
    line-height: 1.75;
    margin-bottom: 35px;
    max-width: 480px;
}
.piscine-page .services-liste {
    display: flex;
    flex-direction: column;
    gap: 22px;
}
.piscine-page .service-ligne {
    display: flex;
    align-items: flex-start;
    gap: 16px;
}
.piscine-page .service-icone {
    display: inline-flex;
    justify-content: center;
    align-items: center;
    min-width: 44px;
    height: 44px;
    border-radius: 50%;
    background: rgba(21, 94, 117, 0.08);
    color: var(--bleu-pullman);
    font-size: 16px;
    flex-shrink: 0;
}
.piscine-page .service-ligne h4 {
    color: var(--texte-sombre);
    font-size: 0.95rem;
    font-weight: 700;
    margin-bottom: 4px;
}
.piscine-page .service-ligne p {
    font-size: 0.83rem;
    color: var(--texte-gris);
    line-height: 1.5;
    margin: 0;
}
.piscine-page .art-spa-images {
    display: flex;
    flex-direction: column;
    gap: 15px;
}
.piscine-page .image-principale img {
    width: 100%;
    height: 280px;
    object-fit: cover;
    border-radius: 10px;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
}
.piscine-page .images-secondaires {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 12px;
}
.piscine-page .images-secondaires img {
    width: 100%;
    height: 110px;
    object-fit: cover;
    border-radius: 8px;
    transition: transform 0.3s;
}
.piscine-page .images-secondaires img:hover {
    transform: scale(1.03);
}

/* ================= PRESTATIONS ================= */
.piscine-page .section-prestations {
    padding: 80px 0;
    background: #fff;
}
.piscine-page .prestations-wrapper {
    display: grid;
    grid-template-columns: 1fr 2.2fr;
    gap: 60px;
    align-items: center;
}
.piscine-page .prestations-intro .titre-souligne {
    font-size: 1.6rem;
    padding-bottom: 16px;
    margin-bottom: 25px;
}
.piscine-page .prestations-intro .titre-souligne::after {
    width: 50px;
    height: 3px;
}
.piscine-page .prestations-desc {
    font-size: 0.9rem;
    color: var(--texte-gris);
    line-height: 1.75;
    margin-bottom: 28px;
    max-width: 380px;
}
.piscine-page .btn-contour {
    display: inline-block;
    padding: 12px 28px;
    border: 1.5px solid var(--bleu-pullman);
    border-radius: 30px;
    color: var(--bleu-pullman);
    text-decoration: none;
    font-size: 0.8rem;
    font-weight: 600;
    letter-spacing: 0.5px;
    transition: all 0.3s;
}
.piscine-page .btn-contour:hover {
    background: var(--bleu-pullman);
    color: #fff;
}
.piscine-page .prestations-cards {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 18px;
}
.piscine-page .card-pullman {
    background: #fff;
    border: 1px solid var(--ligne-grise);
    border-radius: 10px;
    overflow: hidden;
    transition: transform 0.3s, box-shadow 0.3s, border-color 0.3s;
    display: flex;
    flex-direction: column;
}
.piscine-page .card-pullman:hover {
    transform: translateY(-5px);
    box-shadow: 0 15px 35px rgba(0, 0, 0, 0.08);
    border-color: var(--vert-pullman);
}
.piscine-page .card-img {
    overflow: hidden;
    height: 150px;
}
.piscine-page .card-img img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    transition: transform 0.5s;
    display: block;
}
.piscine-page .card-pullman:hover .card-img img {
    transform: scale(1.06);
}
.piscine-page .card-body {
    padding: 18px;
    display: flex;
    flex-direction: column;
    flex: 1;
}
.piscine-page .card-body h3 {
    color: var(--texte-sombre);
    font-size: 0.95rem;
    font-weight: 700;
    margin-bottom: 6px;
}
.piscine-page .card-body p {
    font-size: 0.78rem;
    color: var(--texte-gris);
    line-height: 1.55;
    margin-bottom: 14px;
    flex: 1;
}
.piscine-page .prix {
    display: inline-block;
    color: var(--vert-pullman);
    font-weight: 700;
    font-size: 0.8rem;
    margin-top: auto;
    transition: transform 0.3s;
}
.piscine-page .card-pullman:hover .prix {
    transform: translateX(4px);
}

/* ================= BANNIÈRE VERTE ================= */
.piscine-page .banniere-verte {
    padding: 40px 40px;
}
.piscine-page .banniere-container {
    max-width: 1200px;
    margin: 0 auto;
    padding: 55px 50px;
    border-radius: 12px;
    position: relative;
    overflow: hidden;
    background: linear-gradient(135deg, #0A8F66 0%, #007A54 100%);
    color: #fff;
}
.piscine-page .banniere-container::before {
    content: "";
    position: absolute;
    inset: 0;
    background-image:
        radial-gradient(circle at 20% 40%, rgba(255,255,255,0.06) 0%, transparent 40%),
        radial-gradient(circle at 80% 70%, rgba(255,255,255,0.05) 0%, transparent 35%),
        radial-gradient(circle at 50% 100%, rgba(0,0,0,0.1) 0%, transparent 50%);
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
    font-size: clamp(1.5rem, 2.2vw, 1.9rem);
    font-weight: 700;
    margin: 8px 0 15px;
    line-height: 1.2;
    color: #fff;
}
.piscine-page .banniere-texte p {
    font-size: 0.92rem;
    line-height: 1.7;
    opacity: 0.92;
}
.piscine-page .banniere-liste {
    list-style: none;
    padding: 0;
    margin: 0;
    display: flex;
    flex-direction: column;
    gap: 16px;
}
.piscine-page .banniere-liste li {
    display: flex;
    align-items: center;
    gap: 12px;
    font-size: 0.88rem;
    line-height: 1.4;
    opacity: 0.95;
}
.piscine-page .liste-icone {
    display: inline-flex;
    justify-content: center;
    align-items: center;
    min-width: 28px;
    height: 28px;
    border-radius: 50%;
    background: rgba(255, 255, 255, 0.15);
    border: 1px solid rgba(255, 255, 255, 0.3);
    font-size: 0.85rem;
    flex-shrink: 0;
    color: #fff;
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
    font-size: clamp(2rem, 3vw, 2.8rem);
    font-weight: 800;
    margin: 8px 0;
    line-height: 1;
    color: #fff;
}
.piscine-page .btn-blanc {
    display: inline-block;
    background: #fff;
    color: #007A54;
    text-decoration: none;
    padding: 12px 32px;
    border-radius: 30px;
    font-weight: 700;
    font-size: 0.75rem;
    letter-spacing: 1.5px;
    text-transform: uppercase;
    margin-top: 18px;
    transition: transform 0.3s, box-shadow 0.3s;
}
.piscine-page .btn-blanc:hover {
    transform: translateY(-2px);
    box-shadow: 0 8px 25px rgba(0, 0, 0, 0.2);
}

/* ================= HORAIRES ================= */
.piscine-page .section-horaires {
    padding: 70px 0;
    background: #fff;
}
.piscine-page .horaires-wrapper {
    display: grid;
    grid-template-columns: 280px 1fr;
    gap: 60px;
    align-items: center;
}
.piscine-page .horaires-titre .titre-souligne {
    font-size: 1.8rem;
    padding-bottom: 18px;
    line-height: 1.2;
}
.piscine-page .horaires-titre .titre-souligne::after {
    width: 50px;
    height: 3px;
}
.piscine-page .horaires-grid {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
}
.piscine-page .horaire-item {
    text-align: left;
    padding: 0 25px;
    border-left: 1px solid var(--ligne-grise);
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
    width: 42px;
    height: 42px;
    border-radius: 50%;
    background: #fff;
    border: 1px solid var(--ligne-grise);
    color: var(--bleu-pullman);
    font-size: 16px;
    margin-bottom: 18px;
    transition: all 0.3s;
}
.piscine-page .horaire-item:hover .horaire-icone {
    border-color: var(--vert-pullman);
    background: rgba(56, 226, 143, 0.08);
    color: var(--vert-pullman);
}
.piscine-page .horaire-item h4 {
    color: var(--texte-sombre);
    font-size: 0.95rem;
    font-weight: 700;
    margin-bottom: 8px;
    text-transform: none;
}
.piscine-page .horaire-item p {
    font-size: 0.85rem;
    color: var(--texte-gris);
    line-height: 1.6;
    margin: 0;
}

/* ================= RESPONSIVE ================= */
@media (max-width: 992px) {
    .piscine-page .container { padding: 0 25px; }
    .piscine-page .section { padding: 60px 0; }
    .piscine-page .bienfaits-grid,
    .piscine-page .art-spa-grid,
    .piscine-page .prestations-wrapper,
    .piscine-page .horaires-wrapper {
        grid-template-columns: 1fr;
        gap: 40px;
    }
    .piscine-page .bienfaits-image img { height: 300px; }
    .piscine-page .image-principale img { height: 240px; }
    .piscine-page .images-secondaires img { height: 90px; }
    .piscine-page .prestations-desc { max-width: 600px; }
    .piscine-page .horaires-grid {
        grid-template-columns: repeat(2, 1fr);
        row-gap: 40px;
    }
    .piscine-page .horaire-item:nth-child(3) {
        border-left: none;
        padding-left: 0;
    }
    .piscine-page .banniere-verte { padding: 20px; }
    .piscine-page .banniere-container { padding: 40px 30px; }
    .piscine-page .banniere-grid {
        grid-template-columns: 1fr;
        gap: 30px;
        text-align: center;
    }
    .piscine-page .banniere-prix {
        border-left: none;
        border-top: 1px solid rgba(255, 255, 255, 0.25);
        padding: 30px 0 0;
    }
    .piscine-page .banniere-liste li {
        justify-content: center;
    }
}
@media (max-width: 768px) {
    .piscine-page .prestations-cards {
        grid-template-columns: 1fr;
    }
    .piscine-page .card-img { height: 200px; }
}
@media (max-width: 576px) {
    .piscine-page .hero-spa { min-height: 520px; }
    .piscine-page .hero-spa-content { padding: 40px 20px; }
    .piscine-page .hero-spa h1 { font-size: 2rem; }
    .piscine-page .icones-grid { gap: 20px; }
    .piscine-page .icone-cercle { width: 44px; height: 44px; }
    .piscine-page .bienfaits-texte .titre-souligne { font-size: 1.35rem; }
    .piscine-page .images-secondaires { gap: 8px; }
    .piscine-page .images-secondaires img { height: 70px; }
    .piscine-page .horaires-grid { grid-template-columns: 1fr; }
}
CSS_EOF

echo -e "${GREEN}   ✔ css/services-piscine.css créé${NC}\n"

# ============================================================
# 3. VÉRIFICATION
# ============================================================
echo -e "${BLUE}━━━ [3/3] VÉRIFICATION ━━━${NC}"

printf "   %-40s | %s\n" "Élément" "Valeur"
printf "   %-40s-|-%s\n" "----------------------------------------" "--------"

check_file() {
    if [ -f "$1" ]; then
        local lines=$(wc -l < "$1")
        echo -e "   ${GREEN}✔${NC} $1 ($lines lignes)"
    else
        echo -e "   ${RED}✘${NC} $1 MANQUANT"
    fi
}

check_file "experiences-piscine.html"
check_file "css/services-piscine.css"

echo ""
echo -e "   ${BLUE}Contrôle HTML :${NC}"

H=$(cat experiences-piscine.html)
printf "   %-40s | %s\n" "Scopé sous .piscine-page" "$(echo "$H" | grep -c 'piscine-page' || echo 0)"
printf "   %-40s | %s\n" "Header Pullman complet" "$(echo "$H" | grep -c 'lang-menu' || echo 0)"
printf "   %-40s | %s\n" "CTA réservation" "$(echo "$H" | grep -c 'booking-section' || echo 0)"
printf "   %-40s | %s\n" "Footer complet" "$(echo "$H" | grep -c 'main-footer' || echo 0)"
printf "   %-40s | %s\n" "Flatpickr JS chargé" "$(echo "$H" | grep -c 'flatpickr\"' || echo 0)"
printf "   %-40s | %s\n" "booking-bridge.js chargé" "$(echo "$H" | grep -c 'booking-bridge' || echo 0)"
printf "   %-40s | %s\n" "Images dans images/" "$(echo "$H" | grep -o 'src=\"images/' | wc -l)"

echo ""
echo -e "   ${BLUE}Contrôle CSS :${NC}"

C=$(cat css/services-piscine.css)
printf "   %-40s | %s\n" "Scopé sous .piscine-page" "$(echo "$C" | grep -c '\.piscine-page' || echo 0)"
printf "   %-40s | %s\n" "Utilise var(--couleur-vert)" "$(echo "$C" | grep -c 'var(--couleur-vert' || echo 0)"
printf "   %-40s | %s\n" "Utilise var(--couleur-bleu-profond)" "$(echo "$C" | grep -c 'var(--couleur-bleu-profond' || echo 0)"
printf "   %-40s | %s\n" "Aucun 'color: none'" "$(echo "$C" | grep -c 'color: none' || echo 0) (0 attendu)"
printf "   %-40s | %s\n" "Aucun 'background: none'" "$(echo "$C" | grep -c 'background: none' || echo 0) (0 attendu)"

echo ""
echo -e "${GREEN}✅ INTÉGRATION TERMINÉE${NC}"
echo -e "${BLUE}💾 Sauvegarde : $BACKUP${NC}"
echo ""
echo -e "${BLUE}📌 Étapes suivantes :${NC}"
echo "   1. Vérifiez que les images existent dans images/ :"
echo "      - piscinehorizon.jpg"
echo "      - piscine.jpg"
echo "      - ocean.jpg"
echo "      - yogab.jpg"
echo "      - imagesoin.webp"
echo "      - massage3.jpg"
echo "      - Yoga2.jpg"
echo "      - Hamman.jpg"
echo ""
echo "   2. Vérifiez que le lien vers experiences.html existe OU"
echo "      remplacez par services.html dans le menu si vous gardez l'ancien nom"
echo ""
echo "   3. Ctrl+Shift+R dans le navigateur"
echo ""
echo -e "${BLUE}🔄 Rollback :${NC}"
echo "   cp $BACKUP/*.html . 2>/dev/null"
echo "   cp $BACKUP/*.css css/ 2>/dev/null"
