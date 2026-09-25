/* ============================================================= */
/* RESERVATION-FORMS.JS — Soumission des formulaires (v2)        */
/* ============================================================= */
(function () {
    'use strict';

    window.ctxSubmit = function (event, ctxType) {
        event.preventDefault();
        var form = event.target;
        var data = {};
        form.querySelectorAll('input, select, textarea').forEach(function (el) {
            if (el.id) data[el.id] = el.value;
        });

        var prefix = ctxType === 'spa' ? 'SPA' :
                     ctxType === 'resto' ? 'RST' :
                     ctxType === 'evt' ? 'EVT' : 'RES';
        var ref = prefix + '-' + Date.now().toString().slice(-6);

        console.log('[Reservation] ' + ctxType, data, 'ref=' + ref);

        var success = document.createElement('div');
        success.className = 'ctx-success';
        success.innerHTML =
            '<i class="fa-solid fa-circle-check"></i>' +
            '<div>' +
                '<strong>Demande envoyee avec succes !</strong>' +
                '<span>Reference : <b>' + ref + '</b> - Confirmation par e-mail sous 24h.</span>' +
            '</div>';

        var old = form.querySelector('.ctx-success');
        if (old) old.remove();

        form.querySelectorAll('.ctx-row, .ctx-field, .ctx-actions').forEach(function (el) {
            el.style.display = 'none';
        });
        form.appendChild(success);

        setTimeout(function () {
            success.scrollIntoView({ behavior: 'smooth', block: 'center' });
        }, 100);

        return false;
    };
})();
