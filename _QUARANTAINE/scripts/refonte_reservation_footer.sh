#!/bin/bash
set -e

echo "==========================================="
echo "  Refonte footer + barre réassurance"
echo "  (uniquement reservation.html)"
echo "==========================================="

# ---------- 1) Sauvegarde ----------
BACKUP=".backup_resft_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP"
cp reservation.html "$BACKUP/" 2>/dev/null || true
cp css/reservation.css "$BACKUP/" 2>/dev/null || true
echo "📦 Sauvegarde → $BACKUP"

# ============================================================
# 2) AJOUTER le CSS à css/reservation.css
# ============================================================
cat >> css/reservation.css << 'CSS_EOF'

/* ============================================================= */
/* SECTION "POURQUOI RÉSERVER EN DIRECT ?"                       */
/* ============================================================= */
.why-direct-section {
    background: #ffffff;
    padding: 55px 0 50px;
    border-top: 1px solid #f0f0f0;
}
.why-direct-section .container {
    max-width: 1140px;
    margin: 0 auto;
    padding: 0 20px;
}
.why-direct-section h2 {
    font-size: 20px;
    font-weight: 700;
    color: #1a1a1a;
    letter-spacing: .6px;
    margin: 0 0 8px;
    text-transform: uppercase;
    font-family: 'Montserrat', sans-serif;
}
.why-direct-section h2::after {
    content: "";
    display: block;
    width: 45px;
    height: 3px;
    background: #CBA77A;
    margin-top: 14px;
}
.why-direct-grid {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 44px;
    margin-top: 40px;
}
.why-item {
    display: flex;
    align-items: flex-start;
    gap: 18px;
}
.why-icon {
    width: 52px;
    height: 52px;
    border-radius: 50%;
    border: 2px solid #CBA77A;
    color: #CBA77A;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 20px;
    flex-shrink: 0;
}
.why-item h3 {
    font-size: 12px;
    font-weight: 700;
    color: #1a1a1a;
    letter-spacing: 1px;
    margin: 4px 0 6px;
    text-transform: uppercase;
    font-family: 'Montserrat', sans-serif;
}
.why-item p {
    font-size: 13px;
    color: #6b7280;
    line-height: 1.55;
    margin: 0;
}
@media (max-width: 900px) {
    .why-direct-grid {
        grid-template-columns: 1fr;
        gap: 26px;
    }
}

/* ============================================================= */
/* FOOTER — MOYENS DE PAIEMENT + DEVISE                          */
/* ============================================================= */
.main-footer .payment-methods {
    display: flex;
    gap: 8px;
    flex-wrap: wrap;
    margin-top: 4px;
    align-items: center;
}
.main-footer .payment-badge {
    background: #ffffff;
    border-radius: 5px;
    height: 30px;
    min-width: 48px;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    padding: 4px 8px;
    font-family: Arial, Helvetica, sans-serif;
    font-weight: 900;
    font-style: italic;
    font-size: 12px;
    letter-spacing: .5px;
    line-height: 1;
}
.main-footer .pay-visa {
    color: #1A1F71;
}
.main-footer .pay-mc {
    padding: 0 6px;
    gap: 0;
}
.main-footer .pay-mc .circle {
    width: 16px;
    height: 16px;
    border-radius: 50%;
    display: inline-block;
}
.main-footer .pay-mc .c1 {
    background: #EB001B;
    margin-right: -6px;
}
.main-footer .pay-mc .c2 {
    background: #F79E1B;
    opacity: .9;
}
.main-footer .pay-wave {
    background: #1DC8FF;
    color: #ffffff;
    font-style: normal;
    font-size: 11px;
    font-weight: 700;
    letter-spacing: .3px;
}
.main-footer .pay-om {
    background: #FF7900;
    color: #ffffff;
    font-style: normal;
    font-size: 9.5px;
    font-weight: 700;
    letter-spacing: .2px;
    padding: 4px 7px;
}

/* Ligne bas de footer : copyright à gauche, devise à droite */
.main-footer .footer-bottom {
    display: flex;
    justify-content: space-between;
    align-items: center;
    flex-wrap: wrap;
    gap: 12px;
    text-align: left;
    padding-top: 22px;
}
.main-footer .footer-bottom p {
    margin: 0;
}
.main-footer .footer-bottom-right {
    display: flex;
    align-items: center;
    gap: 14px;
}
.main-footer .footer-currency {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    font-size: 11px;
    color: #A0AEC0;
    font-weight: 600;
    letter-spacing: .3px;
    cursor: pointer;
    transition: color .2s;
}
.main-footer .footer-currency:hover {
    color: #ffffff;
}
.main-footer .footer-currency i {
    font-size: 10px;
}

