#!/bin/bash
set -e

BACKUP=".backup_exp_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP"
cp *.html "$BACKUP/"
echo "📦 Sauvegarde → $BACKUP"

# Transformation : <a href="experiences.html" [class="active"]>EXPÉRIENCES</a>
#        devient : <a [class="active"]>EXPÉRIENCES</a>
for f in *.html; do
    perl -0777 -pe '
        s|<a\s+href="experiences\.html"([^>]*)>EXPÉRIENCES</a>|<a$1>EXPÉRIENCES</a>|g;
    ' "$f" > "$f.tmp"
    mv "$f.tmp" "$f"
    echo "✅ $f"
done

echo ""
echo "==========================================="
echo "✅ TERMINÉ — 'EXPÉRIENCES' n'est plus cliquable"
echo "⚠️  Fais Ctrl+F5 dans le navigateur"
echo "==========================================="
