#!/bin/bash
set -e

BACKUP=".backup_BARRE_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP"
cp *.html "$BACKUP/" 2>/dev/null
cp js/booking-bridge.js "$BACKUP/" 2>/dev/null
echo "📦 Sauvegarde → $BACKUP"
echo ""

PAGES="index.html chambres.html contact.html galerie.html evenements.html experiences.html experiences-piscine.html experiences-restaurant.html reservation.html"

# ============================================================
# ÉTAPE 1 — Préparer la nouvelle barre CTA (même structure que hero)
# ============================================================
cat > /tmp/cta_unified.html << 'CTA_EOF'
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
CTA_EOF

# ============================================================
# ÉTAPE 2 — Remplacer le widget du CTA sur chaque page
# ============================================================
echo "─── ÉTAPE 1 : Remplacement du widget CTA ───"

for f in $PAGES; do
    [ ! -f "$f" ] && continue

    export NEW_WIDGET="$(cat /tmp/cta_unified.html)"

    # Remplacer le bloc <div class="booking-widget">...</div> par le nouveau
    # (match multi-ligne, non-greedy, s'arrête au premier </div> qui ferme le widget)
    perl -0777 -i -pe '
        s|<div class="booking-widget">.*?</div>\s*</div>\s*</div>|$ENV{NEW_WIDGET}|s;
    ' "$f"

    # Fallback : si le match précédent échoue, tenter une version plus souple
    if ! grep -q 'cta-chambre' "$f"; then
        perl -0777 -i -pe '
            s|<div class="booking-widget">.*?</div>\s*<div class="booking-features">|$ENV{NEW_WIDGET}\n                <div class="booking-features">|s;
        ' "$f"
    fi

    unset NEW_WIDGET
    echo "  ✅ $f"
done
echo ""

# ============================================================
# ÉTAPE 3 — CSS : adapter la largeur des 4 champs + bouton 2 lignes
# ============================================================
echo "─── ÉTAPE 2 : CSS adapté ───"

cat >> css/footer-cta.css << 'CSS_EOF'

/* ============================================================= */
/* BARRE UNIFIÉE — Chambre · Arrivée · Départ · Hôtes · Bouton   */
/* ============================================================= */
.booking-section .cta-select {
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
.booking-section .cta-select option {
    background: #ffffff;
    color: #062F3D;
    font-family: 'Montserrat', sans-serif;
    font-size: 13px;
}

/* Bouton sur 2 lignes — texte plus compact */
.booking-section .btn-submit {
    text-align: center;
    line-height: 1.25;
    font-size: 10.5px;
    padding: 0 22px;
    min-width: 155px;
}
.booking-section .btn-submit svg {
    margin-left: 4px;
}

/* Champs : ajuster la largeur */
@media (min-width: 993px) {
    .booking-section .booking-widget {
        grid-template-columns: 1.05fr 1.05fr 1.05fr 1fr auto;
        max-width: 1140px;
    }
    .booking-section .widget-field {
        padding: 10px 14px;
    }
}

/* Responsive : garder la belle structure en colonne sur mobile */
@media (max-width: 992px) {
    .booking-section .booking-widget {
        grid-template-columns: 1fr;
        gap: 4px;
    }
    .booking-section .btn-submit {
        min-width: 0;
        width: 100%;
        padding: 14px 20px;
        line-height: 1.3;
    }
}
CSS_EOF
echo "  ✅ CSS ajouté"
echo ""

# ============================================================
# ÉTAPE 4 — Adapter booking-bridge.js à la nouvelle structure
# ============================================================
echo "─── ÉTAPE 3 : Mise à jour booking-bridge.js ───"

# Trouver et remplacer le handler du CTA
python3 << 'PYEOF'
import re

with open('js/booking-bridge.js', 'r', encoding='utf-8') as f:
    content = f.read()

# Nouveau handler pour le CTA unifié
new_handler = """    /* --- 2.2 CTA bas de page (structure unifiée) --- */
    var ctaBtn = document.querySelector('.booking-section .btn-submit');
    if (ctaBtn) {
      ctaBtn.addEventListener('click', function (e) {
        e.preventDefault();
        var roomsEl   = document.getElementById('cta-chambre');
        var guestsEl  = document.getElementById('cta-hotes');
        var guests = guestsEl ? parseGuests(guestsEl.value) : { adults: 2, children: 0 };
        window.goToBooking({
          checkin:  getDateISO('cta-checkin'),
          checkout: getDateISO('cta-checkout'),
          rooms:    roomsEl ? parseRooms(roomsEl.value) : 1,
          adults:   guests.adults,
          children: guests.children
        });
      });
    }"""

# Remplacer l'ancien handler
content = re.sub(
    r'/\* --- 2\.2 CTA bas de page[^*]*\*/\s*var ctaBtn = document\.querySelector.*?\n    \}\n',
    new_handler + '\n',
    content,
    flags=re.DOTALL
)

with open('js/booking-bridge.js', 'w', encoding='utf-8') as f:
    f.write(content)

print("  ✅ booking-bridge.js mis à jour")
PYEOF
echo ""

# ============================================================
# ÉTAPE 5 — Vérification
# ============================================================
echo "─── VÉRIFICATION ───"
printf "  %-32s | %s | %s | %s\n" "Fichier" "chambre" "hotes" "checkin"
printf "  %-32s-|-%s-|-%s-|-%s\n" "--------------------------------" "-------" "-----" "-------"
for f in $PAGES; do
    [ ! -f "$f" ] && continue
    ch=$(grep -c 'cta-chambre' "$f" 2>/dev/null || echo 0)
    ho=$(grep -c 'cta-hotes' "$f" 2>/dev/null || echo 0)
    ci=$(grep -c 'cta-checkin' "$f" 2>/dev/null || echo 0)
    printf "  %-32s | %-7s | %-5s | %-7s\n" "$f" "$ch" "$ho" "$ci"
done

echo ""
echo "  Attendu : chambre=1, hotes=1, checkin=1"
echo ""
echo "==================================================="
echo "✅ TERMINÉ"
echo "💾 Sauvegarde : $BACKUP"
echo ""
echo "📌 Ctrl + F5 dans le navigateur pour voir"
echo "==================================================="
