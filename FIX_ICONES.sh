#!/bin/bash
set -e

BACKUP=".backup_ICONES_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP"
cp *.html "$BACKUP/" 2>/dev/null
echo "📦 Sauvegarde → $BACKUP"
echo ""

PAGES="index.html chambres.html contact.html galerie.html evenements.html experiences.html experiences-piscine.html experiences-restaurant.html reservation.html"

# ============================================================
# ÉTAPE 1 — Ajouter Font Awesome aux pages qui l'oublient
# ============================================================
echo "─── ÉTAPE 1 : Ajout Font Awesome ───"
for f in $PAGES; do
    [ ! -f "$f" ] && continue
    if grep -q 'font-awesome\|fontawesome' "$f"; then
        echo "  ℹ️  $f — FA déjà présent"
        continue
    fi
    # Insérer juste avant </head>
    perl -0777 -i -pe 's|</head>|    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">\n</head>|' "$f"
    echo "  ✅ $f — FA ajouté"
done
echo ""

# ============================================================
# ÉTAPE 2 — Remplacer les icônes CTA par SVG inline
# ============================================================
echo "─── ÉTAPE 2 : SVG inline pour le CTA ───"

# --- Calendrier (Arrivée) ---
SVG_CALENDAR='<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>'

# --- Calendrier check (Départ) ---
SVG_CALENDAR_CHECK='<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line><path d="m9 16 2 2 4-4"></path></svg>'

# --- Lit (Chambres) ---
SVG_BED='<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M2 4v16"></path><path d="M2 8h18a2 2 0 0 1 2 2v10"></path><path d="M2 17h20"></path><path d="M6 8v9"></path></svg>'

# --- Groupe utilisateurs (Voyageurs) ---
SVG_USERS='<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M22 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg>'

# --- Award / Meilleur tarif ---
SVG_AWARD='<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="8" r="6"></circle><path d="M15.477 12.89 17 22l-5-3-5 3 1.523-9.11"></path></svg>'

# --- Rotation (Annulation) ---
SVG_ROTATE='<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M2.5 2v6h6"></path><path d="M2.66 15.57a10 10 0 1 0 .57-8.38"></path></svg>'

# --- Bouclier (Paiement) ---
SVG_SHIELD='<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path></svg>'

# --- Flèche (Bouton) ---
SVG_ARROW='<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><line x1="5" y1="12" x2="19" y2="12"></line><polyline points="12 5 19 12 12 19"></polyline></svg>'

# Échapper pour Perl
export SVG_CALENDAR SVG_CALENDAR_CHECK SVG_BED SVG_USERS SVG_AWARD SVG_ROTATE SVG_SHIELD SVG_ARROW

