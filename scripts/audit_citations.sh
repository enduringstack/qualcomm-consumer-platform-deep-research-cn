#!/usr/bin/env bash
set -euo pipefail

repo_dir=$(cd "$(dirname "$0")/.." && pwd)
ledger="$repo_dir/research/sources-qualcomm.md"
minimum_sources=60

mapfile_compat() {
  local target_name=$1
  shift
  eval "$target_name=()"
  while IFS= read -r item; do
    eval "$target_name+=(\"\$item\")"
  done < <("$@")
}

content_files=()
while IFS= read -r file; do
  case "$file" in
    */sources-qualcomm.md|*/references.md) ;;
    *) content_files+=("$file") ;;
  esac
done < <(find "$repo_dir/research" -maxdepth 1 -type f -name '*.md' -print | sort)

definitions_file=$(mktemp "${TMPDIR:-/tmp}/qualcomm-defs.XXXXXX")
used_file=$(mktemp "${TMPDIR:-/tmp}/qualcomm-used.XXXXXX")
trap 'rm -f "$definitions_file" "$used_file"' EXIT

rg -o '\[Q[0-9]{3}\]' "$ledger" | sort -u > "$definitions_file"
rg --no-filename -o '\[Q[0-9]{3}\]' "${content_files[@]}" | sort -u > "$used_file"

definition_count=$(wc -l < "$definitions_file" | tr -d ' ')
used_count=$(wc -l < "$used_file" | tr -d ' ')
duplicate_definition_count=$(rg -o '\[Q[0-9]{3}\]' "$ledger" | sort | uniq -d | wc -l | tr -d ' ')

undefined=$(comm -13 "$definitions_file" "$used_file")
unused=$(comm -23 "$definitions_file" "$used_file")

echo "defined_sources=$definition_count"
echo "used_sources=$used_count"
echo "duplicate_definitions=$duplicate_definition_count"

failed=0
if (( definition_count < minimum_sources )); then
  echo "FAIL: fewer than $minimum_sources source definitions" >&2
  failed=1
fi
if (( duplicate_definition_count > 0 )); then
  echo "FAIL: duplicate source definitions" >&2
  failed=1
fi
if [[ -n "$undefined" ]]; then
  echo "FAIL: undefined citations:" >&2
  echo "$undefined" >&2
  failed=1
fi
if [[ -n "$unused" ]]; then
  echo "FAIL: unused sources:" >&2
  echo "$unused" >&2
  failed=1
fi
if (( used_count != definition_count )); then
  failed=1
fi

if (( failed != 0 )); then
  exit 1
fi
echo "PASS: citation coverage gate"
