# getwooflog.com

Source for the [getwooflog.com](https://getwooflog.com) marketing and legal site. Three static pages: landing, privacy, support.

## Structure

```
.
├── index.html          # Landing page
├── privacy/index.html  # Privacy Policy (GDPR)
├── support/index.html  # Support page
├── style.css           # Shared stylesheet
├── RUNBOOK.md          # One-time setup: Cloudflare Pages + DNS + Email
├── verify.sh           # Post-deploy verification script
└── README.md           # This file
```

No build step. Plain HTML + one CSS file.

## Local preview

```sh
cd getwooflog-com
python3 -m http.server 8000
# open http://localhost:8000/
```

## Deploy

Pushes to `main` auto-deploy to Cloudflare Pages. Typical deploy is under 60 seconds. First-time setup steps are in [RUNBOOK.md](./RUNBOOK.md).

## How to update

1. Edit the relevant file.
2. If the Privacy Policy changed materially, update the `Last updated:` date on `privacy/index.html`.
3. Commit + push to `main`. Cloudflare Pages redeploys automatically.
4. Run `./verify.sh` to confirm the live site matches expectations.

## Policy and support content

The content of `privacy/index.html` and `support/index.html` is the canonical source — not the drafts in the WoofLog app repo's `docs/milestones/app-store-launch.md`. Those drafts were starting points and may contain stale language (e.g., subscription references that don't apply to v1.0).

Any substantive change to the Privacy Policy should be accompanied by a "What's New" note in the next App Store release.

## Contact

Site maintained by Vitalii Nechypor — <support@getwooflog.com>.
