/* =============================================================
   FIX DATEPICKER — Ouvre le calendrier au clic sur tout le champ
   Commun à toutes les pages sauf reservation.html
   ============================================================= */
(function () {
    'use strict';

    function init() {
        document.querySelectorAll('.booking-section .widget-field').forEach(function (field) {
            var input = field.querySelector('input[type="date"]');
            if (!input) return;

            // Curseur main sur tout le champ
            field.style.cursor = 'pointer';

            field.addEventListener('click', function (e) {
                // Si le clic est déjà sur l'input, ne rien faire (comportement natif)
                if (e.target === input) return;

                // Focus sur l'input
                input.focus({ preventScroll: true });

                // Ouvre le picker natif si dispo (Chrome, Edge, Firefox récents)
                if (typeof input.showPicker === 'function') {
                    try {
                        input.showPicker();
                    } catch (err) {
                        // Certains navigateurs bloquent showPicker hors interaction
                        // Le focus seul suffit alors
                    }
                }
            });
        });
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }
})();
