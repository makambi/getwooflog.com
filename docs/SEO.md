# WoofLog — SEO & AI-search (GEO) strategy

Living notes for getwooflog.com discoverability: who we're for, what to rank for, and how to be
surfaced well by both search engines and AI assistants. Pairs with the technical changes shipped
alongside this doc (robots.txt, sitemap.xml, llms.txt, JSON-LD, meta).

---

## 1. Target audience

WoofLog is a **private, on-device health diary for dog owners** — free, iPhone-only, deliberately
*not* a medical/diagnostic tool. The people who search for and stick with it:

1. **The conscientious tracker (primary).** Their dog has a recurring or chronic issue — itchy skin,
   on-and-off diarrhea, a limp, ear flare-ups — and they're tired of telling the vet "it started…
   maybe last week?" They want to capture symptoms (with a photo) and walk in with a dated history.
   High intent, high retention. This is the core persona and where the App Store keywords point.
2. **The new-puppy / new-rescue owner.** Suddenly responsible for a small life, anxious, googling
   every symptom. Wants a simple log + medication/vaccination-era reminders mindset (note: WoofLog
   does *not* market reminders or vaccinations — see banned terms).
3. **The senior / chronic-condition owner.** Managing meds and weight over months; values the
   medication log, weight trend, and history-for-the-vet.
4. **The privacy-conscious owner (cross-cutting).** Actively rejects account/cloud pet apps. "Local
   first, no account" is a *differentiator*, not fine print — lead with it for this segment.

**Positioning takeaway:** lead with *"dog health diary / symptom & medication tracker, private by
default."* Avoid clinical/medical promises (it's Lifestyle, not Medical).

---

## 2. Keyword strategy

Anchored to the live App Store keyword field:
`poop, diarrhea, vomit, medication, vet, allergy, skin, itch, mobility, ear, weight, limp, appetite, pee, eye`
plus name **`WoofLog: Dog Health Diary`** + subtitle **`Dog Symptom & Med Tracker`**.

### Clusters (English)
- **Core / head terms:** dog health diary, dog health app, dog symptom tracker, dog medication
  tracker, dog health log, dog health record app.
- **Symptom long-tail (high intent):** dog poop / stool tracker, dog diarrhea log, track dog
  vomiting, dog itching / skin issue log, dog limping / mobility tracker, dog ear problems log,
  dog weight tracker, dog appetite tracker.
- **Vet-prep intent:** how to track dog symptoms for the vet, what to tell the vet, dog symptom
  diary for vet visit.
- **Privacy intent (differentiator):** private dog health app, offline dog tracker, no-account pet
  app, on-device dog health log.

### Per-language note
Translate to the **lay** term people actually type, not the clinical one:
- ES `caca/heces de perro`, `diarrea perro`, `vómitos perro`, `app salud perro`
- DE `hund kot/durchfall tagebuch`, `hunde-gesundheits-app`, `medikamente hund tracken`
- FR `journal santé chien`, `diarrhée chien`, `suivi médicaments chien`
- IT `diario salute cane`, `diarrea cane`, `monitoraggio farmaci cane`
- PT `diário de saúde do cão`, `diarreia cão`, `medicação cão`

### On-page mapping
- **Title / H1 / meta description** → core head terms (recommend shifting site title toward the
  store's "Dog Health Diary · Symptom & Med Tracker" phrasing — see §3 follow-ups).
- **Feature sections + an FAQ** → symptom long-tail + vet-prep (natural, lay wording).
- **Privacy section** → privacy-intent terms.
- **llms.txt + JSON-LD** → the canonical, factual term set for machines.

---

## 3. App Store ↔ website alignment (gaps to fix)

The website currently lags the shipped v1.1 listing. **Documented here as follow-ups; not changed in
the SEO PR** (they touch marketing copy + 5 translations).

| Area | App Store (shipped) | Website now | Action |
|---|---|---|---|
| Positioning | "Dog Health Diary", "Symptom & Med Tracker" | "A focused health record app" | Re-point title/H1/meta to the diary/tracker phrasing |
| **Weight** | Ships a Weight tracker | **Not mentioned anywhere** | Add a Weight feature card (+ translations) |
| **History** | "organized by date" | "filter to last 7, 30, or 90 days — or any custom range" | **Likely overstated — verify against the app and correct** |
| Medication | "log each dose, last 7 days at a glance" | "create prescriptions… course… what's still outstanding" | Confirm wording matches the shipped meds view |
| Terminology | poop, pee, diarrhea, itch, limp, weight | stool, urinary (no poop/pee/weight) | Weave lay search terms into body + FAQ |
| Banned words | diagnose, treat, cure, consult, "structured forms", "vet visits/vaccinations", "Timeline" | none present ✓ | keep avoiding |

**Recommended next content PR:** add a Weight card, correct the History claim, and add an FAQ
section (great for both long-tail SEO and AI answers), then re-translate the changed strings.

---

## 4. GEO — being surfaced by AI assistants (Gemini, ChatGPT, Claude, Perplexity)

Shipped in this PR:
- **robots.txt explicitly allows AI crawlers** (GPTBot, OAI-SearchBot, ClaudeBot, anthropic-ai,
  Google-Extended (Gemini grounding), PerplexityBot, Applebot-Extended, CCBot, Bingbot).
- **llms.txt** — a clean, factual markdown summary at the site root that LLM tools increasingly read.
- **JSON-LD** — `SoftwareApplication` (LifestyleApplication, iOS, free), `Organization`, and
  `FAQPage` on /support/ — machine-readable, citable facts. No fabricated ratings.
- **Static, server-rendered HTML** — AI crawlers generally don't run JS, so the content is fully
  visible. The `lang.js` locale redirect is irrelevant to them: they reach each `/xx/` page directly
  via the sitemap + hreflang.

Ongoing GEO practices:
- **State facts plainly and unambiguously** ("WoofLog is a free iPhone app…", "data stays on the
  device", "available in 6 languages"). Assistants quote clear, declarative claims.
- **Answer real questions** — expand the FAQ to mirror how people ask assistants ("how do I track my
  dog's diarrhea?", "is there a private dog health app?"). FAQPage schema reinforces this.
- **Consistency across surfaces** — keep the App Store, website, llms.txt, and JSON-LD telling the
  *same* story (the §3 gaps currently break this for Weight/History).
- **Off-site signals** (not in repo): App Store presence, reputable directory/review listings, and
  any press — these are what assistants triangulate for trust.

---

## 5. Measurement & next steps
- Submit `sitemap.xml` in Google Search Console + Bing Webmaster Tools; verify the domain.
- Validate structured data post-deploy with Google's Rich Results Test + schema.org validator.
- Watch Search Console queries to confirm the symptom long-tail is landing; iterate copy.
- Backlog: (1) the §3 content alignment PR (Weight, History fix, lay terms, FAQ); (2) a real
  1200×630 social/OG share image (currently the square icon → `twitter:card=summary`);
  (3) optional lightweight content (e.g. a short "how to track your dog's symptoms for the vet"
  article) to capture vet-prep long-tail.
