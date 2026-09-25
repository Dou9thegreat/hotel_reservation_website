#!/bin/bash
set -e

echo "==================================================="
echo "  FIX DOUBLONS FOOTERS + SCRIPTS + PERF"
echo "==================================================="

BACKUP=".backup_FIX_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP"
cp *.html "$BACKUP/" 2>/dev/null || true
cp js/*.js "$BACKUP/" 2>/dev/null || true
cp css/*.css "$BACKUP/" 2>/dev/null || true
echo "📦 Sauvegarde → $BACKUP"
echo ""

PAGES="index.html chambres.html contact.html galerie.html evenements.html experiences.html experiences-piscine.html experiences-restaurant.html reservation.html"

# ============================================================
# ÉTAPE 1 — Nettoyage : tronquer après </html> + supprimer doublons
# ============================================================
echo "─── ÉTAPE 1 : Nettoyage ───"
for f in $PAGES; do
    [ ! -f "$f" ] && continue

    # 1) Couper tout ce qui suit la PREMIÈRE balise </html>
    perl -0777 -i -pe 's|(</html>).*|$1\n|s' "$f"

    # 2) Supprimer TOUS les blocs <footer class="main-footer">…</footer>
    perl -0777 -i -pe 's|<footer[^>]*class="main-footer"[^>]*>.*?</footer>\s*||gs' "$f"

    # 3) Supprimer TOUS les <script src="js/i18n.js"> et booking-bridge.js
    perl -0777 -i -pe 's|<script[^>]*src="js/i18n\.js"[^>]*></script>\s*||g' "$f"
    perl -0777 -i -pe 's|<script[^>]*src="js/booking-bridge\.js"[^>]*></script>\s*||g' "$f"

    # 4) Sécurité : au cas où il resterait des </body> en double
    perl -0777 -i -pe 's|(</body>\s*</html>).*|$1\n|s' "$f"

    echo "  ✅ $f nettoyé"
done
echo ""

# ============================================================
# ÉTAPE 2 — Préparer le footer unique
# ============================================================
cat > /tmp/footer_unique.html << 'FEOF'
<footer class="main-footer">
    <div class="container">
        <div class="footer-grid">
            <div class="footer-col brand-col">
                <div class="footer-logo">
                    <img src="images/logo-pullman-white.png" alt="Pullman Hotels and Resorts" class="img-manual-logo">
                </div>
                <div class="contact-details">
                    <p><i class="fa-solid fa-location-dot icon-contact"></i> Pullman Dakar Teranga<br>Route de la Corniche Ouest<br>BP 8181, Dakar, Sénégal</p>
                    <p><i class="fa-solid fa-phone icon-contact"></i> +221 33 869 66 66</p>
                    <p><i class="fa-regular fa-envelope icon-contact"></i> HB076@accor.com</p>
                </div>
            </div>
            <div class="footer-col">
                <h4 class="footer-title">LIENS UTILES</h4>
                <ul>
                    <li><a href="#">Mentions légales</a></li>
                    <li><a href="#">Conditions générales</a></li>
                    <li><a href="#">Politique de confidentialité</a></li>
                    <li><a href="#">Accessibilité</a></li>
                </ul>
            </div>
            <div class="footer-col">
                <h4 class="footer-title">DÉCOUVRIR</h4>
                <ul>
                    <li><a href="chambres.html">Nos chambres</a></li>
                    <li><a href="experiences.html">Expériences</a></li>
                    <li><a href="#">Offres spéciales</a></li>
                    <li><a href="galerie.html">Galerie</a></li>
                </ul>
            </div>
            <div class="footer-col">
                <h4 class="footer-title">SUIVEZ-NOUS</h4>
                <div class="social-links">
                    <a href="#"><i class="fa-brands fa-facebook-f"></i></a>
                    <a href="#"><i class="fa-brands fa-instagram"></i></a>
                    <a href="#"><i class="fa-brands fa-linkedin-in"></i></a>
                    <a href="#"><i class="fa-solid fa-globe"></i></a>
                </div>
                <h4 class="footer-title" style="margin-top:26px;">MOYENS DE PAIEMENT</h4>
                <div class="payment-methods">
                    <span class="payment-badge pay-visa" title="Visa">VISA</span>
                    <span class="payment-badge pay-mc" title="Mastercard">
                        <span class="circle c1"></span><span class="circle c2"></span>
                    </span>
                    <span class="payment-badge pay-wave" title="Wave">Wave</span>
                    <span class="payment-badge pay-om" title="Orange Money">Orange Money</span>
                </div>
            </div>
        </div>
        <div class="footer-bottom">
            <p>© 2026 Pullman Dakar Teranga - Tous droits réservés.</p>
            <div class="footer-bottom-right">
                <div class="currency-switch">
                    <button class="currency-current" type="button">
                        <i class="fas fa-globe"></i> FR · XOF <i class="fas fa-chevron-down"></i>
                    </button>
                    <ul class="currency-menu">
                        <li><a href="#" data-currency="XOF" class="active"><span>Franc CFA</span><span class="code">XOF</span></a></li>
                        <li><a href="#" data-currency="EUR"><span>Euro</span><span class="code">EUR</span></a></li>
                        <li><a href="#" data-currency="USD"><span>Dollar US</span><span class="code">USD</span></a></li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</footer>
FEOF

# ============================================================
# ÉTAPE 3 — Réinsérer UN SEUL footer + UN SEUL set de scripts
# ============================================================
echo "─── ÉTAPE 3 : Réinsertion propre ───"
for f in $PAGES; do
    [ ! -f "$f" ] && continue

    export FT="$(cat /tmp/footer_unique.html)"
    perl -0777 -i -pe '
        s|</body>|$ENV{FT}\n\n    <script src="js/booking-bridge.js"></script>\n    <script src="js/i18n.js"></script>\n</body>|;
    ' "$f"
    unset FT

    echo "  ✅ $f"
done
echo ""

# ============================================================
# ÉTAPE 4 — Vérification
# ============================================================
echo "─── VÉRIFICATION ───"
printf "%-32s | %s | %s | %s | %s\n" "Fichier" "ftr" "i18n" "bb" "html"
printf "%-32s-|-%s-|-%s-|-%s-|-%s\n" "--------------------------------" "--" "--" "--" "----"
for f in $PAGES; do
    [ ! -f "$f" ] && continue
    ft=$(grep -c 'class="main-footer"' "$f" 2>/dev/null || echo 0)
    i18=$(grep -c 'js/i18n.js' "$f" 2>/dev/null || echo 0)
    bb=$(grep -c 'js/booking-bridge.js' "$f" 2>/dev/null || echo 0)
    htm=$(grep -c '</html>' "$f" 2>/dev/null || echo 0)
    printf "%-32s | %-3s | %-4s | %-2s | %-4s\n" "$f" "$ft" "$i18" "$bb" "$htm"
done

echo ""
echo "==================================================="
echo "✅ TERMINÉ — Chaque ligne doit afficher : 1 1 1 1"
echo "💾 Sauvegarde : $BACKUP"
echo ""
echo "⚠️  IMPORTANT :"
echo "   1. Fais Ctrl + F5 (vider le cache)"
echo "   2. Teste le sélecteur de langue"
echo "   3. Le site doit être plus rapide"
echo "==================================================="
