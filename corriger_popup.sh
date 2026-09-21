#!/usr/bin/env bash
# =============================================================================
# corriger_popup.sh
#
# Corrige la pop-up "VOIR TOUS LES TARIFS" de chambres.html :
#   1. Sauvegarde
#   2. Vérifie la structure (boutons, modale, ordre des scripts)
#   3. Remplace le bloc JS de la pop-up par la version robuste
#   4. Ajoute les logs de diagnostic
#   5. Redirige directement vers reservation.html au clic sur "Choisir"
# =============================================================================
set -euo pipefail

HTML_FILE="${1:-chambres.html}"

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; BLUE='\033[0;34m'; NC='\033[0m'

echo -e "${BLUE}=====================================================${NC}"
echo -e "${BLUE} CORRECTION POP-UP TARIFS — chambres.html${NC}"
echo -e "${BLUE}=====================================================${NC}\n"

# ============================================================
# 0. Vérifications
# ============================================================
if [ ! -f "$HTML_FILE" ]; then
    echo -e "${RED}❌ $HTML_FILE introuvable${NC}"
    exit 1
fi

if ! command -v python3 >/dev/null 2>&1; then
    echo -e "${RED}❌ python3 requis${NC}"
    exit 1
fi

echo -e "${BLUE}━━━ DIAGNOSTIC AVANT ━━━${NC}"

# Compter les éléments clés
count_open_tariffs=$(grep -c 'data-open-tariffs=' "$HTML_FILE" || echo 0)
count_tariffs_modal=$(grep -c 'id="tariffsModal"' "$HTML_FILE" || echo 0)
count_init_func=$(grep -c 'initTariffsModal' "$HTML_FILE" || echo 0)
count_booking_bridge=$(grep -c 'booking-bridge.js' "$HTML_FILE" || echo 0)

echo -e "   Boutons [data-open-tariffs]  : $count_open_tariffs"
echo -e "   Modale #tariffsModal          : $count_tariffs_modal"
echo -e "   Fonction initTariffsModal     : $count_init_func"
echo -e "   Script booking-bridge.js      : $count_booking_bridge"
echo ""

if [ "$count_open_tariffs" -lt 1 ]; then
    echo -e "${YELLOW}⚠  Aucun bouton [data-open-tariffs] détecté.${NC}"
    echo -e "${YELLOW}   Les liens seront convertis automatiquement...${NC}"
fi

if [ "$count_tariffs_modal" -lt 1 ]; then
    echo -e "${RED}❌ La modale #tariffsModal est absente du HTML.${NC}"
    echo -e "${RED}   Lancez d'abord inserer_popup_tarifs.sh${NC}"
    exit 1
fi

# ============================================================
# 1. Sauvegarde
# ============================================================
BACKUP=".backup_popup_fix_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP"
cp "$HTML_FILE" "$BACKUP/"
echo -e "${GREEN}📦 Sauvegarde → $BACKUP${NC}\n"

# ============================================================
# 2. Préparer le nouveau bloc JS robuste
# ============================================================
NEW_JS=$(mktemp)
trap 'rm -f "$NEW_JS"' EXIT

