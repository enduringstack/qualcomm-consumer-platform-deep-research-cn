# Qualcomm Consumer Platform Deep Research CN

截至 2026-08-04 的 Qualcomm 消费端与完整产品体系中文深度研究。报告以 Snapdragon PC/手机为主线，覆盖 XR/AR、穿戴、音频、掌机、家庭网络、Dragonwing IoT、Snapdragon Digital Chassis、Cloud AI/Dragonfly 数据中心，以及 QCT/QTL 商业模式。

## 直接阅读

- [合并版深度报告](QUALCOMM_CONSUMER_PLATFORM_DEEP_RESEARCH.md)
- [编辑规范与证据等级](research/editorial.md)
- [综合判断](research/executive-synthesis.md)
- [架构演进](research/architecture-evolution.md)
- [架构术语](research/architecture-glossary.md)
- [消费产品体系](research/consumer-products.md)
- [完整产品组合](research/product-portfolio.md)
- [内存与端到端协同](research/memory-interconnect.md)
- [软件与 AI 生态](research/software-ai-ecosystem.md)
- [市场与竞争](research/market-competition.md)
- [正式路线图与风险](research/roadmap-risks.md)
- [来源账本](research/sources-qualcomm.md)
- [代表产品矩阵](data/product-matrix.csv)

## 工程专题

- [Snapdragon PC 兼容性与持续性能](research/pc-compatibility-fieldbook.md)
- [手机影像、无线与稳态体验](research/mobile-imaging-wireless-fieldbook.md)
- [XR、AI 眼镜、手表与音频](research/xr-wear-audio-fieldbook.md)
- [跨设备端侧 AI 案例库](research/cross-device-ai-casebook.md)
- [IoT、网络、汽车与数据中心部署](research/edge-auto-datacenter-fieldbook.md)
- [平台选型与采购](research/platform-selection-playbook.md)
- [生命周期、安全与运营](research/lifecycle-security-operations.md)
- [失效模式与根因分析](research/failure-analysis.md)

## 事实边界

报告始终区分 SoC、平台、终端 SKU 和 OEM 设备；区分发布、预计可用、OEM 宣布、上市与量产。峰值频率、TOPS、带宽和无线速率只按来源定义使用。厂商代际百分比保留自测属性，路线图不纳入传闻。产品页标记 Active 不等于全球供货或所有功能均被终端采用。

所有 89 个编号来源均来自 Qualcomm/SEC、操作系统责任主体或竞品对自身产品负责的页面，并须被正文实际引用。链接 403、429 或超时只报告为网络限制；404/410 才是硬失败，避免把无法访问伪装成已核验。

## 重建与验收

```bash
bash scripts/assemble_report.sh
bash scripts/check_report.sh
bash scripts/audit_citations.sh
perl scripts/check_duplicates.pl .
bash scripts/check_links.sh
git diff --check
```

`assemble_report.sh` 按固定章节顺序生成合并版。长度门禁在去除代码、行内代码和 URL 后按 Unicode Han 字符计数，阈值为 50,000；引用门禁要求不少于 60 个来源、无未定义引用、无未使用来源；重复门禁对规范化后至少 160 字的段落做精确查重。

## 使用方式

技术选型先从场景章节建立数据路径，再查产品矩阵与完整产品页，最后用对应实战手册做终端/样机验证。财务与市场内容是产业分析，不构成投资建议；汽车、健康、安全、专利和合规事项需由相应专业人员确认。

本仓库采用快照研究方式。后续更新应先修改来源账本和矩阵，再更新分析，重建合并版并重新执行全部门禁。
