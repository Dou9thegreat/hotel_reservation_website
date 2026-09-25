#!/bin/bash
set -e

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; NC='\033[0m'

echo -e "${BLUE}=================================================${NC}"
echo -e "${BLUE} POP-UP 'VOIR TOUS LES TARIFS' — chambres.html${NC}"
echo -e "${BLUE}=================================================${NC}\n"

BACKUP=".backup_popup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP"
cp chambres.html "$BACKUP/"
cp css/chambres.css "$BACKUP/"
echo -e "${GREEN}📦 Sauvegarde → $BACKUP${NC}\n"

# ============================================================
# 1. Ajouter le HTML de la pop-up avant </div><!-- /.chambres-page -->
# ============================================================
echo -e "${BLUE}━━━ [1/3] Ajout de la pop-up HTML ━━━${NC}"

python3 << 'PYEOF'
import re
from pathlib import Path

f = Path('chambres.html')
c = f.read_text(encoding='utf-8')

POPUP_HTML = '''
    <!-- ============== POP-UP : TOUS LES TARIFS ============== -->
    <div class="tariffs-modal-overlay" id="tariffsModal">
        <div class="tariffs-modal-container">
            <button class="tariffs-modal-close" id="closeTariffsModal" aria-label="Fermer">&times;</button>

            <header class="tariffs-modal-header">
                <span class="tariffs-modal-tag" id="tariffsRoomType">Chambre</span>
                <h3 class="tariffs-modal-title" id="tariffsRoomName">Nom de la chambre</h3>
                <p class="tariffs-modal-subtitle">
                    Comparez nos tarifs et choisissez celui qui vous convient.
                </p>
            </header>

            <div class="tariffs-modal-body" id="tariffsList">
                <!-- Rempli dynamiquement par JS -->
            </div>

            <footer class="tariffs-modal-footer">
                <div class="tariffs-reassurance">
                    <span>✓ Meilleur tarif garanti</span>
                    <span>✓ Paiement sécurisé</span>
                    <span>✓ Annulation flexible</span>
                </div>
                <button type="button" class="tariffs-modal-btn-close" id="closeTariffsModalBtn">
                    FERMER
                </button>
            </footer>
        </div>
    </div>

'''

# Insérer avant </div><!-- /.chambres-page -->
c = c.replace(
    '</div><!-- /.chambres-page -->',
    POPUP_HTML + '</div><!-- /.chambres-page -->',
    1
)

f.write_text(c, encoding='utf-8')
print("   ✔ Pop-up HTML ajoutée")
PYEOF

# ============================================================
# 2. Ajouter le CSS dans css/chambres.css
# ============================================================
echo -e "\n${BLUE}━━━ [2/3] Ajout du CSS ━━━${NC}"

cat >> css/chambres.css << 'CSS_EOF'

/* ============================================================= */
/* POP-UP : TOUS LES TARIFS                                      */
/* ============================================================= */
.chambres-page .tariffs-modal-overlay {
    position: fixed;
    inset: 0;
    background: rgba(0, 0, 0, 0.65);
    display: flex;
    justify-content: center;
    align-items: center;
    z-index: 1500;
    opacity: 0;
    visibility: hidden;
    transition: opacity 0.3s ease, visibility 0.3s ease;
    padding: 20px;
}
.chambres-page .tariffs-modal-overlay.active {
    opacity: 1;
    visibility: visible;
}

.chambres-page .tariffs-modal-container {
    background: #fff;
    border-radius: 12px;
    max-width: 640px;
    width: 100%;
    max-height: 90vh;
    overflow-y: auto;
    position: relative;
    box-shadow: 0 20px 60px rgba(0, 0, 0, 0.35);
    transform: translateY(20px);
    transition: transform 0.3s ease;
}
.chambres-page .tariffs-modal-overlay.active .tariffs-modal-container {
    transform: translateY(0);
}

.chambres-page .tariffs-modal-close {
    position: absolute;
    top: 14px;
    right: 18px;
    background: transparent;
    border: none;
    font-size: 26px;
    line-height: 1;
    cursor: pointer;
    color: #666;
    z-index: 5;
    transition: color 0.2s;
}
.chambres-page .tariffs-modal-close:hover {
    color: #1a1a1a;
}