cat > "$NEW_JS" << 'JS_EOF'
    /* ============================================================
       POP-UP : TOUS LES TARIFS (version robuste)
       Déclenchée uniquement au clic sur [data-open-tariffs]
       ============================================================ */
    (function initTariffsModal() {
        var TARIFS_DATA = {
            'deluxe-ocean': {
                type: 'CHAMBRE DELUXE',
                title: 'Chambre Deluxe Vue Océan',
                desc: "Balcon privé et vue imprenable sur l'Atlantique depuis votre lit King Size.",
                tariffs: [
                    { name: 'Tarif Flexible', sub: "Annulation gratuite jusqu'à 48h avant l'arrivée", price: 185000 },
                    { name: 'Tarif Non-remboursable', sub: 'Paiement immédiat, −15%', price: 157250, old: 185000 },
                    { name: 'Petit-déjeuner inclus', sub: 'Buffet Teranga Lounge chaque matin', price: 212750 }
                ]
            },
            'superieure-ocean': {
                type: 'CHAMBRE SUPÉRIEURE',
                title: 'Chambre Supérieure Vue Océan',
                desc: "Terrasse privative et lumière naturelle généreuse, face à l'île de Gorée.",
                tariffs: [
                    { name: 'Tarif Flexible', sub: "Annulation gratuite jusqu'à 48h avant l'arrivée", price: 155000 },
                    { name: 'Tarif Non-remboursable', sub: 'Paiement immédiat, −15%', price: 131750, old: 155000 },
                    { name: 'Petit-déjeuner inclus', sub: 'Buffet Teranga Lounge chaque matin', price: 178250 }
                ]
            },
            'suite-ambassadeur': {
                type: 'SUITE AMBASSADEUR',
                title: 'Suite Ambassadeur Pullman',
                desc: "Salon séparé, volumes généreux et services exclusifs pour un séjour d'exception.",
                tariffs: [
                    { name: 'Tarif Flexible', sub: "Annulation gratuite jusqu'à 48h avant l'arrivée", price: 350000 },
                    { name: 'Tarif Non-remboursable', sub: 'Paiement immédiat, −15%', price: 297500, old: 350000 },
                    { name: 'Petit-déjeuner inclus', sub: 'Buffet Teranga Lounge + service en chambre', price: 402500 }
                ]
            }
        };

        function fmtFCFA(n) {
            return n.toLocaleString('fr-FR').replace(/,/g, ' ') + ' FCFA';
        }

        var modal      = document.getElementById('tariffsModal');
        var modalClose = document.getElementById('tariffsModalClose');
        var modalType  = document.getElementById('tariffsModalType');
        var modalTitle = document.getElementById('tariffsModalTitle');
        var modalDesc  = document.getElementById('tariffsModalDesc');
        var modalList  = document.getElementById('tariffsModalList');

        console.log('[TariffsModal] modal =', modal);
        console.log('[TariffsModal] boutons =', document.querySelectorAll('[data-open-tariffs]').length);

        if (!modal) {
            console.error('[TariffsModal] #tariffsModal introuvable dans le DOM');
            return;
        }

        function renderTariffs(roomId) {
            var room = TARIFS_DATA[roomId];
            if (!room) {
                console.warn('[TariffsModal] Aucune donnée pour', roomId);
                return;
            }

            modalType.textContent  = room.type;
            modalTitle.textContent = room.title;
            modalDesc.textContent  = room.desc;

            modalList.innerHTML = room.tariffs.map(function (t, i) {
                var badge = t.old
                    ? '<span class="tariff-badge">-' + Math.round((1 - t.price / t.old) * 100) + '%</span>'
                    : '';
                var oldPrice = t.old ? '<span class="tariff-old">' + fmtFCFA(t.old) + '</span>' : '';
                return '' +
                    '<div class="tariff-row">' +
                        '<div class="tariff-row-info">' +
                            '<div class="tariff-row-name">' + t.name + badge + '</div>' +
                            '<div class="tariff-row-sub"><i class="fa-solid fa-check"></i> ' + t.sub + '</div>' +
                        '</div>' +
                        '<div class="tariff-row-price">' +
                            oldPrice +
                            '<span class="tariff-amt">' + fmtFCFA(t.price) + '</span>' +
                            '<span class="tariff-unit">par nuit</span>' +
                        '</div>' +
                        '<button type="button" class="tariff-row-btn" data-book-room="' + roomId + '" data-book-tariff="' + i + '">Choisir</button>' +
                    '</div>';
            }).join('');
        }

        function openModal(roomId) {
            console.log('[TariffsModal] Ouverture pour', roomId);
            if (!TARIFS_DATA[roomId]) {
                console.warn('[TariffsModal] roomId inconnu:', roomId);
                return;
            }
            renderTariffs(roomId);
            modal.classList.add('is-open');
            modal.setAttribute('aria-hidden', 'false');
            document.body.style.overflow = 'hidden';
        }

        function closeModal() {
            modal.classList.remove('is-open');
            modal.setAttribute('aria-hidden', 'true');
            document.body.style.overflow = '';
        }

        /* Attacher les listeners sur chaque bouton "VOIR TOUS LES TARIFS" */
        var openBtns = document.querySelectorAll('[data-open-tariffs]');
        openBtns.forEach(function (btn) {
            btn.addEventListener('click', function (e) {
                e.preventDefault();
                e.stopPropagation();
                openModal(btn.dataset.openTariffs || btn.getAttribute('data-open-tariffs'));
            });
        });

        /* Clic sur "Choisir" → redirection directe vers reservation.html */
        modalList.addEventListener('click', function (e) {
            var btn = e.target.closest('[data-book-room]');
            if (!btn) return;
            e.preventDefault();
            e.stopPropagation();
            var roomId = btn.getAttribute('data-book-room');
            var tariff = btn.getAttribute('data-book-tariff') || 0;
            console.log('[TariffsModal] Redirection vers reservation.html?room=' + roomId + '&tariff=' + tariff);
            window.location.href = 'reservation.html?room=' + encodeURIComponent(roomId) + '&tariff=' + encodeURIComponent(tariff);
        });

        /* Fermeture */
        if (modalClose) modalClose.addEventListener('click', closeModal);
        modal.addEventListener('click', function (e) {
            if (e.target === modal) closeModal();
        });
        document.addEventListener('keydown', function (e) {
            if (e.key === 'Escape' && modal.classList.contains('is-open')) closeModal();
        });

        console.log('[TariffsModal] Initialisé avec succès');
    })();
JS_EOF

# ============================================================
# 3. Injection via Python (fiabilité pour multi-lignes)
# ============================================================
echo -e "${BLUE}━━━ Remplacement du JavaScript ━━━${NC}"

python3 - "$HTML_FILE" "$NEW_JS" << 'PY_EOF'
import re
import sys
from pathlib import Path

html_path = Path(sys.argv[1])
new_js    = Path(sys.argv[2]).read_text(encoding='utf-8')
html      = html_path.read_text(encoding='utf-8')

