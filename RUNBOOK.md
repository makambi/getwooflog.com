# RUNBOOK — Deploy getwooflog.com from zero

This is the one-time setup: push the repo to GitHub, connect Cloudflare Pages, bind the custom domain, enable Cloudflare Email Routing, and configure Gmail "Send as" for `support@getwooflog.com`.

**Estimated wall time:** ~60–90 minutes, including waits for DNS + Gmail verification email. Split across 1–2 sittings is fine.

**Execution model:** Claude prepared this repo locally. You do the dashboard clicks below. Nothing here assumes repo access beyond what you already have.

---

## Pre-flight

Before starting, confirm:

- [ ] You can sign in to the **Cloudflare dashboard** at <https://dash.cloudflare.com> and see `getwooflog.com` listed as a zone
- [ ] You can sign in to **GitHub** under your personal account
- [ ] You can sign in to the Gmail account that support emails should forward to (`<your-gmail>@gmail.com`)
- [ ] This repo exists at `~/Projects/getwooflog-com` locally with an initial commit

---

## Step 1 — Push the repo to GitHub (5 min)

1. Go to <https://github.com/new>
2. **Repository name:** `getwooflog-com`
3. **Description:** `Marketing + legal site for getwooflog.com`
4. **Visibility:** Public
5. **Do NOT** initialize with README, .gitignore, or license (we already have a README)
6. Click **Create repository**
7. On the resulting page, copy the commands under *"…or push an existing repository from the command line"* — they look like:

```sh
git remote add origin git@github.com:<your-username>/getwooflog-com.git
git branch -M main
git push -u origin main
```

8. Run those commands from `~/Projects/getwooflog-com` in your terminal.
9. Refresh the GitHub page — you should see `index.html`, `privacy/`, `support/`, etc.

**Checkpoint:** repo is live at `https://github.com/<your-username>/getwooflog-com`.

---

## Step 2 — Create a Cloudflare Pages project and connect the repo (10 min)

1. Go to <https://dash.cloudflare.com> → select your account (left sidebar account picker)
2. In the left nav, click **Compute (Workers)** → **Workers & Pages**
3. Click **Create** → select the **Pages** tab → click **Connect to Git**
4. Click **Connect GitHub**. A GitHub auth window opens — authorize Cloudflare to access your `getwooflog-com` repo (you can grant access to just that one repo rather than all repos)
5. Back in Cloudflare, select **`getwooflog-com`** from the repo list → click **Begin setup**
6. Settings:
   - **Project name:** `getwooflog-com` (becomes the `*.pages.dev` preview URL)
   - **Production branch:** `main`
   - **Framework preset:** `None`
   - **Build command:** *(leave empty)*
   - **Build output directory:** `/` *(just a slash)*
   - **Root directory:** *(leave as `/`)*
7. Click **Save and Deploy**
8. First deploy runs. Should complete in <60 seconds. You'll get a URL like `https://getwooflog-com.pages.dev` — open it and confirm the landing page loads.

**Checkpoint:** `https://getwooflog-com.pages.dev/`, `/privacy/`, and `/support/` all load correctly.

---

## Step 3 — Bind the custom domain (10 min, plus ~1–5 min DNS propagation)

1. In the Pages project (still in Cloudflare dashboard), click the **Custom domains** tab
2. Click **Set up a custom domain**
3. Enter `getwooflog.com` → click **Continue** → click **Activate domain**
4. Cloudflare will detect that the domain is already on your account and add a CNAME automatically. Confirm.
5. Repeat for `www.getwooflog.com`:
   - Click **Set up a custom domain** again
   - Enter `www.getwooflog.com` → **Continue** → **Activate domain**
6. Wait 1–5 minutes. Cloudflare provisions the SSL certificate during this window.

**Verify from terminal:**

```sh
curl -sSI https://getwooflog.com/ | head -1
# Expect: HTTP/2 200
curl -sSI https://www.getwooflog.com/ | head -1
# Expect: HTTP/2 200 (or HTTP/2 301 → redirects to apex; either is fine)
```

**Optional but recommended — redirect www → apex:**

1. In the Cloudflare dashboard, left nav → select `getwooflog.com` zone
2. Left nav → **Rules** → **Redirect Rules** → **Create rule**
3. Name: `www to apex`
4. If incoming requests match:
   - Field: `Hostname`, Operator: `equals`, Value: `www.getwooflog.com`