.chambres-page .tariffs-modal-header {
    padding: 30px 34px 20px;
    border-bottom: 1px solid #E8EAED;
}
.chambres-page .tariffs-modal-tag {
    display: inline-block;
    color: #00A859;
    font-size: 11px;
    font-weight: 700;
    letter-spacing: 2px;
    text-transform: uppercase;
    margin-bottom: 6px;
}
.chambres-page .tariffs-modal-title {
    font-size: 22px;
    font-weight: 700;
    color: #003B5C;
    margin: 0 0 8px;
    line-height: 1.2;
}
.chambres-page .tariffs-modal-subtitle {
    font-size: 13px;
    color: #666;
    margin: 0;
    line-height: 1.5;
}

.chambres-page .tariffs-modal-body {
    padding: 24px 34px;
    display: flex;
    flex-direction: column;
    gap: 14px;
}

/* Ligne tarifaire */
.chambres-page .tariff-option {
    display: grid;
    grid-template-columns: 1fr auto auto;
    gap: 16px;
    align-items: center;
    padding: 16px 18px;
    border: 1.5px solid #E8EAED;
    border-radius: 10px;
    transition: border-color 0.2s, box-shadow 0.2s;
}
.chambres-page .tariff-option:hover {
    border-color: #00A859;
    box-shadow: 0 4px 14px rgba(0, 168, 89, 0.08);
}

.chambres-page .tariff-option-info { min-width: 0; }
.chambres-page .tariff-option-name {
    font-size: 14px;
    font-weight: 700;
    color: #1A1A1A;
    margin-bottom: 4px;
}
.chambres-page .tariff-option-desc {
    font-size: 12px;
    color: #6B7280;
    line-height: 1.45;
}
.chambres-page .tariff-option-desc::before {
    content: "✓ ";
    color: #00A859;
    font-weight: 700;
}

.chambres-page .tariff-option-price {
    text-align: right;
    white-space: nowrap;
    min-width: 110px;
}
.chambres-page .tariff-option-price .old {
    display: block;
    font-size: 11px;
    color: #A0A4A8;
    text-decoration: line-through;
    margin-bottom: 2px;
}
.chambres-page .tariff-option-price .amt {
    display: block;
    font-size: 16px;
    font-weight: 800;
    color: #003B5C;
}
.chambres-page .tariff-option-price .unit {
    display: block;
    font-size: 10.5px;
    color: #6B7280;
    margin-top: 2px;
    font-weight: 500;
}

.chambres-page .tariff-option-btn {
    background: #00A859;
    color: #fff;
    border: none;
    border-radius: 6px;
    padding: 11px 18px;
    font-weight: 700;
    font-size: 11px;
    letter-spacing: 0.8px;
    text-transform: uppercase;
    cursor: pointer;
    white-space: nowrap;
    text-decoration: none;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    min-width: 120px;
    transition: background 0.2s, transform 0.2s;
    font-family: inherit;
}
.chambres-page .tariff-option-btn:hover {
    background: #008E4A;
    transform: translateY(-1px);
}

.chambres-page .tariffs-modal-footer {
    padding: 18px 34px 26px;
    border-top: 1px solid #E8EAED;
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 16px;
    flex-wrap: wrap;
}
.chambres-page .tariffs-reassurance {
    display: flex;
    gap: 16px;
    flex-wrap: wrap;
}
.chambres-page .tariffs-reassurance span {
    font-size: 10.5px;
    font-weight: 600;
    color: #6B7280;
    letter-spacing: 0.3px;
}
.chambres-page .tariffs-modal-btn-close {
    background: transparent;
    border: 1.5px solid #E8EAED;
    border-radius: 6px;
    padding: 11px 24px;
    font-weight: 700;
    font-size: 11px;
    letter-spacing: 0.8px;
    text-transform: uppercase;
    color: #4B5563;
    cursor: pointer;
    transition: border-color 0.2s, color 0.2s;
    font-family: inherit;
}
.chambres-page .tariffs-modal-btn-close:hover {
    border-color: #003B5C;
    color: #003B5C;
}

/* ---------- RESPONSIVE ---------- */
@media (max-width: 600px) {
    .chambres-page .tariffs-modal-header { padding: 24px 22px 16px; }
    .chambres-page .tariffs-modal-title { font-size: 18px; }
    .chambres-page .tariffs-modal-body { padding: 18px 22px; }
    .chambres-page .tariff-option {
        grid-template-columns: 1fr;
        gap: 10px;
        padding: 14px;
    }
    .chambres-page .tariff-option-price { text-align: left; }
    .chambres-page .tariff-option-btn { width: 100%; }
    .chambres-page .tariffs-modal-footer {
        padding: 16px 22px 20px;
        flex-direction: column;
        align-items: stretch;
    }
    .chambres-page .tariffs-reassurance {
        justify-content: center;
    }
}
CSS_EOF

