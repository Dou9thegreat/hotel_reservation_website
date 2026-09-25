#!/bin/bash
set -e

echo "==========================================="
echo "  Uniformisation Footer + CTA"
echo "==========================================="

# ---------- 1) Sauvegarde ----------
BACKUP_DIR=".backup_uniform_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"
cp *.html "$BACKUP_DIR/" 2>/dev/null
cp css/*.css "$BACKUP_DIR/" 2>/dev/null
echo "📦 Sauvegarde → $BACKUP_DIR"

# ---------- 2) Créer css/footer-cta.css ----------
cat > css/footer-cta.css << 'CSS_EOF'
/* ============================================================= */
/* FOOTER + CTA — Styles communs (extraits de index.css)         */
/* Ne pas modifier sans validation du chef de projet             */
/* ============================================================= */

:root {
    --primary-green: #06C65B;
    --accent-green: #00D67D;
    --primary-blue: #0E5A70;
    --dark-blue: #083D4C;
    --footer-bg: #042C39;
    --text-dark: #2D3748;
    --text-muted: #6B7A82;
    --font-serif: 'Times New Roman', Times, serif;
    --font-sans: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Montserrat", sans-serif;
}

/* ---------- SECTION RÉSERVATION (CTA) ---------- */
.booking-section {
    background-color: #073B4C;
    color: #ffffff;
    padding: 50px 0;
    text-align: center;
    font-family: var(--font-sans);
}
.booking-section .container {
    max-width: 1140px;
    margin: 0 auto;
    padding: 0 20px;
}
.booking-section h2 {
    font-size: 30px;
    letter-spacing: 2px;
    font-weight: 700;
    color: #ffffff;
    margin: 0 0 6px 0;
}
.booking-section p.subtitle {
    font-size: 13px;
    color: #A0AEC0;
    margin: 0 0 30px 0;
}
.booking-section .booking-widget {
    background: #ffffff;
    border-radius: 8px;
    display: grid;
    grid-template-columns: repeat(4, 1fr) auto;
    align-items: center;
    padding: 6px;
    margin-bottom: 30px;
    gap: 8px;
}
.booking-section .widget-field {
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 12px 20px;
    border-right: 1px solid #E2E8F0;
    text-align: left;
    color: #0D2834;
}
.booking-section .icon-field {
    font-size: 18px;
    color: var(--text-muted);
}
.booking-section .widget-field label {
    display: block;
    font-size: 10px;
    font-weight: 700;
    color: var(--text-muted);
    letter-spacing: 0.5px;
    text-transform: uppercase;
}
.booking-section .cta-date-input {
    border: none;
    background: transparent;
    outline: none;
    padding: 0;
    width: 100%;
    font-family: inherit;
    font-size: 13px;
    font-weight: 600;
    color: #0D2834;
    cursor: pointer;
    text-transform: capitalize;
}
.booking-section .widget-field select {
    appearance: none;
    -webkit-appearance: none;
    border: none;
    background-color: transparent;
    background-image: url("data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' width='10' height='6' viewBox='0 0 10 6'><path fill='%230D2834' opacity='0.6' d='M0 0l5 5 5-5z'/></svg>");
    background-repeat: no-repeat;
    background-position: right 2px center;
    padding-right: 18px;
    font-family: inherit;
    font-size: 13px;
    font-weight: 600;
    color: #0D2834;
    cursor: pointer;
    outline: none;
}
.booking-section .widget-field select option {
    background-color: #ffffff;
    color: #0D2834;
    font-weight: 600;
}
.booking-section .btn-submit {
    background-color: #D2A366;
    color: #ffffff;
    border: none;
    padding: 18px 28px;
    border-radius: 8px;
    font-weight: 700;
    font-size: 12px;
    letter-spacing: 1px;
    cursor: pointer;
    white-space: nowrap;
    text-transform: uppercase;
    box-shadow: 0 6px 16px rgba(0, 0, 0, 0.18);
    transition: background-color 0.2s, transform 0.2s;
    text-decoration: none;
}
.booking-section .btn-submit:hover {
    background-color: #b88d52;
    transform: scale(1.02);
}
.booking-section .booking-features {
    display: flex;
    justify-content: center;
    gap: 40px;
}
.booking-section .feature-item {
    display: flex;
    align-items: center;
    gap: 10px;
    font-size: 11px;
    font-weight: 600;
    letter-spacing: 1px;
    text-transform: uppercase;
}
.booking-section .icon-circle {
    border: 1px solid var(--accent-green);
    color: var(--accent-green);
    border-radius: 50%;
    width: 28px;
    height: 28px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 12px;
}

