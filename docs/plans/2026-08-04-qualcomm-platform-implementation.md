# Qualcomm Consumer Platform Deep Research Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** 建立并公开发布一个经过来源、字数、重复、链接和敏感信息门禁验证的 Qualcomm 消费端与完整产品体系中文深度研究仓库。

**Architecture:** 采用九篇独立研究章节、一个机器可读产品矩阵和一个统一编号来源账本。Shell/Perl 脚本负责确定性装配与静态审计，所有变化性事实以 2026-08-04 为快照边界。

**Tech Stack:** Markdown、CSV、POSIX shell、Perl、Git、GitHub CLI、Qualcomm/SEC/合作方一手网页。

---

### Task 1: 建立仓库与设计基线

**Files:**
- Create: `docs/plans/2026-08-04-qualcomm-platform-design.md`
- Create: `docs/plans/2026-08-04-qualcomm-platform-implementation.md`

**Steps:**
1. 创建目录并以 `main` 分支初始化 Git。
2. 用 `git diff --check --cached` 检查设计文档。
3. 提交 `docs: design Qualcomm platform research repository`。

### Task 2: 建立来源账本和编辑规范

**Files:**
- Create: `research/editorial.md`
- Create: `research/sources-qualcomm.md`
- Create: `research/references.md`

**Steps:**
1. 检索 Qualcomm 官方产品、开发者、IR/10-K 与责任主体的一手页面。
2. 为至少 60 个实际来源分配唯一 `Q001` 形式编号，并记录标题、发布者、日期、URL、用途与证据等级。
3. 写清 SoC/平台/终端/OEM、性能、功耗、路线图和第三方测试口径。
4. 运行引用审计，预期在正文完成前报告未使用来源，作为失败基线。

### Task 3: 撰写架构、消费产品与产品组合

**Files:**
- Create: `research/architecture-evolution.md`
- Create: `research/consumer-products.md`
- Create: `research/product-portfolio.md`
- Create: `data/product-matrix.csv`

**Steps:**
1. 写 CPU、Adreno、Hexagon、Spectra、modem-RF/FastConnect 的代际演进和数据流。
2. 覆盖 X/8cx/7c 与 Oryon、手机 8/7/6/4、XR/AR、wearables/audio、gaming/handheld、home/networking/IoT。
3. 延伸汽车、Cloud AI、专利授权与业务模式，避免把非消费业务写成消费产品。
4. 给代表产品建立可追溯规格矩阵，并对未知字段留空而非推测。

### Task 4: 撰写系统协同与软件生态

**Files:**
- Create: `research/memory-interconnect.md`
- Create: `research/software-ai-ecosystem.md`

**Steps:**
1. 分析缓存/LPDDR、内存一致性、PCIe/USB、无线、相机与显示路径。
2. 分析 CPU/GPU/NPU/ISP/DSP 之间的拷贝、同步、功耗和热约束。
3. 覆盖 QNN、SNPE、AI Hub、ONNX/框架入口、Windows on Snapdragon 与 Android 软件栈。
4. 给出兼容性和持续性能诊断清单，不把峰值 TOPS 当应用吞吐。

### Task 5: 撰写竞争、市场、路线图和风险

**Files:**
- Create: `research/market-competition.md`
- Create: `research/roadmap-risks.md`

**Steps:**
1. 以相同设备类别和功耗边界比较 Apple、Intel、AMD、MediaTek、Samsung、NVIDIA。
2. 使用 10-K/IR 区分 QCT、QTL、终端市场和授权经济性。
3. 只把正式发布/宣布项目写入路线图，其他内容标为情景而非事实。
4. 建立技术、生态、供应链、监管、客户集中与执行风险登记表。

### Task 6: 建立装配和质量门禁

**Files:**
- Create: `scripts/assemble_report.sh`
- Create: `scripts/check_report.sh`
- Create: `scripts/audit_citations.sh`
- Create: `scripts/check_duplicates.pl`
- Create: `scripts/check_links.sh`
- Create: `README.md`
- Generate: `QUALCOMM_CONSUMER_PLATFORM_DEEP_RESEARCH.md`

**Steps:**
1. 固定章节装配顺序并生成合并版。
2. 验证合并版 Unicode 汉字数至少 50,000。
3. 验证引用无未定义、来源无未使用，且实际使用来源不少于 60。
4. 验证长段落重复为 0，404/410 硬失败为 0。
5. 执行 `git diff --check` 和令牌/私钥模式敏感信息扫描。

### Task 7: 提交、发布和远端审计

**Files:**
- Commit all report, data, scripts, and generated files.

**Steps:**
1. 提交 `docs: publish Qualcomm consumer platform deep research`。
2. 若远端不存在，运行 `gh repo create enduringstack/qualcomm-consumer-platform-deep-research-cn --public --source=. --remote=origin --push`；若存在，先读取其默认分支与历史，再以非破坏方式添加 remote 并推送。
3. 用 GitHub API 验证 `visibility=PUBLIC`、`default_branch=main`、远端 HEAD 与本地 SHA 一致。
4. 对 README、合并版、九篇研究文档、CSV、五个脚本和两个计划逐一查询远端可见性。
