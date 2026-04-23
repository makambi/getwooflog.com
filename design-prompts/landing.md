# Claude Design prompt — getwooflog.com landing page

Paste this as a prompt into Claude Design (or any AI web design tool). It's self-contained — you don't need to add context.

---

## PROMPT STARTS HERE

Design a landing page for **WoofLog**, an iPhone app for dog health logging, to be hosted at `https://getwooflog.com/`. Deliver a single self-contained `index.html` file (CSS may be inline in a `<style>` tag or in one separate `style.css` file — your choice). No JavaScript, no frameworks, no external script or font CDNs. Plain static HTML + CSS that can be dropped onto Cloudflare Pages and served as-is.

### What WoofLog is

WoofLog is a focused iPhone app for dog owners who want to log symptoms, track medication, and see the full health record of their dog over time. The differentiator is restraint: it does fewer things than other pet apps, does them well, and never asks for an account. All data lives on the device. There is no cloud, no analytics, no tracking, no ads, no social features.

It is not a wellness or mood app. It is not a vet marketplace. It is a record — the kind of thing you'd hand to a vet and say "here's what I've been seeing."

### Who visits this page

Three audiences, in order of importance:

1. **Curious dog owners** who heard about the app and are checking whether it looks legitimate before they download it.
2. **Apple App Review reviewers** clicking through from the listing to sanity-check the product description, privacy policy, and support URL.
3. **Press / word-of-mouth recipients** — someone sharing the link in a dog owner community; the landing page needs to answer "what is this?" in under ten seconds.

### Tone and aesthetic

- **Calm, trustworthy, indie-but-professional.** Think of a quiet utility app's landing page, not a SaaS product page.
- Not flashy. No animations beyond subtle. No gradient-heavy hero blocks. No stock photography.
- Slightly warm — this is a page about caring for a dog. Cold enterprise aesthetic is wrong.
- Reads honestly. No "revolutionary pet care platform" marketing language. Use observation / record / log verbs; never diagnose / treat / cure / consult (this is an Apple review risk for pet apps).
- Editorial-magazine feel is fine. So is utilitarian-but-warm.

### Brand

- **Primary color:** `#3D8A5A` (forest green). A darker shade `#2F6D46` for hover and emphasis.
- **Dark-mode variants:** brand `#4D9B6A`, text `#EAEEEB` on background `#121512`, muted text `#9BA8A0`, border `#2A312C`. Use `@media (prefers-color-scheme: dark)`.
- **App icon:** assume a 1024×1024 PNG is available at `/assets/icon-light.png` (light mode) and `/assets/icon-dark.png` (dark mode). It's a rounded-square dark tile with a forest-green paw print. Use `<picture>` with a `<source media="(prefers-color-scheme: dark)">`.
- **Typography:** system font stack only (`-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Oxygen, Ubuntu, Cantarell, "Helvetica Neue", sans-serif`). No Google Fonts, no Typekit.

### Structure and copy (use verbatim where possible)

Use this exact content. You can re-arrange, but do not invent claims or add marketing copy not in this list.

**Document `<title>`:** WoofLog — A focused health record app for your dog
**Meta description:** WoofLog is an iPhone app for logging your dog's symptoms, tracking medication, and seeing the full health record — local-first, private by design. Coming to the App Store in the Netherlands in 2026.

**Header:** app icon (small, ~28px) + "WoofLog" wordmark on the left. Right side: nav links to `/privacy/` and `/support/`.

**Hero section:**
- App icon, large (~128px on desktop, ~104px on mobile), rounded corners, subtle shadow.
- H1: **Log your dog's health. See the full record.**
- Tagline: A focused iPhone app for dog owners who want to track symptoms, medication, and the daily picture of how their dog is doing — without the noise.

**Intro paragraph:** WoofLog is a health record for your dog. You log what you notice — a soft stool, a skin flare-up, a missed meal — and it stays there, ready when the next vet visit asks "how long has this been happening?" Everything is stored on your iPhone, so nothing leaves your device unless you want it to.

**Four feature cards/blocks:**

1. **Eight structured loggers** — Stool, skin & coat, vomiting, urinary, mobility, ears, vet visits, plus free-form notes. Each one captures the signals that actually matter without turning logging into homework.
2. **Medication tracking** — Create prescriptions, log doses as you give them, and see where you are in a course at a glance. Reminders keep you on schedule.
3. **The full record** — A unified timeline with filters for the last 7, 30, or 90 days — or any custom range. Walk into the vet with exactly what they need to see.
4. **Private by design** — No accounts, no sign-up, no analytics, no tracking. Your dog's data lives on your iPhone. If you uninstall the app, everything goes with it.

**Launch info callout (visually emphasized, subtle accent background):**
- H2: **Launching in the Netherlands, 2026**
- Body: **Free during early access.** WoofLog will be free while we're in early access in the Netherlands. A paid version with additional features is planned for a future release — early-access users will have time to decide whether to stay.

**About section:**
- H2: **Built by one person**
- Body: WoofLog is developed by Vitalii Nechypor, a solo developer in the Netherlands. It's the app I wanted for my own dog — a way to keep track of the small things so the big ones make sense.
- Contact line: Questions, feedback, or a bug? `support@getwooflog.com` (as a `mailto:` link).

**Footer:** © Vitalii Nechypor. Built in the Netherlands. Links: Privacy, Support, Email (mailto).

### Hard requirements

- **Single page, one HTML file.** Inline CSS or one linked `style.css` file. Nothing else.
- **No JavaScript.** The page must work with JS disabled.
- **No external network calls.** No Google Fonts, no analytics, no third-party widgets, no image CDNs. The icon is the only image, served locally.
- **No signup form, no email capture.** The privacy policy explicitly promises no tracking or email collection — a signup form would be a contradiction.
- **No fake screenshots or mockups of the app.** We have the app icon only. Do not render iPhone frames with placeholder screens.
- **No "Download on the App Store" button.** The app is not live yet; a button would be false.
- **Responsive, mobile-first.** Must look good at 360px wide. Must look good at 1440px wide. Readable at 200% browser zoom and with iOS "Larger Text" accessibility settings.
- **Dark mode via `prefers-color-scheme`.** No manual toggle needed.
- **Accessible:** semantic HTML (`<header>`, `<main>`, `<section>`, `<footer>`), meaningful `alt` text only on the hero app icon (decorative icon in the header nav can use empty `alt=""`), proper heading hierarchy, 4.5:1 contrast minimum.
- **Fast:** page should load and render in <1s on a 3G connection. No oversized images, no blocking fonts.
- **Self-consistent privacy promise:** the page must be honest to the claim "no tracking, no analytics." Do not add any behavior that would contradict the Privacy Policy linked at `/privacy/`.

### Deliverable

Return a single `index.html` file (plus a `style.css` if you split them out) that I can drop into `~/Projects/getwooflog-com/` replacing the existing `index.html`. Use the existing icon asset paths (`/assets/icon-light.png` and `/assets/icon-dark.png`). The existing `/privacy/` and `/support/` pages use the same stylesheet — if you change `style.css`, keep the existing selectors working (header `.site`, `.brand`, `.brand-icon`, footer `.site`) so those pages don't break. Alternatively, scope your new styles under a landing-page-specific class so they don't leak.

Make it calm, honest, and confident. Don't over-design.
