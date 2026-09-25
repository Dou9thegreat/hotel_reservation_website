/* ============================================================= */
/* MOBILE-NAV.JS v2 — Menu plein écran + header transparent      */
/* ============================================================= */
(function () {
    'use strict';

    function injectTrigger() {
        var mainbar = document.querySelector('.site-header .mainbar');
        if (!mainbar || mainbar.querySelector('.rp-menu-trigger')) return;
        var btn = document.createElement('button');
        btn.type = 'button';
        btn.className = 'rp-menu-trigger';
        btn.setAttribute('aria-label', 'Ouvrir le menu');
        btn.setAttribute('aria-expanded', 'false');
        btn.innerHTML = '<span></span><span></span><span></span>';
        mainbar.appendChild(btn);
    }

    function injectFullscreenMenu() {
        if (document.querySelector('.rp-fullscreen-menu')) return;
        var menu = document.createElement('div');
        menu.className = 'rp-fullscreen-menu';
        menu.setAttribute('aria-hidden', 'true');
        menu.setAttribute('role', 'dialog');
        menu.setAttribute('aria-modal', 'true');
        menu.setAttribute('aria-label', 'Menu principal');

        var path = window.location.pathname.split('/').pop() || 'index.html';
        function active(p) { return path === p ? ' active' : ''; }

        menu.innerHTML =
            '<a href="index.html" class="rp-nav-link' + active('index.html') + '">Accueil</a>' +
            '<a href="chambres.html" class="rp-nav-link' + active('chambres.html') + '">Chambres</a>' +
            '<a href="experiences.html" class="rp-nav-link' + active('experiences.html') + '">Expériences</a>' +
            '<div class="rp-submenu">' +
                '<a href="experiences-piscine.html">— Piscine + Spa</a>' +
                '<a href="experiences-restaurant.html">— Restaurants + Bars</a>' +
            '</div>' +
            '<a href="galerie.html" class="rp-nav-link' + active('galerie.html') + '">Galerie</a>' +
            '<a href="evenements.html" class="rp-nav-link' + active('evenements.html') + '">Meeting & Events</a>' +
            '<a href="contact.html" class="rp-nav-link' + active('contact.html') + '">Contact</a>' +
            '<div class="rp-menu-footer">' +
                '<a href="reservation.html" class="rp-menu-cta">Réserver maintenant</a>' +
                '<div class="rp-menu-contact">' +
                    '+221 33 869 66 66<br>' +
                    '<a href="mailto:HB076@accor.com">HB076@accor.com</a>' +
                '</div>' +
            '</div>';

        document.body.appendChild(menu);
    }

    function openMenu() {
        var menu = document.querySelector('.rp-fullscreen-menu');
        var trigger = document.querySelector('.rp-menu-trigger');
        if (!menu) return;
        menu.classList.add('is-open');
        menu.setAttribute('aria-hidden', 'false');
        if (trigger) {
            trigger.classList.add('is-open');
            trigger.setAttribute('aria-expanded', 'true');
        }
        document.body.classList.add('rp-menu-open');
    }

    function closeMenu() {
        var menu = document.querySelector('.rp-fullscreen-menu');
        var trigger = document.querySelector('.rp-menu-trigger');
        if (!menu) return;
        menu.classList.remove('is-open');
        menu.setAttribute('aria-hidden', 'true');
        if (trigger) {
            trigger.classList.remove('is-open');
            trigger.setAttribute('aria-expanded', 'false');
        }
        document.body.classList.remove('rp-menu-open');
    }

    function toggleMenu() {
        var menu = document.querySelector('.rp-fullscreen-menu');
        if (!menu) return;
        if (menu.classList.contains('is-open')) closeMenu();
        else openMenu();
    }

    /* --- Header transparent → solide au scroll --- */
    function bindHeaderScroll() {
        var header = document.querySelector('.site-header');
        if (!header) return;

        function update() {
            if (window.innerWidth > 1024) {
                header.classList.remove('rp-scrolled');
                return;
            }
            if (window.scrollY > 60) {
                header.classList.add('rp-scrolled');
            } else {
                header.classList.remove('rp-scrolled');
            }
        }
        update();
        window.addEventListener('scroll', update, { passive: true });
        window.addEventListener('resize', update);
    }

    function bind() {
        var trigger = document.querySelector('.rp-menu-trigger');
        if (trigger && !trigger.dataset.bound) {
            trigger.dataset.bound = '1';
            trigger.addEventListener('click', function (e) {
                e.preventDefault();
                e.stopPropagation();
                toggleMenu();
            });
        }

        var links = document.querySelectorAll('.rp-fullscreen-menu a');
        for (var i = 0; i < links.length; i++) {
            if (links[i].dataset.bound) continue;
            links[i].dataset.bound = '1';
            links[i].addEventListener('click', function () {
                setTimeout(closeMenu, 150);
            });
        }

        if (!document.body.dataset.escBound) {
            document.body.dataset.escBound = '1';
            document.addEventListener('keydown', function (e) {
                if (e.key === 'Escape') closeMenu();
            });
        }
    }

    function init() {
        injectTrigger();
        injectFullscreenMenu();
        bind();
        bindHeaderScroll();
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }
})();
