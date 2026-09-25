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

        /* --- 2.2 CTA bas de page (structure unifiée) --- */
    var ctaBtn = document.querySelector('.booking-section .btn-submit');
    if (ctaBtn) {
      ctaBtn.addEventListener('click', function (e) {
        e.preventDefault();
        var roomsEl   = document.getElementById('cta-chambre');
        var guestsEl  = document.getElementById('cta-hotes');
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

    /* ============================================================
       PARTIE 5 — INITIALISATION FLATPICKR (dates cliquables)
       ============================================================ */
    if (typeof flatpickr !== 'undefined') {
      var fpConfig = {
        locale: 'fr',
        dateFormat: 'd M. Y',
        minDate: 'today',
        disableMobile: true
      };

      /* --- Hero (index.html) --- */
      var heroCheckin  = document.getElementById('checkin');
      var heroCheckout = document.getElementById('checkout');
      if (heroCheckin) {
        flatpickr('#checkin', Object.assign({}, fpConfig, {
          defaultDate: '2026-09-09',
          onChange: function (selectedDates) {
            if (heroCheckout && heroCheckout._flatpickr && selectedDates[0]) {
              heroCheckout._flatpickr.set('minDate', selectedDates[0]);
            }
          }
        }));
      }
      if (heroCheckout) {
        flatpickr('#checkout', Object.assign({}, fpConfig, {
          defaultDate: '2026-09-30',
          minDate: '2026-09-09'
        }));
      }

      /* --- CTA (toutes les pages) --- */
      var ctaCheckin  = document.getElementById('cta-checkin');
      var ctaCheckout = document.getElementById('cta-checkout');
      if (ctaCheckin) {
        flatpickr('#cta-checkin', Object.assign({}, fpConfig, {
          onChange: function (selectedDates) {
            if (ctaCheckout && ctaCheckout._flatpickr && selectedDates[0]) {
              ctaCheckout._flatpickr.set('minDate', selectedDates[0]);
            }
          }
        }));
      }
      if (ctaCheckout) {
        flatpickr('#cta-checkout', fpConfig);
      }
    }
  });

})();
