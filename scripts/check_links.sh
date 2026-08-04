#!/usr/bin/env bash
set -euo pipefail

repo_dir=$(cd "$(dirname "$0")/.." && pwd)
urls_file=$(mktemp "${TMPDIR:-/tmp}/qualcomm-urls.XXXXXX")
results_file=$(mktemp "${TMPDIR:-/tmp}/qualcomm-links.XXXXXX")
trap 'rm -f "$urls_file" "$results_file"' EXIT

rg --no-filename -o 'https?://[^[:space:]]+' "$repo_dir/research/sources-qualcomm.md" \
  | sed 's/[.,;:]$//' | sort -u > "$urls_file"

check_url() {
  local url=$1
  local code
  code=$(curl -L --max-time 25 --connect-timeout 8 -A 'Mozilla/5.0 citation-audit' \
    -sS -o /dev/null -w '%{http_code}' "$url" 2>/dev/null || true)
  [[ -n "$code" ]] || code=000
  printf '%s\t%s\n' "$code" "$url"
}
export -f check_url

xargs -P 12 -n 1 bash -c 'check_url "$1"' _ < "$urls_file" | sort > "$results_file"

total=$(wc -l < "$results_file" | tr -d ' ')
ok=$(awk -F '\t' '$1 >= 200 && $1 < 400 {n++} END {print n+0}' "$results_file")
hard=$(awk -F '\t' '$1 == 404 || $1 == 410 {n++} END {print n+0}' "$results_file")
soft=$(awk -F '\t' '$1 == 0 || $1 == 000 || $1 == 403 || $1 == 429 || $1 >= 500 {n++} END {print n+0}' "$results_file")

echo "links_total=$total"
echo "links_2xx_3xx=$ok"
echo "links_soft_restriction_or_transient=$soft"
echo "links_404_410=$hard"
awk -F '\t' '$1 !~ /^[23]/ {print "status=" $1 " url=" $2}' "$results_file"

if (( hard > 0 )); then
  echo "FAIL: hard link failures detected" >&2
  exit 1
fi
echo "PASS: no 404/410 link failures"
