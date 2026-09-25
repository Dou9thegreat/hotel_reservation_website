#!/bin/bash
# ============================================================
# Uniformisation du top-menu - Pullman Dakar Teranga
# Usage : bash uniformiser-menu.sh
# ============================================================

BACKUP_DIR=".backup_headers"
mkdir -p "$BACKUP_DIR"

# ---------- 1) Renommer services.html -> experiences.html ----------
if [ -f "services.html" ] && [ ! -f "experiences.html" ]; then
    mv services.html experiences.html
    echo "🔁 services.html -> experiences.html"
fi

# ---------- 2) Génération du header (avec état actif) ----------
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

# ---------- 3) Remplacement du header dans un fichier ----------
replace_header() {
    local file="$1" active="$2"

    if [ ! -f "$file" ]; then
        echo "⚠️  Absent, ignoré : $file"
        return
    fi

    cp "$file" "$BACKUP_DIR/$(basename "$file").bak"
    generate_header "$active" > /tmp/new_header.html

    awk '
        /<header class="site-header">/ {
            in_header = 1
            while ((getline l < "/tmp/new_header.html") > 0) print l
            close("/tmp/new_header.html")
            next
        }
        in_header && /<\/header>/ { in_header = 0; next }
        !in_header { print }
    ' "$file" > "$file.tmp"

    mv "$file.tmp" "$file"
    echo "✅ $file"
}

# ---------- 4) Application sur toutes les pages ----------
replace_header "index.html"                  "index"
replace_header "chambres.html"               "chambres"
replace_header "contact.html"                "contact"
replace_header "evenements.html"             "evenements"
replace_header "experiences.html"            "experiences"
replace_header "experiences-piscine.html"    "experiences"
replace_header "experiences-restaurant.html" "experiences"
replace_header "galerie.html"                "galerie"
replace_header "reservation.html"            ""

# Pages obsolètes (plus dans le menu) — traitées si présentes
for f in chambre-superieure.html chambre-deluxe.html suite.html gabarit.html; do
    [ -f "$f" ] && replace_header "$f" ""
done

echo ""
echo "✨ Terminé ! Sauvegardes dans $BACKUP_DIR/"