echo "   ✔ CSS ajouté à css/chambres.css"

# ============================================================
# 3. Ajouter le JS + changer les liens "VOIR TOUS LES TARIFS"
# ============================================================
echo -e "\n${BLUE}━━━ [3/3] Ajout du JavaScript ━━━${NC}"

python3 << 'PYEOF'
import re
from pathlib import Path

f = Path('chambres.html')
c = f.read_text(encoding='utf-8')

# ---------- 3a. Transformer les liens "VOIR TOUS LES TARIFS" en boutons ----------
def fix_voir_tarifs(match):
    article = match.group(0)
    rid = re.search(r'data-room-id="([^"]+)"', article)
    if not rid:
        return article
    return article.replace(
        '<a href="#" class="btn-tarifs">',
        f'<button type="button" class="btn-tarifs" data-tariffs-room="{rid.group(1)}">'
    ).replace(
        'VOIR TOUS LES TARIFS <i class="fa-solid fa-chevron-right"></i></a>',
        'VOIR TOUS LES TARIFS <i class="fa-solid fa-chevron-right"></i></button>'
    )

c = re.sub(r'<article class="room-card[^>]*>.*?</article>', fix_voir_tarifs, c, flags=re.DOTALL)

# ---------- 3b. Ajouter le JS avant la fermeture </script> final ----------
JS_TARIFFS = '''
    // ================= POP-UP : TOUS LES TARIFS =================
    // Table des tarifs par chambre (synchronisée avec reservation.html)
    const TARIFFS_BY_ROOM = {
        'deluxe-ocean': {
            name: 'Chambre Deluxe Vue Océan',
            type: 'CHAMBRE DELUXE',
            tariffs: [
                { name: 'Tarif Flexible', sub: "Annulation gratuite jusqu'à 48h avant l'arrivée", price: 185000, unit: 'par nuit' },
                { name: 'Tarif Non-remboursable', sub: 'Paiement immédiat, −15%', price: 157250, old: 185000, unit: 'par nuit' },
                { name: 'Petit-déjeuner inclus', sub: 'Buffet Teranga Lounge chaque matin', price: 212750, unit: 'par nuit' }
            ]
        },
        'suite-ambassadeur': {
            name: 'Suite Ambassadeur Pullman',
            type: 'SUITE AMBASSADEUR',
            tariffs: [
                { name: 'Tarif Flexible', sub: "Annulation gratuite jusqu'à 48h avant l'arrivée", price: 350000, unit: 'par nuit' },
                { name: 'Tarif Non-remboursable', sub: 'Paiement immédiat, −15%', price: 297500, old: 350000, unit: 'par nuit' },
                { name: 'Petit-déjeuner inclus', sub: 'Buffet Teranga Lounge + service en chambre', price: 402500, unit: 'par nuit' }
            ]
        },
        'superieure-ocean': {
            name: 'Chambre Supérieure Vue Océan',
            type: 'CHAMBRE SUPÉRIEURE',
            tariffs: [
                { name: 'Tarif Flexible', sub: "Annulation gratuite jusqu'à 48h avant l'arrivée", price: 155000, unit: 'par nuit' },
                { name: 'Tarif Non-remboursable', sub: 'Paiement immédiat, −15%', price: 131750, old: 155000, unit: 'par nuit' },
                { name: 'Petit-déjeuner inclus', sub: 'Buffet Teranga Lounge chaque matin', price: 178250, unit: 'par nuit' }
            ]
        }
    };

    const fmtTarif = n => n.toString().replace(/\\B(?=(\\d{3})+(?!\\d))/g, ' ');
    const tariffsModal = document.getElementById('tariffsModal');

    function openTariffsModal(roomId) {
        const data = TARIFFS_BY_ROOM[roomId];
        if (!data || !tariffsModal) return;

        document.getElementById('tariffsRoomType').textContent = data.type;
        document.getElementById('tariffsRoomName').textContent = data.name;

        const list = document.getElementById('tariffsList');
        list.innerHTML = data.tariffs.map((t, i) => {
            const oldHtml = t.old ? `<span class="old">${fmtTarif(t.old)} FCFA</span>` : '';
            const url = `reservation.html?room=${roomId}&tariff=${i}`;
            return `
                <div class="tariff-option">
                    <div class="tariff-option-info">
                        <div class="tariff-option-name">${t.name}</div>
                        <div class="tariff-option-desc">${t.sub}</div>
                    </div>
                    <div class="tariff-option-price">
                        ${oldHtml}
                        <span class="amt">${fmtTarif(t.price)} FCFA</span>
                        <span class="unit">${t.unit}</span>
                    </div>
                    <a href="${url}" class="tariff-option-btn">Sélectionner</a>
                </div>
            `;
        }).join('');

        tariffsModal.classList.add('active');
        document.body.style.overflow = 'hidden';
    }

    function closeTariffsModal() {
        if (!tariffsModal) return;
        tariffsModal.classList.remove('active');
        document.body.style.overflow = '';
    }

    // Attacher les boutons "VOIR TOUS LES TARIFS"
    document.querySelectorAll('.chambres-page .btn-tarifs[data-tariffs-room]').forEach(btn => {
        btn.addEventListener('click', e => {
            e.preventDefault();
            openTariffsModal(btn.dataset.tariffsRoom);
        });
    });

    // Fermeture
    document.getElementById('closeTariffsModal')?.addEventListener('click', closeTariffsModal);
    document.getElementById('closeTariffsModalBtn')?.addEventListener('click', closeTariffsModal);
    tariffsModal?.addEventListener('click', e => {
        if (e.target === tariffsModal) closeTariffsModal();
    });
    document.addEventListener('keydown', e => {
        if (e.key === 'Escape' && tariffsModal?.classList.contains('active')) {
            closeTariffsModal();
        }
    });
'''

