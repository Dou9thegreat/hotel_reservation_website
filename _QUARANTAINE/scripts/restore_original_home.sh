#!/usr/bin/env bash
# =============================================================================
# restore_original_home.sh
#
# Restaure l'état d'origine de :
#   - index.html        (retire badges, boutons Réserver, classes populaires)
#   - css/index.css     (retire le bloc "AMÉLIORATIONS PAGE D'ACCUEIL")
#
# Nettoyage ciblé, sûr et idempotent.
# =============================================================================
set -uo pipefail

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; BLUE='\033[0;34m'; NC='\033[0m'

BACKUP=".backup_restore_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP"
for f in index.html css/index.css; do
    [ -f "$f" ] && cp "$f" "$BACKUP/$(basename $f)"
done

echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  RESTAURATION DESIGN D'ORIGINE — index.html + index.css${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}\n"
echo -e "${GREEN}📦 Sauvegarde → $BACKUP${NC}\n"

# =============================================================================
# 1. NETTOYER index.html
# =============================================================================
echo -e "${BLUE}━━━ 1. Nettoyage de index.html ━━━${NC}"

python3 << 'PY_EOF'
import re
from pathlib import Path

p = Path('index.html')
html = p.read_text(encoding='utf-8')
original = html
changes = []

# -------------------------------------------------------------------
# 1a. Supprimer les <span class="room-badge ...">...</span>
# -------------------------------------------------------------------
pattern_badges = re.compile(
    r'\s*<span class="room-badge[^"]*">[^<]*</span>\s*',
    re.DOTALL
)
html, n = pattern_badges.subn('\n', html)
if n:
    changes.append(f"Badges room supprimés ({n})")

# -------------------------------------------------------------------
# 1b. Supprimer les <a class="room-btn room-btn--book">...</a>
# -------------------------------------------------------------------
# Variante avec retour à la ligne
pattern_book = re.compile(
    r'\s*<a\s+href="reservation\.html\?room=[^"]*"\s+class="room-btn\s+room-btn--book"[^>]*>.*?</a>\s*',
    re.DOTALL
)
html, n1 = pattern_book.subn('\n', html)
if n1:
    changes.append(f"Boutons Réserver supprimés ({n1})")

# Filet de sécurité : variante générique
pattern_book2 = re.compile(
    r'\s*<a[^>]*class="[^"]*room-btn--book[^"]*"[^>]*>.*?</a>\s*',
    re.DOTALL
)
html, n2 = pattern_book2.subn('\n', html)
if n2:
    changes.append(f"Boutons Réserver (fallback) supprimés ({n2})")

# -------------------------------------------------------------------
# 1c. Retirer la classe exp-card--popular
# -------------------------------------------------------------------
html, n3 = re.subn(
    r'class="exp-card exp-card--popular gsap-reveal"',
    'class="exp-card gsap-reveal"',
    html
)
if n3:
    changes.append(f"Classe exp-card--popular retirée ({n3})")

# -------------------------------------------------------------------
# 1d. Nettoyer les lignes vides multiples créées par les suppressions
# -------------------------------------------------------------------
html = re.sub(r'\n[ \t]*\n[ \t]*\n', '\n\n', html)

# -------------------------------------------------------------------
# Rapport
# -------------------------------------------------------------------
if changes:
    for c in changes:
        print(f"   ✔ {c}")
else:
    print("   ℹ  Aucune modification nécessaire")

if html != original:
    p.write_text(html, encoding='utf-8')
PY_EOF

# =============================================================================
# 2. NETTOYER css/index.css
# =============================================================================
echo ""
echo -e "${BLUE}━━━ 2. Nettoyage de css/index.css ━━━${NC}"

python3 << 'PY_EOF'
import re
from pathlib import Path

p = Path('css/index.css')
css = p.read_text(encoding='utf-8')
original = css

# Trouver le début du bloc ajouté
marker = "/* 12. AMÉLIORATIONS PAGE D'ACCUEIL"
if marker in css:
    idx = css.index(marker)
    # Revenir au début du bloc commentaire qui précède
    start = css.rfind('/*', 0, idx)
    if start == -1:
        start = idx
    css = css[:start].rstrip() + '\n'
    print("   ✔ Bloc 'AMÉLIORATIONS PAGE D'ACCUEIL' supprimé")
else:
    # Fallback : retirer les règles par nom
    patterns = [
        r'\.room-badge[^{]*\{[^}]*\}\s*',
        r'\.room-badge--[^{]*\{[^}]*\}\s*',
        r'\.room-badge::before\s*\{[^}]*\}\s*',
        r'\.room-btn--book[^{]*\{[^}]*\}\s*',
        r'\.room-btn--book:hover[^{]*\{[^}]*\}\s*',
        r'\.room-btn--book i\s*\{[^}]*\}\s*',
        r'\.room-btn--book:hover i\s*\{[^}]*\}\s*',
        r'\.exp-card--popular[^{]*\{[^}]*\}\s*',
        r'\.exp-card--popular::before\s*\{[^}]*\}\s*',
    ]
    total = 0
    for pat in patterns:
        css, n = re.subn(pat, '', css)
        total += n
    if total:
        print(f"   ✔ {total} règle(s) CSS supprimée(s) (fallback)")
    else:
        print("   ℹ  Aucun bloc à supprimer")

if css != original:
    p.write_text(css, encoding='utf-8')
PY_EOF

# =============================================================================
# 3. VÉRIFICATION FINALE
# =============================================================================
echo ""
echo -e "${BLUE}━━━ 3. Vérification ━━━${NC}"

check() {
    local label="$1"; local pattern="$2"; local file="$3"
    if grep -q "$pattern" "$file" 2>/dev/null; then
        echo -e "   ${RED}✘${NC} $label  (encore présent)"
    else
        echo -e "   ${GREEN}✔${NC} $label  (supprimé)"
    fi
}

echo -e "${BLUE}   → index.html${NC}"
check "Badges room"                'room-badge'             index.html
check "Boutons Réserver"           'room-btn--book'         index.html
check "Classe exp-card--popular"   'exp-card--popular'      index.html

echo ""
echo -e "${BLUE}   → css/index.css${NC}"
check "Bloc améliorations"         "AMÉLIORATIONS PAGE"     css/index.css
check "Règles .room-badge"         '\.room-badge'           css/index.css
check "Règles .room-btn--book"     '\.room-btn--book'       css/index.css
check "Règles .exp-card--popular"  '\.exp-card--popular'    css/index.css

echo ""
echo -e "${GREEN}═══════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}  ✅ RESTAURATION TERMINÉE${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════════${NC}"
echo ""
echo -e "💾 Sauvegarde : $BACKUP"
echo ""
echo -e "${BLUE}🧪 TEST :${NC}"
echo "   1. Ctrl + Shift + R sur index.html"
echo "   2. Le design doit être IDENTIQUE à l'original"
echo "   3. Pas de badge, pas de bouton Réserver supplémentaire"
echo ""
echo -e "${BLUE}🔄 ROLLBACK :${NC}"
echo "   cp $BACKUP/index.html ."
echo "   cp $BACKUP/index.css css/"
echo ""
