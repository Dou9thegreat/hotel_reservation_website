#!/bin/bash
set -e

echo "==========================================="
echo "  Réparation Footer + CTA"
echo "==========================================="

# ---------- 1) Sauvegarde ----------
BACKUP=".backup_rep_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP"
cp *.html "$BACKUP/"
echo "📦 Sauvegarde → $BACKUP"

# ---------- 2) Extraire CTA + Footer de index.html ----------
perl -0777 -ne 'print $1 if /(<section class="booking-section">.*?<\/section>)/s' index.html > /tmp/cta.txt
perl -0777 -ne 'print $1 if /(<footer class="main-footer">.*?<\/footer>)/s'        index.html > /tmp/footer.txt

if [ ! -s /tmp/cta.txt ];    then echo "❌ CTA extrait vide";    exit 1; fi
if [ ! -s /tmp/footer.txt ]; then echo "❌ Footer extrait vide"; exit 1; fi

echo "✅ CTA extrait    : $(wc -c < /tmp/cta.txt) octets"
echo "✅ Footer extrait : $(wc -c < /tmp/footer.txt) octets"

# ---------- 3) Pages cibles ----------
PAGES="chambres.html experiences.html experiences-piscine.html experiences-restaurant.html galerie.html evenements.html contact.html reservation.html"

for f in $PAGES; do
    if [ ! -f "$f" ]; then
        echo "⚠️  $f absent, ignoré"
        continue
    fi

    # --- 3a) Supprimer anciens footers / sections réservation ---
    perl -0777 -pe '
        s|<footer[^>]*>.*?</footer>||gs;
        s|<section class="booking-section">.*?</section>||gs;
        s|<section class="booking-bar">.*?</section>||gs;
    ' "$f" > "$f.step1"

    # --- 3b) Insérer CTA + footer avant </body> (via awk, méthode robuste) ---
    awk -v CF=/tmp/cta.txt -v FF=/tmp/footer.txt '
        /<\/body>/ {
            while ((getline line < CF) > 0) print line
            close(CF)
            print ""
            while ((getline line < FF) > 0) print line
            close(FF)
            print ""
        }
        { print }
    ' "$f.step1" > "$f.step2"

    # --- 3c) Remplacer l'original ---
    mv "$f.step2" "$f"
    rm -f "$f.step1"

    # --- 3d) S'assurer que footer-cta.css est lié ---
    if ! grep -q 'footer-cta.css' "$f"; then
        perl -0777 -pe '
            s|(<link rel="stylesheet" href="css/commun.css">)|$1\n    <link rel="stylesheet" href="css/footer-cta.css">|;
        ' "$f" > "$f.step3"
        mv "$f.step3" "$f"
    fi

    echo "✅ $f"
done

echo ""
echo "==========================================="
echo "✅ TERMINÉ"
echo "💾 Sauvegarde : $BACKUP"
echo "⚠️  Fais Ctrl+F5 dans le navigateur"
echo "==========================================="
