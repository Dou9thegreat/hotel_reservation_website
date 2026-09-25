/* ============================================================= */
/* EXTRAS.JS — Version stable et unique                          */
/* ============================================================= */
(function () {
    'use strict';

    /* ---------- CATALOGUE ---------- */
    var EXTRAS = [
        { id: 'spa-massage', cat: 'spa', name: 'Massage relaxant 50 min',
          desc: 'Massage aux huiles essentielles ou pierres chaudes',
          price: 45000, image: 'images/massage3.jpg', popular: true },

        { id: 'spa-hammam', cat: 'spa', name: 'Hammam et Sauna',
          desc: 'Acces libre au hammam traditionnel et au sauna',
          price: 30000, image: 'images/Hamman.jpg' },

        { id: 'spa-journee', cat: 'spa', name: 'Journee Bien-etre complete',
          desc: 'Piscine + hammam + sauna + massage + dejeuner',
          price: 75000, image: 'images/piscine.jpg' },

        { id: 'resto-brunch', cat: 'resto', name: 'Brunch du dimanche',
          desc: 'Buffet sale et sucre a volonte, musique live',
          price: 35000, image: 'images/resto-brunch.jpg', popular: true },

        { id: 'resto-diner', cat: 'resto', name: 'Diner au Teranga Lounge',
          desc: 'Menu 3 services pour 2 personnes',
          price: 120000, image: 'images/resto-chef-sow.jpg' },

        { id: 'resto-beach', cat: 'resto', name: 'Dejeuner Beach Club',
          desc: 'Poisson grille au feu de bois pour 2 personnes',
          price: 80000, image: 'images/resto-feu-bois.jpg', popular: true },

        { id: 'bar-cocktail', cat: 'bar', name: 'Cocktail Sunset Bar',
          desc: 'Cocktail signature face au coucher de soleil',
          price: 15000, image: 'images/resto-bar-nuit.jpg' },

        { id: 'bar-champagne', cat: 'bar', name: 'Bouteille de champagne',
          desc: 'Champagne brut en chambre ou au bar',
          price: 75000, image: 'images/resto-bar-nuit.jpg', popular: true },

        { id: 'svc-late', cat: 'service', name: 'Late check-out (16h)',
          desc: 'Profitez de votre chambre jusqu\'a 16h',
          price: 25000, image: 'images/room-deluxe.png' },

        { id: 'svc-transfer', cat: 'service', name: 'Transfert aeroport AIBD',
          desc: 'Navette privee aller-retour',
          price: 48000, image: 'images/hero.png' },

        { id: 'svc-breakfast', cat: 'service', name: 'Petit-dejeuner en chambre',
          desc: 'Petit-dejeuner servi dans votre chambre',
          price: 20000, image: 'images/resto-brunch.jpg' }
    ];

    var BANNERS = {
        spa:     { image: 'images/piscine.jpg',        title: 'Spa & Bien-etre',  subtitle: 'Ressourcez-vous face a l\'Atlantique' },
        resto:   { image: 'images/resto-feu-bois.jpg', title: 'Restaurants',      subtitle: 'Une gastronomie signee par nos chefs' },
        bar:     { image: 'images/resto-bar-nuit.jpg', title: 'Bars & Cocktails', subtitle: 'L\'art du cocktail au coucher du soleil' },
        service: { image: 'images/ocean.jpg',          title: 'Services',         subtitle: 'Tout pour un sejour sans souci' }
    };

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

    function renderQuickGrid() {
        var grid = document.getElementById('exbQuickGrid');
        if (!grid) return;
        var popular = EXTRAS.filter(function (e) { return e.popular; }).slice(0, 4);
        grid.innerHTML = popular.map(function (e) {
            var active = isSelected(e.id) ? ' is-active' : '';
            return '<button type="button" class="exb-quick' + active + '" data-quick-id="' + e.id + '">' +
                '<span class="exb-quick-thumb" style="background-image:url(\'' + e.image + '\');"></span>' +
                '<span class="exb-quick-info">' +
                    '<span class="exb-quick-name">' + e.name + '</span>' +
                    '<span class="exb-quick-price">+' + fmt(e.price) + '</span>' +
                '</span>' +
            '</button>';
        }).join('');

        grid.querySelectorAll('.exb-quick').forEach(function (btn) {
            btn.addEventListener('click', function () {
                toggle(btn.getAttribute('data-quick-id'));
                renderQuickGrid();
                renderList();
                renderSelectionPanel();
                updateSubtotal();
            });
        });
    }

    var currentTab = 'all';

    function renderBanner(cat) {
        var banner = document.getElementById('exbCategoryBanner');
        if (!banner) return;
        if (cat === 'all' || !BANNERS[cat]) {
            banner.style.display = 'none';
            return;
        }
        var b = BANNERS[cat];
        banner.style.display = 'block';
        banner.style.backgroundImage =
            'linear-gradient(180deg, rgba(13,40,52,.15) 0%, rgba(13,40,52,.75) 100%), url(' + b.image + ')';
        banner.querySelector('.exb-banner-title').textContent = b.title;
        banner.querySelector('.exb-banner-subtitle').textContent = b.subtitle;
    }

    function renderList() {
        var list = document.getElementById('exbList');
        if (!list) return;
        var items = EXTRAS.filter(function (e) { return currentTab === 'all' || e.cat === currentTab; });
        renderBanner(currentTab);

        list.innerHTML = items.map(function (e) {
            var sel = isSelected(e.id) ? ' is-selected' : '';
            return '<div class="exb-card' + sel + '" data-extra-id="' + e.id + '">' +
                '<div class="exb-card-image" style="background-image:url(\'' + e.image + '\');"></div>' +
                '<div class="exb-card-body">' +
                    '<span class="exb-card-name">' + e.name + '</span>' +
                    '<span class="exb-card-desc">' + e.desc + '</span>' +
                    '<span class="exb-card-price">+' + fmt(e.price) + '</span>' +
                '</div>' +
                '<span class="exb-card-check"><i class="fa-solid fa-check"></i></span>' +
            '</div>';
        }).join('');

        list.querySelectorAll('.exb-card').forEach(function (el) {
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
        document.querySelectorAll('.exb-tab').forEach(function (tab) {
            tab.addEventListener('click', function () {
                document.querySelectorAll('.exb-tab').forEach(function (t) { t.classList.remove('active'); });
                tab.classList.add('active');
                currentTab = tab.getAttribute('data-cat');
                renderList();
            });
        });
    }

    function updateSubtotal() {
        var el = document.getElementById('exbSubtotal');
        if (el) el.textContent = fmt(subtotal());
    }

    function openModal() {
        var modal = document.getElementById('exbModal');
        if (!modal) return;
        renderList();
        updateSubtotal();
        modal.classList.add('is-open');
        modal.setAttribute('aria-hidden', 'false');
        document.body.style.overflow = 'hidden';
    }
    function closeModal() {
        var modal = document.getElementById('exbModal');
        if (!modal) return;
        modal.classList.remove('is-open');
        modal.setAttribute('aria-hidden', 'true');
        document.body.style.overflow = '';
    }

    function renderSelectionPanel() {
        var selContent = document.getElementById('selContent');
        if (!selContent) return;
        var old = selContent.querySelector('.exb-sel-list');
        if (old) old.remove();
        if (selectedIds.length === 0) return;

        var html = '<div class="exb-sel-list">' +
            '<h4>Extras selectionnes</h4>' +
            selectedIds.map(function (id) {
                var e = getExtra(id);
                if (!e) return '';
                return '<div class="exb-sel-line">' +
                    '<span><i class="fa-solid fa-check"></i>' + e.name + '</span>' +
                    '<b>' + fmt(e.price) + '</b>' +
                    '<button type="button" class="exb-sel-remove" data-remove-id="' + id + '" aria-label="Retirer">' +
                        '<i class="fa-solid fa-xmark"></i>' +
                    '</button>' +
                '</div>';
            }).join('') +
        '</div>';

        selContent.insertAdjacentHTML('beforeend', html);

        selContent.querySelectorAll('.exb-sel-remove').forEach(function (btn) {
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

    function updateBannerVisibility() {
        var banner = document.getElementById('exbBanner');
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

    document.addEventListener('DOMContentLoaded', function () {
        var openBtn = document.getElementById('exbOpenModal');
        if (openBtn) openBtn.addEventListener('click', openModal);

        var closeBtn = document.getElementById('exbModalClose');
        var cancelBtn = document.getElementById('exbCancel');
        var confirmBtn = document.getElementById('exbConfirm');
        var overlay = document.getElementById('exbModal');

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

    window.Extras = {
        refreshSelectionPanel: function () { renderSelectionPanel(); },

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
