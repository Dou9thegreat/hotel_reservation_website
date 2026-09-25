#!/bin/bash
# ============================================================
# INSTALLATION COMPLÈTE — Système de réservation interconnecté
# ============================================================
set -e

echo "==========================================="
echo "  Installation du système de réservation"
echo "==========================================="

# ---------- 1) Sauvegarde ----------
BACKUP=".backup_booking_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP"
cp *.html "$BACKUP/" 2>/dev/null || true
[ -d css ] && cp css/*.css "$BACKUP/" 2>/dev/null || true
echo "📦 Sauvegarde → $BACKUP"

# ---------- 2) Créer dossier js/ ----------
mkdir -p js
echo "📁 Dossier js/ prêt"

# ============================================================
# 3) Créer js/booking-bridge.js
# ============================================================
cat > js/booking-bridge.js << 'BRIDGE_EOF'
/* ============================================================= */
/* BOOKING-BRIDGE.JS                                             */
/* Fait le lien entre toutes les pages et reservation.html       */
/* Responsable : Mamadou Diagne (chef de projet)                 */
/* ============================================================= */

(function () {
  'use strict';

  function toISODate(dateObj) {
    if (!dateObj) return '';
    const d = new Date(dateObj);
    if (isNaN(d)) return '';
    return d.getFullYear() + '-' +
           String(d.getMonth() + 1).padStart(2, '0') + '-' +
           String(d.getDate()).padStart(2, '0');
  }

  function getDateISO(inputId) {
    const el = document.getElementById(inputId);
    if (!el) return '';
    if (el._flatpickr && el._flatpickr.selectedDates[0]) {
      return toISODate(el._flatpickr.selectedDates[0]);
    }
    if (el.value) return el.value;
    return '';
  }

  function parseRooms(str) {
    const m = String(str).match(/(\d+)/);
    return m ? parseInt(m[1]) : 1;
  }

  function parseGuests(str) {
    const a = String(str).match(/(\d+)\s*adulte/i);
    const c = String(str).match(/(\d+)\s*enfant/i);
    return {
      adults: a ? parseInt(a[1]) : 2,
      children: c ? parseInt(c[1]) : 0
    };
  }

  window.buildBookingURL = function (params) {
    params = params || {};
    const q = new URLSearchParams();
    if (params.checkin)  q.set('checkin',  params.checkin);
    if (params.checkout) q.set('checkout', params.checkout);
    if (params.rooms)    q.set('rooms',    params.rooms);
    if (params.adults != null)   q.set('adults',   params.adults);
    if (params.children != null) q.set('children', params.children);
    if (params.room)     q.set('room',     params.room);
    if (params.tariff != null)   q.set('tariff',   params.tariff);
    if (params.promo)    q.set('promo',    params.promo);
    const qs = q.toString();
    return 'reservation.html' + (qs ? '?' + qs : '');
  };

  window.goToBooking = function (params) {
    window.location.href = window.buildBookingURL(params);
  };

  function findHeroRoomsSelect() {
    return document.getElementById('heroRooms') ||
           document.querySelector('form.booking-bar .booking-field:nth-child(1) .field-select');
  }

  function findHeroGuestsSelect() {
    return document.getElementById('heroGuests') ||
           document.querySelector('form.booking-bar .booking-field:nth-child(4) .field-select');
  }

  function findCtaField(index) {
    const cta = document.querySelector('.booking-section .booking-widget');
    if (!cta) return null;
    return cta.querySelector('.widget-field:nth-child(' + index + ')');
  }

  document.addEventListener('DOMContentLoaded', function () {

    /* 1) Formulaire hero (index.html) */
    const heroForm = document.querySelector('form.booking-bar');
    if (heroForm) {
      heroForm.addEventListener('submit', function (e) {
        e.preventDefault();
        const roomsEl  = findHeroRoomsSelect();
        const guestsEl = findHeroGuestsSelect();
        const guests = guestsEl ? parseGuests(guestsEl.value) : { adults: 2, children: 0 };
        window.goToBooking({
          checkin:  getDateISO('checkin'),
          checkout: getDateISO('checkout'),
          rooms:    roomsEl ? parseRooms(roomsEl.value) : 1,
          adults:   guests.adults,
          children: guests.children
        });
      });
    }

    /* 2) Bloc CTA (.booking-section) sur toutes les pages */
    const ctaBtn = document.querySelector('.booking-section .btn-submit');
    if (ctaBtn) {
      ctaBtn.addEventListener('click', function (e) {
        e.preventDefault();
        const f3 = findCtaField(3), f4 = findCtaField(4);
        const roomsEl  = f3 && f3.querySelector('select');
        const guestsEl = f4 && f4.querySelector('select');
        const guests = guestsEl ? parseGuests(guestsEl.value) : { adults: 2, children: 0 };
        window.goToBooking({
          checkin:  getDateISO('cta-checkin'),
          checkout: getDateISO('cta-checkout'),
          rooms:    roomsEl ? parseRooms(roomsEl.value) : 1,
          adults:   guests.adults,
          children: guests.children
        });
      });
    }

    /* 3) Boutons "data-book-room" (chambres.html) */
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

    /* 4) Page Réservation : lire les params et pré-remplir */
    const isReservationPage = document.querySelector('.reservation-page');
    if (!isReservationPage) return;

    const params = new URLSearchParams(window.location.search);

    const dArrivee = document.getElementById('dArrivee');
    const dDepart  = document.getElementById('dDepart');
    if (params.get('checkin')  && dArrivee) dArrivee.value = params.get('checkin');
    if (params.get('checkout') && dDepart)  dDepart.value  = params.get('checkout');

    const dChambres  = document.getElementById('dChambres');
    const roomsParam = params.get('rooms');
    if (roomsParam && dChambres) {
      dChambres.value = String(roomsParam);
      if (typeof window.doSearch === 'function') window.doSearch();
    }

    const adults   = parseInt(params.get('adults')   || '0', 10);
    const children = parseInt(params.get('children') || '0', 10);
    if (adults > 0) {
      const dVoy = document.getElementById('dVoy');
      if (dVoy) {
        const target = children === 0
          ? (adults === 1 ? '1 adulte' : adults + ' adultes')
          : (adults + ' adultes, ' + children + ' enfant' + (children > 1 ? 's' : ''));
        Array.from(dVoy.options).forEach(function (opt) {
          if (opt.textContent.trim() === target) opt.selected = true;
        });
      }
    }

    const dCode = document.getElementById('dCode');
    if (params.get('promo') && dCode) dCode.value = params.get('promo');

    const roomId    = params.get('room');
    const tariffIdx = params.get('tariff');
    if (roomId && typeof window.selectTariff === 'function') {
      setTimeout(function () {
        window.selectTariff(roomId, tariffIdx != null ? parseInt(tariffIdx, 10) : 0);
      }, 80);
    }
  });

})();
BRIDGE_EOF
echo "✅ js/booking-bridge.js créé"

