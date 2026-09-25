/* ============================================================= */
/* I18N.JS — Traduction FR / EN / ES complète                    */
/* MutationObserver : traduit aussi le contenu dynamique         */
/* ============================================================= */
(function () {
  'use strict';

  var DICTS = {
    fr: {},
    en: {
      /* Header */
      'ACCUEIL':'HOME','CHAMBRES':'ROOMS','EXPÉRIENCES':'EXPERIENCES',
      'GALERIE':'GALLERY','MEETING & EVENTS':'MEETING & EVENTS','CONTACT':'CONTACT',
      'Réserver maintenant':'Book now','Nous contacter':'Contact us',

      /* Footer */
      'LIENS UTILES':'USEFUL LINKS','DÉCOUVRIR':'DISCOVER','SUIVEZ-NOUS':'FOLLOW US',
      'MOYENS DE PAIEMENT':'PAYMENT METHODS','NOTRE ENGAGEMENT':'OUR COMMITMENT',
      'Mentions légales':'Legal notices','Conditions générales':'Terms & conditions',
      'Politique de confidentialité':'Privacy policy','Accessibilité':'Accessibility',
      'Nos chambres':'Our rooms','Expériences':'Experiences',
      'Offres spéciales':'Special offers','Galerie':'Gallery',
      'Our World Is':'Our World Is','Your Playground':'Your Playground',
      'Franc CFA':'CFA Franc','Euro':'Euro','Dollar US':'US Dollar',
      '© 2026 Pullman Dakar Teranga - Tous droits réservés.':
        '© 2026 Pullman Dakar Teranga - All rights reserved.',
      'BP 8181, Dakar, Sénégal':'BP 8181, Dakar, Senegal',
      'Route de la Corniche Ouest':'Route de la Corniche Ouest',

      /* Pourquoi réserver */
      'Pourquoi réserver en direct ?':'Why book direct?',
      'Meilleur tarif garanti':'Best rate guaranteed',
      'Profitez des meilleurs tarifs disponibles uniquement sur notre site officiel.':
        'Enjoy the best rates available only on our official website.',
      'Annulation flexible':'Flexible cancellation',
      "Annulation gratuite jusqu'à 48h avant votre arrivée.":
        'Free cancellation up to 48h before arrival.',
      'Paiement sécurisé':'Secure payment',
      'Vos transactions sont 100% sécurisées.':'Your transactions are 100% secure.',

      /* CTA */
      'PRÊT POUR VOTRE PROCHAINE ÉVASION ?':'READY FOR YOUR NEXT ESCAPE?',
      "Réservez maintenant et vivez l'expérience Pullman Dakar Teranga.":
        'Book now and live the Pullman Dakar Teranga experience.',

      /* Réservation */
      'Réservez votre séjour au Pullman Dakar Teranga':'Book your stay at Pullman Dakar Teranga',
      "Profitez d'une expérience unique alliant confort, élégance et hospitalité sénégalaise face à l'océan Atlantique.":
        'Enjoy a unique experience combining comfort, elegance and Senegalese hospitality facing the Atlantic Ocean.',
      'Choix du séjour':'Choose your stay','Vos coordonnées':'Your details',
      'Récapitulatif':'Summary','Confirmation':'Confirmation',
      'Arrivée':'Arrival','Départ':'Departure','Voyageurs':'Guests',
      'Chambres':'Rooms','Code promo':'Promo code','Facultatif':'Optional',
      'Rechercher':'Search',
      'Toutes les vues':'All views','Vue océan':'Ocean view','Vue ville':'City view',
      '1 lit King':'1 King bed','2 lits simples':'2 twin beds',
      'Votre sélection':'Your selection',
      'Choisissez une chambre et un tarif dans la liste pour voir apparaître ici le détail de votre réservation.':
        'Choose a room and rate from the list to see your booking details here.',
      'Continuer':'Continue',
      '✓ Meilleur tarif garanti':'✓ Best rate guaranteed',
      '✓ Paiement sécurisé':'✓ Secure payment',
      '✓ Annulation flexible':'✓ Flexible cancellation',
      'TOTAL SÉJOUR':'TOTAL STAY','TOTAL':'TOTAL',

      /* Chambres */
      'Chambre Classique Vue Ville':'Classic City View Room',
      'Chambre Classique Twin Vue Ville':'Classic Twin City View Room',
      'Chambre Deluxe Vue Océan':'Deluxe Ocean View Room',
      'Chambre Supérieure Vue Océan':'Superior Ocean View Room',
      'Suite Ambassadeur Pullman':'Pullman Ambassador Suite',
      'Vue Océan':'Ocean View','Vue Ville':'City View',
      "Élégante et confortable, pensée pour un séjour urbain pratique au cœur de Dakar.":
        'Elegant and comfortable, designed for a convenient urban stay in the heart of Dakar.',
      "Deux lits simples, idéale pour les collègues ou amis en voyage d'affaires.":
        'Two twin beds, ideal for colleagues or friends on a business trip.',
      "Balcon privé et vue imprenable sur l'Atlantique depuis votre lit King Size.":
        'Private balcony and stunning Atlantic views from your King Size bed.',
      "Terrasse privative et lumière naturelle généreuse, face à l'île de Gorée.":
        'Private terrace and generous natural light, facing Gorée Island.',
      "Salon séparé, volumes généreux et services exclusifs pour un séjour d'exception.":
        'Separate living room, generous volumes and exclusive services for an exceptional stay.',
      'Plus que 2 chambres à ce tarif':'Only 2 rooms left at this rate',
      'Plus que 3 chambres à ce tarif':'Only 3 rooms left at this rate',
      'Plus que 4 chambres à ce tarif':'Only 4 rooms left at this rate',

      /* Équipements */
      'Lit King Size':'King Size bed','Wi-Fi haut débit':'High-speed Wi-Fi',
      'Minibar':'Minibar','Climatisation':'Air conditioning',
      'Balcon privé':'Private balcony','Machine Illy':'Illy coffee machine',
      'Terrasse':'Terrace','Baignoire':'Bathtub','Coffre-fort':'Safe',
      'Salon séparé':'Separate living room','Canapé-lit':'Sofa bed',
      'Baignoire & douche':'Bathtub & shower','Service Concierge':'Concierge service',

      /* Tarifs */
      'Tarif Flexible':'Flexible Rate','Tarif Non-remboursable':'Non-refundable Rate',
      'Petit-déjeuner inclus':'Breakfast included',
      "Annulation gratuite jusqu'à 48h avant l'arrivée":
        'Free cancellation up to 48h before arrival',
      'Paiement immédiat, −15%':'Immediate payment, −15%',
      'Buffet Teranga Lounge chaque matin':'Teranga Lounge buffet every morning',
      'Buffet Teranga Lounge + service en chambre':
        'Teranga Lounge buffet + room service',
      'par nuit':'per night','Sélectionner':'Select','✓ Sélectionnée':'✓ Selected',

      /* Panneau */
      'Nuits':'Nights','Taxe de promotion touristique':'Tourist promotion tax',
      'TVA':'VAT','incluse':'included',
      "Non remboursable — paiement immédiat":'Non-refundable — immediate payment',

      /* Étape 2 */
      "Ces informations serviront à votre confirmation de réservation et à votre accueil à l'hôtel.":
        'This information will be used for your booking confirmation and hotel check-in.',
      'Voyageur principal':'Main guest','Civilité':'Title',
      'Madame':'Mrs','Monsieur':'Mr','Autre':'Other',
      'Prénom':'First name','Nom':'Last name',
      'E-mail':'E-mail','Téléphone':'Phone',
      'Pays de résidence':'Country of residence','Sénégal':'Senegal',
      'France':'France',"Côte d'Ivoire":'Ivory Coast','États-Unis':'United States',
      'Motif du séjour':'Purpose of stay','Loisirs':'Leisure',
      'Affaires':'Business','Événement / Séminaire':'Event / Seminar',
      'Votre arrivée':'Your arrival',
      "Heure d'arrivée estimée":'Estimated arrival time',
      'Avant 14h':'Before 2 pm','14h – 18h':'2 pm – 6 pm','18h – 22h':'6 pm – 10 pm',
      'Après 22h (arrivée tardive)':'After 10 pm (late arrival)',
      'Numéro adhérent ALL (facultatif)':'ALL member number (optional)',
      'Ex : 3512xxxxxx':'E.g. 3512xxxxxx',
      'Demandes particulières':'Special requests',
      'Étage élevé, lit bébé, allergie, anniversaire… (sous réserve de disponibilité)':
        'High floor, baby cot, allergy, birthday… (subject to availability)',
      'Services additionnels':'Additional services',
      'Transfert aéroport AIBD aller-retour — 35 000 FCFA':
        'Round-trip AIBD airport transfer — 35,000 XOF',
      'Late check-out (départ 16h) — Gratuit sur demande':
        'Late check-out (4 pm departure) — Free on request',
      'Accès Pullman Spa — 25 000 FCFA / personne':
        'Pullman Spa access — 25,000 XOF / person',
      "J'accepte les":'I accept the',
      'conditions générales de vente':'terms and conditions',
      'Je souhaite recevoir les offres et actualités du Pullman Dakar Teranga':
        'I would like to receive offers and news from Pullman Dakar Teranga',
      '← Retour':'← Back','Continuer vers le récapitulatif →':'Continue to summary →',

      /* Étape 3 */
      'Votre séjour':'Your stay','Modifier':'Change',
      'Mode de paiement':'Payment method',
      "Paiement instantané via l'application Wave":'Instant payment via the Wave app',
      'Orange Money':'Orange Money',
      'Paiement via votre compte Orange Money':'Payment via your Orange Money account',
      'Carte bancaire':'Bank card',
      'Visa, Mastercard — paiement sécurisé 3D Secure':'Visa, Mastercard — 3D Secure payment',
      '🔒 Transaction chiffrée SSL · Conforme 3D Secure':
        '🔒 SSL encrypted transaction · 3D Secure compliant',
      "Politique d'annulation":'Cancellation policy',
      'Total à régler':'Total to pay','Payer et confirmer':'Pay and confirm',

      /* Étape 4 */
      'Réservation confirmée':'Booking confirmed',
      'Un e-mail et un SMS de confirmation viennent de vous être envoyés. Nous avons hâte de vous accueillir au Pullman Dakar Teranga.':
        'A confirmation email and SMS have just been sent. We look forward to welcoming you at Pullman Dakar Teranga.',
      'Numéro de réservation':'Booking number',
      'Télécharger le PDF':'Download PDF','Ajouter au calendrier':'Add to calendar',

      /* Panier */
      'Chambre':'Room','Tarif':'Rate','Voyageur':'Guest',
      'Séjour':'Stay','Total réglé':'Total paid'
    },
    es: {
      'ACCUEIL':'INICIO','CHAMBRES':'HABITACIONES','EXPÉRIENCES':'EXPERIENCIAS',
      'GALERIE':'GALERÍA','MEETING & EVENTS':'REUNIONES Y EVENTOS','CONTACT':'CONTACTO',
      'Réserver maintenant':'Reservar ahora','Nous contacter':'Contáctenos',
      'LIENS UTILES':'ENLACES ÚTILES','DÉCOUVRIR':'DESCUBRIR','SUIVEZ-NOUS':'SÍGANOS',
      'MOYENS DE PAIEMENT':'MÉTODOS DE PAGO','NOTRE ENGAGEMENT':'NUESTRO COMPROMISO',
      'Mentions légales':'Aviso legal','Conditions générales':'Términos y condiciones',
      'Politique de confidentialité':'Política de privacidad','Accessibilité':'Accesibilidad',
      'Nos chambres':'Nuestras habitaciones','Expériences':'Experiencias',
      'Offres spéciales':'Ofertas especiales','Galerie':'Galería',
      'Our World Is':'Nuestro Mundo Es','Your Playground':'Tu Patio de Juegos',
      'Franc CFA':'Franco CFA','Euro':'Euro','Dollar US':'Dólar US',
      '© 2026 Pullman Dakar Teranga - Tous droits réservés.':
        '© 2026 Pullman Dakar Teranga - Todos los derechos reservados.',
      'BP 8181, Dakar, Sénégal':'BP 8181, Dakar, Senegal',
      'Pourquoi réserver en direct ?':'¿Por qué reservar directo?',
      'Meilleur tarif garanti':'Mejor precio garantizado',
      'Profitez des meilleurs tarifs disponibles uniquement sur notre site officiel.':
        'Disfruta de las mejores tarifas solo en nuestro sitio oficial.',
      'Annulation flexible':'Cancelación flexible',
      "Annulation gratuite jusqu'à 48h avant votre arrivée.":
        'Cancelación gratuita hasta 48h antes de la llegada.',
      'Paiement sécurisé':'Pago seguro',
      'Vos transactions sont 100% sécurisées.':'Tus transacciones son 100% seguras.',
      'PRÊT POUR VOTRE PROCHAINE ÉVASION ?':'¿LISTO PARA TU PRÓXIMA ESCAPADA?',
      "Réservez maintenant et vivez l'expérience Pullman Dakar Teranga.":
        'Reserva ahora y vive la experiencia Pullman Dakar Teranga.',
      'Réservez votre séjour au Pullman Dakar Teranga':
        'Reserva tu estancia en Pullman Dakar Teranga',
      "Profitez d'une expérience unique alliant confort, élégance et hospitalité sénégalaise face à l'océan Atlantique.":
        'Disfruta de una experiencia única que combina confort, elegancia y hospitalidad senegalesa frente al océano Atlántico.',
      'Choix du séjour':'Elige tu estancia','Vos coordonnées':'Tus datos',
      'Récapitulatif':'Resumen','Confirmation':'Confirmación',
      'Arrivée':'Llegada','Départ':'Salida','Voyageurs':'Huéspedes',
      'Chambres':'Habitaciones','Code promo':'Código promocional','Facultatif':'Opcional',
      'Rechercher':'Buscar',
      'Toutes les vues':'Todas las vistas','Vue océan':'Vista al océano',
      'Vue ville':'Vista a la ciudad','1 lit King':'1 cama King',
      '2 lits simples':'2 camas individuales',
      'Votre sélection':'Tu selección',
      'Choisissez une chambre et un tarif dans la liste pour voir apparaître ici le détail de votre réservation.':
        'Elige una habitación y una tarifa de la lista para ver aquí los detalles de tu reserva.',
      'Continuer':'Continuar',
      '✓ Meilleur tarif garanti':'✓ Mejor precio garantizado',
      '✓ Paiement sécurisé':'✓ Pago seguro',
      '✓ Annulation flexible':'✓ Cancelación flexible',
      'TOTAL SÉJOUR':'TOTAL ESTANCIA','TOTAL':'TOTAL',
      'Chambre Classique Vue Ville':'Habitación Clásica Vista Ciudad',
      'Chambre Deluxe Vue Océan':'Habitación Deluxe Vista Océano',
      'Chambre Supérieure Vue Océan':'Habitación Superior Vista Océano',
      'Suite Ambassadeur Pullman':'Suite Embajador Pullman',
      'Vue Océan':'Vista Océano','Vue Ville':'Vista Ciudad',
      'Tarif Flexible':'Tarifa Flexible','Tarif Non-remboursable':'Tarifa No Reembolsable',
      'Petit-déjeuner inclus':'Desayuno incluido',
      'par nuit':'por noche','Sélectionner':'Seleccionar','✓ Sélectionnée':'✓ Seleccionada',
      'Nuits':'Noches','Taxe de promotion touristique':'Tasa de promoción turística',
      'TVA':'IVA','incluse':'incluido',
      'Voyageur principal':'Huésped principal','Civilité':'Tratamiento',
      'Madame':'Sra.','Monsieur':'Sr.','Autre':'Otro',
      'Prénom':'Nombre','Nom':'Apellido','E-mail':'Correo electrónico',
      'Téléphone':'Teléfono','Pays de résidence':'País de residencia',
      'Sénégal':'Senegal','France':'Francia',"Côte d'Ivoire":'Costa de Marfil',
      'États-Unis':'Estados Unidos','Motif du séjour':'Motivo de la estancia',
      'Loisirs':'Ocio','Affaires':'Negocios','Événement / Séminaire':'Evento / Seminario',
      'Votre arrivée':'Tu llegada',"Heure d'arrivée estimée":'Hora de llegada estimada',
      'Demandes particulières':'Solicitudes especiales',
      'Services additionnels':'Servicios adicionales',
      "J'accepte les":'Acepto los',
      'conditions générales de vente':'términos y condiciones',
      '← Retour':'← Atrás','Continuer vers le récapitulatif →':'Continuar al resumen →',
      'Votre séjour':'Tu estancia','Modifier':'Cambiar',
      'Mode de paiement':'Método de pago','Carte bancaire':'Tarjeta bancaria',
      "Politique d'annulation":'Política de cancelación',
      'Total à régler':'Total a pagar','Payer et confirmer':'Pagar y confirmar',
      'Réservation confirmée':'Reserva confirmada',
      'Numéro de réservation':'Número de reserva',
      'Télécharger le PDF':'Descargar PDF','Ajouter au calendrier':'Añadir al calendario',
      'Chambre':'Habitación','Tarif':'Tarifa','Voyageur':'Huésped',
      'Séjour':'Estancia','Total réglé':'Total pagado'
    }
  };

  var SUBSTR = {
    fr: {},
    en: { ' nuit': ' night', ' pers.': ' guests' },
    es: { ' nuit': ' noche', ' pers.': ' huéspedes' }
  };

  var currentLang = localStorage.getItem('pullman_lang') || 'fr';
  var observer = null;
  var debounceTimer = null;

  function applySubstitutions(text, subs) {
    var result = text;
    for (var k in subs) {
      if (result.indexOf(k) !== -1) result = result.split(k).join(subs[k]);
    }
    return result;
  }

  function translateTextNode(node) {
    if (node.__origFr === undefined) node.__origFr = node.nodeValue;
    var orig = node.__origFr;
    var trimmed = orig.trim();
    if (!trimmed) return;
    var dict = DICTS[currentLang] || {};
    var subs = SUBSTR[currentLang] || {};
    if (dict[trimmed] !== undefined) {
      var lead = orig.match(/^\s*/)[0];
      var trail = orig.match(/\s*$/)[0];
      node.nodeValue = lead + dict[trimmed] + trail;
      return;
    }
    var replaced = applySubstitutions(orig, subs);
    node.nodeValue = (replaced !== orig) ? replaced : orig;
  }

  function walkAndTranslate(root) {
    var walker = document.createTreeWalker(root, NodeFilter.SHOW_TEXT, {
      acceptNode: function (node) {
        var p = node.parentNode;
        if (!p) return NodeFilter.FILTER_REJECT;
        var tag = p.tagName;
        if (tag === 'SCRIPT' || tag === 'STYLE' || tag === 'NOSCRIPT') return NodeFilter.FILTER_REJECT;
        if (!node.nodeValue || !node.nodeValue.trim()) return NodeFilter.FILTER_REJECT;
        return NodeFilter.FILTER_ACCEPT;
      }
    });
    var n;
    while ((n = walker.nextNode())) translateTextNode(n);
  }

  function translatePlaceholders() {
    document.querySelectorAll('[placeholder]').forEach(function (el) {
      if (el.__origPH === undefined) el.__origPH = el.placeholder;
      var dict = DICTS[currentLang] || {};
      var tr = dict[el.__origPH.trim()];
      el.placeholder = tr || el.__origPH;
    });
  }

  function applyLanguage(lang) {
    currentLang = lang;
    walkAndTranslate(document.body);
    translatePlaceholders();
  }

  function startObserver() {
    if (observer) return;
    if (currentLang === 'fr') return;
    observer = new MutationObserver(function () {
      clearTimeout(debounceTimer);
      debounceTimer = setTimeout(function () {
        walkAndTranslate(document.body);
        translatePlaceholders();
      }, 60);
    });
    observer.observe(document.body, { childList: true, subtree: true });
  }

  function stopObserver() {
    if (observer) { observer.disconnect(); observer = null; }
    clearTimeout(debounceTimer);
  }

  function init() {
    var names = { fr: 'Français', en: 'English', es: 'Español' };
    var lc = document.querySelector('.topbar .lang-current');
    if (lc) lc.textContent = names[currentLang] || 'Français';
    document.querySelectorAll('.topbar .lang-menu a').forEach(function (a) {
      a.classList.toggle('active', a.dataset.lang === currentLang);
    });
    if (currentLang !== 'fr') {
      applyLanguage(currentLang);
      startObserver();
    }
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }

  window.t = function (key) {
    var dict = DICTS[currentLang] || {};
    return dict[key] || key;
  };
  window.i18nRefresh = function () {
    walkAndTranslate(document.body);
    translatePlaceholders();
  };
  window.i18nSetLang = function (lang) {
    localStorage.setItem('pullman_lang', lang);
    applyLanguage(lang);
    if (lang !== 'fr') startObserver(); else stopObserver();
  };

  window.addEventListener('language-changed', function (e) {
    var lang = e.detail && e.detail.lang;
    if (!lang) return;
    applyLanguage(lang);
    if (lang !== 'fr') startObserver(); else stopObserver();
  });
})();
