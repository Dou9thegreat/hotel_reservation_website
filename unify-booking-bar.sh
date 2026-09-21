#!/bin/bash
# =============================================================
# UNIFY-BOOKING-BAR.SH
# Unifie la barre de réservation (CTA) sur toutes les pages,
# avec index.html comme référence, sauf reservation.html
# =============================================================

set -e

REFERENCE="index.html"
EXCLUDE="reservation.html"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE} UNIFICATION DE LA BARRE DE RÉSERVATION  ${NC}"
echo -e "${BLUE}=========================================${NC}"
echo ""

# ---------- Vérifs ----------
if [ ! -f "$REFERENCE" ]; then
    echo -e "${RED}❌ Fichier référence '$REFERENCE' introuvable${NC}"
    exit 1
fi

if ! command -v python3 &> /dev/null; then
    echo -e "${RED}❌ python3 requis mais introuvable${NC}"
    exit 1
fi

# ---------- Sauvegardes ----------
echo "📦 Création des sauvegardes..."
mkdir -p .backup-booking
for f in *.html; do
    cp "$f" ".backup-booking/$f.bak"
done
echo "   ✔ Sauvegardes dans .backup-booking/"
echo ""

# ---------- Traitement Python ----------
python3 - "$REFERENCE" "$EXCLUDE" << 'PYEOF'
import re, sys
from pathlib import Path

reference = sys.argv[1]
exclude   = sys.argv[2]

GREEN  = '\033[0;32m'
YELLOW = '\033[1;33m'
RED    = '\033[0;31m'
BLUE   = '\033[0;34m'
NC     = '\033[0m'

# --- 1. Extraire le bloc de référence ---
ref_content = Path(reference).read_text(encoding="utf-8")

pattern = re.compile(
    r'(<section\s+class="booking-section"[^>]*>)(.*?)(</section>)',
    re.DOTALL
)
match = pattern.search(ref_content)

if not match:
    print(f"{RED}❌ Aucune <section class=\"booking-section\"> dans {reference}{NC}")
    sys.exit(1)

reference_block = match.group(0)

# Vérif basique d'équilibre <section> ... </section>
opens  = len(re.findall(r'<section\b', reference_block))
closes = len(re.findall(r'</section>', reference_block))
if opens != closes:
    print(f"{YELLOW}⚠  Le bloc référence contient {opens} <section> et {closes} </section>{NC}")
    print(f"{YELLOW}   Vérifie manuellement {reference} — des <section> imbriquées perturbent la détection.{NC}")
    sys.exit(1)

print(f"{GREEN}✔ Bloc référence extrait de {reference} ({len(reference_block)} caractères){NC}")
print("")

# --- 2. Parcourir tous les HTML ---
html_files = sorted(Path(".").glob("*.html"))
if not html_files:
    print(f"{RED}❌ Aucun fichier HTML trouvé à la racine{NC}")
    sys.exit(1)

modified = skipped = inserted = removed = 0

for html_file in html_files:
    name = html_file.name
    content = html_file.read_text(encoding="utf-8")
    has_section = '<section class="booking-section"' in content

    # ---- Cas 1 : reservation.html (doit NE PAS avoir la section) ----
    if name == exclude:
        if has_section:
            new_content = pattern.sub('', content, count=1)
            new_content = re.sub(r'\n{3,}', '\n\n', new_content)
            html_file.write_text(new_content, encoding="utf-8")
            print(f"{YELLOW}✔ {name} : section CTA RETIRÉE (page réservation){NC}")
            removed += 1
        else:
            print(f"{GREEN}✔ {name} : aucune section CTA (conforme){NC}")
            skipped += 1
        continue

    # ---- Cas 2 : le fichier référence ----
    if name == reference:
        print(f"ℹ  {name} : fichier référence, non modifié")
        skipped += 1
        continue

    # ---- Cas 3 : autres pages → synchroniser ----
    if has_section:
        new_content = pattern.sub(reference_block, content, count=1)
        if new_content != content:
            html_file.write_text(new_content, encoding="utf-8")
            print(f"{GREEN}✔ {name} : section synchronisée avec {reference}{NC}")
            modified += 1
        else:
            print(f"ℹ  {name} : déjà identique à {reference}")
            skipped += 1
    else:
        # Tenter insertion avant le footer
        inserted_here = False
        for pat in [r'(</footer>)', r'(<footer\b)', r'(<!--\s*FOOTER)']:
            fm = re.search(pat, content, re.IGNORECASE)
            if fm:
                pos = fm.start()
                new_content = (
                    content[:pos].rstrip() + "\n\n" +
                    reference_block + "\n\n" +
                    content[pos:]
                )
                html_file.write_text(new_content, encoding="utf-8")
                print(f"{GREEN}✔ {name} : section CTA INSÉRÉE avant le footer{NC}")
                inserted += 1
                inserted_here = True
                break
        if not inserted_here:
            print(f"{YELLOW}⚠  {name} : ni section CTA ni footer détecté — insertion manuelle requise{NC}")

print("")
print(f"{BLUE}========================================={NC}")
print(f"{GREEN}Résumé :{NC}")
print(f"  • Synchronisées : {modified}")
print(f"  • Insérées      : {inserted}")
print(f"  • Retirées      : {removed}")
print(f"  • Ignorées      : {skipped}")
print(f"{BLUE}========================================={NC}")
PYEOF

echo ""
echo -e "${GREEN}✅ Unification terminée !${NC}"
echo ""
echo -e "${BLUE}📋 Vérifications recommandées :${NC}"
echo "   1. grep -l 'booking-section' *.html   # doit exclure $EXCLUDE"
echo "   2. Ouvre $REFERENCE et contact.html côte à côte"
echo "   3. Ctrl+Shift+R dans le navigateur"
echo ""
echo -e "${BLUE}🔄 Rollback :${NC}"
echo "   cp .backup-booking/*.bak ."
echo ""
echo -e "${BLUE}🧹 Nettoyage final (après validation) :${NC}"
echo "   rm -rf .backup-booking unify-booking-bar.sh"