5. Then: **Dynamic** redirect
   - Expression: `concat("https://getwooflog.com", http.request.uri.path)`
   - Status code: `301`
   - Preserve query string: ✅
6. **Deploy**

**Checkpoint:** `https://getwooflog.com/` and `https://getwooflog.com/privacy/` and `https://getwooflog.com/support/` all serve your pages under HTTPS.

---

## Step 4 — Enable Cloudflare Email Routing (15 min, may wait for DNS)

1. Back in Cloudflare dashboard → select `getwooflog.com` zone
2. Left nav → **Email** → **Email Routing**
3. Click **Get started** (or **Enable Email Routing** if already partially set up)
4. Cloudflare will propose adding MX + TXT records automatically. Click **Add records and enable**
   - This adds 3 MX records pointing to `route1/2/3.mx.cloudflare.net`
   - Plus an SPF TXT record: `v=spf1 include:_spf.mx.cloudflare.net ~all`
   - **Important:** we will *replace* this SPF record in Step 5 to also authorize Gmail
5. Add your personal Gmail as a **destination address**:
   - Under **Destination addresses**, click **Add destination address**
   - Enter `<your-gmail>@gmail.com`
   - Click **Send verification** — check your Gmail inbox for a Cloudflare email with a button to confirm
   - Click the verification link → confirm
6. Create the routing rule:
   - Under **Routes**, click **Create address**
   - **Custom address:** `support@getwooflog.com`
   - **Destination:** select `<your-gmail>@gmail.com` from the dropdown
   - Click **Save**

**Verify:**

```sh
dig +short MX getwooflog.com
# Expect three lines like: 10 route1.mx.cloudflare.net.
```

**Test end-to-end:**

