#!/usr/bin/env bash
# =============================================================================
# fix_reservation.sh
# Corrige les bugs de reservation.html :
#   1. Intègre les extras dans le total (étape 1 + étape 3)
#   2. Préserve le panneau extras après re-render de la sélection
#   3. Supprime le double Flatpickr (déjà géré par booking-bridge.js)
#   4. Ajoute updateTotalWithExtras + refreshSelectionPanel
#   5. Ajoute un vrai bouton "Payer et confirmer" avec génération de réf.
#
# Idempotent : ne réapplique pas les corrections si déjà faites.
# =============================================================================
set -euo pipefail

HTML_FILE="${1:-reservation.html}"
EXTRAS_FILE="${2:-js/extras.js}"

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; BLUE='\033[0;34m'; NC='\033[0m'

echo -e "${BLUE}=====================================================${NC}"
echo -e "${BLUE} FIX RESERVATION.HTML — Extras + Flatpickr + Total${NC}"
echo -e "${BLUE}=====================================================${NC}\n"

# ---------- Vérifications ----------
if [ ! -f "$HTML_FILE" ]; then
  echo -e "${RED}❌ $HTML_FILE introuvable${NC}"; exit 1
fi
if [ ! -f "$EXTRAS_FILE" ]; then
  echo -e "${RED}❌ $EXTRAS_FILE introuvable${NC}"; exit 1
fi
if ! command -v python3 >/dev/null 2>&1; then
  echo -e "${RED}❌ python3 requis${NC}"; exit 1
fi

# ---------- Sauvegarde ----------
BACKUP=".backup_fix_res_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP"
cp "$HTML_FILE" "$BACKUP/"
cp "$EXTRAS_FILE" "$BACKUP/"
echo -e "${GREEN}📦 Sauvegarde → $BACKUP${NC}\n"

# =============================================================================
# 1) PATCH reservation.html via Python (fiable pour HTML multi-lignes)
# =============================================================================
echo -e "${BLUE}━━━ Patch reservation.html ━━━${NC}"

python3 - "$HTML_FILE" << 'PY_EOF'
import re, sys
from pathlib import Path

path = Path(sys.argv[1])
html = path.read_text(encoding='utf-8')

changed = []

# ---------------------------------------------------------------------------
# 1a. Supprimer les 2 lignes Flatpickr en double (déjà faites par booking-bridge.js)
# ---------------------------------------------------------------------------
old_fp = '''flatpickr("#cta-checkin",  { locale: "fr", dateFormat: "d M. Y", minDate: "today" });
flatpickr("#cta-checkout", { locale: "fr", dateFormat: "d M. Y", minDate: "today" });'''

if old_fp in html:
    html = html.replace(old_fp, '/* Flatpickr géré par booking-bridge.js */', 1)
    changed.append("Flatpickr en double supprimé")
else:
    changed.append("Flatpickr déjà nettoyé (ou absent)")

# ---------------------------------------------------------------------------
# 1b. Ajouter les helpers extras AVANT "function renderRecap()"
# ---------------------------------------------------------------------------
helper_block = '''/* ===== HELPERS EXTRAS ===== */
function getExtrasTotal() {
  return (window.Extras && typeof window.Extras.getSubtotal === 'function')
    ? window.Extras.getSubtotal() : 0;
}
function getExtrasObjects() {
  return (window.Extras && typeof window.Extras.getSelectedObjects === 'function')
    ? window.Extras.getSelectedObjects() : [];
}

window.updateTotalWithExtras = function () {
  if (selected) {
    renderSelection();
    var p3 = document.getElementById('panel-3');
    if (p3 && p3.classList.contains('active')) renderRecap();
  }
};

'''

anchor_recap = 'function renderRecap(){'
if 'window.updateTotalWithExtras' not in html and anchor_recap in html:
    html = html.replace(anchor_recap, helper_block + anchor_recap, 1)
    changed.append("Helpers extras ajoutés")
