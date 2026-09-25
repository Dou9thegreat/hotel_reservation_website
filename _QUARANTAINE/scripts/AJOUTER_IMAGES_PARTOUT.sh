#!/bin/bash
set -e

BACKUP=".backup_IMG_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP"
cp reservation.html "$BACKUP/" 2>/dev/null
cp css/reservation.css "$BACKUP/" 2>/dev/null
cp js/extras.js "$BACKUP/" 2>/dev/null
echo "📦 Sauvegarde → $BACKUP"
echo ""

# ============================================================
# 1) CSS : styles des images (hero + cartes + extras)
# ============================================================
echo "─── [1/4] CSS images ───"

cat >> css/reservation.css << 'CSS_EOF'

/* ============================================================= */
/* IMAGES — HERO, CARTES CHAMBRES, EXTRAS                        */
/* ============================================================= */

/* ---------- HERO : image de fond ---------- */
.reservation-page .hero {
    background-image:
        linear-gradient(120deg, rgba(14,74,94,.88), rgba(21,94,117,.55)),
        url('../images/hero3.png');
    background-size: cover;
    background-position: center;
    background-repeat: no-repeat;
}
.reservation-page .hero .ph {
    /* Placeholder retiré visuellement (mais conservé si image absente) */
    display: none;
}

/* ---------- CARTES CHAMBRES : image de la chambre ---------- */
.reservation-page .rc-gallery {
    position: relative;
    min-height: 200px;
    overflow: hidden;
    background: linear-gradient(135deg, #DCE9EC, #EAF2F4);
}
.reservation-page .rc-gallery img {
    position: absolute;
    inset: 0;
    width: 100%;
    height: 100%;
    object-fit: cover;
    object-position: center;
    display: block;
    transition: transform .6s ease;
    z-index: 1;
}
.reservation-page .room-card:hover .rc-gallery img {
    transform: scale(1.06);
}
.reservation-page .rc-gallery .ph {
    position: absolute;
    inset: 0;
    display: none; /* S'affiche seulement si image absente */
    align-items: center;
    justify-content: center;
    color: #7C939A;
    font-size: .65rem;
    font-weight: 700;
    text-align: center;
    letter-spacing: .3px;
    line-height: 1.4;
    padding: 6px;
    background-image: repeating-linear-gradient(-45deg, rgba(21,94,117,.06) 0 3px, transparent 3px 10px);
    z-index: 2;
}
.reservation-page .rc-gallery.img-error .ph { display: flex; }

/* ---------- SÉLECTION : miniature chambre ---------- */
.reservation-page .sel-room img {
    width: 70px;
    height: 60px;
    border-radius: 6px;
    object-fit: cover;
    flex: none;
    display: block;
}

/* ---------- EXTRAS : carte + miniature ---------- */
.exb-card-image img,
.exb-quick-thumb img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    display: block;
}
CSS_EOF
echo "  ✅ css/reservation.css enrichi"
echo ""

# ============================================================
# 2) JS : ajouter les images aux cartes chambres générées
# ============================================================
echo "─── [2/4] Modifier reservation.html ───"

# 2a) Ajouter images dans le tableau ROOMS
perl -0777 -i -pe '
    s/(\{id:\x27classique-ville\x27[^}]*?cap:2,)/$1 image:\x27images\/room-deluxe.png\x27,/s;
    s/(\{id:\x27classique-twin\x27[^}]*?cap:2,)/$1 image:\x27images\/room-deluxe.png\x27,/s;
    s/(\{id:\x27superieure-ocean\x27[^}]*?cap:2,)/$1 image:\x27images\/room-superior.png\x27,/s;
    s/(\{id:\x27deluxe-ocean\x27[^}]*?cap:2,)/$1 image:\x27images\/room-deluxe.png\x27,/s;
    s/(\{id:\x27suite-ambassadeur\x27[^}]*?cap:2,)/$1 image:\x27images\/room-suite.png\x27,/s;
' reservation.html
echo "  ✅ Tableau ROOMS : images ajoutées"

