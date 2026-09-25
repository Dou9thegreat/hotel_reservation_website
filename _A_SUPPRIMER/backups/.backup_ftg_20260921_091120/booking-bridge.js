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
