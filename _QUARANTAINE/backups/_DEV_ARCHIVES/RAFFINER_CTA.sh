#!/bin/bash
set -e

BACKUP=".backup_RAFFINER_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP"
cp *.html "$BACKUP/" 2>/dev/null
cp css/footer-cta.css "$BACKUP/"
echo "📦 Sauvegarde → $BACKUP"

# 1) Ajouter le <span class="highlight"> autour d'ÉVASION dans le titre
PAGES="index.html chambres.html contact.html galerie.html evenements.html experiences.html experiences-piscine.html experiences-restaurant.html reservation.html"

for f in $PAGES; do
    [ ! -f "$f" ] && continue
    perl -0777 -i -pe 's|<h2>PRÊT POUR VOTRE PROCHAINE ÉVASION \?</h2>|<h2>PRÊT POUR VOTRE PROCHAINE <span class="highlight">ÉVASION</span> ?</h2>|g' "$f"
    perl -0777 -i -pe 's|<h2>PRÊT POUR VOTRE PROCHAINE ÉVASION&nbsp;\?</h2>|<h2>PRÊT POUR VOTRE PROCHAINE <span class="highlight">ÉVASION</span> ?</h2>|g' "$f"
    echo "  ✅ $f"
done

# 2) Corriger la troncature "Sélectionne" → augmenter largeur des champs
cat >> css/footer-cta.css << 'CSS_EOF'

/* ============================================================= */
/* CORRECTIF — Largeur des champs pour éviter la troncature      */
/* ============================================================= */
@media (min-width: 993px) {
    .booking-section .booking-widget {
        grid-template-columns: 1.1fr 1.1fr 0.9fr 0.9fr auto;
    }
    .booking-section .cta-date-input {
        font-size: 17px;
        letter-spacing: 0;
    }
    .booking-section .widget-field {
        padding: 20px 22px;
    }
}

/* Renforcer le style "highlight" */
.booking-section h2 .highlight {
    color: #C59A67 !important;
    font-style: italic !important;
    font-weight: 700 !important;
    font-family: 'Playfair Display', Georgia, 'Times New Roman', serif !important;
    letter-spacing: .3px !important;
}
CSS_EOF

echo "  ✅ CSS correctif ajouté"
echo ""
echo "==================================================="
echo "✅ TERMINÉ"
echo "💾 Sauvegarde : $BACKUP"
echo ""
echo "⚠️  Ctrl + F5 dans le navigateur"
echo "==================================================="
