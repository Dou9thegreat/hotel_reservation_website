#!/bin/bash
set -e

echo "================================================================"
echo "  RÉSOLUTION DÉFINITIVE — tous les problèmes"
echo "  Langue · Paiement · Devise · Logo · Footers identiques"
echo "================================================================"

# ---------- 0) Sauvegarde ----------
BACKUP=".backup_SUPER_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP"
cp *.html "$BACKUP/" 2>/dev/null || true
mkdir -p "$BACKUP/css" "$BACKUP/js"
cp css/*.css "$BACKUP/css/" 2>/dev/null || true
cp js/*.js   "$BACKUP/js/"   2>/dev/null || true
echo "📦 Sauvegarde complète → $BACKUP"
echo ""

# ================================================================
# ÉTAPE 1 — Reconstruire css/footer-cta.css proprement
# ================================================================
echo "─── [1/6] Reconstruction de css/footer-cta.css ───"

cat > css/footer-cta.css << 'CSS_FULL_EOF'
/* ============================================================= */
/* FOOTER + CTA — Styles complets                                */
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
    --font-sans: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Montserrat", sans-serif;
}

/* ---------- CTA (bandeau réservation) ---------- */
.booking-section {
    background-color: #073B4C;
    color: #ffffff;
    padding: 50px 0;
    text-align: center;
    font-family: var(--font-sans);
}
.booking-section .container { max-width: 1140px; margin: 0 auto; padding: 0 20px; }
.booking-section h2 { font-size: 30px; letter-spacing: 2px; font-weight: 700; color: #fff; margin: 0 0 6px 0; }
.booking-section p.subtitle { font-size: 13px; color: #A0AEC0; margin: 0 0 30px 0; }
.booking-section .booking-widget {
    background: #fff; border-radius: 8px; display: grid;
    grid-template-columns: repeat(4, 1fr) auto; align-items: center;
    padding: 6px; margin-bottom: 30px; gap: 8px;
}
.booking-section .widget-field {
    display: flex; align-items: center; gap: 12px; padding: 12px 20px;
    border-right: 1px solid #E2E8F0; text-align: left; color: #0D2834;
}
.booking-section .icon-field { font-size: 18px; color: var(--text-muted); }
.booking-section .widget-field label {
    display: block; font-size: 10px; font-weight: 700;
    color: var(--text-muted); letter-spacing: 0.5px; text-transform: uppercase;
}
.booking-section .cta-date-input {
    border: none; background: transparent; outline: none; padding: 0;
    width: 100%; font-family: inherit; font-size: 13px; font-weight: 600;
    color: #0D2834; cursor: pointer;
}
.booking-section .widget-field select {
    appearance: none; -webkit-appearance: none; border: none;
    background-color: transparent;
    background-image: url("data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' width='10' height='6' viewBox='0 0 10 6'><path fill='%230D2834' opacity='0.6' d='M0 0l5 5 5-5z'/></svg>");
    background-repeat: no-repeat; background-position: right 2px center;
    padding-right: 18px; font-family: inherit; font-size: 13px;
    font-weight: 600; color: #0D2834; cursor: pointer; outline: none;
}
.booking-section .widget-field select option { background: #fff; color: #0D2834; }
.booking-section .btn-submit {
    background-color: #D2A366; color: #fff; border: none;
    padding: 18px 28px; border-radius: 8px; font-weight: 700;
    font-size: 12px; letter-spacing: 1px; cursor: pointer;
    white-space: nowrap; text-transform: uppercase;
    box-shadow: 0 6px 16px rgba(0,0,0,.18); transition: .2s;
    text-decoration: none;
}
.booking-section .btn-submit:hover { background-color: #b88d52; transform: scale(1.02); }
.booking-section .booking-features { display: flex; justify-content: center; gap: 40px; }
.booking-section .feature-item {
    display: flex; align-items: center; gap: 10px;
    font-size: 11px; font-weight: 600; letter-spacing: 1px; text-transform: uppercase;
}
.booking-section .icon-circle {
    border: 1px solid var(--accent-green); color: var(--accent-green);
    border-radius: 50%; width: 28px; height: 28px;
    display: flex; align-items: center; justify-content: center; font-size: 12px;
}

/* ============================================================= */
/* FOOTER                                                        */
/* ============================================================= */
.main-footer {
    background-color: var(--footer-bg);
    color: #A0AEC0;
    padding: 60px 0 20px 0;
    font-size: 12px;
    font-family: var(--font-sans);
    position: relative;
    overflow: hidden;
}
.main-footer .container {
    max-width: 1140px;
    margin: 0 auto;
    padding: 0 20px;
    position: relative;
    z-index: 1;
}
.main-footer .footer-grid {
    display: grid;
    grid-template-columns: 1.5fr 1fr 1fr 1fr;
    gap: 40px;
    border-bottom: 1px solid rgba(255,255,255,.08);
    padding-bottom: 40px;
}
.main-footer .footer-title {
    color: var(--accent-green);
    font-size: 12px; letter-spacing: 1.5px;
    margin: 0 0 20px 0; font-weight: 700;
}
.main-footer .footer-col h4 {
    color: #fff; font-size: 12px; letter-spacing: 1.5px;
    margin: 0 0 20px 0; font-weight: 700;
}
.main-footer .footer-col ul { list-style: none; padding: 0; margin: 0; }
.main-footer .footer-col ul li { margin-bottom: 10px; }
.main-footer .footer-col ul a { color: #A0AEC0; text-decoration: none; transition: color .2s; }
.main-footer .footer-col ul a:hover { color: #fff; }

.main-footer .img-manual-logo {
    width: 240px; max-width: 100%; height: auto;
    display: block; margin: -20px 0 20px -70px;
}
.main-footer .contact-details p {
    margin: 0 0 10px -10px; display: flex;
    align-items: flex-start; gap: 10px; line-height: 1.6;
}
.main-footer .icon-contact { color: #A0AEC0; font-size: 14px; margin-top: 3px; }

.main-footer .social-links { display: flex; gap: 10px; margin-bottom: 30px; }
.main-footer .social-links a {
    width: 32px; height: 32px; border-radius: 50%;
    border: 1px solid rgba(255,255,255,.2); color: #fff;
    display: flex; align-items: center; justify-content: center;
    text-decoration: none; transition: .2s;
}
.main-footer .social-links a:hover {
    border-color: var(--accent-green); color: var(--accent-green);
    transform: translateY(-2px);
}
.main-footer .engagement-block { margin-top: 20px; }
.main-footer .slogan { color: #fff; font-size: 16px; font-weight: 600; line-height: 1.3; margin: 0; }
.main-footer .slogan-line { width: 30px; height: 2px; background: var(--accent-green); margin-top: 10px; }

/* ---------- MOYENS DE PAIEMENT ---------- */
.main-footer .payment-methods {
    display: flex; gap: 8px; flex-wrap: wrap; margin-top: 4px; align-items: center;
}
.main-footer .payment-badge {
    background: #ffffff; border-radius: 5px; height: 30px; min-width: 48px;
    display: inline-flex; align-items: center; justify-content: center;
    padding: 4px 8px; font-family: Arial, Helvetica, sans-serif;
    font-weight: 900; font-style: italic; font-size: 12px;
    letter-spacing: .5px; line-height: 1;
}
.main-footer .pay-visa { color: #1A1F71; }
.main-footer .pay-mc { padding: 0 6px; gap: 0; }
.main-footer .pay-mc .circle { width: 16px; height: 16px; border-radius: 50%; display: inline-block; }
.main-footer .pay-mc .c1 { background: #EB001B; margin-right: -6px; }
.main-footer .pay-mc .c2 { background: #F79E1B; opacity: .9; }
.main-footer .pay-wave { background: #1DC8FF; color: #fff; font-style: normal; font-size: 11px; font-weight: 700; }
.main-footer .pay-om { background: #FF7900; color: #fff; font-style: normal; font-size: 9.5px; font-weight: 700; padding: 4px 7px; }

/* ---------- FOOTER BOTTOM (copyright + devise) ---------- */
.main-footer .footer-bottom {
    display: flex;
    justify-content: space-between;
    align-items: center;
    flex-wrap: wrap;
    gap: 12px;
    text-align: left;
    padding-top: 22px;
    font-size: 11px;
    color: #718096;
}
.main-footer .footer-bottom p { margin: 0; }
.main-footer .footer-bottom-right { display: flex; align-items: center; gap: 14px; }

.main-footer .currency-switch { position: relative; }
.main-footer .currency-current {
    display: inline-flex; align-items: center; gap: 8px;
    font-size: 11px; color: #A0AEC0; font-weight: 600; letter-spacing: .3px;
    cursor: pointer; background: none; border: none; font-family: inherit;
    padding: 6px 10px; border-radius: 4px; transition: background .2s, color .2s;
}
.main-footer .currency-current:hover { background: rgba(255,255,255,.06); color: #fff; }
.main-footer .currency-current i { font-size: 10px; }
.main-footer .currency-menu {
    display: none; position: absolute; bottom: calc(100% + 6px); right: 0;
    background: #1a1a1a; border: 1px solid rgba(255,255,255,.1);
    border-radius: 6px; min-width: 190px; padding: 6px 0;
    list-style: none; margin: 0;
    box-shadow: 0 8px 20px rgba(0,0,0,.4); z-index: 2000;
}
.main-footer .currency-switch.open .currency-menu { display: block; }
.main-footer .currency-menu li { margin: 0; }
.main-footer .currency-menu a {
    display: flex; align-items: center; justify-content: space-between; gap: 10px;
    padding: 9px 14px; color: #A0AEC0; text-decoration: none; font-size: 12px;
    transition: background .15s, color .15s;
}
.main-footer .currency-menu a:hover { background: rgba(255,255,255,.06); color: #fff; }
.main-footer .currency-menu a.active { color: #38E28F; font-weight: 700; }
.main-footer .currency-menu a .code {
    font-weight: 700; font-size: 11px; color: #fff;
    background: rgba(255,255,255,.08); padding: 2px 8px; border-radius: 4px;
}

/* ---------- LOGO DÉCORATIF EN BAS À DROITE ---------- */
.main-footer::after {
    content: "";
    position: absolute;
    bottom: -70px;
    right: -80px;
    width: 320px;
    height: 320px;
    background-image: url('../images/logo-symbole.png');
    background-size: contain;
    background-repeat: no-repeat;
    background-position: center;
    opacity: 0.08;
    pointer-events: none;
    z-index: 0;
}

/* ============================================================= */
/* SÉLECTEUR DE LANGUE (TOPBAR)                                  */
/* ============================================================= */
.topbar .lang-switch { position: relative; user-select: none; }
.topbar .lang-current {
    cursor: pointer; color: #C59A67; font-weight: 600;
    display: inline-flex; align-items: center; gap: 4px;
}
.topbar .lang-menu {
    display: none;
    position: absolute;
    top: calc(100% + 8px);
    right: 0;
    background: #fff;
    border: 1px solid #E9ECEF;
    border-radius: 6px;
    min-width: 140px;
    padding: 6px 0;
    list-style: none;
    margin: 0;
    box-shadow: 0 8px 20px rgba(0,0,0,.12);
    z-index: 2000;
}
.topbar .lang-switch.open .lang-menu { display: block; }
.topbar .lang-menu li { margin: 0; }
.topbar .lang-menu a {
    display: block;
    padding: 8px 14px;
    color: #404040;
    text-decoration: none;
    font-size: 12px;
    font-weight: 500;
    transition: background .15s, color .15s;
}
.topbar .lang-menu a:hover { background: #f7f7f7; color: #C59A67; }
.topbar .lang-menu a.active { color: #C59A67; font-weight: 700; }

/* ---------- RESPONSIVE ---------- */
@media (max-width: 992px) {
    .booking-section .booking-widget { grid-template-columns: 1fr; gap: 10px; }
    .booking-section .widget-field { border-right: none; border-bottom: 1px solid #E2E8F0; }
    .main-footer .footer-grid { grid-template-columns: 1fr 1fr; }
}
@media (max-width: 768px) {
    .booking-section .booking-features { flex-direction: column; gap: 15px; }
    .main-footer .footer-grid { grid-template-columns: 1fr; }
}
@media (max-width: 700px) {
    .main-footer .footer-bottom { flex-direction: column; align-items: flex-start; }
    .main-footer::after { width: 200px; height: 200px; bottom: -50px; right: -50px; }
}
CSS_FULL_EOF
echo "   ✅ css/footer-cta.css reconstruit ($(wc -l < css/footer-cta.css) lignes)"

# ================================================================
# ÉTAPE 2 — Reconstruire js/booking-bridge.js (PROPRE, sans doublon)
# ================================================================
echo ""
echo "─── [2/6] Reconstruction de js/booking-bridge.js ───"

cat > js/booking-bridge.js << 'BRIDGE_FULL_EOF'
/* ============================================================= */
/* BOOKING-BRIDGE.JS                                             */
/* Pont entre toutes les pages et reservation.html               */
/* + Sélecteurs LANGUE et DEVISE                                 */
/* Responsable : Mamadou Diagne (chef de projet)                 */
/* ============================================================= */
(function () {
  'use strict';

  /* ============================================================
     PARTIE 1 — PONT VERS LA PAGE RÉSERVATION
     ============================================================ */

  function toISODate(dateObj) {
    if (!dateObj) return '';
    var d = new Date(dateObj);
    if (isNaN(d)) return '';
    return d.getFullYear() + '-' +
           String(d.getMonth() + 1).padStart(2, '0') + '-' +
           String(d.getDate()).padStart(2, '0');
  }
  function getDateISO(inputId) {
    var el = document.getElementById(inputId);
    if (!el) return '';
    if (el._flatpickr && el._flatpickr.selectedDates[0]) {
      return toISODate(el._flatpickr.selectedDates[0]);
    }
    if (el.value) return el.value;
    return '';
  }
  function parseRooms(str) {
    var m = String(str).match(/(\d+)/);
    return m ? parseInt(m[1]) : 1;
  }
  function parseGuests(str) {
    var a = String(str).match(/(\d+)\s*adulte/i);
    var c = String(str).match(/(\d+)\s*enfant/i);
    return {
      adults: a ? parseInt(a[1]) : 2,
      children: c ? parseInt(c[1]) : 0
    };
  }

  window.buildBookingURL = function (params) {
    params = params || {};
    var q = new URLSearchParams();
    if (params.checkin)  q.set('checkin',  params.checkin);
    if (params.checkout) q.set('checkout', params.checkout);
    if (params.rooms)    q.set('rooms',    params.rooms);
    if (params.adults != null)   q.set('adults',   params.adults);
    if (params.children != null) q.set('children', params.children);
    if (params.room)     q.set('room',     params.room);
    if (params.tariff != null)   q.set('tariff',   params.tariff);
    if (params.promo)    q.set('promo',    params.promo);
    var qs = q.toString();
    return 'reservation.html' + (qs ? '?' + qs : '');
  };

  window.goToBooking = function (params) {
    window.location.href = window.buildBookingURL(params);
  };

  function findHeroRoomsSelect() {
    return document.querySelector('form.booking-bar .booking-field:nth-child(1) .field-select');
  }
  function findHeroGuestsSelect() {
    return document.querySelector('form.booking-bar .booking-field:nth-child(4) .field-select');
  }
  function findCtaField(index) {
    var cta = document.querySelector('.booking-section .booking-widget');
    return cta ? cta.querySelector('.widget-field:nth-child(' + index + ')') : null;
  }

  /* ============================================================
     PARTIE 2 — INITIALISATION APRÈS CHARGEMENT
     ============================================================ */
  document.addEventListener('DOMContentLoaded', function () {

    /* --- 2.1 Formulaire hero (index.html) --- */
    var heroForm = document.querySelector('form.booking-bar');
    if (heroForm) {
      heroForm.addEventListener('submit', function (e) {
        e.preventDefault();
        var roomsEl  = findHeroRoomsSelect();
        var guestsEl = findHeroGuestsSelect();
        var guests = guestsEl ? parseGuests(guestsEl.value) : { adults: 2, children: 0 };
        window.goToBooking({
          checkin:  getDateISO('checkin'),
          checkout: getDateISO('checkout'),
          rooms:    roomsEl ? parseRooms(roomsEl.value) : 1,
          adults:   guests.adults,
          children: guests.children
        });
      });
    }

    /* --- 2.2 CTA bas de page --- */
    var ctaBtn = document.querySelector('.booking-section .btn-submit');
    if (ctaBtn) {
      ctaBtn.addEventListener('click', function (e) {
        e.preventDefault();
        var f3 = findCtaField(3), f4 = findCtaField(4);
        var roomsEl  = f3 && f3.querySelector('select');
        var guestsEl = f4 && f4.querySelector('select');
        var guests = guestsEl ? parseGuests(guestsEl.value) : { adults: 2, children: 0 };
        window.goToBooking({
          checkin:  getDateISO('cta-checkin'),
          checkout: getDateISO('cta-checkout'),
          rooms:    roomsEl ? parseRooms(roomsEl.value) : 1,
          adults:   guests.adults,
          children: guests.children
        });
      });
    }

    /* --- 2.3 Boutons data-book-room --- */
    document.querySelectorAll('[data-book-room]').forEach(function (el) {
      el.addEventListener('click', function (e) {
        e.preventDefault();
        window.goToBooking({
          room:     el.dataset.bookRoom,
          tariff:   el.dataset.bookTariff || 0,
          checkin:  el.dataset.bookCheckin  || '',
          checkout: el.dataset.bookCheckout || ''
        });
      });
    });

    /* --- 2.4 Page réservation : lire les params --- */
    var isReservationPage = document.querySelector('.reservation-page');
    if (isReservationPage) {
      var params = new URLSearchParams(window.location.search);
      var dArrivee = document.getElementById('dArrivee');
      var dDepart  = document.getElementById('dDepart');
      if (params.get('checkin')  && dArrivee) dArrivee.value = params.get('checkin');
      if (params.get('checkout') && dDepart)  dDepart.value  = params.get('checkout');

      var dChambres  = document.getElementById('dChambres');
      var roomsParam = params.get('rooms');
      if (roomsParam && dChambres) {
        dChambres.value = String(roomsParam);
        if (typeof window.doSearch === 'function') window.doSearch();
      }

      var adults   = parseInt(params.get('adults')   || '0', 10);
      var children = parseInt(params.get('children') || '0', 10);
      if (adults > 0) {
        var dVoy = document.getElementById('dVoy');
        if (dVoy) {
          var target = children === 0
            ? (adults === 1 ? '1 adulte' : adults + ' adultes')
            : (adults + ' adultes, ' + children + ' enfant' + (children > 1 ? 's' : ''));
          Array.from(dVoy.options).forEach(function (opt) {
            if (opt.textContent.trim() === target) opt.selected = true;
          });
        }
      }

      var dCode = document.getElementById('dCode');
      if (params.get('promo') && dCode) dCode.value = params.get('promo');

      var roomId    = params.get('room');
      var tariffIdx = params.get('tariff');
      if (roomId && typeof window.selectTariff === 'function') {
        setTimeout(function () {
          window.selectTariff(roomId, tariffIdx != null ? parseInt(tariffIdx, 10) : 0);
        }, 80);
      }
    }

    /* ============================================================
       PARTIE 3 — SÉLECTEUR DE LANGUE
       ============================================================ */
    var langSwitch  = document.querySelector('.topbar .lang-switch');
    var langCurrent = document.querySelector('.topbar .lang-current');
    var savedLang   = localStorage.getItem('pullman_lang') || 'fr';
    var langNames   = { fr: 'Français', en: 'English', es: 'Español' };

    if (langCurrent && langNames[savedLang]) {
      langCurrent.textContent = langNames[savedLang];
    }
    document.querySelectorAll('.topbar .lang-menu a').forEach(function (a) {
      a.classList.toggle('active', a.dataset.lang === savedLang);
    });

    if (langSwitch && langCurrent) {
      langCurrent.addEventListener('click', function (e) {
        e.stopPropagation();
        document.querySelectorAll('.currency-switch').forEach(function (cs) {
          cs.classList.remove('open');
        });
        langSwitch.classList.toggle('open');
      });
      document.querySelectorAll('.topbar .lang-menu a').forEach(function (a) {
        a.addEventListener('click', function (e) {
          e.preventDefault();
          var lang = a.dataset.lang;
          localStorage.setItem('pullman_lang', lang);
          document.querySelectorAll('.topbar .lang-menu a').forEach(function (x) {
            x.classList.remove('active');
          });
          a.classList.add('active');
          langCurrent.textContent = langNames[lang] || 'Français';
          langSwitch.classList.remove('open');
          window.dispatchEvent(new CustomEvent('language-changed', { detail: { lang: lang } }));
        });
      });
    }

    /* ============================================================
       PARTIE 4 — SÉLECTEUR DE DEVISE
       ============================================================ */
    var currencySwitch  = document.querySelector('.currency-switch');
    var currencyCurrent = document.querySelector('.currency-current');
    var savedCur        = localStorage.getItem('pullman_currency') || 'XOF';
    var labels          = { XOF: 'FR · XOF', EUR: 'FR · EUR', USD: 'FR · USD' };

    function updateCurrencyUI(cur) {
      if (currencyCurrent) {
        currencyCurrent.innerHTML = '<i class="fas fa-globe"></i> ' +
          (labels[cur] || 'FR · XOF') +
          ' <i class="fas fa-chevron-down"></i>';
      }
      document.querySelectorAll('.currency-menu a').forEach(function (x) {
        x.classList.toggle('active', x.dataset.currency === cur);
      });
    }
    updateCurrencyUI(savedCur);

    if (currencySwitch && currencyCurrent) {
      currencyCurrent.addEventListener('click', function (e) {
        e.stopPropagation();
        if (langSwitch) langSwitch.classList.remove('open');
        currencySwitch.classList.toggle('open');
      });
      document.querySelectorAll('.currency-menu a').forEach(function (a) {
        a.addEventListener('click', function (e) {
          e.preventDefault();
          var cur = a.dataset.currency;
          localStorage.setItem('pullman_currency', cur);
          updateCurrencyUI(cur);
          currencySwitch.classList.remove('open');
          window.dispatchEvent(new CustomEvent('currency-changed', { detail: { currency: cur } }));
        });
      });
    }

    /* --- Fermeture au clic extérieur --- */
    document.addEventListener('click', function () {
      if (langSwitch) langSwitch.classList.remove('open');
      document.querySelectorAll('.currency-switch').forEach(function (cs) {
        cs.classList.remove('open');
      });
    });
    document.addEventListener('keydown', function (e) {
      if (e.key === 'Escape') {
        if (langSwitch) langSwitch.classList.remove('open');
        document.querySelectorAll('.currency-switch').forEach(function (cs) {
          cs.classList.remove('open');
        });
      }
    });
  });

})();
BRIDGE_FULL_EOF
echo "   ✅ js/booking-bridge.js reconstruit ($(wc -l < js/booking-bridge.js) lignes)"

# ================================================================
# ÉTAPE 3 — Reconstruire js/i18n.js (dictionnaire complet)
# ================================================================
echo ""
echo "─── [3/6] Reconstruction de js/i18n.js ───"

cat > js/i18n.js << 'I18N_FULL_EOF'
/* ============================================================= */
/* I18N.JS — Traduction FR / EN / ES complète                    */
/* MutationObserver : traduit aussi le contenu dynamique         */
/* ============================================================= */
(function () {
  'use strict';

  var DICTS = {
    fr: {},
    en: {
      /* Header */
      'ACCUEIL':'HOME','CHAMBRES':'ROOMS','EXPÉRIENCES':'EXPERIENCES',
      'GALERIE':'GALLERY','MEETING & EVENTS':'MEETING & EVENTS','CONTACT':'CONTACT',
      'Réserver maintenant':'Book now','Nous contacter':'Contact us',

      /* Footer */
      'LIENS UTILES':'USEFUL LINKS','DÉCOUVRIR':'DISCOVER','SUIVEZ-NOUS':'FOLLOW US',
      'MOYENS DE PAIEMENT':'PAYMENT METHODS','NOTRE ENGAGEMENT':'OUR COMMITMENT',
      'Mentions légales':'Legal notices','Conditions générales':'Terms & conditions',
      'Politique de confidentialité':'Privacy policy','Accessibilité':'Accessibility',
      'Nos chambres':'Our rooms','Expériences':'Experiences',
      'Offres spéciales':'Special offers','Galerie':'Gallery',
      'Our World Is':'Our World Is','Your Playground':'Your Playground',
      'Franc CFA':'CFA Franc','Euro':'Euro','Dollar US':'US Dollar',
      '© 2026 Pullman Dakar Teranga - Tous droits réservés.':
        '© 2026 Pullman Dakar Teranga - All rights reserved.',
      'BP 8181, Dakar, Sénégal':'BP 8181, Dakar, Senegal',
      'Route de la Corniche Ouest':'Route de la Corniche Ouest',

      /* Pourquoi réserver */
      'Pourquoi réserver en direct ?':'Why book direct?',
      'Meilleur tarif garanti':'Best rate guaranteed',
      'Profitez des meilleurs tarifs disponibles uniquement sur notre site officiel.':
        'Enjoy the best rates available only on our official website.',
      'Annulation flexible':'Flexible cancellation',
      "Annulation gratuite jusqu'à 48h avant votre arrivée.":
        'Free cancellation up to 48h before arrival.',
      'Paiement sécurisé':'Secure payment',
      'Vos transactions sont 100% sécurisées.':'Your transactions are 100% secure.',

      /* CTA */
      'PRÊT POUR VOTRE PROCHAINE ÉVASION ?':'READY FOR YOUR NEXT ESCAPE?',
      "Réservez maintenant et vivez l'expérience Pullman Dakar Teranga.":
        'Book now and live the Pullman Dakar Teranga experience.',

      /* Réservation */
      'Réservez votre séjour au Pullman Dakar Teranga':'Book your stay at Pullman Dakar Teranga',
      "Profitez d'une expérience unique alliant confort, élégance et hospitalité sénégalaise face à l'océan Atlantique.":
        'Enjoy a unique experience combining comfort, elegance and Senegalese hospitality facing the Atlantic Ocean.',
      'Choix du séjour':'Choose your stay','Vos coordonnées':'Your details',
      'Récapitulatif':'Summary','Confirmation':'Confirmation',
      'Arrivée':'Arrival','Départ':'Departure','Voyageurs':'Guests',
      'Chambres':'Rooms','Code promo':'Promo code','Facultatif':'Optional',
      'Rechercher':'Search',
      'Toutes les vues':'All views','Vue océan':'Ocean view','Vue ville':'City view',
      '1 lit King':'1 King bed','2 lits simples':'2 twin beds',
      'Votre sélection':'Your selection',
      'Choisissez une chambre et un tarif dans la liste pour voir apparaître ici le détail de votre réservation.':
        'Choose a room and rate from the list to see your booking details here.',
      'Continuer':'Continue',
      '✓ Meilleur tarif garanti':'✓ Best rate guaranteed',
      '✓ Paiement sécurisé':'✓ Secure payment',
      '✓ Annulation flexible':'✓ Flexible cancellation',
      'TOTAL SÉJOUR':'TOTAL STAY','TOTAL':'TOTAL',

      /* Chambres */
      'Chambre Classique Vue Ville':'Classic City View Room',
      'Chambre Classique Twin Vue Ville':'Classic Twin City View Room',
      'Chambre Deluxe Vue Océan':'Deluxe Ocean View Room',
      'Chambre Supérieure Vue Océan':'Superior Ocean View Room',
      'Suite Ambassadeur Pullman':'Pullman Ambassador Suite',
      'Vue Océan':'Ocean View','Vue Ville':'City View',
      "Élégante et confortable, pensée pour un séjour urbain pratique au cœur de Dakar.":
        'Elegant and comfortable, designed for a convenient urban stay in the heart of Dakar.',
      "Deux lits simples, idéale pour les collègues ou amis en voyage d'affaires.":
        'Two twin beds, ideal for colleagues or friends on a business trip.',
      "Balcon privé et vue imprenable sur l'Atlantique depuis votre lit King Size.":
        'Private balcony and stunning Atlantic views from your King Size bed.',
      "Terrasse privative et lumière naturelle généreuse, face à l'île de Gorée.":
        'Private terrace and generous natural light, facing Gorée Island.',
      "Salon séparé, volumes généreux et services exclusifs pour un séjour d'exception.":
        'Separate living room, generous volumes and exclusive services for an exceptional stay.',
      'Plus que 2 chambres à ce tarif':'Only 2 rooms left at this rate',
      'Plus que 3 chambres à ce tarif':'Only 3 rooms left at this rate',
      'Plus que 4 chambres à ce tarif':'Only 4 rooms left at this rate',

      /* Équipements */
      'Lit King Size':'King Size bed','Wi-Fi haut débit':'High-speed Wi-Fi',
      'Minibar':'Minibar','Climatisation':'Air conditioning',
      'Balcon privé':'Private balcony','Machine Illy':'Illy coffee machine',
      'Terrasse':'Terrace','Baignoire':'Bathtub','Coffre-fort':'Safe',
      'Salon séparé':'Separate living room','Canapé-lit':'Sofa bed',
      'Baignoire & douche':'Bathtub & shower','Service Concierge':'Concierge service',

      /* Tarifs */
      'Tarif Flexible':'Flexible Rate','Tarif Non-remboursable':'Non-refundable Rate',
      'Petit-déjeuner inclus':'Breakfast included',
      "Annulation gratuite jusqu'à 48h avant l'arrivée":
        'Free cancellation up to 48h before arrival',
      'Paiement immédiat, −15%':'Immediate payment, −15%',
      'Buffet Teranga Lounge chaque matin':'Teranga Lounge buffet every morning',
      'Buffet Teranga Lounge + service en chambre':
        'Teranga Lounge buffet + room service',
      'par nuit':'per night','Sélectionner':'Select','✓ Sélectionnée':'✓ Selected',

      /* Panneau */
      'Nuits':'Nights','Taxe de promotion touristique':'Tourist promotion tax',
      'TVA':'VAT','incluse':'included',
      "Non remboursable — paiement immédiat":'Non-refundable — immediate payment',

      /* Étape 2 */
      "Ces informations serviront à votre confirmation de réservation et à votre accueil à l'hôtel.":
        'This information will be used for your booking confirmation and hotel check-in.',
      'Voyageur principal':'Main guest','Civilité':'Title',
      'Madame':'Mrs','Monsieur':'Mr','Autre':'Other',
      'Prénom':'First name','Nom':'Last name',
      'E-mail':'E-mail','Téléphone':'Phone',
      'Pays de résidence':'Country of residence','Sénégal':'Senegal',
      'France':'France',"Côte d'Ivoire":'Ivory Coast','États-Unis':'United States',
      'Motif du séjour':'Purpose of stay','Loisirs':'Leisure',
      'Affaires':'Business','Événement / Séminaire':'Event / Seminar',
      'Votre arrivée':'Your arrival',
      "Heure d'arrivée estimée":'Estimated arrival time',
      'Avant 14h':'Before 2 pm','14h – 18h':'2 pm – 6 pm','18h – 22h':'6 pm – 10 pm',
      'Après 22h (arrivée tardive)':'After 10 pm (late arrival)',
      'Numéro adhérent ALL (facultatif)':'ALL member number (optional)',
      'Ex : 3512xxxxxx':'E.g. 3512xxxxxx',
      'Demandes particulières':'Special requests',
      'Étage élevé, lit bébé, allergie, anniversaire… (sous réserve de disponibilité)':
        'High floor, baby cot, allergy, birthday… (subject to availability)',
      'Services additionnels':'Additional services',
      'Transfert aéroport AIBD aller-retour — 35 000 FCFA':
        'Round-trip AIBD airport transfer — 35,000 XOF',
      'Late check-out (départ 16h) — Gratuit sur demande':
        'Late check-out (4 pm departure) — Free on request',
      'Accès Pullman Spa — 25 000 FCFA / personne':
        'Pullman Spa access — 25,000 XOF / person',
      "J'accepte les":'I accept the',
      'conditions générales de vente':'terms and conditions',
      'Je souhaite recevoir les offres et actualités du Pullman Dakar Teranga':
        'I would like to receive offers and news from Pullman Dakar Teranga',
      '← Retour':'← Back','Continuer vers le récapitulatif →':'Continue to summary →',

      /* Étape 3 */
      'Votre séjour':'Your stay','Modifier':'Change',
      'Mode de paiement':'Payment method',
      "Paiement instantané via l'application Wave":'Instant payment via the Wave app',
      'Orange Money':'Orange Money',
      'Paiement via votre compte Orange Money':'Payment via your Orange Money account',
      'Carte bancaire':'Bank card',
      'Visa, Mastercard — paiement sécurisé 3D Secure':'Visa, Mastercard — 3D Secure payment',
      '🔒 Transaction chiffrée SSL · Conforme 3D Secure':
        '🔒 SSL encrypted transaction · 3D Secure compliant',
      "Politique d'annulation":'Cancellation policy',
      'Total à régler':'Total to pay','Payer et confirmer':'Pay and confirm',

      /* Étape 4 */
      'Réservation confirmée':'Booking confirmed',
      'Un e-mail et un SMS de confirmation viennent de vous être envoyés. Nous avons hâte de vous accueillir au Pullman Dakar Teranga.':
        'A confirmation email and SMS have just been sent. We look forward to welcoming you at Pullman Dakar Teranga.',
      'Numéro de réservation':'Booking number',
      'Télécharger le PDF':'Download PDF','Ajouter au calendrier':'Add to calendar',

      /* Panier */
      'Chambre':'Room','Tarif':'Rate','Voyageur':'Guest',
      'Séjour':'Stay','Total réglé':'Total paid'
    },
    es: {
      'ACCUEIL':'INICIO','CHAMBRES':'HABITACIONES','EXPÉRIENCES':'EXPERIENCIAS',
      'GALERIE':'GALERÍA','MEETING & EVENTS':'REUNIONES Y EVENTOS','CONTACT':'CONTACTO',
      'Réserver maintenant':'Reservar ahora','Nous contacter':'Contáctenos',
      'LIENS UTILES':'ENLACES ÚTILES','DÉCOUVRIR':'DESCUBRIR','SUIVEZ-NOUS':'SÍGANOS',
      'MOYENS DE PAIEMENT':'MÉTODOS DE PAGO','NOTRE ENGAGEMENT':'NUESTRO COMPROMISO',
      'Mentions légales':'Aviso legal','Conditions générales':'Términos y condiciones',
      'Politique de confidentialité':'Política de privacidad','Accessibilité':'Accesibilidad',
      'Nos chambres':'Nuestras habitaciones','Expériences':'Experiencias',
      'Offres spéciales':'Ofertas especiales','Galerie':'Galería',
      'Our World Is':'Nuestro Mundo Es','Your Playground':'Tu Patio de Juegos',
      'Franc CFA':'Franco CFA','Euro':'Euro','Dollar US':'Dólar US',
      '© 2026 Pullman Dakar Teranga - Tous droits réservés.':
        '© 2026 Pullman Dakar Teranga - Todos los derechos reservados.',
      'BP 8181, Dakar, Sénégal':'BP 8181, Dakar, Senegal',
      'Pourquoi réserver en direct ?':'¿Por qué reservar directo?',
      'Meilleur tarif garanti':'Mejor precio garantizado',
      'Profitez des meilleurs tarifs disponibles uniquement sur notre site officiel.':
        'Disfruta de las mejores tarifas solo en nuestro sitio oficial.',
      'Annulation flexible':'Cancelación flexible',
      "Annulation gratuite jusqu'à 48h avant votre arrivée.":
        'Cancelación gratuita hasta 48h antes de la llegada.',
      'Paiement sécurisé':'Pago seguro',
      'Vos transactions sont 100% sécurisées.':'Tus transacciones son 100% seguras.',
      'PRÊT POUR VOTRE PROCHAINE ÉVASION ?':'¿LISTO PARA TU PRÓXIMA ESCAPADA?',
      "Réservez maintenant et vivez l'expérience Pullman Dakar Teranga.":
        'Reserva ahora y vive la experiencia Pullman Dakar Teranga.',
      'Réservez votre séjour au Pullman Dakar Teranga':
        'Reserva tu estancia en Pullman Dakar Teranga',
      "Profitez d'une expérience unique alliant confort, élégance et hospitalité sénégalaise face à l'océan Atlantique.":
        'Disfruta de una experiencia única que combina confort, elegancia y hospitalidad senegalesa frente al océano Atlántico.',
      'Choix du séjour':'Elige tu estancia','Vos coordonnées':'Tus datos',
      'Récapitulatif':'Resumen','Confirmation':'Confirmación',
      'Arrivée':'Llegada','Départ':'Salida','Voyageurs':'Huéspedes',
      'Chambres':'Habitaciones','Code promo':'Código promocional','Facultatif':'Opcional',
      'Rechercher':'Buscar',
      'Toutes les vues':'Todas las vistas','Vue océan':'Vista al océano',
      'Vue ville':'Vista a la ciudad','1 lit King':'1 cama King',
      '2 lits simples':'2 camas individuales',
      'Votre sélection':'Tu selección',
      'Choisissez une chambre et un tarif dans la liste pour voir apparaître ici le détail de votre réservation.':
        'Elige una habitación y una tarifa de la lista para ver aquí los detalles de tu reserva.',
      'Continuer':'Continuar',
      '✓ Meilleur tarif garanti':'✓ Mejor precio garantizado',
      '✓ Paiement sécurisé':'✓ Pago seguro',
      '✓ Annulation flexible':'✓ Cancelación flexible',
      'TOTAL SÉJOUR':'TOTAL ESTANCIA','TOTAL':'TOTAL',
      'Chambre Classique Vue Ville':'Habitación Clásica Vista Ciudad',
      'Chambre Deluxe Vue Océan':'Habitación Deluxe Vista Océano',
      'Chambre Supérieure Vue Océan':'Habitación Superior Vista Océano',
      'Suite Ambassadeur Pullman':'Suite Embajador Pullman',
      'Vue Océan':'Vista Océano','Vue Ville':'Vista Ciudad',
      'Tarif Flexible':'Tarifa Flexible','Tarif Non-remboursable':'Tarifa No Reembolsable',
      'Petit-déjeuner inclus':'Desayuno incluido',
      'par nuit':'por noche','Sélectionner':'Seleccionar','✓ Sélectionnée':'✓ Seleccionada',
      'Nuits':'Noches','Taxe de promotion touristique':'Tasa de promoción turística',
      'TVA':'IVA','incluse':'incluido',
      'Voyageur principal':'Huésped principal','Civilité':'Tratamiento',
      'Madame':'Sra.','Monsieur':'Sr.','Autre':'Otro',
      'Prénom':'Nombre','Nom':'Apellido','E-mail':'Correo electrónico',
      'Téléphone':'Teléfono','Pays de résidence':'País de residencia',
      'Sénégal':'Senegal','France':'Francia',"Côte d'Ivoire":'Costa de Marfil',
      'États-Unis':'Estados Unidos','Motif du séjour':'Motivo de la estancia',
      'Loisirs':'Ocio','Affaires':'Negocios','Événement / Séminaire':'Evento / Seminario',
      'Votre arrivée':'Tu llegada',"Heure d'arrivée estimée":'Hora de llegada estimada',
      'Demandes particulières':'Solicitudes especiales',
      'Services additionnels':'Servicios adicionales',
      "J'accepte les":'Acepto los',
      'conditions générales de vente':'términos y condiciones',
      '← Retour':'← Atrás','Continuer vers le récapitulatif →':'Continuar al resumen →',
      'Votre séjour':'Tu estancia','Modifier':'Cambiar',
      'Mode de paiement':'Método de pago','Carte bancaire':'Tarjeta bancaria',
      "Politique d'annulation":'Política de cancelación',
      'Total à régler':'Total a pagar','Payer et confirmer':'Pagar y confirmar',
      'Réservation confirmée':'Reserva confirmada',
      'Numéro de réservation':'Número de reserva',
      'Télécharger le PDF':'Descargar PDF','Ajouter au calendrier':'Añadir al calendario',
      'Chambre':'Habitación','Tarif':'Tarifa','Voyageur':'Huésped',
      'Séjour':'Estancia','Total réglé':'Total pagado'
    }
  };

  var SUBSTR = {
    fr: {},
    en: { ' nuit': ' night', ' pers.': ' guests' },
    es: { ' nuit': ' noche', ' pers.': ' huéspedes' }
  };

  var currentLang = localStorage.getItem('pullman_lang') || 'fr';
  var observer = null;
  var debounceTimer = null;

  function applySubstitutions(text, subs) {
    var result = text;
    for (var k in subs) {
      if (result.indexOf(k) !== -1) result = result.split(k).join(subs[k]);
    }
    return result;
  }

  function translateTextNode(node) {
    if (node.__origFr === undefined) node.__origFr = node.nodeValue;
    var orig = node.__origFr;
    var trimmed = orig.trim();
    if (!trimmed) return;
    var dict = DICTS[currentLang] || {};
    var subs = SUBSTR[currentLang] || {};
    if (dict[trimmed] !== undefined) {
      var lead = orig.match(/^\s*/)[0];
      var trail = orig.match(/\s*$/)[0];
      node.nodeValue = lead + dict[trimmed] + trail;
      return;
    }
    var replaced = applySubstitutions(orig, subs);
    node.nodeValue = (replaced !== orig) ? replaced : orig;
  }

  function walkAndTranslate(root) {
    var walker = document.createTreeWalker(root, NodeFilter.SHOW_TEXT, {
      acceptNode: function (node) {
        var p = node.parentNode;
        if (!p) return NodeFilter.FILTER_REJECT;
        var tag = p.tagName;
        if (tag === 'SCRIPT' || tag === 'STYLE' || tag === 'NOSCRIPT') return NodeFilter.FILTER_REJECT;
        if (!node.nodeValue || !node.nodeValue.trim()) return NodeFilter.FILTER_REJECT;
        return NodeFilter.FILTER_ACCEPT;
      }
    });
    var n;
    while ((n = walker.nextNode())) translateTextNode(n);
  }

  function translatePlaceholders() {
    document.querySelectorAll('[placeholder]').forEach(function (el) {
      if (el.__origPH === undefined) el.__origPH = el.placeholder;
      var dict = DICTS[currentLang] || {};
      var tr = dict[el.__origPH.trim()];
      el.placeholder = tr || el.__origPH;
    });
  }

  function applyLanguage(lang) {
    currentLang = lang;
    walkAndTranslate(document.body);
    translatePlaceholders();
  }

  function startObserver() {
    if (observer) return;
    if (currentLang === 'fr') return;
    observer = new MutationObserver(function () {
      clearTimeout(debounceTimer);
      debounceTimer = setTimeout(function () {
        walkAndTranslate(document.body);
        translatePlaceholders();
      }, 60);
    });
    observer.observe(document.body, { childList: true, subtree: true });
  }

  function stopObserver() {
    if (observer) { observer.disconnect(); observer = null; }
    clearTimeout(debounceTimer);
  }

  function init() {
    var names = { fr: 'Français', en: 'English', es: 'Español' };
    var lc = document.querySelector('.topbar .lang-current');
    if (lc) lc.textContent = names[currentLang] || 'Français';
    document.querySelectorAll('.topbar .lang-menu a').forEach(function (a) {
      a.classList.toggle('active', a.dataset.lang === currentLang);
    });
    if (currentLang !== 'fr') {
      applyLanguage(currentLang);
      startObserver();
    }
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }

  window.t = function (key) {
    var dict = DICTS[currentLang] || {};
    return dict[key] || key;
  };
  window.i18nRefresh = function () {
    walkAndTranslate(document.body);
    translatePlaceholders();
  };
  window.i18nSetLang = function (lang) {
    localStorage.setItem('pullman_lang', lang);
    applyLanguage(lang);
    if (lang !== 'fr') startObserver(); else stopObserver();
  };

  window.addEventListener('language-changed', function (e) {
    var lang = e.detail && e.detail.lang;
    if (!lang) return;
    applyLanguage(lang);
    if (lang !== 'fr') startObserver(); else stopObserver();
  });
})();
I18N_FULL_EOF
echo "   ✅ js/i18n.js reconstruit ($(wc -l < js/i18n.js) lignes)"

# ================================================================
# ÉTAPE 4 — Préparer le FOOTER complet (fichier temporaire)
# ================================================================
echo ""
echo "─── [4/6] Préparation du footer universel ───"

cat > /tmp/footer_universel.html << 'FT_EOF'
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
FT_EOF

cat > /tmp/topbar_langswitch.html << 'LANG_EOF'
<div class="lang-switch">
            <span class="lang-current">Français</span>
            <span class="chevron">▾</span>
            <ul class="lang-menu">
                <li><a href="#" data-lang="fr" class="active">Français</a></li>
                <li><a href="#" data-lang="en">English</a></li>
                <li><a href="#" data-lang="es">Español</a></li>
            </ul>
        </div>
LANG_EOF

echo "   ✅ Footer universel prêt ($(wc -l < /tmp/footer_universel.html) lignes)"
echo "   ✅ Topbar lang-switch prêt"

# ================================================================
# ÉTAPE 5 — Appliquer sur toutes les pages (AWK robuste)
# ================================================================
echo ""
echo "─── [5/6] Application sur toutes les pages ───"

PAGES="index.html chambres.html contact.html galerie.html evenements.html experiences.html experiences-piscine.html experiences-restaurant.html reservation.html"

for f in $PAGES; do
    [ ! -f "$f" ] && continue

    # 1) Supprimer tout ancien footer (même mal fermé)
    awk '
        BEGIN { skip = 0 }
        /<footer[^>]*>/ { skip = 1; next }
        skip && /<\/footer>/ { skip = 0; next }
        !skip { print }
    ' "$f" > "$f.step1"

    # 2) Insérer le footer universel avant </body>
    awk -v FT=/tmp/footer_universel.html '
        /<\/body>/ {
            while ((getline line < FT) > 0) print line
            close(FT)
            print ""
        }
        { print }
    ' "$f.step1" > "$f.step2"

    mv "$f.step2" "$f"
    rm -f "$f.step1"

    # 3) Remplacer le lang-switch du topbar
    export NEW_LANG="$(cat /tmp/topbar_langswitch.html)"
    perl -0777 -i -pe '
        s|<div class="lang-switch">.*?</div>\s*(?=<span class="separator")|$ENV{NEW_LANG}|s;
    ' "$f"
    unset NEW_LANG

    # 4) S'assurer que les scripts sont présents et dans le bon ordre
    # Supprimer TOUTES les anciennes références aux scripts
    perl -0777 -i -pe '
        s|<script src="js/i18n\.js"></script>\s*||g;
        s|<script src="js/booking-bridge\.js"></script>\s*||g;
    ' "$f"

    # Réinsérer proprement avant </body>
    perl -0777 -i -pe '
        s|</body>|    <script src="js/booking-bridge.js"></script>\n    <script src="js/i18n.js"></script>\n</body>|;
    ' "$f"

    # 5) S'assurer que footer-cta.css est chargé
    if ! grep -q 'footer-cta.css' "$f"; then
        perl -0777 -i -pe '
            s|(<link rel="stylesheet" href="css/commun\.css">)|$1\n    <link rel="stylesheet" href="css/footer-cta.css">|;
        ' "$f"
    fi

    echo "   ✅ $f"
done

# ================================================================
# ÉTAPE 6 — VÉRIFICATION FINALE
# ================================================================
echo ""
echo "─── [6/6] VÉRIFICATION FINALE ───"
echo ""
printf "   %-32s | %s | %s | %s | %s | %s\n" "Fichier" "ftr" "pm" "curr" "lang" "js"
printf "   %-32s-|-%s-|-%s-|-%s-|-%s-|-%s\n" "--------------------------------" "--" "--" "----" "----" "---"
for f in $PAGES; do
    [ ! -f "$f" ] && continue
    ft=$(grep -c 'class="main-footer"' "$f")
    pm=$(grep -c 'payment-badge' "$f")
    cs=$(grep -c 'currency-switch' "$f")
    lg=$(grep -c 'lang-menu' "$f")
    js=$(grep -c 'js/i18n.js\|js/booking-bridge.js' "$f")
    printf "   %-32s | %-3s | %-2s | %-4s | %-4s | %-3s\n" "$f" "$ft" "$pm" "$cs" "$lg" "$js"
done

echo ""
echo "   ─── Fichiers JS / CSS ───"
printf "   %-32s : %s\n" "css/footer-cta.css" "$(wc -l < css/footer-cta.css) lignes"
printf "   %-32s : %s\n" "js/booking-bridge.js" "$(wc -l < js/booking-bridge.js) lignes"
printf "   %-32s : %s\n" "js/i18n.js" "$(wc -l < js/i18n.js) lignes"

echo ""
echo "   ─── Doublons éventuels ───"
DUP_JS=$(grep -c 'lang-menu' js/booking-bridge.js || echo 0)
echo "   lang-menu dans booking-bridge.js : $DUP_JS (doit être 1)"
DUP_I18N=$(grep -c 'MutationObserver' js/i18n.js || echo 0)
echo "   MutationObserver dans i18n.js    : $DUP_I18N (doit être 1)"

echo ""
echo "   ─── Image logo-symbole.png ───"
if [ -f "images/logo-symbole.png" ]; then
    echo "   ✅ images/logo-symbole.png existe"
else
    echo "   ⚠️  images/logo-symbole.png MANQUANT — le logo décoratif ne s'affichera pas"
fi

echo ""
echo "================================================================"
echo "✅ TERMINÉ — Résolution complète"
echo "💾 Sauvegarde : $BACKUP"
echo ""
echo "📌 PROCHAINES ÉTAPES :"
echo "   1. Vérifie que images/logo-symbole.png est bien présent"
echo "   2. Fais Ctrl + F5 (vider le cache) dans le navigateur"
echo "   3. Teste :"
echo "      • Change la langue → les textes doivent changer"
echo "      • Clique FR · XOF ▾ dans le footer → menu doit s'ouvrir"
echo "      • Regarde le footer → 4 badges paiement visibles"
echo "      • Regarde en bas à droite du footer → logo symbole en transparence"
echo "================================================================"