for f in $PAGES; do
    [ ! -f "$f" ] && continue

    # --- Icône Arrivée (far fa-calendar-alt ou fa-calendar-day) ---
    perl -0777 -i -pe 's|<span class="icon-field"><i class="fa[rs]? fa-calendar-alt"></i></span>|<span class="icon-field">$ENV{SVG_CALENDAR}</span>|g' "$f"
    perl -0777 -i -pe 's|<span class="icon-field"><i class="fa[rs]? fa-calendar-day"></i></span>|<span class="icon-field">$ENV{SVG_CALENDAR}</span>|g' "$f"

    # --- Icône Départ (2ème occurrence du calendar-alt) : on traite tous les restants ---
    perl -0777 -i -pe 's|<span class="icon-field"><i class="fa[rs]? fa-calendar-days"></i></span>|<span class="icon-field">$ENV{SVG_CALENDAR_CHECK}</span>|g' "$f"

    # --- Icône Lit ---
    perl -0777 -i -pe 's|<span class="icon-field"><i class="fa[rs]? fa-bed"></i></span>|<span class="icon-field">$ENV{SVG_BED}</span>|g' "$f"

    # --- Icône Voyageurs (user / user-group) ---
    perl -0777 -i -pe 's|<span class="icon-field"><i class="fa[rs]? fa-user-group"></i></span>|<span class="icon-field">$ENV{SVG_USERS}</span>|g' "$f"
    perl -0777 -i -pe 's|<span class="icon-field"><i class="fa[rs]? fa-user"></i></span>|<span class="icon-field">$ENV{SVG_USERS}</span>|g' "$f"

    # --- Badges ---
    perl -0777 -i -pe 's|<span class="icon-circle"><i class="fa[rs]? fa-certificate"></i></span>|<span class="icon-circle">$ENV{SVG_AWARD}</span>|g' "$f"
    perl -0777 -i -pe 's|<span class="icon-circle"><i class="fa[rs]? fa-award"></i></span>|<span class="icon-circle">$ENV{SVG_AWARD}</span>|g' "$f"
    perl -0777 -i -pe 's|<span class="icon-circle"><i class="fa[rs]? fa-calendar-check"></i></span>|<span class="icon-circle">$ENV{SVG_ROTATE}</span>|g' "$f"
    perl -0777 -i -pe 's|<span class="icon-circle"><i class="fa[rs]? fa-rotate-left"></i></span>|<span class="icon-circle">$ENV{SVG_ROTATE}</span>|g' "$f"
    perl -0777 -i -pe 's|<span class="icon-circle"><i class="fa[rs]? fa-lock"></i></span>|<span class="icon-circle">$ENV{SVG_SHIELD}</span>|g' "$f"
    perl -0777 -i -pe 's|<span class="icon-circle"><i class="fa[rs]? fa-shield-halved"></i></span>|<span class="icon-circle">$ENV{SVG_SHIELD}</span>|g' "$f"

    # --- Flèche du bouton ---
    perl -0777 -i -pe 's|<i class="fa[rs]? fa-arrow-right"></i>|$ENV{SVG_ARROW}|g' "$f"

    echo "  ✅ $f"
done

unset SVG_CALENDAR SVG_CALENDAR_CHECK SVG_BED SVG_USERS SVG_AWARD SVG_ROTATE SVG_SHIELD SVG_ARROW
echo ""

# ============================================================
# ÉTAPE 3 — CSS : s'assurer que les SVG s'affichent bien
# ============================================================
echo "─── ÉTAPE 3 : CSS de sécurité pour les SVG ───"

cat >> css/footer-cta.css << 'CSS_EOF'

/* ============================================================= */
/* CORRECTIF — SVG inline dans le CTA (affichage immédiat)       */
/* ============================================================= */
.booking-section .icon-field svg,
.booking-section .icon-circle svg,
.booking-section .btn-submit svg {
    display: block !important;
    flex-shrink: 0;
    width: 100%;
    height: 100%;
    max-width: 100%;
    max-height: 100%;
    stroke-linecap: round;
    stroke-linejoin: round;
}
.booking-section .icon-field svg {
    width: 18px !important;
    height: 18px !important;
}
.booking-section .icon-circle svg {
    width: 12px !important;
    height: 12px !important;
}
.booking-section .btn-submit svg {
    width: 14px !important;
    height: 14px !important;
    transition: transform .25s ease;
}
.booking-section .btn-submit:hover svg {
    transform: translateX(4px);
}
CSS_EOF
echo "  ✅ CSS SVG ajouté"
echo ""

# ============================================================
# ÉTAPE 4 — Vérification
# ============================================================
echo "─── VÉRIFICATION ───"
printf "  %-32s | %s | %s\n" "Fichier" "FA" "SVG"
printf "  %-32s-|-%s-|-%s\n" "--------------------------------" "--" "---"
for f in $PAGES; do
    [ ! -f "$f" ] && continue
    fa=$(grep -c 'font-awesome\|fontawesome' "$f" 2>/dev/null || echo 0)
    svg=$(grep -c 'viewBox' "$f" 2>/dev/null || echo 0)
    printf "  %-32s | %-2s | %-3s\n" "$f" "$fa" "$svg"
done

echo ""
echo "  Attendu : FA=1 et SVG≥7 sur chaque page"
echo ""
echo "==================================================="
echo "✅ TERMINÉ"
echo "💾 Sauvegarde : $BACKUP"
echo ""
echo "📌 Ctrl + F5 dans le navigateur"
echo "==================================================="
