/* ============================================================= */
/* LANDING-PAGE.JS — Pullman Dakar Teranga (v3 corrigé)          */
/* SVG paths complets (P avec trou) · Durée 4.7s                 */
/* ============================================================= */
(function () {
    'use strict';

    var STORAGE_KEY = 'pullman_landing_seen';
    var DURATION    = 3800;
    var PAUSE       = 900;
    var FORCE       = /[?&]rp_force=1/.test(window.location.search);

    if (!FORCE) {
        try {
            if (sessionStorage.getItem(STORAGE_KEY) === '1') return;
            sessionStorage.setItem(STORAGE_KEY, '1');
        } catch (e) { /* mode privé : on affiche quand même */ }
    }

    var SVG_ORB =
        '<div class="lp-orb-wrap">' +
          '<svg viewBox="0 0 220 220" preserveAspectRatio="xMidYMid meet">' +
            '<circle class="lp-ring-dotted" cx="110" cy="110" r="96" fill="none" stroke="rgba(138,212,173,0.4)" stroke-width="1.4" stroke-dasharray="1 7" stroke-linecap="round"/>' +
            '<g class="lp-ring-arc-a">' +
              '<path d="M110 22 A88 88 0 0 1 194 92" fill="none" stroke="#47B27D" stroke-width="2" stroke-linecap="round" style="filter:drop-shadow(0 0 5px rgba(71,178,125,0.85))"/>' +
              '<circle cx="194" cy="92" r="4" fill="#47B27D" style="filter:drop-shadow(0 0 6px rgba(71,178,125,0.9))"/>' +
            '</g>' +
            '<g class="lp-ring-arc-b">' +
              '<path d="M110 198 A88 88 0 0 1 26 128" fill="none" stroke="#8AD4AD" stroke-width="2" stroke-linecap="round" style="filter:drop-shadow(0 0 5px rgba(138,212,173,0.85))"/>' +
              '<circle cx="26" cy="128" r="3.5" fill="#8AD4AD" style="filter:drop-shadow(0 0 6px rgba(138,212,173,0.9))"/>' +
            '</g>' +
            '<svg x="50" y="50" width="120" height="120" viewBox="746.58 233.91 179.22 179.30">' +
              '<g class="lp-mark-pulse">' +
                '<path d="M858.74,348.44l-8-7.93-60.75,60.14-9.55-6.57,62.31-61.72-8.13-7.86-62.62,62-7.5-8.67,62.27-61.63-8.15-7.87-60.38,59.81c-.57-1-1.12-1.9-1.58-2.83-1.1-2.23-2.12-4.5-3.24-6.72a1.64,1.64,0,0,1,.43-2.2q16.58-16.35,33.1-32.76l23.15-22.91c.21-.21.39-.46.67-.79l-8.13-7.78-53.67,53.16c-.34-1.42-.68-2.59-.88-3.78-.47-2.8-.86-5.62-1.32-8.43a2.65,2.65,0,0,1,.88-2.58q19.14-18.89,38.22-37.85c2.92-2.91,5.68-6,8.5-9l-7.77-7.59L746.9,315.39l-.32-.15c.31-2.27.51-4.55,1-6.79.71-3.53,1.59-7,2.38-10.53a7.53,7.53,0,0,1,2.25-3.82q13-12.78,25.89-25.63a5.78,5.78,0,0,1,.91-.57L771.58,261A90,90,0,0,1,808.35,238l-29.16,29.91L787,275.6c.46-.44,1.07-1,1.65-1.58q19.82-19.65,39.62-39.27a2.61,2.61,0,0,1,1.57-.81c5-.07,9.94,0,14.91,0l.2.41L794.86,283.9l8.49,7.94c2.44-2.55,5.06-5.39,7.8-8.11q15.78-15.74,31.63-31.41c5-5,10.06-9.95,15.06-14.94a1.77,1.77,0,0,1,2.1-.56c2.94,1,5.91,2,8.86,2.93.61.21,1.19.5,2,.86L810.93,300l8.36,8c2.41-2.5,5-5.26,7.64-7.92q24.54-24.35,49.1-48.66c1.61-1.6,3.2-3.22,4.85-4.78.28-.26,1-.49,1.2-.34,3,1.92,6,3.91,9.22,6l-64.41,63.83L835,324l64.75-64.12,7.58,8.55-64.44,63.85,8.05,7.92,62.69-62.11a12.29,12.29,0,0,1,.75,1.15c1.41,2.78,2.77,5.57,4.21,8.33a1.51,1.51,0,0,1-.38,2.07q-10.12,10-20.2,20l-29.86,29.59L860,347.23c-.35.34-.67.7-1.08,1.13,2.71,2.62,5.37,5.2,8.13,7.85l56.07-55.56c.28,1.15.53,2,.69,2.91.57,3.19,1.17,6.38,1.63,9.58a2.45,2.45,0,0,1-.61,1.85q-18.44,18.38-36.93,36.67-5.77,5.73-11.6,11.43a14.73,14.73,0,0,1-1.56,1.17l8.37,8,42.35-41.94.34.15c-.28,2.4-.41,4.82-.87,7.19-.68,3.57-1.53,7.11-2.43,10.64a5.48,5.48,0,0,1-1.4,2.33q-14.45,14.43-29,28.78c-.38.37-.81.68-1.38,1.16L898.7,388A86,86,0,0,1,862,409.19l28.76-28.46-8.1-7.6.19-.43c-.44.41-.9.81-1.32,1.24q-19.15,19-38.27,38a3.9,3.9,0,0,1-3,1.27c-4.57-.1-9.14-.1-13.71-.14l-.19-.49,48.46-48-8.51-7.93a16.86,16.86,0,0,1-1.58,2q-22.5,22.31-45,44.58c-2.12,2.1-4.22,4.22-6.36,6.29-.28.27-.81.59-1.1.5-3.8-1.19-7.57-2.45-11.72-3.81Z"/>' +
              '</g>' +
            '</svg>' +
          '</svg>' +
        '</div>';

    var SVG_WORDMARK =
        '<svg class="lp-wordmark" viewBox="670.34 536.84 331.73 53.31" xmlns="http://www.w3.org/2000/svg">' +
          '<path d="M674.77,569.72V590.1H670.5c0-.49-.1-1-.1-1.55,0-8.92-.07-17.84-.06-26.76,0-6.24,3.23-10.8,9.16-12.74a26.81,26.81,0,0,1,17.16,0c7,2.34,10.51,8.53,8.61,15.1-1.46,5-5.35,7.58-10.1,8.91C688.13,575.06,682.38,574.08,674.77,569.72Zm13.77,1.19a59.67,59.67,0,0,0,6.28-1.46,8.94,8.94,0,0,0,.48-17,18.74,18.74,0,0,0-13.78-.25,11.13,11.13,0,0,0-3.46,2.12c-5,4.48-4.32,10.72,1.56,13.91A22.46,22.46,0,0,0,688.54,570.91Z"/>' +
          '<path d="M865.25,552.07c4.57-4.47,10-5.05,15.79-3.73,4.64,1.06,7.57,4,7.82,8.47.3,5.41.07,10.86.07,16.41h-4.18c0-5.09,0-10,0-15,0-3.56-1.5-5.88-5-6.59a18.15,18.15,0,0,0-7.12,0c-3.78.78-5.43,3.25-5.44,7.11,0,4.77,0,9.53,0,14.47h-4.08V558.56c0-4-1.53-6.28-5.43-7a18.71,18.71,0,0,0-7.3.22c-3.09.7-4.47,2.92-4.5,6.22,0,4.33,0,8.67,0,13v2.2h-4.26c0-5.71-.29-11.35.09-17,.32-4.55,4.51-7.69,9.81-8.32S861.39,548.12,865.25,552.07Z"/>' +
          '<path d="M948.18,573.25h-4v-4l-2.06,1.28c-7.1,4.54-17.35,4.58-23.73.09a11.74,11.74,0,0,1,.41-19.92c6.55-4.2,18-3.94,24.37.6a11,11,0,0,1,5,8.72C948.31,564.36,948.18,568.69,948.18,573.25Zm-17.69-2.59a19.08,19.08,0,0,0,10.9-3.82A5.93,5.93,0,0,0,944.1,562a10.08,10.08,0,0,0-4.39-8.57c-4.9-3.42-14.09-3.11-18.76.62a8.77,8.77,0,0,0,.14,13.84C923.76,569.94,926.88,570.54,930.49,570.66Z"/>' +
          '<path d="M1001.87,590.15h-4.13V560c0-5-2.12-7.91-7.06-8.59a22.38,22.38,0,0,0-8.38.6c-3.35.87-4.74,3.19-4.79,6.66,0,4.09,0,8.17,0,12.26v2.13h-4.31v-2.88c0-3.65,0-7.3,0-11,0-4.88,2.35-8.38,7.1-10.2a19.94,19.94,0,0,1,14.52-.08c4.57,1.71,7.16,5.1,7.21,10,.09,10.15,0,20.31,0,30.46A3.93,3.93,0,0,1,1001.87,590.15Z"/>' +
          '<path d="M729.86,548.43h4.19c0,.72.11,1.38.11,2.05,0,3.9,0,7.8,0,11.71,0,4.53,2.1,7.23,6.57,8.1a19.16,19.16,0,0,0,6.09.2c4.93-.67,7.34-3.58,7.41-8.62.06-3.78,0-7.55,0-11.33,0-.67.06-1.34.09-2.09h4.22v4.3c0,3.29.06,6.57,0,9.85-.15,6-3.55,10.07-9.44,10.84a39.06,39.06,0,0,1-10,0c-5.38-.68-8.82-4.2-9.21-9.61C729.58,558.78,729.86,553.7,729.86,548.43Z"/>' +
          '<path d="M783.51,536.86h4.11v36.37h-4.11Z"/>' +
          '<path d="M812.55,536.84h4.07v36.37h-4.07Z"/>' +
        '</svg>';

    var HTML =
      '<div class="lp-inner">' +
        SVG_ORB +
        SVG_WORDMARK +
        '<div class="lp-label">TERANGA NDAKARU</div>' +
        '<div class="lp-bar-row">' +
          '<div class="lp-bar"><div class="lp-bar-fill" id="lpBarFill"></div></div>' +
          '<div class="lp-pct" id="lpPctLabel">0%</div>' +
        '</div>' +
        '<div class="lp-word"><span class="bold">Yeksil Ak Jàam</span> <span class="reg">« You are welcome »</span></div>' +
      '</div>';

    function inject() {
        var el = document.createElement('div');
        el.id = 'rp-loader-landing';
        el.setAttribute('role', 'status');
        el.setAttribute('aria-live', 'polite');
        el.setAttribute('aria-label', 'Chargement du site Pullman Dakar Teranga');
        el.innerHTML = HTML;
        document.body.appendChild(el);
        document.body.classList.add('rp-locked');

        var fill = document.getElementById('lpBarFill');
        var pct  = document.getElementById('lpPctLabel');

        setTimeout(function () {
            var start = performance.now();
            (function tick(now) {
                var t = Math.min(1, (now - start) / DURATION);
                var p = Math.floor(t * 100);
                if (fill) fill.style.width = p + '%';
                if (pct)  pct.textContent = p + '%';
                if (t < 1) requestAnimationFrame(tick);
                else setTimeout(hide, PAUSE);
            })(performance.now());
        }, 200);
    }

    function hide() {
        var el = document.getElementById('rp-loader-landing');
        if (el) el.classList.add('rp-hidden');
        document.body.classList.remove('rp-locked');
        setTimeout(function () {
            if (el && el.parentNode) el.parentNode.removeChild(el);
        }, 700);
    }

    function boot() { setTimeout(inject, 60); }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', boot);
    } else {
        boot();
    }
})();