# Insérer avant la dernière ligne "});" du script principal
# On cherche le dernier "});" du DOMContentLoaded
pattern = re.compile(r'(\n\s*//\s*=+\s*PARALLAX HERO\s*=+.*?\n\s*\}\n\}\));', re.DOTALL)
match = pattern.search(c)

if match:
    # Insérer avant la fermeture du DOMContentLoaded
    insertion_point = match.start(2) if match.lastindex and match.lastindex >= 2 else match.end() - 6
    # Plus simple : insérer juste avant "});" qui ferme le DOMContentLoaded
    pass

# Approche alternative : chercher "});\n</script>" tout à la fin du script chambres
# Trouver la fin du script inline (après PARALLAX HERO)
end_pattern = re.compile(
    r'(//\s*=+\s*PARALLAX HERO\s*=+\s*\n\s*const heroBg.*?\n\s*\}\n)(\s*\}\s*\)\s*;)',
    re.DOTALL
)
end_match = end_pattern.search(c)
if end_match:
    c = c[:end_match.end(1)] + JS_TARIFFS + '\n' + end_match.group(2) + c[end_match.end(2):]
    print("   ✔ JavaScript pop-up inséré")
else:
    print("   ⚠️  Point d'insertion JS non trouvé — insertion générique")
    # Fallback : insérer avant le dernier </script> de la page
    c = c.replace('</script>\n\n</body>', JS_TARIFFS + '\n</script>\n\n</body>', 1)

f.write_text(c, encoding='utf-8')
PYEOF

echo "   ✔ JavaScript ajouté"

# ---------- Vérification ----------
echo -e "\n${BLUE}━━━ VÉRIFICATION ━━━${NC}"

H=$(cat chambres.html)
CSS=$(cat css/chambres.css)

check() {
    local label="$1"
    local pattern="$2"
    local source="$3"
    local count=$(echo "$source" | grep -c "$pattern" 2>/dev/null || echo 0)
    echo -e "   ${GREEN}✔${NC}  $label : $count"
}

check "Pop-up overlay HTML" 'tariffsModal' "$H"
check "Boutons data-tariffs-room" 'data-tariffs-room=' "$H"
check "Table TARIFFS_BY_ROOM" 'TARIFFS_BY_ROOM' "$H"
check "Fonction openTariffsModal" 'openTariffsModal' "$H"
check "CSS .tariffs-modal-overlay" 'tariffs-modal-overlay' "$CSS"
check "CSS .tariff-option" 'tariff-option' "$CSS"

echo ""
echo -e "${GREEN}✅ TERMINÉ${NC}"
echo -e "${BLUE}💾 Sauvegarde : $BACKUP${NC}"
echo ""
echo -e "${BLUE}📌 Test :${NC}"
echo "   1. Ctrl + Shift + R dans le navigateur"
echo "   2. Ouvrez chambres.html"
echo "   3. Cliquez sur 'VOIR TOUS LES TARIFS' dans une carte"
echo "   4. → Pop-up affichant les 3 tarifs (Flexible / Non-remb. / Petit-déj)"
echo "   5. Cliquez sur 'Sélectionner' → reservation.html?room=XXX&tariff=N"
echo ""
echo -e "${BLUE}🔄 Rollback :${NC}"
echo "   cp $BACKUP/chambres.html $BACKUP/chambres.css css/"
