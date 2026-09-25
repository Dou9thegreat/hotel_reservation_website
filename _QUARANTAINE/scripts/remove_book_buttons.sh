#!/usr/bin/env bash
# Retire les boutons "RÉSERVER" (room-btn--book) de index.html
set -uo pipefail

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; BLUE='\033[0;34m'; NC='\033[0m'

BACKUP=".backup_bookbtn_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP"
[ -f "index.html" ] && cp "index.html" "$BACKUP/"
echo -e "${GREEN}📦 Sauvegarde → $BACKUP${NC}\n"

python3 << 'PY_EOF'
import re
from pathlib import Path

p = Path('index.html')
html = p.read_text(encoding='utf-8')
original = html

# Retirer les boutons "RÉSERVER" avec la classe room-btn--book
# Ils ressemblent à :
#   <a href="reservation.html?room=XXX" class="room-btn room-btn--book">RÉSERVER <i ...></i></a>

patterns = [
    # Variante standard (avec retours à la ligne possibles)
    re.compile(
        r'\s*<a\s+href="reservation\.html\?room=[^"]*"\s+class="room-btn\s+room-btn--book">\s*RÉSERVER\s*<i[^>]*></i>\s*</a>',
        re.DOTALL
    ),
    # Variante sans <i> final
    re.compile(
        r'\s*<a\s+href="reservation\.html\?room=[^"]*"\s+class="room-btn\s+room-btn--book">\s*RÉSERVER\s*</a>',
        re.DOTALL
    ),
    # Variante générique (filet de sécurité)
    re.compile(
        r'\s*<a[^>]*class="[^"]*room-btn--book[^"]*"[^>]*>.*?</a>',
        re.DOTALL
    ),
]

total_removed = 0
for pat in patterns:
    html, n = pat.subn('', html)
    total_removed += n

# Nettoyer les lignes vides résiduelles (double saut de ligne)
html = re.sub(r'\n{3,}', '\n\n', html)

print(f"   ✔ {total_removed} bouton(s) 'RÉSERVER' supprimé(s)")

if html != original:
    p.write_text(html, encoding='utf-8')
else:
    print("   ℹ  Aucun bouton à supprimer")
PY_EOF

echo ""
echo -e "${BLUE}━━━ Vérification ━━━${NC}"
if grep -q 'room-btn--book' index.html; then
    echo -e "   ${RED}✘${NC} room-btn--book encore présent"
    echo -e "   ${YELLOW}   Vérifiez manuellement dans index.html${NC}"
else
    echo -e "   ${GREEN}✔${NC} Aucun room-btn--book dans index.html"
fi

echo ""
echo -e "${GREEN}✅ TERMINÉ${NC}"
echo -e "💾 Sauvegarde : $BACKUP"
echo ""
echo -e "${BLUE}🔄 Pour annuler ce rollback :${NC}"
echo "   cp $BACKUP/index.html ."
echo ""
