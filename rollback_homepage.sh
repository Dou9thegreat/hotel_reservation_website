#!/usr/bin/env bash
# =============================================================================
# rollback_homepage.sh
#
# Annule les modifications faites par :
#   - fix_homepage_links.sh
#   - improve_homepage.sh
#
# Actions :
#   1. Restaure index.html et chambres.html depuis le backup le plus récent
#   2. Supprime le bloc CSS ajouté à css/index.css
#   3. Supprime .missing_images.txt
#
# Sécurisé : sauvegarde l'état actuel avant restauration.
# =============================================================================
set -uo pipefail

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; BLUE='\033[0;34m'; NC='\033[0m'

echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  ROLLBACK — Annulation des modifications homepage${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}\n"

# =============================================================================
# ÉTAPE 0 : Sauvegarde de l'état actuel (au cas où)
# =============================================================================
SAFETY=".backup_rollback_safety_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$SAFETY"
for f in index.html chambres.html css/index.css; do
    [ -f "$f" ] && cp "$f" "$SAFETY/"
done
echo -e "${GREEN}📦 État actuel sauvegardé → $SAFETY${NC}\n"

# =============================================================================
# ÉTAPE 1 : Trouver le backup le plus récent
# =============================================================================
echo -e "${BLUE}━━━ 1. Recherche du backup ━━━${NC}"

LATEST_BACKUP=""
LATEST_TIME=0

# Chercher dans .backup_links_* et .backup_home_*
for dir in .backup_links_* .backup_home_*; do
    if [ -d "$dir" ]; then
        # Extraire le timestamp du nom
        ts=$(echo "$dir" | grep -oE '[0-9]{8}_[0-9]{6}' | head -1)
        if [ -n "$ts" ]; then
            # Convertir en entier pour comparaison
            ts_num=$(echo "$ts" | tr -d '_')
            if [ "$ts_num" -gt "$LATEST_TIME" ]; then
                LATEST_TIME="$ts_num"
                LATEST_BACKUP="$dir"
            fi
        fi
    fi
done

if [ -z "$LATEST_BACKUP" ]; then
    echo -e "   ${RED}❌ Aucun backup trouvé (.backup_links_* ou .backup_home_*)${NC}"
    echo -e "   ${YELLOW}   → Restauration manuelle nécessaire${NC}"
    echo -e "   ${YELLOW}   → Consultez le dossier $SAFETY pour l'état actuel${NC}"
    exit 1
fi

echo -e "   ${GREEN}✔${NC} Backup trouvé : $LATEST_BACKUP"
echo -e "   ${GREEN}✔${NC} Date : $(echo $LATEST_BACKUP | grep -oE '[0-9]{8}_[0-9]{6}')"

# =============================================================================
# ÉTAPE 2 : Restaurer index.html et chambres.html
# =============================================================================
echo ""
echo -e "${BLUE}━━━ 2. Restauration des fichiers HTML ━━━${NC}"

for f in index.html chambres.html; do
    if [ -f "$LATEST_BACKUP/$f" ]; then
        cp "$LATEST_BACKUP/$f" "$f"
        echo -e "   ${GREEN}✔${NC} $f restauré depuis $LATEST_BACKUP/"
    else
        echo -e "   ${YELLOW}⚠${NC}  $f absent du backup — fichier actuel conservé"
    fi
done

# =============================================================================
# ÉTAPE 3 : Supprimer le bloc CSS ajouté à css/index.css
# =============================================================================
echo ""
echo -e "${BLUE}━━━ 3. Nettoyage de css/index.css ━━━${NC}"

python3 << 'PY_EOF'
import re
from pathlib import Path

p = Path('css/index.css')
if not p.exists():
    print("   ⚠  css/index.css introuvable")
    exit()

css = p.read_text(encoding='utf-8')
original = css

# Identifier le bloc ajouté par improve_homepage.sh
# Il commence par un commentaire "AMÉLIORATIONS PAGE D'ACCUEIL"
marker_pattern = re.compile(
    r'\n*/\* =+ \*/\s*'
    r'/\* 12\. AMÉLIORATIONS PAGE D\'ACCUEIL.*?(?=\Z|\n/\* =+ \*/)',
    re.DOTALL
)

