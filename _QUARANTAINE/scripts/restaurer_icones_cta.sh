#!/bin/bash
set -e

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; BLUE='\033[0;34m'; NC='\033[0m'

echo -e "${BLUE}=================================================${NC}"
echo -e "${BLUE} RESTAURATION DES 3 ICÔNES DU CTA${NC}"
echo -e "${BLUE}=================================================${NC}\n"

# ---------- 1. Sauvegarde ----------
BACKUP=".backup_icones_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP"
cp *.html "$BACKUP/" 2>/dev/null
cp css/footer-cta.css "$BACKUP/" 2>/dev/null
echo -e "${GREEN}📦 Sauvegarde → $BACKUP${NC}\n"

# ---------- 2. Chercher dans les backups un ancien bloc booking-features ----------
echo -e "${BLUE}━━━ Recherche dans les backups ━━━${NC}"
FOUND_CSS=""
for dir in .backup_* .backup*; do
    [ ! -d "$dir" ] && continue
    # Cherche un footer-cta.css avec un bloc booking-features
    for f in "$dir"/footer-cta.css "$dir"/*.css; do
        [ ! -f "$f" ] && continue
        if grep -q 'width: 36px' "$f" 2>/dev/null && grep -q 'booking-features' "$f" 2>/dev/null; then
            echo -e "${GREEN}   ✔ Trouvé : $f (36px)${NC}"
            FOUND_CSS="$f"
            break 2
        fi
    done
done

# Fallback : cherche juste un fichier avec 32px (ancien CTA_LUXE)
if [ -z "$FOUND_CSS" ]; then
    for dir in .backup_* .backup*; do
        [ ! -d "$dir" ] && continue
        for f in "$dir"/footer-cta.css "$dir"/*.css; do
            [ ! -f "$f" ] && continue
            if grep -q 'width: 32px' "$f" 2>/dev/null && grep -q 'icon-circle' "$f" 2>/dev/null; then
                echo -e "${YELLOW}   ✔ Trouvé (version 32px) : $f${NC}"
                FOUND_CSS="$f"
                break 2
            fi
        done
    done
fi

if [ -z "$FOUND_CSS" ]; then
    echo -e "${YELLOW}   ⚠  Aucun backup avec icônes 36px/32px trouvé${NC}"
    echo -e "${YELLOW}      → On applique la version 'Breathe' prédéfinie${NC}"
fi
echo ""

# ---------- 3. Nettoyer le CSS actuel (retirer l'ancien bloc booking-features) ----------
echo -e "${BLUE}━━━ Nettoyage CSS ━━━${NC}"

python3 << 'PYEOF'
import re
with open('css/footer-cta.css', 'r', encoding='utf-8') as f:
    c = f.read()

# Retirer tout ancien bloc booking-features + feature-item + icon-circle
c = re.sub(
    r'/\* -+ BADGES DE RÉASSURANCE -+ \*/.*?(?=/\* -+ (?:RESPONSIVE|CORRECTIF|BARRE|$))',
    '',
    c,
    flags=re.DOTALL
)
c = re.sub(
    r'\.booking-section \.booking-features \{.*?\}\s*',
    '',
    c,
    flags=re.DOTALL
)
c = re.sub(
    r'\.booking-section \.feature-item \{.*?\}\s*',
    '',
    c,
    flags=re.DOTALL
)
c = re.sub(
    r'\.booking-section \.feature-item:hover \{.*?\}\s*',
    '',
    c,
    flags=re.DOTALL
)
c = re.sub(
    r'\.booking-section \.icon-circle \{.*?\}\s*',
    '',
    c,
    flags=re.DOTALL
)
c = re.sub(
    r'\.booking-section \.feature-item:hover \.icon-circle \{.*?\}\s*',
    '',
    c,
    flags=re.DOTALL
)
c = re.sub(
    r'\.booking-section \.icon-circle i,?\s*\.booking-section \.icon-circle svg \{.*?\}\s*',
    '',
    c,
    flags=re.DOTALL
)

with open('css/footer-cta.css', 'w', encoding='utf-8') as f:
    f.write(c)
print("   ✔ Ancien bloc CSS retiré")
PYEOF

# ---------- 4. Ajouter la version "Breathe" (grande, visible) ----------
echo -e "${BLUE}━━━ Application du style 'Breathe' (36px) ━━━${NC}"

cat >> css/footer-cta.css << 'CSS_EOF'