# 2b) Modifier renderRooms() pour insérer une <img>
perl -0777 -i -pe '
    s|<div class="rc-gallery"><div class="ph">Photo —<br>\x27 \+ r\.name \+ \x27</div></div>|<div class="rc-gallery"><img src="\x27 + r.image + \x27" alt="\x27 + r.name + \x27" loading="lazy" onerror="this.style.display=\x27none\x27;this.parentNode.classList.add(\x27img-error\x27);"><div class="ph">Photo —<br>\x27 + r.name + \x27</div></div>|g
' reservation.html
echo "  ✅ renderRooms() : balise <img> ajoutée"

# 2c) Modifier renderSelection() pour afficher une miniature
perl -0777 -i -pe '
    s|<div class="sel-room"><div class="ph">Photo</div>|<div class="sel-room"><img src="\x27 + room.image + \x27" alt="\x27 + room.name + \x27">|g
' reservation.html
echo "  ✅ renderSelection() : miniature ajoutée"
echo ""

# ============================================================
# 3) JS : ajouter les images aux extras (déjà présentes mais à vérifier)
# ============================================================
echo "─── [3/4] Vérifier js/extras.js ───"

# Le fichier extras.js contient déjà `image: 'images/xxx.jpg'` dans son tableau
# On vérifie juste que les images existent et on remplace par les images du dossier
if grep -q 'massage3.jpg' js/extras.js; then
    echo "  ℹ️  extras.js contient déjà des chemins d'images"
else
    echo "  ⚠️  Aucun chemin d'image trouvé dans extras.js"
fi

# Remplacer les chemins par ceux qui existent dans le dossier images/
perl -0777 -i -pe '
    s|image: \x27images/massage3\.jpg\x27|image: \x27images/spa-s.webp\x27|g;
    s|image: \x27images/Hamman\.jpg\x27|image: \x27images/spa-sauna.webp\x27|g;
    s|image: \x27images/piscine\.jpg\x27|image: \x27images/hero-pool.webp\x27|g;
    s|image: \x27images/resto-brunch\.jpg\x27|image: \x27images/restaurant-buffet.webp\x27|g;
    s|image: \x27images/resto-chef-sow\.jpg\x27|image: \x27images/chef-plat.webp\x27|g;
    s|image: \x27images/resto-feu-bois\.jpg\x27|image: \x27images/restaurant-terrasse.webp\x27|g;
    s|image: \x27images/resto-bar-nuit\.jpg\x27|image: \x27images/bar-nuit.webp\x27|g;
    s|image: \x27images/room-deluxe\.png\x27|image: \x27images/chambre-deluxe.webp\x27|g;
    s|image: \x27images/hero\.png\x27|image: \x27images/hero3.png\x27|g;
    s|image: \x27images/ocean\.jpg\x27|image: \x27images/hero-pool.webp\x27|g;
' js/extras.js
echo "  ✅ extras.js : chemins d'images mis à jour"
echo ""

# ============================================================
# 4) Vérification
# ============================================================
echo "─── [4/4] VÉRIFICATION ───"
echo ""
echo "  reservation.html :"
grep -c 'rc-gallery"><img' reservation.html | xargs -I{} echo "    ▸ Cartes chambres avec <img>  : {}"
grep -c 'image:' reservation.html | xargs -I{} echo "    ▸ Propriétés image dans ROOMS : {}"

echo ""
echo "  js/extras.js :"
grep -c 'image:' js/extras.js | xargs -I{} echo "    ▸ Propriétés image dans EXTRAS : {}"

echo ""
echo "  css/reservation.css :"
grep -c 'rc-gallery img' css/reservation.css | xargs -I{} echo "    ▸ Règles .rc-gallery img     : {}"
grep -c 'hero.*url' css/reservation.css | xargs -I{} echo "    ▸ Hero avec background-url   : {}"

echo ""
echo "  ⚠️  Vérifie que ces fichiers existent dans images/ :"
ls -1 images/ 2>/dev/null | head -20 || echo "    (dossier introuvable)"

echo ""
echo "==================================================="
echo "✅ TERMINÉ"
echo "💾 Sauvegarde : $BACKUP"
echo ""
echo "📌 Ctrl+F5 dans le navigateur pour tester"
echo ""
echo "📸 Si une image ne s'affiche pas, vérifie :"
echo "   1. Le nom exact du fichier dans images/"
echo "   2. Que la casse (majuscules/minuscules) correspond"
echo "   3. Que l'extension est bonne (.png vs .webp vs .jpg)"
echo "==================================================="
