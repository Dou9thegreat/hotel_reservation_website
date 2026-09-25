#!/usr/bin/env bash
# =============================================================================
# inserer_popup_tarifs.sh
#
# Ajoute une pop-up "VOIR TOUS LES TARIFS" à la page chambres.html
# Déclenchement : uniquement au clic sur les boutons [data-open-tariffs]
#
# Le script est IDEMPOTENT : ne fait rien si la pop-up est déjà installée.
# =============================================================================
set -euo pipefail

HTML_FILE="${1:-chambres.html}"
CSS_FILE="${2:-css/chambres.css}"

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; BLUE='\033[0;34m'; NC='\033[0m'

echo -e "${BLUE}=====================================================${NC}"
echo -e "${BLUE} INSERTION POP-UP 'VOIR TOUS LES TARIFS'${NC}"
echo -e "${BLUE}=====================================================${NC}\n"

# ============================================================
# 0. VÉRIFICATIONS PRÉALABLES
# ============================================================
echo -e "${BLUE}━━━ Vérifications ━━━${NC}"

if [ ! -f "$HTML_FILE" ]; then
    echo -e "${RED}❌ $HTML_FILE introuvable${NC}"
    exit 1
fi

if [ ! -f "$CSS_FILE" ]; then
    echo -e "${RED}❌ $CSS_FILE introuvable${NC}"
    exit 1
fi

if ! command -v python3 >/dev/null 2>&1; then
    echo -e "${RED}❌ python3 requis${NC}"
    exit 1
fi

if grep -q "tariffsModal" "$HTML_FILE"; then
    echo -e "${YELLOW}ℹ  La pop-up est déjà installée dans $HTML_FILE${NC}"
    echo -e "${YELLOW}   Aucune action effectuée.${NC}"
    exit 0
fi

echo -e "${GREEN}   ✔ $HTML_FILE trouvé${NC}"
echo -e "${GREEN}   ✔ $CSS_FILE trouvé${NC}"
echo ""

# ============================================================
# 1. SAUVEGARDES
# ============================================================
BACKUP=".backup_popup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP"
cp "$HTML_FILE" "$BACKUP/"
cp "$CSS_FILE" "$BACKUP/"
echo -e "${GREEN}📦 Sauvegarde → $BACKUP${NC}\n"

# ============================================================
# 2. FICHIERS TEMPORAIRES POUR LES BLOCS À INSÉRER
# ============================================================
MODAL_HTML=$(mktemp)
MODAL_JS=$(mktemp)
MODAL_CSS=$(mktemp)
trap 'rm -f "$MODAL_HTML" "$MODAL_JS" "$MODAL_CSS"' EXIT

# ---------- Bloc HTML de la pop-up ----------
cat > "$MODAL_HTML" << 'HTML_BLOCK'
    <!-- ========================================================= -->
    <!-- POP-UP : TOUS LES TARIFS                                  -->
    <!-- Déclenchée par [data-open-tariffs] uniquement             -->
    <!-- ========================================================= -->
    <div class="tariffs-modal-overlay" id="tariffsModal" aria-hidden="true">
        <div class="tariffs-modal" role="dialog" aria-modal="true" aria-labelledby="tariffsModalTitle">
            <button type="button" class="tariffs-modal-close" id="tariffsModalClose" aria-label="Fermer">
                <i class="fa-solid fa-xmark"></i>
            </button>

            <div class="tariffs-modal-header">
                <span class="tariffs-modal-eyebrow" id="tariffsModalType">CHAMBRE</span>
                <h3 id="tariffsModalTitle">Tous les tarifs</h3>
                <p id="tariffsModalDesc" class="tariffs-modal-desc"></p>
            </div>

            <div class="tariffs-modal-list" id="tariffsModalList">
                <!-- Rempli dynamiquement par le script -->
            </div>

            <div class="tariffs-modal-footer">
                <span><i class="fa-solid fa-shield-halved"></i> Meilleur tarif garanti sur le site officiel</span>
            </div>
        </div>
    </div>
    <!-- ======================== /POP-UP ======================== -->

HTML_BLOCK

