#!/usr/bin/env bash
# =============================================================================
# fix_hero_image.sh  (v2 — robuste)
#
# Corrige l'affichage du hero :
#   1. Retire le fond gradient du .hero (qui masque .ph)
#   2. Corrige z-index: -1 → 0 sur .ph
#   3. Ajoute un dégradé bleu élégant par-dessus l'image
#   4. Passe .hero-text au-dessus du .ph (z-index)
#
# Modifie UNIQUEMENT css/reservation.css
# =============================================================================
set -uo pipefail

CSS_FILE="${1:-css/reservation.css}"
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; BLUE='\033[0;34m'; NC='\033[0m'

echo -e "${BLUE}═══════════════════════════════════════════${NC}"
echo -e "${BLUE}  FIX HERO — Image + Dégradé élégant (v2)${NC}"
echo -e "${BLUE}═══════════════════════════════════════════${NC}\n"

if [ ! -f "$CSS_FILE" ]; then
  echo -e "${RED}❌ $CSS_FILE introuvable${NC}"; exit 1
fi
if ! command -v python3 >/dev/null 2>&1; then
  echo -e "${RED}❌ python3 requis${NC}"; exit 1
fi

# ---------- Sauvegarde ----------
BACKUP=".backup_hero_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP"
cp "$CSS_FILE" "$BACKUP/"
echo -e "${GREEN}📦 Sauvegarde → $BACKUP${NC}\n"

# ---------- Patch Python (robuste : cible les blocs par sélecteur) ----------
python3 - "$CSS_FILE" << 'PY_EOF'
import re, sys
from pathlib import Path

path = Path(sys.argv[1])
css = path.read_text(encoding='utf-8')
report = []

# ============================================================
# 1. Bloc .reservation-page .hero { ... } → retirer le background
# ============================================================
hero_re = re.compile(
    r'(\.reservation-page\s+\.hero\s*\{)([^{}]*?)(\})',
    re.DOTALL
)

def process_hero(m):
    prefix, content, suffix = m.group(1), m.group(2), m.group(3)
    new_content, n = re.subn(
        r'\n?\s*background\s*:\s*[^;]*;',
        '', content, count=1
    )
    if n:
        report.append("  ✔ .hero : fond linear-gradient retiré")
    else:
        report.append("  ℹ  .hero : aucun fond à retirer")
    return prefix + new_content + suffix

css, n = hero_re.subn(process_hero, css, count=1)
if n == 0:
    report.append("  ❌ .hero : bloc non trouvé")
    print("\n".join(report))
    sys.exit(2)

# ============================================================
# 2. Bloc .reservation-page .hero .ph { ... }
#    → z-index: 0 + nouveau dégradé élégant + image
# ============================================================
ph_re = re.compile(
    r'(\.reservation-page\s+\.hero\s+\.ph\s*\{)([^{}]*?)(\})',
    re.DOTALL
)

def process_ph(m):
    prefix, content, suffix = m.group(1), m.group(2), m.group(3)

    # a. Corriger z-index
    content = re.sub(r'z-index\s*:\s*-1\s*;', 'z-index: 0;', content)
    if 'z-index' not in content:
        content = content.rstrip() + "\n  z-index: 0;"

    # b. Remplacer/augmenter le background-image
    new_bg = (
        "background-image:\n"
        "    linear-gradient(120deg,\n"
        "      rgba(14, 74, 94, 0.92) 0%,\n"
        "      rgba(14, 74, 94, 0.78) 30%,\n"
        "      rgba(21, 94, 117, 0.55) 60%,\n"
        "      rgba(21, 94, 117, 0.35) 100%),\n"
        "    url('../images/hero.png');"
    )
    content, n = re.subn(
        r'background-image\s*:\s*[^;]*;',
        new_bg, content, count=1
    )
    if n:
        report.append("  ✔ .hero .ph : dégradé élégant + image appliqués")
    else:
        # Pas de background-image → on l'ajoute
        content = content.rstrip() + "\n  " + new_bg + "\n"
        report.append("  ✔ .hero .ph : background-image ajouté")

    # c. S'assurer que background-size/position existent
    if 'background-size' not in content:
        content = content.rstrip() + "\n  background-size: cover;\n  background-position: center;\n"
    return prefix + content + suffix

css, n = ph_re.subn(process_ph, css, count=1)
if n == 0:
    report.append("  ❌ .hero .ph : bloc non trouvé")
else:
    report.append("  ✔ .hero .ph : mis à jour")

# ============================================================
# 3. Bloc .reservation-page .hero-text { ... }
#    → ajouter position:relative; z-index:1 (une seule fois)
# ============================================================
text_re = re.compile(
    r'(\.reservation-page\s+\.hero-text\s*\{)([^{}]*?)(\})',
    re.DOTALL
)

def process_text(m):
    prefix, content, suffix = m.group(1), m.group(2), m.group(3)
    if 'z-index' in content and 'position' in content:
        report.append("  ℹ  .hero-text : z-index/position déjà présents")
        return m.group(0)
    insert = "position: relative;\n  z-index: 1;\n  "
    new_content = insert + content.lstrip('\n ').lstrip()
    report.append("  ✔ .hero-text : position + z-index ajoutés")
    return prefix + new_content + suffix

css, n = text_re.subn(process_text, css, count=1)
if n == 0:
    report.append("  ⚠  .hero-text : bloc non trouvé (non bloquant)")

# ============================================================
# Écriture
# ============================================================
path.write_text(css, encoding='utf-8')
print("\n".join(report))
sys.exit(0)
PY_EOF

EXIT=$?

if [ "$EXIT" -ne 0 ]; then
    echo ""
    echo -e "${RED}⚠️  Erreur (code $EXIT) — fichier intact${NC}"
    echo -e "${YELLOW}   Sauvegarde : $BACKUP${NC}"
    exit "$EXIT"
fi

# ---------- Vérification ----------
echo ""
echo -e "${BLUE}━━━ VÉRIFICATION ━━━${NC}"

check() {
  local label="$1"; local pattern="$2"
  if grep -q "$pattern" "$CSS_FILE" 2>/dev/null; then
    echo -e "   ${GREEN}✔${NC} $label"
  else
    echo -e "   ${YELLOW}⚠${NC}  $label"
  fi
}

check "z-index: 0 sur .hero .ph"            'z-index: 0'
check "Dégradé bleu élégant présent"         'rgba(14, 74, 94, 0.92)'
check "Référence url('../images/hero.png')"  "url('../images/hero.png')"

if [ -f "images/hero.png" ]; then
  echo -e "   ${GREEN}✔${NC} images/hero.png existe sur le disque"
else
  echo -e "   ${YELLOW}⚠${NC}  images/hero.png ABSENT — copiez votre photo dans images/"
fi

echo ""
echo -e "${GREEN}✅ TERMINÉ${NC}"
echo -e "💾 Sauvegarde : $BACKUP"
echo ""
echo -e "${BLUE}🧪 Test :${NC}"
echo "   1. Ctrl + Shift + R dans le navigateur"
echo "   2. Le hero doit afficher l'image avec un dégradé bleu élégant"
echo ""
echo -e "${BLUE}🔄 Rollback :${NC}"
echo "   cp $BACKUP/$(basename "$CSS_FILE") $(dirname "$CSS_FILE")/"
echo ""
