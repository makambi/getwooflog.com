#!/usr/bin/env bash
# verify.sh — post-deploy verification for getwooflog.com
# Run after the RUNBOOK steps complete. Exits non-zero if any check fails.

set -u

DOMAIN="getwooflog.com"
FAIL=0
PASS=0

green() { printf "\033[32m%s\033[0m" "$1"; }
red()   { printf "\033[31m%s\033[0m" "$1"; }
dim()   { printf "\033[2m%s\033[0m" "$1"; }

check() {
  local label="$1"
  local cmd="$2"
  local out
  if out=$(eval "$cmd" 2>&1); then
    printf "  [%s] %s\n" "$(green "PASS")" "$label"
    PASS=$((PASS + 1))
  else
    printf "  [%s] %s\n" "$(red "FAIL")" "$label"
    printf "         %s\n" "$(dim "$out")"
    FAIL=$((FAIL + 1))
  fi
}

echo
echo "=== HTTP reachability ==="
check "GET https://$DOMAIN/ returns 200"            "curl -sSfI https://$DOMAIN/ -o /dev/null"
check "GET https://$DOMAIN/privacy/ returns 200"    "curl -sSfI https://$DOMAIN/privacy/ -o /dev/null"
check "GET https://$DOMAIN/support/ returns 200"    "curl -sSfI https://$DOMAIN/support/ -o /dev/null"
check "GET https://www.$DOMAIN/ returns 200 or 301" \
  "code=\$(curl -sS -o /dev/null -w '%{http_code}' https://www.$DOMAIN/); [[ \$code == 200 || \$code == 301 ]]"

echo
echo "=== Content correctness ==="
check "Privacy page names 'Vitalii Nechypor'"      "curl -sSf https://$DOMAIN/privacy/ | grep -q 'Vitalii Nechypor'"
check "Privacy page links support@ email"          "curl -sSf https://$DOMAIN/privacy/ | grep -q 'support@getwooflog.com'"
check "Privacy page has 'Last updated' meta"       "curl -sSf https://$DOMAIN/privacy/ | grep -q 'Last updated'"
check "Privacy page has NO subscription section"   "! curl -sSf https://$DOMAIN/privacy/ | grep -q 'Subscription and payment data'"
check "Support page has NO subscription Q&A"       "! curl -sSf https://$DOMAIN/support/ | grep -q 'manage or cancel my subscription'"
check "Support page mentions 'Delete All Data'"    "curl -sSf https://$DOMAIN/support/ | grep -q 'Delete All Data'"
check "Landing page has brand name 'WoofLog'"      "curl -sSf https://$DOMAIN/ | grep -q 'WoofLog'"

echo
echo "=== DNS / email routing ==="
check "MX records present (Cloudflare)"            "dig +short MX $DOMAIN | grep -q 'mx.cloudflare.net'"
check "SPF record includes Google"                 "dig +short TXT $DOMAIN | grep -q '_spf.google.com'"
check "SPF record includes Cloudflare"             "dig +short TXT $DOMAIN | grep -q '_spf.mx.cloudflare.net'"

echo
echo "=== Summary ==="
if [[ $FAIL -eq 0 ]]; then
  printf "  %s — %d checks passed\n" "$(green "ALL GOOD")" "$PASS"
  echo
  echo "  Remaining manual checks (see RUNBOOK.md Step 8):"
  echo "    - Load on physical iPhone in Safari"
  echo "    - Send test email from iCloud/Outlook → support@getwooflog.com"
  echo "    - Reply from Gmail, confirm sender shows correctly"
  exit 0
else
  printf "  %s — %d passed, %d failed\n" "$(red "FAILURES")" "$PASS" "$FAIL"
  echo
  echo "  See RUNBOOK.md 'Troubleshooting' section."
  exit 1
fi