# ---------- Bloc JavaScript ----------
cat > "$MODAL_JS" << 'JS_BLOCK'

    /* ============================================================
       POP-UP : TOUS LES TARIFS
       Déclenchée au clic sur les boutons [data-open-tariffs]
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

        if (!modal) return; // sécurité si le HTML n'a pas été inséré

        function renderTariffs(roomId) {
            var room = TARIFS_DATA[roomId];
            if (!room) return;

            modalType.textContent = room.type;
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
            if (!TARIFS_DATA[roomId]) return;
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

        /* Boutons "VOIR TOUS LES TARIFS" */
        document.querySelectorAll('[data-open-tariffs]').forEach(function (btn) {
            btn.addEventListener('click', function (e) {
                e.preventDefault();
                openModal(btn.dataset.openTariffs);
            });
        });

        /* Clic sur "Choisir" dans la pop-up → redirection réservation */
        modalList.addEventListener('click', function (e) {
            var btn = e.target.closest('[data-book-room]');
            if (!btn) return;
            if (typeof window.goToBooking === 'function') {
                window.goToBooking({
                    room: btn.dataset.bookRoom,
                    tariff: btn.dataset.bookTariff || 0
                });
            }
        });

        /* Fermeture */
        if (modalClose) modalClose.addEventListener('click', closeModal);
        modal.addEventListener('click', function (e) {
            if (e.target === modal) closeModal();
        });
        document.addEventListener('keydown', function (e) {
            if (e.key === 'Escape' && modal.classList.contains('is-open')) closeModal();
        });
    })();

JS_BLOCK

# ---------- Bloc CSS ----------
cat > "$MODAL_CSS" << 'CSS_BLOCK'

/* ============================================================= */
/* POP-UP "VOIR TOUS LES TARIFS"                                 */
/* ============================================================= */
.chambres-page .btn-tarifs {
    background: none;
    border: none;
    font-family: inherit;
    cursor: pointer;
}

.tariffs-modal-overlay {
    position: fixed;
    inset: 0;
    background: rgba(10, 20, 30, 0.55);
    backdrop-filter: blur(2px);
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 20px;
    z-index: 2000;
    opacity: 0;
    visibility: hidden;
    transition: opacity 0.25s ease, visibility 0.25s ease;
}
.tariffs-modal-overlay.is-open {
    opacity: 1;
    visibility: visible;
}

.tariffs-modal {
    background: #fff;
    width: 100%;
    max-width: 620px;
    max-height: 85vh;
    overflow-y: auto;
    border-radius: 10px;
    position: relative;
    padding: 36px 36px 24px;
    box-shadow: 0 25px 60px rgba(0, 0, 0, 0.3);
    transform: translateY(20px) scale(0.98);
    transition: transform 0.25s ease;
}
.tariffs-modal-overlay.is-open .tariffs-modal {
    transform: translateY(0) scale(1);
}

.tariffs-modal-close {
    position: absolute;
    top: 18px;
    right: 18px;
    width: 36px;
    height: 36px;
    border-radius: 50%;
    border: 1px solid #E0E0E0;
    background: #fff;
    color: #003B5C;
    font-size: 14px;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    transition: background 0.2s, color 0.2s;
}
.tariffs-modal-close:hover {
    background: #003B5C;
    color: #fff;
}

.tariffs-modal-header {
    margin-bottom: 22px;
    padding-right: 30px;
}
.tariffs-modal-eyebrow {
    display: block;
    color: #00A859;
    font-size: 11px;
    font-weight: 700;
    letter-spacing: 2px;
    text-transform: uppercase;
    margin-bottom: 8px;
}
.tariffs-modal-header h3 {
    font-size: 24px;
    color: #003B5C;
    text-transform: uppercase;
    letter-spacing: 0.3px;
    margin: 0 0 8px;
}
.tariffs-modal-desc {
    color: #666;
    font-size: 14px;
    line-height: 1.5;
}

.tariffs-modal-list {
    display: flex;
    flex-direction: column;
    gap: 14px;
}

