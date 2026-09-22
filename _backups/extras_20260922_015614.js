/* ============================================================= */
/* EXTRAS.JS v4 - 7 images seulement, réutilisées par catégorie  */
/* ============================================================= */
(function () {
    'use strict';

    /* ---------- CHEMIN DES IMAGES ---------- */
    var IMG = 'images/extras/';

    /* ---------- IMAGES PAR EXTRA ---------- */
    var IMG_FILES = {
        /* Spa */
        'spa-massage':       IMG + 'thumb-massage.jpg',
        'spa-hammam':        IMG + 'thumb-hammam.jpg',
        'spa-journee':       IMG + 'thumb-journee.jpg',
        /* Resto */
        'resto-brunch':      IMG + 'thumb-brunch.jpg',
        'resto-diner':       IMG + 'thumb-diner.jpg',
        'resto-beach':       IMG + 'thumb-beach.jpg',
        /* Bar */
        'bar-cocktail':      IMG + 'thumb-cocktail.jpg',
        'bar-champagne':     IMG + 'thumb-champagne.jpg',
        /* Services */
        'svc-late':          IMG + 'thumb-late.jpg',
        'svc-transfer':      IMG + 'thumb-transfer.jpg',
        'svc-breakfast':     IMG + 'thumb-breakfast.jpg'
    };

    /* ---------- CATALOGUE ENRICHI ---------- */
    var EXTRAS = [
        /* SPA */
        { id: 'spa-massage', cat: 'spa', icon: 'fa-spa',
          name: 'Massage relaxant 50 min',
          desc: 'Massage aux huiles essentielles ou pierres chaudes',
          price: 45000, image: IMG_FILES['spa-massage'], popular: true },

        { id: 'spa-hammam', cat: 'spa', icon: 'fa-hot-tub-person',
          name: 'Hammam et Sauna',
          desc: 'Acces libre au hammam traditionnel et au sauna',
          price: 30000, image: IMG_FILES['spa-hammam']},

        { id: 'spa-journee', cat: 'spa', icon: 'fa-hand-sparkles',
          name: 'Journee Bien-etre complete',
          desc: 'Piscine + hammam + sauna + massage + dejeuner',
          price: 75000, image: IMG_FILES['spa-journee']},

        /* RESTO */
        { id: 'resto-brunch', cat: 'resto', icon: 'fa-utensils',
          name: 'Brunch du dimanche',
          desc: 'Buffet sale et sucre a volonte, musique live',
          price: 35000, image: IMG_FILES['resto-brunch'], popular: true },

        { id: 'resto-diner', cat: 'resto', icon: 'fa-champagne-glasses',
          name: 'Diner au Teranga Lounge',
          desc: 'Menu 3 services pour 2 personnes',
          price: 120000, image: IMG_FILES['resto-diner']},

        { id: 'resto-beach', cat: 'resto', icon: 'fa-fire',
          name: 'Dejeuner Beach Club',
          desc: 'Poisson grille au feu de bois pour 2 personnes',
          price: 80000, image: IMG_FILES['resto-beach'], popular: true },

        /* BAR */
        { id: 'bar-cocktail', cat: 'bar', icon: 'fa-martini-glass',
          name: 'Cocktail Sunset Bar',
          desc: 'Cocktail signature face au coucher de soleil',
          price: 15000, image: IMG_FILES['bar-cocktail']},

        { id: 'bar-champagne', cat: 'bar', icon: 'fa-wine-bottle',
          name: 'Bouteille de champagne',
          desc: 'Champagne brut en chambre ou au bar',
          price: 75000, image: IMG_FILES['bar-champagne'], popular: true },

        /* SERVICES */
        { id: 'svc-late', cat: 'service', icon: 'fa-clock',
          name: 'Late check-out (16h)',
          desc: 'Profitez de votre chambre jusqu\'a 16h',
          price: 25000, image: IMG_FILES['svc-late']},

        { id: 'svc-transfer', cat: 'service', icon: 'fa-car',
          name: 'Transfert aeroport AIBD',
          desc: 'Navette privee aller-retour',
          price: 48000, image: IMG_FILES['svc-transfer']},

        { id: 'svc-breakfast', cat: 'service', icon: 'fa-mug-hot',
          name: 'Petit-dejeuner en chambre',
          desc: 'Petit-dejeuner servi dans votre chambre',
          price: 20000, image: IMG_FILES['svc-breakfast']}
    ];

    /* ---------- BANNIÈRES (4 images) ---------- */
    var BANNERS = {
        spa:     { image: IMG + 'banner-spa.jpg',     title: 'Spa & Bien-etre',  subtitle: 'Ressourcez-vous face a l\'Atlantique' },
        resto:   { image: IMG + 'banner-resto.jpg',   title: 'Restaurants',      subtitle: 'Une gastronomie signee par nos chefs' },
        bar:     { image: IMG + 'banner-bar.jpg',     title: 'Bars & Cocktails', subtitle: 'L\'art du cocktail au coucher du soleil' },
        service: { image: IMG + 'banner-service.jpg', title: 'Services',         subtitle: 'Tout pour un sejour sans souci' }
    };

    /* ---------- ÉTAT ---------- */
    var STORAGE_KEY = 'pullman_extras_selected';
    var selectedIds = [];
    try {
        var saved = localStorage.getItem(STORAGE_KEY);
        if (saved) selectedIds = JSON.parse(saved);
    } catch (e) { selectedIds = []; }

    function save() {
        try { localStorage.setItem(STORAGE_KEY, JSON.stringify(selectedIds)); } catch (e) {}
        if (typeof window.updateTotalWithExtras === 'function') window.updateTotalWithExtras();
    }

    function fmt(n) { return n.toLocaleString('fr-FR').replace(/,/g, ' ') + ' FCFA'; }
    function getExtra(id) { for (var i = 0; i < EXTRAS.length; i++) if (EXTRAS[i].id === id) return EXTRAS[i]; return null; }
    function isSelected(id) { return selectedIds.indexOf(id) !== -1; }
    function toggle(id) { var i = selectedIds.indexOf(id); if (i === -1) selectedIds.push(id); else selectedIds.splice(i, 1); save(); }
    function removeExtra(id) { var i = selectedIds.indexOf(id); if (i !== -1) { selectedIds.splice(i, 1); save(); } }
    function subtotal() {
        var t = 0;
        for (var i = 0; i < selectedIds.length; i++) { var e = getExtra(selectedIds[i]); if (e) t += e.price; }
        return t;
    }

    /* ---------- BANDEAU : 4 EXTRAS POPULAIRES ---------- */
    function renderQuickGrid() {
        var grid = document.getElementById('extrasQuickGrid');
        if (!grid) return;
        var popular = EXTRAS.filter(function (e) { return e.popular; }).slice(0, 4);
        grid.innerHTML = popular.map(function (e) {
            var active = isSelected(e.id) ? ' is-active' : '';
            return '<button type="button" class="extras-quick' + active + '" data-quick-id="' + e.id + '">' +
                '<span class="extras-quick-thumb" style="background-image:url(\'' + e.image + '\');">' +
                    '<i class="fa-solid ' + e.icon + '"></i>' +
                '</span>' +
                '<span class="extras-quick-info">' +
                    '<span class="extras-quick-name">' + e.name + '</span>' +
                    '<span class="extras-quick-price">+' + fmt(e.price) + '</span>' +
                '</span>' +
            '</button>';
        }).join('');

        grid.querySelectorAll('.extras-quick').forEach(function (btn) {
            btn.addEventListener('click', function () {
                toggle(btn.getAttribute('data-quick-id'));
                renderQuickGrid();
                renderList();
                renderSelectionPanel();
                updateSubtotal();
            });
        });
    }

    /* ---------- MODAL ---------- */
    var currentTab = 'all';

    function renderBanner(cat) {
        var banner = document.getElementById('extrasCategoryBanner');
        if (!banner) return;
        if (cat === 'all' || !BANNERS[cat]) {
            banner.style.display = 'none';
            return;
        }
        var b = BANNERS[cat];
        banner.style.display = 'block';
        banner.style.backgroundImage =
            'linear-gradient(90deg, rgba(13,40,52,.75) 0%, rgba(13,40,52,.35) 100%), url(' + b.image + ')';
        banner.querySelector('.extras-modal-banner-title').textContent = b.title;
        banner.querySelector('.extras-modal-banner-subtitle').textContent = b.subtitle;
    }

    function renderList() {
        var list = document.getElementById('extrasList');
        if (!list) return;
        var items = EXTRAS.filter(function (e) { return currentTab === 'all' || e.cat === currentTab; });

        renderBanner(currentTab);

        list.innerHTML = items.map(function (e) {
            var sel = isSelected(e.id) ? ' is-selected' : '';
            return '<div class="extras-item' + sel + '" data-extra-id="' + e.id + '">' +
                '<div class="extras-item-thumb" style="background-image:url(\'' + e.image + '\');">' +
                    '<i class="fa-solid ' + e.icon + '"></i>' +
                '</div>' +
                '<div class="extras-item-info">' +
                    '<span class="extras-item-name">' + e.name + '</span>' +
                    '<span class="extras-item-desc">' + e.desc + '</span>' +
                '</div>' +
                '<span class="extras-item-price">+' + fmt(e.price) + '</span>' +
                '<span class="extras-item-check"><i class="fa-solid fa-check"></i></span>' +
            '</div>';
        }).join('');

        list.querySelectorAll('.extras-item').forEach(function (el) {
            el.addEventListener('click', function () {
                toggle(el.getAttribute('data-extra-id'));
                renderList();
                renderQuickGrid();
                renderSelectionPanel();
                updateSubtotal();
            });
        });
    }

    function initTabs() {
        document.querySelectorAll('.extras-tab').forEach(function (tab) {
            tab.addEventListener('click', function () {
                document.querySelectorAll('.extras-tab').forEach(function (t) { t.classList.remove('active'); });
                tab.classList.add('active');
                currentTab = tab.getAttribute('data-cat');
                renderList();
            });
        });
    }

    function updateSubtotal() {
        var el = document.getElementById('extrasSubtotal');
        if (el) el.textContent = fmt(subtotal());
    }

    function openModal() {
        var modal = document.getElementById('extrasModal');
        if (!modal) return;
        renderList();
        updateSubtotal();
        modal.classList.add('is-open');
        modal.setAttribute('aria-hidden', 'false');
        document.body.style.overflow = 'hidden';
    }
    function closeModal() {
        var modal = document.getElementById('extrasModal');
        if (!modal) return;
        modal.classList.remove('is-open');
        modal.setAttribute('aria-hidden', 'true');
        document.body.style.overflow = '';
    }

    /* ---------- PANNEAU DE SELECTION ---------- */
    function renderSelectionPanel() {
        var selContent = document.getElementById('selContent');
        if (!selContent) return;
        var old = selContent.querySelector('.sel-extras-list');
        if (old) old.remove();
        if (selectedIds.length === 0) return;

        var html = '<div class="sel-extras-list">' +
            '<h4>Extras selectionnes</h4>' +
            selectedIds.map(function (id) {
                var e = getExtra(id);
                if (!e) return '';
                return '<div class="sel-extra-line">' +
                    '<span><i class="fa-solid fa-check"></i>' + e.name + '</span>' +
                    '<b>' + fmt(e.price) + '</b>' +
                    '<button type="button" class="sel-extra-remove" data-remove-id="' + id + '" aria-label="Retirer">' +
                        '<i class="fa-solid fa-xmark"></i>' +
                    '</button>' +
                '</div>';
            }).join('') +
        '</div>';

        selContent.insertAdjacentHTML('beforeend', html);

        selContent.querySelectorAll('.sel-extra-remove').forEach(function (btn) {
            btn.addEventListener('click', function (e) {
                e.preventDefault();
                e.stopPropagation();
                removeExtra(btn.getAttribute('data-remove-id'));
                renderQuickGrid();
                renderList();
                renderSelectionPanel();
                updateSubtotal();
            });
        });
    }

    /* ---------- BANDEAU : VISIBILITÉ CONDITIONNELLE ---------- */
    function updateBannerVisibility() {
        var banner = document.getElementById('extrasBanner');
        if (!banner) return;
        var step1 = document.getElementById('panel-1');
        var step1Active = step1 && step1.classList.contains('active');
        var roomSelected = document.querySelector('.room-card.selected');
        if (step1Active && roomSelected) banner.style.display = 'block';
        else banner.style.display = 'none';
    }

    function watchStepChanges() {
        var panels = document.querySelectorAll('.step-panel');
        if (panels.length && typeof MutationObserver !== 'undefined') {
            var obs = new MutationObserver(updateBannerVisibility);
            panels.forEach(function (p) { obs.observe(p, { attributes: true, attributeFilter: ['class'] }); });
        }
        var cards = document.querySelectorAll('.room-card');
        if (cards.length && typeof MutationObserver !== 'undefined') {
            var obs2 = new MutationObserver(updateBannerVisibility);
            cards.forEach(function (c) { obs2.observe(c, { attributes: true, attributeFilter: ['class'] }); });
        }
        document.addEventListener('click', function () {
            setTimeout(updateBannerVisibility, 50);
        });
    }

    /* ---------- INIT ---------- */
    document.addEventListener('DOMContentLoaded', function () {
        var openBtn = document.getElementById('extrasOpenModal');
        if (openBtn) openBtn.addEventListener('click', openModal);

        var closeBtn = document.getElementById('extrasModalClose');
        var cancelBtn = document.getElementById('extrasCancel');
        var confirmBtn = document.getElementById('extrasConfirm');
        var overlay = document.getElementById('extrasModal');

        if (closeBtn) closeBtn.addEventListener('click', closeModal);
        if (cancelBtn) cancelBtn.addEventListener('click', closeModal);
        if (confirmBtn) confirmBtn.addEventListener('click', closeModal);
        if (overlay) overlay.addEventListener('click', function (e) { if (e.target === overlay) closeModal(); });
        document.addEventListener('keydown', function (e) { if (e.key === 'Escape') closeModal(); });

        initTabs();
        renderQuickGrid();
        renderSelectionPanel();
        updateSubtotal();
        updateBannerVisibility();
        watchStepChanges();
    });

    /* ---------- API PUBLIQUE ---------- */
    window.Extras = {
        list: EXTRAS,
        getSelected: function () { return selectedIds.slice(); },
        getSubtotal: subtotal,
        getSelectedObjects: function () { return selectedIds.map(getExtra).filter(Boolean); },
        clear: function () {
            selectedIds = [];
            save();
            renderQuickGrid();
            renderList();
            renderSelectionPanel();
            updateSubtotal();
        }
    };

})();
