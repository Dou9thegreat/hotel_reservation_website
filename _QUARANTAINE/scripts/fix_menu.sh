#!/bin/bash

echo "==========================================="
echo "  Uniformisation du top-menu - Pullman"
echo "==========================================="

# 1. Créer un dossier de sauvegarde
BACKUP_DIR=".backup_menu_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"
cp *.html "$BACKUP_DIR/" 2>/dev/null
echo "📦 Sauvegarde créée : $BACKUP_DIR"

# 2. Renommer les fichiers services -> experiences
[ -f "services.html" ] && [ ! -f "experiences.html" ] && mv services.html experiences.html && echo "🔁 services.html -> experiences.html"
[ -f "services-piscine.html" ] && [ ! -f "experiences-piscine.html" ] && mv services-piscine.html experiences-piscine.html && echo "🔁 services-piscine.html -> experiences-piscine.html"
[ -f "services-restaurant.html" ] && [ ! -f "experiences-restaurant.html" ] && mv services-restaurant.html experiences-restaurant.html && echo "🔁 services-restaurant.html -> experiences-restaurant.html"

# 3. Mettre à jour les liens dans tous les fichiers HTML
perl -i -pe 's/href="services\.html"/href="experiences.html"/g' *.html
perl -i -pe 's/href="services-piscine\.html"/href="experiences-piscine.html"/g' *.html
perl -i -pe 's/href="services-restaurant\.html"/href="experiences-restaurant.html"/g' *.html
echo "🔗 Liens mis à jour vers experiences.html et sous-pages"

# 4. Supprimer le dropdown CHAMBRES (remplacer par un lien simple)
# Cette regex capture le lien <a> et supprime le reste du bloc <div class="dropdown">
perl -i -0777 -pe 's/<div class="dropdown">\s*(<a href="chambres\.html"[^>]*>CHAMBRES<\/a>)\s*<div class="dropdown-content">.*?<\/div>\s*<\/div>/$1/gs' *.html
echo "📂 Dropdown CHAMBRES remplacé par un lien direct"

# 5. Corriger galerie.html (liens d'ancrage -> pages réelles)
if [ -f "galerie.html" ]; then
    perl -i -pe 's/href="#chambres-section"/href="chambres.html"/g' galerie.html
    perl -i -pe 's/href="#experiences-section"/href="experiences.html"/g' galerie.html
    perl -i -pe 's/href="#evenements-section"/href="evenements.html"/g' galerie.html
    echo "🖼️  Liens de galerie.html corrigés"
fi

echo "==========================================="
echo "✅ Terminé !"
echo "⚠️  IMPORTANT : Vide le cache de ton navigateur (Ctrl+F5) pour voir les changements."
echo "==========================================="