# Alternative plus simple : chercher depuis le marqueur jusqu'à la fin
if '/* 12. AMÉLIORATIONS PAGE D\'ACCUEIL' in css:
    idx = css.index('/* 12. AMÉLIORATIONS PAGE D\'ACCUEIL')
    # Revenir au début du bloc de commentaire
    start = css.rfind('/*', 0, idx)
    if start == -1:
        start = idx
    css = css[:start].rstrip() + '\n'
    print("   ✔ Bloc 'AMÉLIORATIONS PAGE D'ACCUEIL' supprimé")
elif 'room-badge--popular' in css or 'exp-card--popular' in css:
    # Fallback : supprimer toutes les règles liées
    rules_to_remove = [
        r'\.room-badge[^{]*\{[^}]*\}\s*',
        r'\.room-btn--book[^{]*\{[^}]*\}\s*',
        r'\.exp-card--popular[^{]*\{[^}]*\}\s*',
        r'\.exp-img-wrapper::after\s*\{[^}]*\}\s*',
        r'\.exp-title\s*,\s*\.exp-desc\s*,\s*\.exp-btn\s*\{[^}]*\}\s*',
    ]
    for pattern in rules_to_remove:
        css = re.sub(pattern, '', css)
    print("   ✔ Règles CSS ajoutées supprimées (fallback)")
else:
    print("   ℹ  Aucun bloc à supprimer dans css/index.css")

if css != original:
    p.write_text(css, encoding='utf-8')
PY_EOF

# =============================================================================
# ÉTAPE 4 : Supprimer .missing_images.txt
# =============================================================================
echo ""
echo -e "${BLUE}━━━ 4. Nettoyage des fichiers temporaires ━━━${NC}"

if [ -f ".missing_images.txt" ]; then
    rm ".missing_images.txt"
    echo -e "   ${GREEN}✔${NC} .missing_images.txt supprimé"
else
    echo -e "   ℹ  .missing_images.txt absent"
fi

# =============================================================================
# ÉTAPE 5 : Vérification que les modifications ont été annulées
# =============================================================================
echo ""
echo -e "${BLUE}━━━ 5. Vérification ━━━${NC}"

check_absent() {
    local label="$1"; local pattern="$2"; local file="$3"
    if [ ! -f "$file" ]; then
        echo -e "   ${YELLOW}⚠${NC}  $file introuvable"
        return
    fi
    if grep -q "$pattern" "$file" 2>/dev/null; then
        echo -e "   ${RED}✘${NC} $label (encore présent)"
    else
        echo -e "   ${GREEN}✔${NC} $label supprimé"
    fi
}

echo -e "${BLUE}   → index.html${NC}"
check_absent "Badge 'Le + demandé'"        'room-badge--popular'    index.html
check_absent "Bouton Réserver"             'room-btn--book'         index.html
check_absent "Badge Populaire expériences" 'exp-card--popular'      index.html

echo ""
echo -e "${BLUE}   → css/index.css${NC}"
check_absent "Bloc améliorations"          'AMÉLIORATIONS PAGE'     css/index.css

echo ""
echo -e "${BLUE}   → Fichiers temporaires${NC}"
if [ ! -f ".missing_images.txt" ]; then
    echo -e "   ${GREEN}✔${NC} .missing_images.txt supprimé"
else
    echo -e "   ${RED}✘${NC} .missing_images.txt encore présent"
fi

# =============================================================================
# RÉCAPITULATIF
# =============================================================================
echo ""
echo -e "${GREEN}═══════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}  ✅ ROLLBACK TERMINÉ${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════════${NC}"
echo ""
echo -e "💾 État d'avant rollback (au cas où) : $SAFETY"
echo -e "💾 Backup utilisé pour restaurer   : $LATEST_BACKUP"
echo ""
echo -e "${BLUE}🧪 TEST :${NC}"
echo "   1. Ctrl + Shift + R sur index.html"
echo "   2. La page doit être IDENTIQUE à avant les scripts"
echo ""
echo -e "${BLUE}🗑️  Pour nettoyer les backups ensuite :${NC}"
echo "   rm -rf .backup_links_* .backup_home_* .backup_rollback_safety_*"
echo ""
