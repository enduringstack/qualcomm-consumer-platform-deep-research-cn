#!/usr/bin/env bash
set -euo pipefail

repo_dir=$(cd "$(dirname "$0")/.." && pwd)
output="$repo_dir/QUALCOMM_CONSUMER_PLATFORM_DEEP_RESEARCH.md"
temp_output=$(mktemp "${TMPDIR:-/tmp}/qualcomm-report.XXXXXX")
trap 'rm -f "$temp_output"' EXIT

parts=(
  research/editorial.md
  research/executive-synthesis.md
  research/architecture-evolution.md
  research/architecture-glossary.md
  research/consumer-products.md
  research/product-portfolio.md
  research/memory-interconnect.md
  research/software-ai-ecosystem.md
  research/pc-compatibility-fieldbook.md
  research/mobile-imaging-wireless-fieldbook.md
  research/xr-wear-audio-fieldbook.md
  research/cross-device-ai-casebook.md
  research/edge-auto-datacenter-fieldbook.md
  research/platform-selection-playbook.md
  research/lifecycle-security-operations.md
  research/failure-analysis.md
  research/market-competition.md
  research/roadmap-risks.md
  research/references.md
  research/sources-qualcomm.md
)

for part in "${parts[@]}"; do
  if [[ ! -f "$repo_dir/$part" ]]; then
    echo "missing source part: $part" >&2
    exit 1
  fi
done

{
  echo '# Qualcomm 消费端与完整产品体系深度研究'
  echo
  echo '> 快照日期：2026-08-04。本文由仓库内独立研究章节确定性生成；产品、软件与路线图只采用截至快照已正式披露的信息。'
  echo
  echo '本报告覆盖 Snapdragon PC、手机、XR/AR、穿戴、音频、掌机、家庭网络、IoT、汽车、Cloud AI/数据中心及 QCT/QTL 商业模式，并从 CPU、GPU、NPU、ISP、DSP、内存、PCIe、USB、蜂窝、Wi-Fi 和软件栈解释端到端协同。'
  echo
  echo '---'
  for part in "${parts[@]}"; do
    echo
    perl -pe 's/^(#+) /#$1 /' "$repo_dir/$part"
    echo
    echo '---'
  done
} > "$temp_output"

mv "$temp_output" "$output"
trap - EXIT
echo "assembled: $output"