else:
    changed.append("Helpers extras déjà présents")

# ---------------------------------------------------------------------------
# 1c. Réécrire renderSelection() pour intégrer les extras dans le total
# ---------------------------------------------------------------------------
new_render_selection = '''function renderSelection(){
  const el = document.getElementById('selContent');
  const btn = document.getElementById('btnContinueStep1');
  if (!selected){
    el.innerHTML = '<p class="sel-empty">Choisissez une chambre et un tarif dans la liste pour voir apparaître ici le détail de votre réservation.</p>';
    btn.disabled = true;
    if (window.Extras && typeof window.Extras.refreshSelectionPanel === 'function') window.Extras.refreshSelectionPanel();
    return;
  }
  const n = nights(), g = guestsCount();
  const room = selected.room, tariff = selected.tariff;
  const sousTotal = tariff.price * n;
  const taxe = TAXE_NUIT_PERS * g * n;
  const extrasTotal = getExtrasTotal();
  const total = sousTotal + taxe + extrasTotal;
  el.innerHTML =
    '<div class="sel-room"><div class="ph">Photo</div>' +
      '<div><div class="sel-room-name">' + room.name + '</div><div class="sel-room-tariff">' + tariff.name + '</div></div>' +
    '</div>' +
    '<div class="sel-meta">' +
      '<div><span>Arrivée</span><b>' + fmtDate(document.getElementById('dArrivee').value) + '</b></div>' +
      '<div><span>Départ</span><b>' + fmtDate(document.getElementById('dDepart').value) + '</b></div>' +
      '<div><span>Voyageurs</span><b>' + document.getElementById('dVoy').value + '</b></div>' +
      '<div><span>Nuits</span><b>' + n + '</b></div>' +
    '</div>' +
    '<div class="price-detail">' +
      '<div><span>' + fmt(tariff.price) + ' × ' + n + ' nuit' + (n > 1 ? 's' : '') + '</span><b>' + fmt(sousTotal) + '</b></div>' +
      '<div class="sub"><span>Taxe de promotion touristique</span><b>' + fmt(taxe) + '</b></div>' +
      (extrasTotal > 0 ? '<div><span>Extras</span><b>' + fmt(extrasTotal) + '</b></div>' : '') +
      '<div><span>TVA</span><b>incluse</b></div>' +
    '</div>' +
    '<div class="price-total"><span class="lbl">TOTAL SÉJOUR</span><span class="amt">' + fmt(total) + '</span></div>';
  btn.disabled = false;

  /* Réinjecter le panneau extras après le nouveau innerHTML */
  if (window.Extras && typeof window.Extras.refreshSelectionPanel === 'function') {
    window.Extras.refreshSelectionPanel();
  }
}'''

# Match la fonction complète renderSelection(){ ... } jusqu'au prochain \n}
pattern = re.compile(r'function renderSelection\(\)\{.*?\n\}', re.DOTALL)
if pattern.search(html):
    html = pattern.sub(new_render_selection, html, count=1)
    changed.append("renderSelection() réécrite (extras inclus)")
else:
    changed.append("⚠️  renderSelection() introuvable")