# ---------- Étape 1 : convertir les liens <a class="btn-tarifs"> en <button data-open-tariffs> ----------
pattern_links = re.compile(
    r'<a\s+href="reservation\.html\?room=([a-z0-9\-]+)"\s+class="btn-tarifs"[^>]*>\s*'
    r'VOIR TOUS LES TARIFS\s*<i class="fa-solid fa-chevron-right"></i>\s*</a>',
    re.IGNORECASE | re.DOTALL
)

def to_button(m):
    rid = m.group(1)
    return (
        f'<button type="button" class="btn-tarifs" data-open-tariffs="{rid}">\n'
        f'                        VOIR TOUS LES TARIFS <i class="fa-solid fa-chevron-right"></i>\n'
        f'                    </button>'
    )

html, n_links = pattern_links.subn(to_button, html)
if n_links > 0:
    print(f"   ✔ {n_links} lien(s) converti(s) en <button data-open-tariffs>")
else:
    print(f"   ℹ  Aucun lien à convertir (déjà en <button>)")

# ---------- Étape 2 : supprimer tout ancien bloc initTariffsModal ----------
# Chercher du premier (function initTariffsModal jusqu'à la fermeture })();
pattern_old_js = re.compile(
    r'/\*\s*=+\s*\n\s*POP-UP\s*:.*?\n\s*\*/\s*\n\s*\(function initTariffsModal\(\).*?\}\)\(\);',
    re.DOTALL
)

if pattern_old_js.search(html):
    html = pattern_old_js.sub('', html, count=1)
    print("   ✔ Ancien bloc JS de la pop-up supprimé")

# Aussi, chercher une version alternative (sans le commentaire /* */ avant)
pattern_old_js2 = re.compile(
    r'\(function initTariffsModal\(\).*?\}\)\(\);',
    re.DOTALL
)
if pattern_old_js2.search(html):
    html = pattern_old_js2.sub('', html, count=1)
    print("   ✔ Ancien bloc JS (variante) supprimé")

# ---------- Étape 3 : insérer le nouveau JS avant PARALLAX HERO ----------
anchor_parallax = '// ================= PARALLAX HERO ================='
if anchor_parallax in html:
    html = html.replace(anchor_parallax, new_js + '\n    ' + anchor_parallax, 1)
    print("   ✔ Nouveau JS inséré avant PARALLAX HERO")
else:
    # Fallback : insérer avant la dernière balise </script>
    last_script_pos = html.rfind('</script>')
    if last_script_pos != -1:
        html = html[:last_script_pos] + new_js + '\n' + html[last_script_pos:]
        print("   ✔ Nouveau JS inséré avant </script> (fallback)")
    else:
        print("   ❌ Aucun point d'insertion JS trouvé")
        sys.exit(1)

# ---------- Étape 4 : écrire le fichier ----------
html_path.write_text(html, encoding='utf-8')

print("   ✔ Fichier mis à jour")
PY_EOF

# ============================================================
# 4. Vérification finale
# ============================================================
echo ""
echo -e "${BLUE}━━━ VÉRIFICATION APRÈS ━━━${NC}"

H=$(cat "$HTML_FILE")

count_btn=$(echo "$H" | grep -c 'data-open-tariffs=' || echo 0)
count_modal=$(echo "$H" | grep -c 'id="tariffsModal"' || echo 0)
count_init=$(echo "$H" | grep -c 'initTariffsModal' || echo 0)
count_console=$(echo "$H" | grep -c '\[TariffsModal\]' || echo 0)
count_booking=$(echo "$H" | grep -c 'booking-bridge.js' || echo 0)

printf "   %-40s | %s\n" "Boutons [data-open-tariffs]" "$count_btn"
printf "   %-40s | %s\n" "Modale #tariffsModal" "$count_modal"
printf "   %-40s | %s\n" "Fonction initTariffsModal" "$count_init"
printf "   %-40s | %s\n" "Logs de diagnostic [TariffsModal]" "$count_console"
printf "   %-40s | %s\n" "Script booking-bridge.js" "$count_booking"

echo ""
if [ "$count_btn" -ge 1 ] && [ "$count_modal" -ge 1 ] && [ "$count_init" -ge 1 ]; then
    echo -e "${GREEN}✅ CORRECTION APPLIQUÉE AVEC SUCCÈS${NC}"
else
    echo -e "${YELLOW}⚠  Vérifiez manuellement${NC}"
fi

echo -e "${BLUE}💾 Sauvegarde : $BACKUP${NC}"
echo ""
echo -e "${BLUE}📌 Étapes suivantes :${NC}"
echo "   1. Ouvrez chambres.html dans le navigateur"
echo "   2. F12 → Console"
echo "   3. Vous devez voir : [TariffsModal] Initialisé avec succès"
echo "   4. Cliquez sur VOIR TOUS LES TARIFS → la pop-up s'ouvre"
echo "   5. Cliquez sur Choisir → redirection vers reservation.html"
echo ""
echo -e "${BLUE}🔄 Rollback :${NC}"
echo "   cp $BACKUP/chambres.html ."
echo ""
echo -e "${BLUE}🧹 Nettoyage après validation :${NC}"
echo "   rm -rf $BACKUP corriger_popup.sh"
