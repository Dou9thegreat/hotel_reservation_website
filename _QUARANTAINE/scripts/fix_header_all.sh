#!/bin/bash
# ============================================================
# Uniformisation TOTALE du header - Pullman Dakar Teranga
# ============================================================

set -e
BACKUP_DIR=".backup_header_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"
cp *.html "$BACKUP_DIR/" 2>/dev/null || true
echo "📦 Sauvegarde → $BACKUP_DIR"

# ---- 1) Renommer services -> experiences -----------------
[ -f "services.html" ] && [ ! -f "experiences.html" ] && mv services.html experiences.html && echo "🔁 services.html → experiences.html"
[ -f "services-piscine.html" ] && [ ! -f "experiences-piscine.html" ] && mv services-piscine.html experiences-piscine.html && echo "🔁 services-piscine.html → experiences-piscine.html"
[ -f "services-restaurant.html" ] && [ ! -f "experiences-restaurant.html" ] && mv services-restaurant.html experiences-restaurant.html && echo "🔁 services-restaurant.html → experiences-restaurant.html"

# ---- 2) Corriger liens internes --------------------------
perl -i -pe '
    s/href="services\.html"/href="experiences.html"/g;
    s/href="services-piscine\.html"/href="experiences-piscine.html"/g;
    s/href="services-restaurant\.html"/href="experiences-restaurant.html"/g;
    s/href="events\.html"/href="evenements.html"/g;
    s/href="#chambres-section"/href="chambres.html"/g;
    s/href="#experiences-section"/href="experiences.html"/g;
    s/href="#evenements-section"/href="evenements.html"/g;
' *.html
echo "🔗 Liens internes corrigés"

# ---- 3) Générateur de header -----------------------------
generate_header() {
    local active="$1"
    local c_acc="" c_cha="" c_exp="" c_gal="" c_evt="" c_con=""
    case "$active" in
        index)       c_acc=' class="active"' ;;
        chambres)    c_cha=' class="active"' ;;
        experiences) c_exp=' class="active"' ;;
        galerie)     c_gal=' class="active"' ;;
        evenements)  c_evt=' class="active"' ;;
        contact)     c_con=' class="active"' ;;
    esac

    cat <<EOF
<header class="site-header">
    <div class="topbar">
        <div class="lang-switch">Français <span class="chevron">▾</span></div>
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
            <a href="index.html"${c_acc}>ACCUEIL</a>
            <span class="nav-sep">|</span>

            <a href="chambres.html"${c_cha}>CHAMBRES</a>
            <span class="nav-sep">|</span>

            <div class="dropdown">
                <a href="experiences.html"${c_exp}>EXPÉRIENCES</a>
                <div class="dropdown-content">
                    <a href="experiences-piscine.html">Piscine + Spa</a>
                    <a href="experiences-restaurant.html">Restaurant + Wifi</a>
                </div>
            </div>
            <span class="nav-sep">|</span>

            <a href="galerie.html"${c_gal}>GALERIE</a>
            <span class="nav-sep">|</span>

            <a href="evenements.html"${c_evt}>MEETING &amp; EVENTS</a>
            <span class="nav-sep">|</span>

            <a href="contact.html"${c_con}>CONTACT</a>
        </nav>

        <a href="reservation.html" class="btn-reserver">Réserver maintenant</a>
    </div>
</header>
EOF
}

# ---- 4) Remplacement du header sur 1 fichier -------------
replace_header() {
    local file="$1" active="$2"
    [ ! -f "$file" ] && { echo "⚠️  Absent : $file"; return; }

    generate_header "$active" > /tmp/new_hdr.html
    export NEW_HEADER="$(cat /tmp/new_hdr.html)"

    # Remplace TOUT <header ...> ... </header> (multi-lignes, non-greedy)
    perl -i -0777 -pe 's|<header[^>]*>.*?</header>|$ENV{NEW_HEADER}|gs' "$file"

    unset NEW_HEADER
    echo "✅ $file  (active=$active)"
}

# ---- 5) Application sur TOUTES les pages -----------------
replace_header "index.html"                  "index"
replace_header "chambres.html"               "chambres"
replace_header "experiences.html"            "experiences"
replace_header "experiences-piscine.html"    "experiences"
replace_header "experiences-restaurant.html" "experiences"
replace_header "galerie.html"                "galerie"
replace_header "evenements.html"             "evenements"
replace_header "contact.html"                "contact"
replace_header "reservation.html"            ""

# Pages obsolètes si elles existent encore
for f in chambre-superieure.html chambre-deluxe.html suite.html; do
    [ -f "$f" ] && replace_header "$f" "chambres"
done

echo ""
echo "==========================================="
echo "✅ TERMINÉ"
echo "💾 Sauvegarde : $BACKUP_DIR"
echo "⚠️  Fais Ctrl+F5 dans le navigateur pour voir les changements."
echo "==========================================="