/* ---------- FOOTER ---------- */
.main-footer {
    background-color: var(--footer-bg);
    color: #A0AEC0;
    padding: 60px 0 20px 0;
    font-size: 12px;
    font-family: var(--font-sans);
}
.main-footer .container {
    max-width: 1140px;
    margin: 0 auto;
    padding: 0 20px;
}
.main-footer .footer-grid {
    display: grid;
    grid-template-columns: 1.5fr 1fr 1fr 1fr;
    gap: 40px;
    border-bottom: 1px solid rgba(255, 255, 255, 0.08);
    padding-bottom: 40px;
}
.main-footer .footer-title {
    color: var(--accent-green);
    font-size: 12px;
    letter-spacing: 1.5px;
    margin: 0 0 20px 0;
    font-weight: 700;
}
.main-footer .footer-col h4 {
    color: #ffffff;
    font-size: 12px;
    letter-spacing: 1.5px;
    margin: 0 0 20px 0;
    font-weight: 700;
}
.main-footer .footer-col ul {
    list-style: none;
    padding: 0;
    margin: 0;
}
.main-footer .footer-col ul li {
    margin-bottom: 10px;
}
.main-footer .footer-col ul a {
    color: #A0AEC0;
    text-decoration: none;
    transition: color 0.2s;
}
.main-footer .footer-col ul a:hover {
    color: #ffffff;
}
.main-footer .img-manual-logo {
    width: 240px;
    max-width: 100%;
    height: auto;
    display: block;
    margin-top: -20px;
    margin-bottom: 20px;
    margin-left: -70px;
}
.main-footer .contact-details p {
    margin: 0 0 10px -10px;
    display: flex;
    align-items: flex-start;
    gap: 10px;
    line-height: 1.6;
}
.main-footer .icon-contact {
    color: #A0AEC0;
    font-size: 14px;
    margin-top: 3px;
}
.main-footer .social-links {
    display: flex;
    gap: 10px;
    margin-bottom: 30px;
}
.main-footer .social-links a {
    width: 32px;
    height: 32px;
    border-radius: 50%;
    border: 1px solid rgba(255, 255, 255, 0.2);
    color: #ffffff;
    display: flex;
    align-items: center;
    justify-content: center;
    text-decoration: none;
    transition: border-color 0.2s, color 0.2s, transform 0.2s;
}
.main-footer .social-links a:hover {
    border-color: var(--accent-green);
    color: var(--accent-green);
    transform: translateY(-2px);
}
.main-footer .engagement-block {
    margin-top: 20px;
}
.main-footer .slogan {
    color: #ffffff;
    font-size: 16px;
    font-weight: 600;
    line-height: 1.3;
    margin: 0;
}
.main-footer .slogan-line {
    width: 30px;
    height: 2px;
    background-color: var(--accent-green);
    margin-top: 10px;
}
.main-footer .footer-bottom {
    text-align: center;
    padding-top: 20px;
    font-size: 11px;
    color: #718096;
}
.main-footer .footer-bottom p {
    margin: 0;
}
.footer-logo {
    width: 100%;
}

/* ---------- RESPONSIVE ---------- */
@media (max-width: 992px) {
    .booking-section .booking-widget {
        grid-template-columns: 1fr;
        gap: 10px;
    }
    .booking-section .widget-field {
        border-right: none;
        border-bottom: 1px solid #E2E8F0;
    }
    .main-footer .footer-grid {
        grid-template-columns: 1fr 1fr;
    }
}
@media (max-width: 768px) {
    .booking-section .booking-features {
        flex-direction: column;
        gap: 15px;
    }
    .main-footer .footer-grid {
        grid-template-columns: 1fr;
    }
}
CSS_EOF
echo "🎨 css/footer-cta.css créé"

# ---------- 3) Ajouter le <link> dans toutes les pages ----------
for f in *.html; do
    if ! grep -q 'footer-cta.css' "$f"; then
        perl -i -pe 's|(<link rel="stylesheet" href="css/commun.css">)|$1\n    <link rel="stylesheet" href="css/footer-cta.css">|' "$f"
    fi
done
echo "🔗 <link> footer-cta.css ajouté partout"

# ---------- 4) Extraire CTA et footer depuis index.html ----------
perl -0777 -ne 'print $1 if /(<section class="booking-section">.*?<\/section>)/s' index.html > /tmp/cta.html
perl -0777 -ne 'print $1 if /(<footer class="main-footer">.*?<\/footer>)/s' index.html > /tmp/footer.html

if [ ! -s /tmp/cta.html ] || [ ! -s /tmp/footer.html ]; then
    echo "❌ Impossible d'extraire le CTA ou le footer depuis index.html"
    exit 1
fi
echo "📤 CTA et footer extraits depuis index.html"

# ---------- 5) Remplacer dans toutes les pages sauf index ----------
for f in *.html; do
    [ "$f" = "index.html" ] && continue

    # Supprimer anciennes sections/footers
    perl -i -0777 -pe 's|<section class="booking-bar">.*?</section>||gs'      "$f"
    perl -i -0777 -pe 's|<section class="booking-section">.*?</section>||gs'  "$f"
    perl -i -0777 -pe 's|<footer[^>]*>.*?</footer>||gs'                        "$f"

    # Insérer CTA + footer avant </body>
    perl -i -0777 -e '
        my $file = $ARGV;
        open my $f1, "<", "/tmp/cta.html" or die;    local $/; my $cta = <$f1>; close $f1;
        open my $f2, "<", "/tmp/footer.html" or die; my $ft  = <$f2>; close $f2;
        open my $f3, "<", $file or die;              my $c   = <$f3>; close $f3;
        $c =~ s|</body>|$cta\n\n$ft\n\n</body>|s;
        open my $f4, ">", $file or die; print $f4 $c; close $f4;
    ' "$f"
    echo "✅ $f"
done

echo ""
echo "==========================================="
echo "✅ TERMINÉ"
echo "💾 Sauvegarde : $BACKUP_DIR"
echo "⚠️  Fais Ctrl+F5 dans le navigateur"
echo "==========================================="
