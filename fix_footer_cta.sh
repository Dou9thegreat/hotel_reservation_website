#!/bin/bash
# ============================================================
# Uniformisation Footer + CTA (version corrigée)
# ============================================================
set -e

BACKUP=".backup_fix_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP"
cp *.html "$BACKUP/" 2>/dev/null || true
echo "📦 Sauvegarde → $BACKUP"

# ---- 1) Extraire le CTA et le footer de index.html ----
perl -0777 -ne 'print $1 if /(<section class="booking-section">.*?<\/section>)/s' index.html > /tmp/cta.txt
perl -0777 -ne 'print $1 if /(<footer class="main-footer">.*?<\/footer>)/s'        index.html > /tmp/footer.txt

if [ ! -s /tmp/cta.txt ];    then echo "❌ CTA introuvable dans index.html";    exit 1; fi
if [ ! -s /tmp/footer.txt ]; then echo "❌ Footer introuvable dans index.html"; exit 1; fi

echo "✅ CTA extrait    : $(wc -c < /tmp/cta.txt) octets"
echo "✅ Footer extrait : $(wc -c < /tmp/footer.txt) octets"

# ---- 2) Traiter chaque page ----
PAGES="chambres.html experiences.html experiences-piscine.html experiences-restaurant.html galerie.html evenements.html contact.html reservation.html"

for f in $PAGES; do
    if [ ! -f "$f" ]; then
        echo "⚠️  $f absent, ignoré"
        continue
    fi

    perl -i -0777 -e '
        # -- Lire le CTA --
        open(my $FC, "<", "/tmp/cta.txt") or die "CTA: $!";
        my $cta = do { local $/; <$FC> };
        close $FC;

        # -- Lire le Footer --
        open(my $FF, "<", "/tmp/footer.txt") or die "Footer: $!";
        my $ft = do { local $/; <$FF> };
        close $FF;

        # -- Lire le fichier cible --
        open(my $FI, "<", $ARGV) or die "Open $ARGV: $!";
        my $c = do { local $/; <$FI> };
        close $FI;

        # -- Supprimer les anciens footers et sections booking --
        $c =~ s|<footer[^>]*>.*?</footer>||gs;
        $c =~ s|<section class="booking-section">.*?</section>||gs;
        $c =~ s|<section class="booking-bar">.*?</section>||gs;

        # -- Insérer CTA + footer avant </body> --
        if ($c =~ /<\/body>/) {
            $c =~ s|</body>|$cta\n\n$ft\n\n</body>|s;
        } else {
            # Fallback : insérer après </main>
            $c =~ s|</main>|</main>\n$cta\n\n$ft\n|s;
        }

        # -- Écrire --
        open(my $FO, ">", $ARGV) or die "Write $ARGV: $!";
        print $FO $c;
        close $FO;
    ' "$f"

    echo "✅ $f"
done

# ---- 3) S'assurer que footer-cta.css est lié ----
for f in $PAGES; do
    [ ! -f "$f" ] && continue
    if ! grep -q 'footer-cta.css' "$f"; then
        perl -i -pe 's|(<link rel="stylesheet" href="css/commun.css">)|$1\n    <link rel="stylesheet" href="css/footer-cta.css">|' "$f"
        echo "🔗 CSS footer-cta.css ajouté à $f"
    fi
done

echo ""
echo "==========================================="
echo "✅ TERMINÉ"
echo "💾 Sauvegarde : $BACKUP"
echo "⚠️  Fais Ctrl+F5 dans le navigateur"
echo "==========================================="