.tariff-row {
    display: grid;
    grid-template-columns: 1fr auto auto;
    align-items: center;
    gap: 18px;
    border: 1px solid #E0E0E0;
    border-radius: 8px;
    padding: 16px 18px;
    transition: border-color 0.2s, box-shadow 0.2s;
}
.tariff-row:hover {
    border-color: #2ECC71;
    box-shadow: 0 4px 16px rgba(0, 0, 0, 0.06);
}

.tariff-row-name {
    font-size: 14.5px;
    font-weight: 700;
    color: #1A1A1A;
    display: flex;
    align-items: center;
    gap: 8px;
}
.tariff-badge {
    background: #FDECEC;
    color: #D64545;
    font-size: 10px;
    font-weight: 700;
    padding: 2px 7px;
    border-radius: 3px;
    letter-spacing: 0.3px;
}
.tariff-row-sub {
    font-size: 12.5px;
    color: #666;
    margin-top: 4px;
}
.tariff-row-sub i { color: #2ECC71; margin-right: 3px; }

.tariff-row-price {
    text-align: right;
    white-space: nowrap;
    min-width: 130px;
}
.tariff-old {
    display: block;
    font-size: 12px;
    color: #A0A0A0;
    text-decoration: line-through;
}
.tariff-amt {
    display: block;
    font-size: 19px;
    font-weight: 700;
    color: #D4A373;
}
.tariff-unit {
    display: block;
    font-size: 10px;
    color: #666;
}

.tariff-row-btn {
    background-color: #2ECC71;
    color: #fff;
    border: none;
    padding: 10px 20px;
    border-radius: 4px;
    font-size: 12px;
    font-weight: 700;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    cursor: pointer;
    white-space: nowrap;
    transition: background 0.2s;
}
.tariff-row-btn:hover { background-color: #27AE60; }

.tariffs-modal-footer {
    margin-top: 22px;
    padding-top: 16px;
    border-top: 1px solid #E0E0E0;
    font-size: 12.5px;
    color: #666;
    display: flex;
    align-items: center;
    gap: 8px;
}
.tariffs-modal-footer i { color: #2ECC71; }

@media (max-width: 600px) {
    .tariffs-modal { padding: 26px 20px 20px; max-height: 90vh; }
    .tariff-row {
        grid-template-columns: 1fr;
        text-align: left;
    }
    .tariff-row-price { text-align: left; min-width: 0; }
    .tariff-row-btn { width: 100%; }
}
CSS_BLOCK

# ============================================================
# 3. INSERTION VIA PYTHON (fiable pour HTML multi-lignes)
# ============================================================
echo -e "${BLUE}━━━ Insertion dans le HTML ━━━${NC}"

python3 - "$HTML_FILE" "$CSS_FILE" "$MODAL_HTML" "$MODAL_JS" "$MODAL_CSS" << 'PY_EOF'
import re
import sys
from pathlib import Path

html_path = Path(sys.argv[1])
css_path  = Path(sys.argv[2])
modal_html = Path(sys.argv[3]).read_text(encoding='utf-8')
modal_js   = Path(sys.argv[4]).read_text(encoding='utf-8')
modal_css  = Path(sys.argv[5]).read_text(encoding='utf-8')

html = html_path.read_text(encoding='utf-8')
css  = css_path.read_text(encoding='utf-8')

# ---------- 3a. Transformer les liens "VOIR TOUS LES TARIFS" en boutons ----------
pattern_links = re.compile(
    r'<a\s+href="reservation\.html\?room=([a-z0-9\-]+)"\s+class="btn-tarifs">'
    r'\s*VOIR TOUS LES TARIFS\s*<i class="fa-solid fa-chevron-right"></i>\s*</a>',
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
if n_links == 0:
    print("   ⚠️  Aucun lien 'VOIR TOUS LES TARIFS' trouvé.")
    print("       Vérifiez que les liens ont bien la forme :")
    print('         <a href="reservation.html?room=XXX" class="btn-tarifs">VOIR TOUS LES TARIFS ...</a>')
else:
    print(f"   ✔ {n_links} bouton(s) 'VOIR TOUS LES TARIFS' câblé(s) sur la pop-up")

# ---------- 3b. Insérer la pop-up HTML avant la fermeture de .chambres-page ----------
anchor_html = '<!-- ============================== MODALE "VOIR TOUS LES TARIFS" ============================== -->'
if anchor_html in html:
    print("   ℹ  Pop-up HTML déjà présente — non insérée")
else:
    # Chercher la fermeture de .chambres-page
    close_anchor = '</div><!-- /.chambres-page -->'
    if close_anchor in html:
        html = html.replace(close_anchor, modal_html + '\n' + close_anchor, 1)
        print("   ✔ Pop-up HTML insérée avant la fermeture de .chambres-page")
    else:
        print("   ❌ Ancre '</div><!-- /.chambres-page -->' introuvable")
        sys.exit(1)

# ---------- 3c. Insérer le JS avant le bloc PARALLAX HERO ----------
anchor_js = '// ================= PARALLAX HERO ================='
if 'initTariffsModal' in html:
    print("   ℹ  JavaScript pop-up déjà présent — non inséré")
elif anchor_js in html:
    html = html.replace(anchor_js, modal_js + '\n    ' + anchor_js, 1)
    print("   ✔ JavaScript pop-up inséré avant PARALLAX HERO")
else:
    # Fallback : insérer avant la dernière balise </script>
    last_script = html.rfind('</script>')
    if last_script != -1:
        html = html[:last_script] + modal_js + '\n' + html[last_script:]
        print("   ✔ JavaScript pop-up inséré avant </script> (fallback)")
    else:
        print("   ❌ Aucun point d'insertion JS trouvé")
        sys.exit(1)

# ---------- 3d. Ajouter le CSS ----------
if '.tariffs-modal-overlay' in css:
    print("   ℹ  CSS pop-up déjà présent — non ajouté")
else:
    css = css.rstrip() + '\n' + modal_css
    print("   ✔ CSS pop-up ajouté à la fin de chambres.css")

# ---------- 3e. Écrire les fichiers ----------
html_path.write_text(html, encoding='utf-8')
css_path.write_text(css, encoding='utf-8')

PY_EOF

# ============================================================
# 4. VÉRIFICATION FINALE
# ============================================================
echo ""
echo -e "${BLUE}━━━ VÉRIFICATION ━━━${NC}"

H=$(cat "$HTML_FILE")
C=$(cat "$CSS_FILE")

check() {
    local label="$1"
    local pattern="$2"
    local source="$3"
    local expected="$4"
    local count=$(echo "$source" | grep -c "$pattern" 2>/dev/null || echo 0)
    if [ "$count" -eq "$expected" ]; then
        echo -e "   ${GREEN}✔${NC} $label : $count/$expected"
    else
        echo -e "   ${YELLOW}⚠${NC} $label : $count/$expected"
    fi
}

check "Boutons data-open-tariffs (3 attendus)"  'data-open-tariffs='      "$H" 3
check "Pop-up id=tariffsModal (1 attendu)"     'id="tariffsModal"'       "$H" 1
check "Fonction initTariffsModal (1 attendue)" 'initTariffsModal'        "$H" 1
check "CSS .tariffs-modal-overlay (1 attendu)" 'tariffs-modal-overlay'   "$C" 1
check "CSS .tariff-row (1 attendu)"            '\.tariff-row\b'          "$C" 1

echo ""
echo -e "${GREEN}✅ TERMINÉ${NC}"
echo -e "${BLUE}💾 Sauvegarde : $BACKUP${NC}"
echo ""
echo -e "${BLUE}📌 Test :${NC}"
echo "   1. Ctrl + Shift + R dans le navigateur"
echo "   2. Ouvrez chambres.html"
echo "   3. Cliquez sur 'VOIR TOUS LES TARIFS' d'une carte"
echo "   4. → La pop-up s'ouvre avec les 3 tarifs"
echo "   5. Cliquez sur 'Choisir' → redirection vers reservation.html"
echo ""
echo -e "${BLUE}🔄 Rollback :${NC}"
echo "   cp $BACKUP/chambres.html ."
echo "   cp $BACKUP/chambres.css css/"
echo ""
echo -e "${BLUE}🧹 Nettoyage après validation :${NC}"
echo "   rm -rf $BACKUP inserer_popup_tarifs.sh"
