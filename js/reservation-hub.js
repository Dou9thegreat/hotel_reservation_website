/* ============================================================= */
/* RESERVATION-HUB.JS — Moteur central (v2 corrige)              */
/* ============================================================= */
(function () {
    'use strict';

    var CONTEXTS = {
        'chambre-classique':   { type: 'room',  icon: 'fa-bed',               label: 'Chambre Classique' },
        'chambre-deluxe':      { type: 'room',  icon: 'fa-bed',               label: 'Chambre Deluxe Vue Ocean' },
        'chambre-superieure':  { type: 'room',  icon: 'fa-bed',               label: 'Chambre Superieure' },
        'suite-ambassadeur':   { type: 'room',  icon: 'fa-crown',             label: 'Suite Ambassadeur Pullman' },

        'spa':                 { type: 'spa',   icon: 'fa-spa',               label: 'Soin Spa',              soin: 'massage' },
        'journee-bien-etre':   { type: 'spa',   icon: 'fa-spa',               label: 'Journee Bien-etre',     soin: 'journee-bien-etre' },
        'massage':             { type: 'spa',   icon: 'fa-hand-sparkles',     label: 'Massage relaxant',      soin: 'massage' },
        'yoga':                { type: 'spa',   icon: 'fa-om',                label: 'Yoga et Meditation',    soin: 'yoga' },
        'hammam':              { type: 'spa',   icon: 'fa-hot-tub-person',    label: 'Hammam et Sauna',       soin: 'hammam' },
        'piscine':             { type: 'spa',   icon: 'fa-water-ladder',      label: 'Acces Piscine',         soin: 'piscine' },

        'restaurant-lounge':   { type: 'resto', icon: 'fa-champagne-glasses', label: 'Teranga Lounge',        venue: 'lounge' },
        'restaurant-beach':    { type: 'resto', icon: 'fa-fire',              label: 'Teranga Beach Club',    venue: 'beach' },
        'brunch':              { type: 'resto', icon: 'fa-utensils',          label: 'Brunch du dimanche',    venue: 'brunch' },

        'evt-devis':           { type: 'evt',   icon: 'fa-calendar-check',    label: 'Devis evenement',       evtType: '' },
        'evt-seminaire':       { type: 'evt',   icon: 'fa-briefcase',         label: 'Seminaire',             evtType: 'seminaire' },
        'evt-conference':      { type: 'evt',   icon: 'fa-microphone',        label: 'Conference',            evtType: 'conference' },
        'evt-mariage':         { type: 'evt',   icon: 'fa-heart',             label: 'Mariage',               evtType: 'mariage' },
        'evt-cocktail':        { type: 'evt',   icon: 'fa-martini-glass',     label: 'Cocktail / Reception',  evtType: 'cocktail' }
    };

    function detectContext() {
        var p = new URLSearchParams(window.location.search);
        var t = p.get('target');
        if (t && CONTEXTS[t]) return { key: t, cfg: CONTEXTS[t] };

        // Retro-compatibilite : ?room=xxx&tariff=yyy
        var room = p.get('room');
        if (room) {
            var key = 'chambre-' + (
                room.indexOf('deluxe')     !== -1 ? 'deluxe' :
                room.indexOf('suite')      !== -1 ? 'suite-ambassadeur' :
                room.indexOf('superieure') !== -1 ? 'chambre-superieure' :
                room.indexOf('classique')  !== -1 ? 'chambre-classique' : 'deluxe'
            );
            if (CONTEXTS[key]) return { key: key, cfg: CONTEXTS[key], room: room, tariff: p.get('tariff') || 0 };
        }

        // ?spa=xxx
        var spa = p.get('spa');
        if (spa && CONTEXTS[spa]) return { key: spa, cfg: CONTEXTS[spa] };

        // ?venue=xxx
        var venue = p.get('venue');
        if (venue) {
            if (venue === 'lounge') return { key: 'restaurant-lounge', cfg: CONTEXTS['restaurant-lounge'] };
            if (venue === 'beach')  return { key: 'restaurant-beach',  cfg: CONTEXTS['restaurant-beach'] };
            if (venue === 'brunch') return { key: 'brunch',            cfg: CONTEXTS['brunch'] };
        }

        // ?evt=xxx
        var evt = p.get('evt');
        if (evt && CONTEXTS['evt-' + evt]) return { key: 'evt-' + evt, cfg: CONTEXTS['evt-' + evt] };

        return null;
    }

    function showPanel(type) {
        // Masquer tous les panels
        document.querySelectorAll('.ctx-panel').forEach(function (el) {
            el.style.display = 'none';
        });
        // Afficher le panel cible
        var target = document.getElementById('ctx-' + type);
        if (target) target.style.display = 'block';
        // Masquer le systeme d'etapes pour les contextes non-room
        var steps = document.querySelector('.steps');
        if (steps) {
            if (type === 'room') steps.style.display = '';
            else steps.style.display = 'none';
        }
    }

    function prefill(ctx) {
        var cfg = ctx.cfg;

        // Champs caches
        var hiddenType = document.getElementById('hiddenResType');
        if (hiddenType) hiddenType.value = cfg.type;

        // SPA
        if (cfg.type === 'spa' && cfg.soin) {
            var sel = document.getElementById('spaSoinSelect');
            if (sel) { sel.value = cfg.soin; }
        }

        // RESTO
        if (cfg.type === 'resto' && cfg.venue) {
            var sel2 = document.getElementById('restoVenueSelect');
            if (sel2) { sel2.value = cfg.venue; }
        }

        // EVT
        if (cfg.type === 'evt' && cfg.evtType) {
            var sel3 = document.getElementById('evtTypeSelect');
            if (sel3) { sel3.value = cfg.evtType; }
        }

        // ROOM - Dates
        if (cfg.type === 'room') {
            var params = new URLSearchParams(window.location.search);
            if (params.get('checkin'))  { var dA = document.getElementById('dArrivee'); if (dA) dA.value = params.get('checkin'); }
            if (params.get('checkout')) { var dD = document.getElementById('dDepart');  if (dD) dD.value = params.get('checkout'); }
        }
    }

    function scrollAndHighlight(type) {
        var panel = document.getElementById('ctx-' + type);
        if (!panel) return;
        setTimeout(function () {
            var header = document.querySelector('.site-header');
            var offset = header ? header.offsetHeight + 30 : 120;
            var top = panel.getBoundingClientRect().top + window.pageYOffset - offset;
            window.scrollTo({ top: top, behavior: 'smooth' });
            panel.classList.add('ctx-panel--highlight');
            setTimeout(function () { panel.classList.remove('ctx-panel--highlight'); }, 3500);
        }, 300);
    }

    function showBanner(cfg) {
        var banner = document.getElementById('ctxBanner');
        if (!banner) {
            banner = document.createElement('div');
            banner.id = 'ctxBanner';
            banner.className = 'ctx-banner';
            banner.innerHTML = '<i class="fa-solid fa-circle-info"></i> <span></span>';
            document.body.appendChild(banner);
        }
        banner.querySelector('i').className = 'fa-solid ' + (cfg.icon || 'fa-circle-info');
        banner.querySelector('span').textContent = 'Vous reservez : ' + cfg.label;
        banner.classList.add('is-visible');
    }

    document.addEventListener('DOMContentLoaded', function () {
        var ctx = detectContext();
        if (!ctx) return; // page normale, on ne touche a rien
        console.log('[ReservationHub] Contexte :', ctx.key);
        showPanel(ctx.cfg.type);
        prefill(ctx);
        showBanner(ctx.cfg);
        scrollAndHighlight(ctx.cfg.type);
    });

    window.ReservationHub = { contexts: CONTEXTS, detect: detectContext };
})();