# ---------------------------------------------------------------------------
# 1d. Réécrire renderRecap() pour intégrer les extras dans le total final
# ---------------------------------------------------------------------------
new_render_recap = '''function renderRecap(){
  if (!selected) return;
  const n = nights(), g = guestsCount();
  const room = selected.room, tariff = selected.tariff;
  const sousTotal = tariff.price * n;
  const taxe = TAXE_NUIT_PERS * g * n;
  const extrasTotal = getExtrasTotal();
  const extrasList = getExtrasObjects();
  const total = sousTotal + taxe + extrasTotal;

  document.getElementById('recapStay').innerHTML =
    '<div class="recap-line"><span>Chambre</span><b>' + room.name + '</b></div>' +
    '<div class="recap-line"><span>Tarif</span><b>' + tariff.name + '</b></div>' +
    '<div class="recap-line"><span>Arrivée</span><b>' + fmtDate(document.getElementById('dArrivee').value) + '</b></div>' +
    '<div class="recap-line"><span>Départ</span><b>' + fmtDate(document.getElementById('dDepart').value) + '</b></div>' +
    '<div class="recap-line"><span>Voyageurs</span><b>' + document.getElementById('dVoy').value + '</b></div>' +
    (extrasList.length > 0
      ? '<div class="recap-line"><span>Extras</span><b>' + extrasList.map(function(e){return e.name;}).join(', ') + '</b></div>'
      : '');

  const form = document.getElementById('coordForm');
  const inputs = form.querySelectorAll('input[type=text],input[type=email],input[type=tel]');
  const prenom = (inputs[0] && inputs[0].value) || '—';
  const nom = (inputs[1] && inputs[1].value) || '—';
  const emailEl = form.querySelector('input[type=email]');
  const email = (emailEl && emailEl.value) || '—';
  document.getElementById('recapCoord').innerHTML =
    '<div class="recap-line"><span>Nom</span><b>' + prenom + ' ' + nom + '</b></div>' +
    '<div class="recap-line"><span>E-mail</span><b>' + email + '</b></div>';

  document.getElementById('finalPriceDetail').innerHTML =
    '<div><span>' + fmt(tariff.price) + ' × ' + n + ' nuit' + (n > 1 ? 's' : '') + '</span><b>' + fmt(sousTotal) + '</b></div>' +
    '<div class="sub"><span>Taxe de promotion touristique</span><b>' + fmt(taxe) + '</b></div>' +
    (extrasTotal > 0 ? '<div><span>Extras (' + extrasList.length + ')</span><b>' + fmt(extrasTotal) + '</b></div>' : '') +
    '<div><span>TVA</span><b>incluse</b></div>';

  document.getElementById('finalTotal').textContent = fmt(total);

  const arr = new Date(document.getElementById('dArrivee').value);
  arr.setDate(arr.getDate() - 2);
  document.getElementById('policyDate').textContent =
    arr.toLocaleDateString('fr-FR',{day:'2-digit',month:'short',year:'numeric'}) + ', 18h00';

  document.getElementById('confSummary').innerHTML =
    '<div class="recap-line"><span>Chambre</span><b>' + room.name + ' — ' + tariff.name + '</b></div>' +
    '<div class="recap-line"><span>Séjour</span><b>' + fmtDate(document.getElementById('dArrivee').value) + ' → ' + fmtDate(document.getElementById('dDepart').value) + '</b></div>' +
    '<div class="recap-line"><span>Voyageur</span><b>' + prenom + ' ' + nom + '</b></div>' +
    (extrasList.length > 0
      ? '<div class="recap-line"><span>Extras</span><b>' + extrasList.map(function(e){return e.name + ' (' + fmt(e.price) + ')';}).join(' · ') + '</b></div>'
      : '') +
    '<div class="recap-line"><span>Total réglé</span><b>' + fmt(total) + '</b></div>';
}

window.confirmAndPay = function(){
  if (!selected) { alert('Veuillez sélectionner une chambre.'); return; }
  var ref = 'PDT-' + Math.floor(100000 + Math.random() * 900000);
  var refEl = document.getElementById('bookingRef');
  if (refEl) refEl.textContent = ref;
  renderRecap();
  goStep(4);
};'''

pattern2 = re.compile(r'function renderRecap\(\)\{.*?\n\}', re.DOTALL)
if pattern2.search(html):
    html = pattern2.sub(new_render_recap, html, count=1)
    changed.append("renderRecap() réécrite (extras + réf. dynamique)")
else:
    changed.append("⚠️  renderRecap() introuvable")