- From a non-Gmail address (iCloud, Outlook, a friend's address), send an email to `support@getwooflog.com` with subject "CF routing test"
- Expect: arrives in `<your-gmail>@gmail.com` within 60 seconds

**Checkpoint:** sending to `support@getwooflog.com` lands in your Gmail inbox.

---

## Step 5 — Update SPF to authorize Gmail as a sender (5 min)

Cloudflare added an SPF record authorizing its own mail servers. We need to extend it so that Gmail (used in Step 6 for outbound) is also authorized.

1. Cloudflare dashboard → `getwooflog.com` zone → left nav → **DNS** → **Records**
2. Find the TXT record with content starting `v=spf1 include:_spf.mx.cloudflare.net` — click **Edit**
3. Change the content to:
   ```
   v=spf1 include:_spf.google.com include:_spf.mx.cloudflare.net ~all
   ```
4. Click **Save**

**Verify:**

```sh
dig +short TXT getwooflog.com | grep "v=spf1"
# Expect: "v=spf1 include:_spf.google.com include:_spf.mx.cloudflare.net ~all"
```

---

## Step 6 — Configure Gmail to send AS support@getwooflog.com (15 min)

1. Open Gmail → click the gear icon (top right) → **See all settings**
2. Click the **Accounts and Import** tab
3. Under **Send mail as**, click **Add another email address**
4. A popup opens:
   - **Name:** `Vitalii Nechypor` (or `WoofLog Support` — your call; "Vitalii Nechypor" feels more personal and fits a solo indie tone)
   - **Email address:** `support@getwooflog.com`
   - **Treat as an alias:** ✅ (checked)
   - Click **Next Step**
5. Next screen:
   - **SMTP Server:** `smtp.gmail.com`
   - **Port:** `587`
   - **Username:** your full Gmail (`<your-gmail>@gmail.com`)
   - **Password:** an **App Password** (see sub-step below if you don't have one yet)
   - **Secured connection using TLS:** ✅
   - Click **Add Account**

### Creating a Gmail App Password (if you don't have one)

If you use 2-Step Verification on your Google account (you should), Gmail requires an App Password for SMTP:

1. Go to <https://myaccount.google.com/apppasswords>
2. Sign in if prompted
3. **App name:** `WoofLog support@` → click **Create**
4. Copy the 16-character password that appears
5. Paste it into the Gmail **Password** field in the "Send mail as" setup above
6. Store a copy in your password manager — Google won't show it again

### Verify the new sender

6. After clicking **Add Account**, Gmail sends a verification email to `support@getwooflog.com`
7. That email is routed by Cloudflare → lands in your Gmail inbox within 60s
8. The email contains a confirmation link + a numeric code. Either click the link OR paste the code into the Gmail popup.

### Test sending

9. In Gmail, click **Compose**
10. Click the **From** dropdown (appears if you have multiple addresses now) → select `support@getwooflog.com`
11. Send a test email to a non-Gmail address you control (iCloud / Outlook)
12. Check that external inbox: the email should appear as `From: Vitalii Nechypor <support@getwooflog.com>`

**Known caveat:** in Gmail's web UI (when a Gmail user receives email from you), a small "via gmail.com" tag may appear next to your sender address. This is because the DKIM signature is `gmail.com`, not `getwooflog.com`. Apple Mail, Outlook mobile, and most other clients do not show this tag. Acceptable for v1.0 launch. If it becomes an issue, upgrade path is a proper mailbox at Zoho Mail free (15 min).

**Checkpoint:** you can reply from `support@getwooflog.com` and recipients see the correct sender address.

---

## Step 7 — Run the verification script (2 min)

From the repo root:

```sh
cd ~/Projects/getwooflog-com
chmod +x verify.sh
./verify.sh
```

All checks should pass. If any fail, the script will print what's missing. See the "Troubleshooting" section below.

---

## Step 8 — Manual iPhone check (5 min)

Cannot be automated. On an actual iPhone in Safari:

- [ ] Open `https://getwooflog.com/` — landing loads, tagline readable, links tappable
- [ ] Open `https://getwooflog.com/privacy/` — policy loads, no horizontal scroll
- [ ] Open `https://getwooflog.com/support/` — support loads, `mailto:` link opens Mail.app with support@ pre-filled
- [ ] iOS Settings → Accessibility → Display & Text Size → **Larger Text** → drag to max → reload `/privacy/`. Text scales, no clipping.

---

## Step 9 — Mark WS0 done in the milestone doc

In the WoofLog repo (`~/Projects/WoofLog`):

1. Open `docs/milestones/app-store-launch.md`
2. In the **WS0 — getwooflog.com** section, tick the checkboxes:
   - `[x] Pick a static host` → Cloudflare Pages
   - `[x] Publish /privacy page`
   - `[x] Publish /support page`
   - `[x] Verify URLs return 200 OK for desktop + mobile user agents`
   - `[x] Fill in placeholder contact email and data controller name`
3. Commit + push to a feature branch, open a PR, mention "WS0 complete — site live on <date>"

---

## Troubleshooting

**Pages project shows "No build output directory found"**
- Re-check Step 2.6: Build output directory should be `/` (just a slash), not empty.

**`https://getwooflog.com/` returns 522 or a Cloudflare error**
- DNS propagation. Wait 5 more minutes. If still failing after 30 minutes, check Cloudflare Pages → Custom domains tab — both domains should show "Active" status.

**SSL warning in browser**
- Cloudflare provisions SSL automatically but can take up to 15 minutes. Wait.

**Test email to support@getwooflog.com doesn't arrive**
- Check Cloudflare dashboard → Email Routing → check the destination address status — must say "Verified".
- Check the Route for `support@` — it should say "Active".
- Run `dig +short MX getwooflog.com` — if empty, MX records didn't save.

**Gmail "Send as" verification email doesn't arrive**
- Check Gmail spam folder.
- Check Cloudflare Email Routing → "Activity" tab — the incoming email from Gmail should appear there.
- If it's blocked by Cloudflare's Email Routing, the reason will be shown in the Activity log.

**"via gmail.com" tag bothers you**
- See "Optional upgrade path to Zoho Mail free" below.

---

## Optional upgrade path: proper DKIM via Zoho Mail (when/if you care)

If the "via gmail.com" tag becomes annoying or you want cleaner deliverability:

1. Sign up for [Zoho Mail Free](https://www.zoho.com/mail/zohomail-pricing.html) — free for 1 domain, up to 5 users, 5 GB/user
2. Add `getwooflog.com` as the domain
3. Zoho walks you through replacing Cloudflare's MX records with Zoho's MX records + adding a DKIM TXT record
4. Update the SPF record to `v=spf1 include:zoho.com ~all`
5. Optionally set up Zoho to forward to Gmail if you want to keep reading mail in Gmail
6. In Gmail "Send mail as", update the SMTP settings to Zoho's: `smtp.zoho.com:587`, username `support@getwooflog.com`, password = a Zoho App Password

Time: ~20 minutes. Cost: €0. Result: `From: support@getwooflog.com` with proper DKIM on getwooflog.com, no "via" tag anywhere.

Don't do this upgrade until you actually feel the friction. Shipping the current setup is the priority.
