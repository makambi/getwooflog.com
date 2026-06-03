/* WoofLog landing-page language handling.
   - On the English root ("/"), redirect first-time visitors to their locale.
   - Remember a manual picker choice (localStorage) so it is never overridden.
   - No cookies, no tracking; fails silently. SEO is handled via hreflang tags. */
(function () {
  try {
    var SUP = { es: '/es/', de: '/de/', fr: '/fr/', it: '/it/', pt: '/pt/' };
    var KEY = 'wl-lang';

    // Auto-redirect from the English root only (run early to minimize the flash).
    if (location.pathname === '/') {
      var pref = null;
      try { pref = localStorage.getItem(KEY); } catch (e) {}
      var lang = pref || (navigator.language || navigator.userLanguage || '')
        .slice(0, 2).toLowerCase();
      if (lang && lang !== 'en' && SUP[lang]) {
        location.replace(SUP[lang]);
        return;
      }
    }

    // Remember manual picker choices once the DOM is ready.
    document.addEventListener('DOMContentLoaded', function () {
      var picker = document.querySelector('.lang-picker');
      if (!picker) return;
      picker.addEventListener('click', function (e) {
        var a = e.target.closest('a[data-lang]');
        if (a) {
          try { localStorage.setItem(KEY, a.getAttribute('data-lang')); } catch (e2) {}
        }
      });
    });
  } catch (e) {}
})();
