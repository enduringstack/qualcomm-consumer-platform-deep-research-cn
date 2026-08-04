#!/usr/bin/env bash
set -euo pipefail

repo_dir=$(cd "$(dirname "$0")/.." && pwd)
ledger="$repo_dir/research/sources-qualcomm.md"
minimum_sources=60

content_files=()
while IFS= read -r file; do
  case "$file" in
    */sources-qualcomm.md|*/references.md) ;;
    *) content_files+=("$file") ;;
  esac
done < <(find "$repo_dir/research" -maxdepth 1 -type f -name '*.md' -print | sort)

source_entries_file=$(mktemp "${TMPDIR:-/tmp}/qualcomm-source-entries.XXXXXX")
definitions_file=$(mktemp "${TMPDIR:-/tmp}/qualcomm-defs.XXXXXX")
source_urls_file=$(mktemp "${TMPDIR:-/tmp}/qualcomm-source-urls.XXXXXX")
used_file=$(mktemp "${TMPDIR:-/tmp}/qualcomm-used.XXXXXX")
matrix_ids_file=$(mktemp "${TMPDIR:-/tmp}/qualcomm-matrix-ids.XXXXXX")
trap 'rm -f "$source_entries_file" "$definitions_file" "$source_urls_file" "$used_file" "$matrix_ids_file"' EXIT

perl -ne '
  if (/^- \[(Q\d{3})\].*?(https?:\/\/\S+)\s*$/) {
    print "[$1]\t$2\n";
  } elsif (/^- \[Q\d{3}\]/) {
    die "malformed source entry at line $.: $_";
  }
' "$ledger" > "$source_entries_file"

cut -f1 "$source_entries_file" | sort -u > "$definitions_file"
cut -f2 "$source_entries_file" | sort -u > "$source_urls_file"
rg --no-filename -o '\[Q[0-9]{3}\]' "${content_files[@]}" | sort -u > "$used_file"

python3 - "$repo_dir/data/product-matrix.csv" > "$matrix_ids_file" <<'PY'
import csv
import re
import sys

path = sys.argv[1]
with open(path, encoding="utf-8", newline="") as handle:
    reader = csv.DictReader(handle)
    if "evidence_ids" not in (reader.fieldnames or []):
        raise SystemExit("product matrix is missing evidence_ids column")
    ids = set()
    row_count = 0
    for line_number, row in enumerate(reader, start=2):
        row_count += 1
        value = (row.get("evidence_ids") or "").strip()
        if not value:
            raise SystemExit(f"product matrix row {line_number} has no evidence_ids")
        tokens = value.split()
        malformed = [token for token in tokens if not re.fullmatch(r"Q\d{3}", token)]
        if malformed:
            raise SystemExit(
                f"product matrix row {line_number} has malformed evidence IDs: "
                + ", ".join(malformed)
            )
        ids.update(f"[{token}]" for token in tokens)
    if row_count == 0:
        raise SystemExit("product matrix has no data rows")
for source_id in sorted(ids):
    print(source_id)
PY

definition_count=$(wc -l < "$definitions_file" | tr -d ' ')
used_count=$(wc -l < "$used_file" | tr -d ' ')
matrix_id_count=$(wc -l < "$matrix_ids_file" | tr -d ' ')
duplicate_definition_count=$(cut -f1 "$source_entries_file" | sort | uniq -d | wc -l | tr -d ' ')
duplicate_url_count=$(cut -f2 "$source_entries_file" | sort | uniq -d | wc -l | tr -d ' ')

undefined=$(comm -13 "$definitions_file" "$used_file")
unused=$(comm -23 "$definitions_file" "$used_file")
undefined_matrix=$(comm -13 "$definitions_file" "$matrix_ids_file")

echo "defined_sources=$definition_count"
echo "used_sources=$used_count"
echo "matrix_source_ids=$matrix_id_count"
echo "duplicate_definitions=$duplicate_definition_count"
echo "duplicate_source_urls=$duplicate_url_count"

failed=0
if (( definition_count < minimum_sources )); then
  echo "FAIL: fewer than $minimum_sources source definitions" >&2
  failed=1
fi
if (( duplicate_definition_count > 0 )); then
  echo "FAIL: duplicate source definition IDs:" >&2
  cut -f1 "$source_entries_file" | sort | uniq -d >&2
  failed=1
fi
if (( duplicate_url_count > 0 )); then
  echo "FAIL: duplicate source URLs:" >&2
  cut -f2 "$source_entries_file" | sort | uniq -d >&2
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
if [[ -n "$undefined_matrix" ]]; then
  echo "FAIL: product matrix uses undefined source IDs:" >&2
  echo "$undefined_matrix" >&2
  failed=1
fi
if (( used_count != definition_count )); then
  failed=1
fi

if (( failed != 0 )); then
  exit 1
fi
echo "PASS: citation structure gate (semantic support requires manual review)"