/* Motif décoratif discret dans le coin du footer */
.main-footer {
    position: relative;
    overflow: hidden;
}
.main-footer::after {
    content: "";
    position: absolute;
    bottom: -30px;
    right: -30px;
    width: 200px;
    height: 200px;
    background-image: repeating-linear-gradient(
        -45deg,
        rgba(56,226,143,.12) 0 4px,
        transparent 4px 14px
    );
    pointer-events: none;
}

@media (max-width: 700px) {
    .main-footer .footer-bottom {
        flex-direction: column;
        align-items: flex-start;
    }
}
CSS_EOF
echo "🎨 CSS ajouté à css/reservation.css"

# ============================================================
# 3) REMPLACER le CTA par la barre "Pourquoi réserver en direct ?"
# ============================================================
cat > /tmp/why_direct.html << 'WHY_EOF'
<section class="why-direct-section">
    <div class="container">
        <h2>Pourquoi réserver en direct ?</h2>
        <div class="why-direct-grid">
            <div class="why-item">
                <div class="why-icon"><i class="fas fa-shield-alt"></i></div>
                <div>
                    <h3>Meilleur tarif garanti</h3>
                    <p>Profitez des meilleurs tarifs disponibles uniquement sur notre site officiel.</p>
                </div>
            </div>
            <div class="why-item">
                <div class="why-icon"><i class="far fa-calendar-check"></i></div>
                <div>
                    <h3>Annulation flexible</h3>
                    <p>Annulation gratuite jusqu'à 48h avant votre arrivée.</p>
                </div>
            </div>
            <div class="why-item">
                <div class="why-icon"><i class="fas fa-lock"></i></div>
                <div>
                    <h3>Paiement sécurisé</h3>
                    <p>Vos transactions sont 100% sécurisées.</p>
                </div>
            </div>
        </div>
    </div>
</section>
WHY_EOF

export WHY_DIRECT="$(cat /tmp/why_direct.html)"
perl -0777 -i -pe 's|<section class="booking-section">.*?</section>|$ENV{WHY_DIRECT}|s' reservation.html
unset WHY_DIRECT
echo "✅ CTA remplacé par la barre 'Pourquoi réserver en direct ?'"

# ============================================================
# 4) ENRICHIR le footer : moyens de paiement + devise
# ============================================================
cat > /tmp/footer_social.html << 'FTS_EOF'
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
FTS_EOF

export FOOTER_SOCIAL="$(cat /tmp/footer_social.html)"
perl -0777 -i -pe 's|<div class="footer-col">\s*<h4 class="footer-title">SUIVEZ-NOUS</h4>.*?</div>\s*</div>\s*<div class="footer-bottom">|$ENV{FOOTER_SOCIAL}\n        </div>\n\n        <div class="footer-bottom">|s' reservation.html
unset FOOTER_SOCIAL
echo "✅ Bloc SUIVEZ-NOUS enrichi avec moyens de paiement"

# ============================================================
# 5) ENRICHIR la ligne du bas avec le sélecteur de devise
# ============================================================
cat > /tmp/footer_bottom.html << 'FTB_EOF'
<div class="footer-bottom">
            <p>© 2026 Pullman Dakar Teranga - Tous droits réservés.</p>
            <div class="footer-bottom-right">
                <span class="footer-currency"><i class="fas fa-globe"></i> FR · XOF <i class="fas fa-chevron-down" style="margin-left:2px;"></i></span>
            </div>
        </div>
FTB_EOF

export FOOTER_BOTTOM="$(cat /tmp/footer_bottom.html)"
perl -0777 -i -pe 's|<div class="footer-bottom">\s*<p>© 2026 Pullman Dakar Teranga.*?</p>\s*</div>|$ENV{FOOTER_BOTTOM}|s' reservation.html
unset FOOTER_BOTTOM
echo "✅ Ligne du bas enrichie avec sélecteur FR · XOF"

# ============================================================
# 6) Vérifications finales
# ============================================================
echo ""
echo "=== Vérifications ==="
grep -c 'why-direct-section' reservation.html   | xargs -I{} echo "  ▸ Barre 'Pourquoi réserver en direct ?' : {} occurrence(s)"
grep -c 'payment-badge' reservation.html        | xargs -I{} echo "  ▸ Badges paiement                      : {} occurrence(s)"
grep -c 'footer-currency' reservation.html      | xargs -I{} echo "  ▸ Sélecteur devise                     : {} occurrence(s)"
grep -c 'booking-section' reservation.html      | xargs -I{} echo "  ▸ Ancien CTA restant                   : {} occurrence(s)"

echo ""
echo "==========================================="
echo "✅ TERMINÉ"
echo "💾 Sauvegarde : $BACKUP"
echo "⚠️  Ctrl+F5 dans le navigateur pour voir le résultat"
echo "==========================================="