/* ============================================================= */
/* BADGES DE RÉASSURANCE — Version visible (Breathe)             */
/* 3 icônes circulaires vertes sous la barre de réservation      */
/* ============================================================= */
.booking-section .booking-features {
    display: flex;
    justify-content: center;
    align-items: center;
    gap: 72px;
    flex-wrap: wrap;
    margin-top: 8px;
}
.booking-section .feature-item {
    display: inline-flex;
    align-items: center;
    gap: 14px;
    font-size: 11.5px;
    font-weight: 700;
    letter-spacing: 1.6px;
    text-transform: uppercase;
    color: rgba(255, 255, 255, .9);
    transition: color .25s ease;
}
.booking-section .feature-item:hover {
    color: #ffffff;
}
.booking-section .icon-circle {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    width: 36px;
    height: 36px;
    border-radius: 50%;
    border: 1px solid rgba(56, 226, 143, .55);
    background: rgba(56, 226, 143, .08);
    color: #38E28F;
    font-size: 14px;
    flex-shrink: 0;
    transition: border-color .25s ease, background .25s ease, transform .25s ease;
}
.booking-section .feature-item:hover .icon-circle {
    border-color: rgba(56, 226, 143, .95);
    background: rgba(56, 226, 143, .18);
    transform: scale(1.10);
}
.booking-section .icon-circle i {
    display: block;
    font-size: 14px;
    line-height: 1;
    color: #38E28F;
}
.booking-section .icon-circle svg {
    display: block !important;
    width: 15px !important;
    height: 15px !important;
    stroke: #38E28F;
    fill: none;
    stroke-width: 2.2;
    stroke-linecap: round;
    stroke-linejoin: round;
}

/* ---------- RESPONSIVE ---------- */
@media (max-width: 992px) {
    .booking-section .booking-features {
        gap: 22px;
        flex-direction: column;
        margin-top: 12px;
    }
}
@media (max-width: 576px) {
    .booking-section .icon-circle {
        width: 32px;
        height: 32px;
    }
    .booking-section .icon-circle i {
        font-size: 12px;
    }
}
CSS_EOF
echo -e "${GREEN}   ✔ Style 'Breathe' (36px) appliqué${NC}\n"

# ---------- 5. Vérifier / injecter le bloc HTML dans chaque page ----------
echo -e "${BLUE}━━━ Vérification HTML (bloc booking-features) ━━━${NC}"

PAGES="index.html chambres.html contact.html galerie.html evenements.html experiences.html experiences-piscine.html experiences-restaurant.html"

# Bloc HTML de référence
FEATURES_BLOCK='                <div class="booking-features">
                    <div class="feature-item">
                        <span class="icon-circle"><i class="fas fa-certificate"></i></span>
                        <span>Meilleur tarif garanti</span>
                    </div>
                    <div class="feature-item">
                        <span class="icon-circle"><i class="fas fa-calendar-check"></i></span>
                        <span>Annulation flexible</span>
                    </div>
                    <div class="feature-item">
                        <span class="icon-circle"><i class="fas fa-lock"></i></span>
                        <span>Paiement sécurisé</span>
                    </div>
                </div>'

export FEATURES_BLOCK

for f in $PAGES; do
    [ ! -f "$f" ] && continue

    if grep -q 'class="booking-features"' "$f"; then
        echo -e "${GREEN}   ✔ $f — booking-features présent${NC}"
        # Vérifier que les 3 items sont bien là
        N=$(grep -o 'class="feature-item"' "$f" | wc -l)
        if [ "$N" -lt 3 ]; then
            echo -e "${YELLOW}      ⚠  Seulement $N feature-item(s), on remplace${NC}"
            # Retirer l'ancien bloc
            perl -0777 -i -pe 's|<div class="booking-features">.*?</div>\s*</div>\s*</div>||s' "$f"
            # Ajouter après le widget
            perl -0777 -i -pe '
                s|(</div>\s*</div>\s*)(</section>\s*<footer)|$1$ENV{FEATURES_BLOCK}\n$2|s;
            ' "$f"
        fi
    else
        echo -e "${YELLOW}   ⚠  $f — booking-features ABSENT, injection...${NC}"
        # Injecter juste avant </section> du CTA
        perl -0777 -i -pe '
            s|(\s*</div>\s*)(</section>)|\n$ENV{FEATURES_BLOCK}\n$2|s;
        ' "$f"
        echo -e "${GREEN}      ✔ Ajouté${NC}"
    fi
done

# ---------- 6. Vérification finale ----------
echo -e "\n${BLUE}━━━ VÉRIFICATION FINALE ━━━${NC}"
printf "   %-32s | %s | %s | %s\n" "Fichier" "features" "items" "CSS-36px"
printf "   %-32s-|-%s-|-%s-|-%s\n" "--------------------------------" "--------" "-----" "--------"
for f in $PAGES; do
    [ ! -f "$f" ] && continue
    feat=$(grep -c 'class="booking-features"' "$f" 2>/dev/null || echo 0)
    items=$(grep -o 'class="feature-item"' "$f" 2>/dev/null | wc -l)
    css36=$(grep -c 'width: 36px' css/footer-cta.css 2>/dev/null || echo 0)
    printf "   %-32s | %-8s | %-5s | %-8s\n" "$f" "$feat" "$items" "$css36"
done

echo ""
echo -e "${GREEN}✅ Terminé !${NC}"
echo -e "${BLUE}💾 Sauvegarde : $BACKUP${NC}"
echo ""
echo -e "${BLUE}📌 Ctrl + F5 dans le navigateur pour voir les 3 icônes (36px)${NC}"
echo -e "${BLUE}🔄 Rollback :${NC}  cp $BACKUP/*.html . && cp $BACKUP/footer-cta.css css/\n"