# ============================================================
# 4) Créer css/reservation.css
# ============================================================
cat > css/reservation.css << 'CSS_EOF'
/* ============================================================= */
/* RESERVATION.CSS — Styles spécifiques à la page Réservation    */
/* Responsable : Mouhamed Niang                                   */
/* ============================================================= */

.reservation-page {
  --ocean: #155E75;
  --ocean-dark: #0E4A5E;
  --green: #38E28F;
  --green-dark: #28B876;
  --sand: #CBA77A;
  --charcoal: #333F48;
  --black: #1A1A1A;
  --white: #fff;
  --bg: #F7F9FA;
  --line: #E3E8EA;
  --radius: 10px;
}

/* ---------- HERO ---------- */
.reservation-page .hero {
  position: relative;
  height: 230px;
  background: linear-gradient(120deg, rgba(14,74,94,.88), rgba(21,94,117,.55)),
              linear-gradient(120deg, #0c3a49, #1c6a83);
  display: flex;
  align-items: center;
  padding: 0 40px;
  overflow: hidden;
}
.reservation-page .hero .ph { position: absolute; inset: 0; z-index: -1; }
.reservation-page .hero-text { color: #fff; max-width: 640px; }
.reservation-page .hero-text h1 {
  font-size: 1.9rem; margin: 0 0 8px; font-weight: 800; line-height: 1.15; color: #fff;
}
.reservation-page .hero-text p { margin: 0; font-size: .92rem; opacity: .92; line-height: 1.5; color: #fff; }

/* ---------- STEPS ---------- */
.reservation-page .steps {
  background: #fff; border-bottom: 1px solid var(--line); padding: 22px 28px;
}
.reservation-page .steps ol {
  list-style: none; display: flex; max-width: 760px; margin: 0 auto; padding: 0; align-items: center;
}
.reservation-page .steps li {
  flex: 1; display: flex; align-items: center; gap: 10px;
  font-size: .72rem; font-weight: 700; letter-spacing: .4px; color: #9AA7AC;
}
.reservation-page .steps li .n {
  width: 26px; height: 26px; border-radius: 50%; border: 2px solid #D5DEE1;
  display: flex; align-items: center; justify-content: center;
  font-size: .78rem; background: #fff; flex: none;
}
.reservation-page .steps li.done .n { background: var(--green); border-color: var(--green); color: #fff; }
.reservation-page .steps li.current { color: var(--ocean-dark); }
.reservation-page .steps li.current .n { border-color: var(--ocean-dark); color: var(--ocean-dark); }
.reservation-page .steps li:not(:last-child)::after {
  content: ''; flex: 1; height: 2px; background: #D5DEE1; margin: 0 8px;
}
.reservation-page .steps li.done:not(:last-child)::after { background: var(--green); }

/* ---------- CONTENEUR ---------- */
.res-inner { max-width: 1200px; margin: 0 auto; padding: 26px 24px 60px; }
.reservation-page .step-panel { display: none; }
.reservation-page .step-panel.active { display: block; }

/* ---------- SEARCHBAR ---------- */
.reservation-page .searchbar {
  background: #fff; border: 1px solid var(--line); border-radius: var(--radius);
  padding: 16px 18px; display: flex; gap: 0; align-items: stretch;
  box-shadow: 0 6px 18px rgba(21,94,117,.07);
  position: sticky; top: 130px; z-index: 30; flex-wrap: wrap;
}
.reservation-page .sf { padding: 4px 18px; border-right: 1px solid var(--line); flex: 1; min-width: 120px; }
.reservation-page .sf:last-of-type { border-right: none; }
.reservation-page .sf label {
  display: block; font-size: .62rem; font-weight: 700; letter-spacing: .6px;
  color: #8B9AA0; text-transform: uppercase; margin-bottom: 3px;
}
.reservation-page .sf input,
.reservation-page .sf select {
  border: none; font-family: inherit; font-size: .85rem; font-weight: 600;
  color: var(--black); background: transparent; width: 100%; padding: 0;
}
.reservation-page .sf input:focus,
.reservation-page .sf select:focus { outline: 2px solid var(--green); border-radius: 3px; }
.reservation-page .sf-actions { display: flex; align-items: center; padding-left: 16px; gap: 10px; }
.reservation-page .btn-search {
  background: var(--ocean); color: #fff; border: none; border-radius: 6px;
  padding: 12px 26px; font-weight: 700; font-size: .8rem; letter-spacing: .3px; white-space: nowrap;
}
.reservation-page .btn-search:hover { background: var(--ocean-dark); }

/* ---------- CHIPS ---------- */
.reservation-page .chips { display: flex; gap: 10px; margin: 18px 0; flex-wrap: wrap; }
.reservation-page .chip {
  border: 1px solid var(--line); background: #fff; border-radius: 20px;
  padding: 8px 16px; font-size: .76rem; font-weight: 600; color: var(--charcoal);
}
.reservation-page .chip.active { background: var(--ocean); color: #fff; border-color: var(--ocean); }

.reservation-page .avail-count { font-size: .8rem; color: var(--charcoal); font-weight: 600; margin: 26px 0 12px; }
.reservation-page .avail-count b { color: var(--ocean-dark); }
.reservation-page .multi-room-flag {
  background: #FFF7E9; border: 1px solid var(--sand); color: #7A5A1E;
  font-size: .78rem; font-weight: 700; padding: 9px 16px; border-radius: 8px;
  margin-bottom: 16px; display: none;
}

/* ---------- GRID ---------- */
.reservation-page .booking-grid { display: grid; grid-template-columns: 1fr 340px; gap: 26px; align-items: start; }
@media (max-width: 900px) { .reservation-page .booking-grid { grid-template-columns: 1fr; } }

/* ---------- ROOM CARD ---------- */
.reservation-page .room-card {
  background: #fff; border: 1px solid var(--line); border-radius: var(--radius);
  margin-bottom: 20px; overflow: hidden;
  display: grid; grid-template-columns: 280px 1fr; position: relative;
  transition: border-color .15s;
}
.reservation-page .room-card.selected {
  border-color: var(--green); box-shadow: 0 0 0 2px rgba(56,226,143,.35);
}
@media (max-width: 760px) { .reservation-page .room-card { grid-template-columns: 1fr; } }
.reservation-page .room-card .check {
  position: absolute; top: 12px; left: 12px; width: 26px; height: 26px;
  border-radius: 50%; background: var(--green); color: #fff;
  display: none; align-items: center; justify-content: center; font-size: .85rem; z-index: 2;
}
.reservation-page .room-card.selected .check { display: flex; }
.reservation-page .rc-gallery { position: relative; min-height: 200px; }
.reservation-page .rc-gallery .ph { position: absolute; inset: 0; }
.reservation-page .rc-gallery .count {
  position: absolute; bottom: 10px; left: 12px; background: rgba(0,0,0,.55);
  color: #fff; font-size: .68rem; padding: 3px 9px; border-radius: 12px; font-weight: 600;
}
.reservation-page .rc-body { padding: 18px 20px; }
.reservation-page .rc-top { display: flex; justify-content: space-between; gap: 10px; flex-wrap: wrap; }
.reservation-page .rc-name { font-size: 1.08rem; font-weight: 700; color: var(--black); margin: 0 0 4px; }
.reservation-page .rc-tag {
  font-size: .68rem; font-weight: 700; letter-spacing: .5px;
  color: var(--green-dark); text-transform: uppercase;
}
.reservation-page .rc-meta { display: flex; gap: 16px; margin: 10px 0; flex-wrap: wrap; }
.reservation-page .rc-meta span {
  font-size: .75rem; color: #6C7A80; font-weight: 600;
  display: flex; align-items: center; gap: 5px;
}
.reservation-page .rc-desc { font-size: .82rem; color: #5b6a70; line-height: 1.5; margin: 0 0 6px; }
.reservation-page .rc-amenities { display: flex; gap: 14px; margin: 10px 0 4px; flex-wrap: wrap; }
.reservation-page .rc-amenities span { font-size: .68rem; color: #7c8a8f; display: flex; align-items: center; gap: 5px; }
.reservation-page .rc-link {
  font-size: .76rem; font-weight: 700; color: var(--ocean);
  text-decoration: underline; background: none; border: none; padding: 0;
}
.reservation-page .rc-scarcity { font-size: .72rem; font-weight: 700; color: var(--sand); margin: 8px 0 2px; }

/* ---------- TARIFFS ---------- */
.reservation-page .tariffs { border-top: 1px dashed var(--line); margin-top: 14px; padding-top: 12px; }
.reservation-page .tariff-row {
  display: flex; align-items: center; justify-content: space-between;
  gap: 12px; padding: 11px 0; border-bottom: 1px solid #F0F3F4;
}
.reservation-page .tariff-row:last-child { border-bottom: none; }
.reservation-page .tariff-info { flex: 1; }
.reservation-page .tariff-name { font-size: .83rem; font-weight: 700; color: var(--black); }
.reservation-page .tariff-sub { font-size: .72rem; color: #7c8a8f; margin-top: 2px; }
.reservation-page .tariff-price { text-align: right; min-width: 120px; }
.reservation-page .tariff-price .old {
  font-size: .72rem; color: #a7b1b5; text-decoration: line-through; display: block;
}
.reservation-page .tariff-price .amt { font-size: 1rem; font-weight: 800; color: var(--black); }
.reservation-page .tariff-price .unit { font-size: .68rem; color: #7c8a8f; font-weight: 500; }
.reservation-page .btn-select {
  border: 1.5px solid var(--ocean); color: var(--ocean); background: #fff;
  border-radius: 6px; padding: 9px 18px; font-weight: 700; font-size: .76rem;
  white-space: nowrap; min-width: 118px;
}
.reservation-page .btn-select.selected { background: var(--green); border-color: var(--green); color: #fff; }
.reservation-page .btn-select:hover { background: #EAF4F6; }
.reservation-page .btn-select.selected:hover { background: var(--green-dark); }

/* ---------- PANNEAU SÉLECTION ---------- */
.reservation-page .selection-panel {
  background: #fff; border: 1px solid var(--line); border-radius: var(--radius);
  padding: 20px; position: sticky; top: 200px;
  box-shadow: 0 8px 22px rgba(21,94,117,.08);
}
.reservation-page .selection-panel h3 { margin: 0 0 14px; font-size: .9rem; letter-spacing: .3px; color: var(--black); }
.reservation-page .sel-empty {
  font-size: .8rem; color: #8b9aa0; text-align: center; padding: 30px 10px; line-height: 1.5;
}
.reservation-page .sel-room { display: flex; gap: 12px; margin-bottom: 14px; }
.reservation-page .sel-room .ph { width: 70px; height: 60px; border-radius: 6px; flex: none; }
.reservation-page .sel-room-name { font-size: .85rem; font-weight: 700; color: var(--black); }
.reservation-page .sel-room-tariff { font-size: .72rem; color: var(--green-dark); font-weight: 600; margin-top: 2px; }
.reservation-page .sel-meta {
  font-size: .76rem; color: #5b6a70; line-height: 2;
  border-top: 1px solid var(--line); border-bottom: 1px solid var(--line);
  padding: 10px 0; margin: 10px 0;
}
.reservation-page .sel-meta div { display: flex; justify-content: space-between; }
.reservation-page .price-detail div {
  display: flex; justify-content: space-between; font-size: .78rem; color: #5b6a70; padding: 4px 0;
}
.reservation-page .price-detail .sub { font-size: .68rem; color: #9aa7ac; padding-top: 0; margin-top: -3px; }
.reservation-page .price-total {
  display: flex; justify-content: space-between; align-items: baseline;
  border-top: 2px solid var(--black); margin-top: 8px; padding-top: 10px;
}
.reservation-page .price-total .lbl { font-size: .78rem; font-weight: 700; letter-spacing: .3px; }
.reservation-page .price-total .amt { font-size: 1.3rem; font-weight: 800; color: var(--ocean-dark); }
.reservation-page .sel-cancel {
  font-size: .7rem; color: var(--green-dark); font-weight: 600; margin-top: 8px; display: flex; gap: 5px;
}
.reservation-page .btn-continue {
  width: 100%; background: var(--green); color: #fff; border: none;
  border-radius: 6px; padding: 14px; font-weight: 800; font-size: .85rem;
  letter-spacing: .3px; margin-top: 16px;
}
.reservation-page .btn-continue:disabled { background: #CBD5D8; cursor: not-allowed; }
.reservation-page .btn-continue:hover:not(:disabled) { background: var(--green-dark); }
.reservation-page .reassure { display: flex; gap: 16px; margin-top: 14px; flex-wrap: wrap; }
.reservation-page .reassure span {
  font-size: .66rem; color: #7c8a8f; display: flex; align-items: center; gap: 5px; font-weight: 600;
}

/* ---------- FORMULAIRE ---------- */
.reservation-page .form-wrap {
  max-width: 760px; margin: 0 auto; background: #fff;
  border: 1px solid var(--line); border-radius: var(--radius); padding: 30px 34px;
}
.reservation-page .form-wrap h2 { margin: 0 0 4px; font-size: 1.25rem; color: var(--black); }
.reservation-page .form-wrap > p.sub { margin: 0 0 24px; font-size: .82rem; color: #7c8a8f; }
.reservation-page fieldset { border: none; padding: 0; margin: 0 0 22px; }
.reservation-page legend {
  font-size: .78rem; font-weight: 700; color: var(--ocean-dark);
  letter-spacing: .4px; margin-bottom: 12px; padding: 0;
}
.reservation-page .grid2 { display: grid; grid-template-columns: 1fr 1fr; gap: 14px; }
.reservation-page .grid3 { display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 14px; }
@media (max-width: 600px) {
  .reservation-page .grid2, .reservation-page .grid3 { grid-template-columns: 1fr; }
}
.reservation-page .field { margin-bottom: 14px; }
.reservation-page .field label {
  display: block; font-size: .74rem; font-weight: 700;
  color: var(--charcoal); margin-bottom: 6px;
}
.reservation-page .field .req { color: var(--sand); }
.reservation-page .field input,
.reservation-page .field select,
.reservation-page .field textarea {
  width: 100%; border: 1.5px solid var(--line); border-radius: 6px;
  padding: 11px 12px; font-family: inherit; font-size: .85rem;
  color: var(--black); background: #fff;
}
.reservation-page .field input:focus,
.reservation-page .field select:focus,
.reservation-page .field textarea:focus { outline: none; border-color: var(--green); }
.reservation-page .field textarea { resize: vertical; min-height: 80px; }
.reservation-page .tel-group { display: flex; gap: 8px; }
.reservation-page .tel-group select { max-width: 100px; flex: none; }
.reservation-page .checkbox-row {
  display: flex; align-items: flex-start; gap: 9px;
  font-size: .78rem; color: #5b6a70; margin-bottom: 12px; line-height: 1.4;
}
.reservation-page .checkbox-row input { margin-top: 3px; flex: none; }
.reservation-page .form-actions { display: flex; justify-content: space-between; margin-top: 26px; gap: 12px; }
.reservation-page .btn-back {
  background: none; border: 1.5px solid var(--line); border-radius: 6px;
  padding: 13px 26px; font-weight: 700; font-size: .8rem; color: var(--charcoal);
}
.reservation-page .btn-back:hover { border-color: var(--ocean); }
.reservation-page .btn-next {
  background: var(--green); border: none; border-radius: 6px;
  padding: 13px 32px; font-weight: 800; font-size: .85rem; color: #fff;
}
.reservation-page .btn-next:hover { background: var(--green-dark); }

/* ---------- ÉTAPE 3 ---------- */
.reservation-page .recap-grid { display: grid; grid-template-columns: 1fr 340px; gap: 26px; }
@media (max-width: 900px) { .reservation-page .recap-grid { grid-template-columns: 1fr; } }
.reservation-page .card {
  background: #fff; border: 1px solid var(--line); border-radius: var(--radius);
  padding: 24px 26px; margin-bottom: 20px;
}
.reservation-page .card h3 {
  margin: 0 0 14px; font-size: .92rem; color: var(--black);
  display: flex; justify-content: space-between; align-items: center;
}
.reservation-page .card h3 button {
  font-size: .7rem; font-weight: 700; color: var(--ocean);
  background: none; border: none; text-decoration: underline;
}
.reservation-page .recap-line {
  display: flex; justify-content: space-between; font-size: .82rem;
  color: #5b6a70; padding: 6px 0; border-bottom: 1px solid #F0F3F4;
}
.reservation-page .recap-line:last-child { border: none; }
.reservation-page .recap-line b { color: var(--black); }
.reservation-page .pay-options { display: flex; flex-direction: column; gap: 10px; }
.reservation-page .pay-opt {
  border: 1.5px solid var(--line); border-radius: 8px; padding: 13px 16px;
  display: flex; align-items: center; gap: 12px; cursor: pointer;
}
.reservation-page .pay-opt input { accent-color: var(--green); }
.reservation-page .pay-opt .pname { font-weight: 700; font-size: .84rem; color: var(--black); }
.reservation-page .pay-opt .pdesc { font-size: .7rem; color: #8b9aa0; }
.reservation-page .pay-opt.checked { border-color: var(--green); background: #F4FCF8; }
.reservation-page .policy-box {
  background: #F4FAFB; border: 1px solid #D9E7EA; border-radius: 8px;
  padding: 14px 16px; font-size: .78rem; color: #3d5964; line-height: 1.5;
}
.reservation-page .secure-row {
  display: flex; gap: 14px; align-items: center; margin-top: 14px;
  font-size: .68rem; color: #8b9aa0; font-weight: 600;
}

/* ---------- ÉTAPE 4 ---------- */
.reservation-page .confirm-wrap { max-width: 620px; margin: 20px auto; text-align: center; }
.reservation-page .confirm-icon {
  width: 66px; height: 66px; border-radius: 50%; background: var(--green); color: #fff;
  display: flex; align-items: center; justify-content: center;
  font-size: 2rem; margin: 0 auto 18px;
}
.reservation-page .confirm-wrap h2 { margin: 0 0 8px; font-size: 1.5rem; color: var(--black); }
.reservation-page .confirm-wrap > p { color: #5b6a70; font-size: .9rem; margin: 0 0 24px; }
.reservation-page .conf-num {
  background: #F4FAFB; border: 1px dashed var(--ocean); border-radius: 8px;
  padding: 14px; font-size: .8rem; color: var(--ocean-dark); font-weight: 700; margin-bottom: 24px;
}
.reservation-page .conf-num span { display: block; font-size: 1.3rem; letter-spacing: 2px; margin-top: 4px; }
.reservation-page .conf-actions {
  display: flex; gap: 12px; justify-content: center; flex-wrap: wrap; margin-top: 22px;
}
.reservation-page .conf-actions button,
.reservation-page .conf-actions a {
  padding: 12px 22px; border-radius: 6px; font-weight: 700; font-size: .8rem;
  text-decoration: none; border: 1.5px solid var(--line); color: var(--charcoal); background: #fff;
}
.reservation-page .conf-actions .primary { background: var(--ocean); color: #fff; border: none; }

/* ---------- Placeholders ---------- */
.reservation-page .ph {
  background: linear-gradient(135deg, #DCE9EC, #EAF2F4);
  display: flex; align-items: center; justify-content: center;
  color: #7C939A; font-size: .65rem; font-weight: 700; text-align: center;
  letter-spacing: .3px; line-height: 1.4; padding: 6px;
  background-image: repeating-linear-gradient(-45deg, rgba(21,94,117,.06) 0 3px, transparent 3px 10px);
  border-radius: 6px;
}
CSS_EOF
echo "✅ css/reservation.css créé"

# ============================================================
# 5) Insérer <script src="js/booking-bridge.js"> dans les pages
# ============================================================
PAGES="index.html chambres.html contact.html galerie.html evenements.html experiences.html experiences-piscine.html experiences-restaurant.html"

for f in $PAGES; do
  if [ ! -f "$f" ]; then
    echo "⚠️  $f absent, ignoré"
    continue
  fi
  if grep -q 'booking-bridge.js' "$f"; then
    echo "ℹ️  $f — bridge déjà présent"
    continue
  fi
  # Ajouter la ligne avant </body>
  perl -0777 -pe 's|</body>|    <script src="js/booking-bridge.js"></script>\n</body>|' "$f" > "$f.tmp"
  mv "$f.tmp" "$f"
  echo "✅ $f — bridge injecté"
done

echo ""
echo "==========================================="
echo "✅ INSTALLATION TERMINÉE"
echo "💾 Sauvegarde  : $BACKUP"
echo ""
echo "📌 PROCHAINE ÉTAPE :"
echo "   1. Remplace ton reservation.html par le contenu"
echo "      fourni dans la conversation"
echo "   2. Fais Ctrl+F5 dans le navigateur pour tester"
echo "==========================================="
