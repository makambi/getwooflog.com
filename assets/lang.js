/* WoofLog landing-page language handling.
   - On the English root ("/"), redirect a visitor to their locale at most ONCE
     per session, so returning to "/" (e.g. via the logo) stays on English.
   - A manual picker choice (localStorage) always wins and persists across sessions.
   - No cookies, no tracking; fails silently. SEO is handled via hreflang tags. */
(function () {
  try {
    var SUP = { es: '/es/', de: '/de/', fr: '/fr/', it: '/it/', pt: '/pt/' };
    var KEY = 'wl-lang';   // explicit choice (localStorage)
    var SEEN = 'wl-seen';  // already auto-redirected this session (sessionStorage)

    // Auto-redirect from the English root only (run early to minimize the flash).
    if (location.pathname === '/') {
      var pref = null;
      try { pref = localStorage.getItem(KEY); } catch (e) {}

      if (pref) {
        // An explicit choice always wins (and persists across sessions).
        if (pref !== 'en' && SUP[pref]) { location.replace(SUP[pref]); return; }
      } else {
        // No explicit choice: auto-detect, but only once per session so that a
        // deliberate return to "/" counts as a soft opt-out (stays on English).
        var seen = null;
        try { seen = sessionStorage.getItem(SEEN); } catch (e) {}
        if (!seen) {
          var lang = (navigator.language || navigator.userLanguage || '')
            .slice(0, 2).toLowerCase();
          if (lang && lang !== 'en' && SUP[lang]) {
            try { sessionStorage.setItem(SEEN, '1'); } catch (e2) {}
            location.replace(SUP[lang]);
            return;
          }
        }
      }
    }

    // Remember manual picker choices once the DOM is ready, and give the
    // native <details> dropdown the usual outside-click / Escape close.
    document.addEventListener('DOMContentLoaded', function () {
      var picker = document.querySelector('.lang-picker');
      if (!picker) return;

      picker.addEventListener('click', function (e) {
        var a = e.target.closest('a[data-lang]');
        if (a) {
          try { localStorage.setItem(KEY, a.getAttribute('data-lang')); } catch (e3) {}
        }
      });

      document.addEventListener('click', function (e) {
        if (picker.open && !picker.contains(e.target)) picker.open = false;
      });
      document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape' && picker.open) picker.open = false;
      });
    });
  } catch (e) {}
})();
