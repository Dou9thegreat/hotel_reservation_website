#!/usr/bin/env bash
# Crée des copies d'images existantes avec les noms attendus
# par les bandeaux de catégorie dans js/extras.js
# AUCUN fichier de code n'est modifié.

set -uo pipefail
IMAGES_DIR="${1:-images}"

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; NC='\033[0m'

if [ ! -d "$IMAGES_DIR" ]; then
  echo -e "${RED}❌ Dossier $IMAGES_DIR/ introuvable${NC}"
  exit 1
fi

cd "$IMAGES_DIR"

copies_done=0

create_if_missing() {
  local target="$1"
  shift
  local sources=("$@")

  if [ -f "$target" ]; then
    echo -e "  ${GREEN}✔${NC} $target existe déjà"
    return 0
  fi

  for src in "${sources[@]}"; do
    if [ -f "$src" ]; then
      cp "$src" "$target"
      echo -e "  ${GREEN}✔${NC} $target  ←  $src"
      copies_done=$((copies_done+1))
      return 0
    fi
  done

  echo -e "  ${YELLOW}⚠${NC}  $target : aucune source disponible parmi ${sources[*]}"
  return 1
}

echo "▶ Bandeau 'Restaurants' → resto-feu-bois.jpg"
create_if_missing "resto-feu-bois.jpg" "hero-resto-jour.jpg" "gal-chef.jpeg" "imageluxe1.jpg"

echo "▶ Bandeau 'Bars' → resto-bar-nuit.jpg"
create_if_missing "resto-bar-nuit.jpg" "hero-resto-nuit.jpg" "hero-resto-jour.jpg" "imageluxe1.jpg"

echo "▶ Bandeau 'Services' → ocean.jpg"
create_if_missing "ocean.jpg" "hero-resto-jour.jpg" "hero-resto-nuit.jpg" "piscine.jpg"

echo ""
if [ "$copies_done" -gt 0 ]; then
  echo -e "${GREEN}✅ $copies_done fichier(s) créé(s)${NC}"
else
  echo -e "${YELLOW}ℹ  Aucun fichier créé${NC}"
fi