# ---------------------------------------------------------------------------
# 1e. Câbler le bouton "Payer et confirmer" sur confirmAndPay()
# ---------------------------------------------------------------------------
old_btn = '<button type="button" class="btn-continue" onclick="goStep(4)">Payer et confirmer</button>'
new_btn = '<button type="button" class="btn-continue" onclick="confirmAndPay()">Payer et confirmer</button>'
if old_btn in html:
    html = html.replace(old_btn, new_btn, 1)
    changed.append("Bouton 'Payer et confirmer' câblé sur confirmAndPay()")
else:
    changed.append("Bouton 'Payer' déjà câblé ou introuvable")

# ---------------------------------------------------------------------------
# Écriture
# ---------------------------------------------------------------------------
path.write_text(html, encoding='utf-8')
for c in changed:
    print("   ✔ " + c)
PY_EOF

# =============================================================================
# 2) PATCH extras.js — ajouter refreshSelectionPanel()
# =============================================================================
echo ""
echo -e "${BLUE}━━━ Patch extras.js ━━━${NC}"

python3 - "$EXTRAS_FILE" << 'PY_EOF'
import sys
from pathlib import Path

path = Path(sys.argv[1])
js = path.read_text(encoding='utf-8')

if 'refreshSelectionPanel' in js:
    print("   ℹ  refreshSelectionPanel() déjà présent")
else:
    # Insérer dans l'objet window.Extras
    anchor = "    window.Extras = {"
    addition = """    window.Extras = {
        refreshSelectionPanel: function () { renderSelectionPanel(); },
"""
    if anchor in js:
        js = js.replace(anchor, addition, 1)
        path.write_text(js, encoding='utf-8')
        print("   ✔ refreshSelectionPanel() ajouté à window.Extras")
    else:
        print("   ❌ Ancre 'window.Extras = {' introuvable")
        sys.exit(1)
PY_EOF

# =============================================================================
# 3) VÉRIFICATION FINALE
# =============================================================================
echo ""
echo -e "${BLUE}━━━ VÉRIFICATION ━━━${NC}"

check() {
  local label="$1"; local pattern="$2"; local file="$3"
  local count=$(grep -c "$pattern" "$file" 2>/dev/null || echo 0)
  if [ "$count" -gt 0 ]; then
    echo -e "   ${GREEN}✔${NC} $label ($count)"
  else
    echo -e "   ${RED}✘${NC} $label — MANQUANT"
  fi
}

check "Helpers extras (updateTotalWithExtras)" "updateTotalWithExtras" "$HTML_FILE"
check "getExtrasTotal() défini"                "function getExtrasTotal"  "$HTML_FILE"
check "confirmAndPay() défini"                 "window.confirmAndPay"     "$HTML_FILE"
check "Bouton câblé sur confirmAndPay"         "onclick=\"confirmAndPay()\"" "$HTML_FILE"
check "Flatpickr inline supprimé"              "Flatpickr géré par booking-bridge" "$HTML_FILE"
check "refreshSelectionPanel() dans extras"    "refreshSelectionPanel"    "$EXTRAS_FILE"

echo ""
echo -e "${GREEN}✅ TERMINÉ${NC}"
echo -e "${BLUE}💾 Sauvegarde : $BACKUP${NC}"
echo ""
echo -e "${BLUE}📌 TEST :${NC}"
echo "   1. Ouvre reservation.html dans le navigateur"
echo "   2. Ctrl + Shift + R (hard refresh)"
echo "   3. Sélectionne une chambre + un tarif"
echo "   4. Ajoute un extra (ex: Massage 45 000 FCFA)"
echo "      → Le TOTAL SÉJOUR doit augmenter de 45 000"
echo "   5. Clique Continuer → étape 3"
echo "      → Le total final doit inclure les extras"
echo "      → La ligne 'Extras (1)' apparaît"
echo "   6. Clique 'Payer et confirmer'"
echo "      → Le numéro de réservation change (PDT-XXXXXX)"
echo ""
echo -e "${BLUE}🔄 ROLLBACK :${NC}"
echo "   cp $BACKUP/reservation.html ."
echo "   cp $BACKUP/extras.js js/"
echo ""
