/* ============================================================= */
/* RESERVATION-FORMS.JS — Tunnel multi-contexte (v3)             */
/* Gère : SPA · RESTO · ÉVÉNEMENT                                */
/* Parcours : Formulaire → Récapitulatif → Confirmation          */
/* ============================================================= */
(function () {
    'use strict';

    var SPA_LABELS = {
        'journee-bien-etre': 'Journée Bien-être complète',
        'massage':           'Massage relaxant 50 min',
        'yoga':              'Yoga & Méditation',
        'hammam':            'Hammam & Sauna',
        'piscine':           'Accès Piscine journée'
    };
    var SPA_PRICES = {
        'journee-bien-etre': 75000,
        'massage':           45000,
        'yoga':              25000,
        'hammam':            30000,
        'piscine':           20000
    };
    var RESTO_LABELS = {
        'lounge': 'Teranga Lounge',
        'beach':  'Teranga Beach Club',
        'brunch': 'Brunch du dimanche'
    };
    var EVT_LABELS = {
        'devis':      'Demande de devis',
        'seminaire':  'Séminaire',
        'conference': 'Conférence',
        'mariage':    'Mariage',
        'cocktail':   'Cocktail / Réception',
        'autre':      'Autre'
    };

    function esc(s) {
        return String(s == null ? '' : s)
            .replace(/&/g, '&amp;').replace(/</g, '&lt;')
            .replace(/>/g, '&gt;').replace(/"/g, '&quot;');
    }
    function fmt(n) {
        if (n == null || isNaN(n)) return '—';
        return Number(n).toLocaleString('fr-FR').replace(/,/g, ' ') + ' FCFA';
    }
    function fmtDate(str) {
        if (!str) return '—';
        var d = new Date(str);
        if (isNaN(d)) return str;
        return d.toLocaleDateString('fr-FR', { day: '2-digit', month: 'short', year: 'numeric' });
    }
    function refFor(ctxType) {
        var prefix = ctxType === 'spa'   ? 'SPA'
                   : ctxType === 'resto' ? 'RST'
                   : ctxType === 'evt'   ? 'EVT'
                   : 'RES';
        return prefix + '-' + Date.now().toString().slice(-6);
    }
    function val(form, sel) { var el = form.querySelector(sel); return el ? el.value : ''; }
    function textInputs(form) { return form.querySelectorAll('input[type="text"]'); }

    function extractData(ctxType, form) {
        var d = {};
        if (ctxType === 'spa') {
            d.soin    = val(form, '#spaSoinSelect');
            d.date    = val(form, '#spaDateSelect');
            d.heure   = val(form, '#spaHeureSelect');
            var t = textInputs(form);
            d.prenom  = t[0] ? t[0].value : '';
            d.nom     = t[1] ? t[1].value : '';
            d.email   = val(form, 'input[type="email"]');
            d.tel     = val(form, 'input[type="tel"]');
            d.message = val(form, 'textarea');
        } else if (ctxType === 'resto') {
            d.venue    = val(form, '#restoVenueSelect');
            d.date     = val(form, 'input[type="date"]');
            d.heure    = val(form, 'input[type="time"]');
            var sel    = form.querySelectorAll('select');
            d.couverts = sel[1] ? sel[1].value : '2';
            d.nom      = val(form, 'input[type="text"]');
            d.tel      = val(form, 'input[type="tel"]');
            d.message  = val(form, 'textarea');
        } else if (ctxType === 'evt') {
            d.evtType      = val(form, '#evtTypeSelect');
            var tx         = textInputs(form);
            d.nom          = tx[0] ? tx[0].value : '';
            d.societe      = tx[1] ? tx[1].value : '';
            d.email        = val(form, 'input[type="email"]');
            d.tel          = val(form, 'input[type="tel"]');
            d.participants = val(form, 'input[type="number"]');
            d.date         = val(form, 'input[type="date"]');
            d.message      = val(form, 'textarea');
        }
        return d;
    }

    function buildRecapCards(ctxType, data) {
        var cards = [];
        if (ctxType === 'spa') {
            cards.push({ title: 'Votre soin', lines: [
                ['Type',    SPA_LABELS[data.soin] || data.soin || '—'],
                ['Date',    fmtDate(data.date)],
                ['Créneau', data.heure || '—']
            ]});
            cards.push({ title: 'Vos coordonnées', lines: [
                ['Nom',       ((data.prenom || '') + ' ' + (data.nom || '')).trim() || '—'],
                ['E-mail',    data.email || '—'],
                ['Téléphone', data.tel || '—']
            ]});
            if (data.message) cards.push({ title: 'Demandes particulières', lines: [['', data.message]] });
            cards.push({ total: {
                label:  'TOTAL ESTIMÉ',
                amount: fmt(SPA_PRICES[data.soin] || 0),
                note:   'Paiement sur place · Confirmation par e-mail sous 24h.'
            }});
        } else if (ctxType === 'resto') {
            cards.push({ title: 'Votre table', lines: [
                ['Restaurant', RESTO_LABELS[data.venue] || data.venue || '—'],
                ['Date',       fmtDate(data.date)],
                ['Heure',      data.heure || '—'],
                ['Couverts',   (data.couverts || '2') + ' personne' + (data.couverts === '1' ? '' : 's')]
            ]});
            cards.push({ title: 'Vos coordonnées', lines: [
                ['Nom',       data.nom || '—'],
                ['Téléphone', data.tel || '—']
            ]});
            if (data.message) cards.push({ title: 'Demandes particulières', lines: [['', data.message]] });
            cards.push({ total: {
                label:  'RÉSERVATION',
                amount: 'Sur place',
                note:   'Aucun paiement en ligne · Confirmation par téléphone sous 2h.'
            }});
        } else if (ctxType === 'evt') {
            cards.push({ title: 'Votre événement', lines: [
                ['Type',         EVT_LABELS[data.evtType] || data.evtType || '—'],
                ['Date',         fmtDate(data.date)],
                ['Participants', data.participants ? (data.participants + ' personne' + (data.participants === '1' ? '' : 's')) : '—']
            ]});
            cards.push({ title: 'Vos coordonnées', lines: [
                ['Nom',       data.nom || '—'],
                ['Société',   data.societe || '—'],
                ['E-mail',    data.email || '—'],
                ['Téléphone', data.tel || '—']
            ]});
            if (data.message) cards.push({ title: 'Votre projet', lines: [['', data.message]] });
            cards.push({ total: {
                label:  'DEVIS',
                amount: 'Sur mesure',
                note:   'Notre équipe vous recontacte sous 24h ouvrées avec une proposition détaillée.'
            }});
        }
        return cards;
    }

    function renderCards(cards) {
        return cards.map(function (c) {
            if (c.total) {
                return '<div class="card ctx-recap-total">' +
                    '<div class="price-total">' +
                        '<span class="lbl">' + esc(c.total.label) + '</span>' +
                        '<span class="amt">' + esc(c.total.amount) + '</span>' +
                    '</div>' +
                    '<p class="ctx-recap-note">' + esc(c.total.note) + '</p>' +
                '</div>';
            }
            var body = c.lines.map(function (l) {
                var key = l[0] ? '<span>' + esc(l[0]) + '</span>' : '<span></span>';
                return '<div class="recap-line">' + key + '<b>' + esc(l[1]) + '</b></div>';
            }).join('');
            return '<div class="card"><h3>' + esc(c.title) + '</h3>' + body + '</div>';
        }).join('');
    }

    function showRecap(ctxType, panel, data) {
        var old = panel.querySelector('.ctx-recap-wrap');
        if (old) old.remove();
        var formWrap = panel.querySelector('.form-wrap');
        if (formWrap) formWrap.style.display = 'none';

        var cardsHtml = renderCards(buildRecapCards(ctxType, data));

        var html =
            '<div class="res-inner ctx-recap-wrap">' +
                '<div class="form-wrap" style="max-width:760px;">' +
                    '<h2>Récapitulatif de votre demande</h2>' +
                    '<p class="sub">Vérifiez les informations avant de confirmer.</p>' +
                    '<div class="ctx-recap-grid">' + cardsHtml + '</div>' +
                    '<div class="form-actions" style="margin-top:26px;">' +
                        '<button type="button" class="btn-back ctx-recap-modify">← Modifier</button>' +
                        '<button type="button" class="btn-next ctx-recap-confirm">Confirmer la demande →</button>' +
                    '</div>' +
                    '<div class="reassure" style="margin-top:18px;">' +
                        '<span>✓ Réponse sous 24h</span>' +
                        '<span>✓ Sans engagement</span>' +
                        '<span>✓ Données sécurisées</span>' +
                    '</div>' +
                '</div>' +
            '</div>';

        var wrapper = document.createElement('div');
        wrapper.innerHTML = html;
        var node = wrapper.firstChild;
        panel.appendChild(node);

        node.querySelector('.ctx-recap-modify').addEventListener('click', function () {
            node.remove();
            if (formWrap) formWrap.style.display = '';
        });
        node.querySelector('.ctx-recap-confirm').addEventListener('click', function () {
            node.remove();
            showConfirmation(ctxType, panel, data);
        });

        window.scrollTo({ top: 0, behavior: 'smooth' });
    }

    function showConfirmation(ctxType, panel, data) {
        var ref = refFor(ctxType);
        var cardsHtml = renderCards(buildRecapCards(ctxType, data));

        var titles = {
            spa:   'Demande de soin envoyée',
            resto: 'Demande de table envoyée',
            evt:   'Demande de devis envoyée'
        };
        var subtitles = {
            spa:   "Un e-mail de confirmation vous sera adressé sous 24h.",
            resto: "Notre équipe vous rappellera sous 2h pour confirmer votre réservation.",
            evt:   "Notre équipe événementielle vous recontactera sous 24h ouvrées."
        };

        var html =
            '<div class="res-inner ctx-confirm-wrap">' +
                '<div class="confirm-wrap">' +
                    '<div class="confirm-icon">✓</div>' +
                    '<h2>' + esc(titles[ctxType] || 'Demande envoyée') + '</h2>' +
                    '<p>' + esc(subtitles[ctxType] || '') + '</p>' +
                    '<div class="conf-num">Numéro de référence<span>' + esc(ref) + '</span></div>' +
                    '<div class="ctx-recap-grid" style="text-align:left;">' + cardsHtml + '</div>' +
                    '<div class="conf-actions" style="margin-top:26px;">' +
                        '<a href="index.html" class="primary">' +
                            '<i class="fa-solid fa-house"></i> Retour à l\'accueil' +
                        '</a>' +
                        '<a href="reservation.html">' +
                            '<i class="fa-regular fa-calendar"></i> Réserver une chambre' +
                        '</a>' +
                    '</div>' +
                '</div>' +
            '</div>';

        var wrapper = document.createElement('div');
        wrapper.innerHTML = html;
        panel.appendChild(wrapper.firstChild);

        window.scrollTo({ top: 0, behavior: 'smooth' });
    }

    window.ctxSubmit = function (event, ctxType) {
        event.preventDefault();
        var form = event.target;
        if (!form.checkValidity()) {
            form.reportValidity();
            return false;
        }
        var panel = form.closest('.ctx-panel');
        if (!panel) {
            console.warn('[ctxSubmit] .ctx-panel introuvable pour', ctxType);
            return false;
        }
        var data = extractData(ctxType, form);
        showRecap(ctxType, panel, data);
        return false;
    };
})();
