# 架构与产品术语辨析

## 1. Snapdragon、Dragonwing、Dragonfly

**Snapdragon** 是消费与汽车领域的平台品牌，可覆盖 SoC、连接、软件和体验认证，不等于单颗芯片。**Dragonwing** 用于工业/嵌入式 IoT、网络等企业基础设施组合。**Dragonfly** 是截至 2026快照的数据中心产品体系。三个品牌下仍可能复用 Qualcomm CPU、AI和连接技术。[Q003][Q068][Q079]

品牌不能替代零件号。Snapdragon X2 Elite包含多个 SKU，8 系同时有 Elite Gen 5和8 Gen 5，Dragonwing又有 Q/IQ/N/NPro/FWA。写规格时先写系列，再写平台和零件号。

## 2. SoC、SiP、平台与参考设计

**SoC** 把 CPU、GPU、NPU、ISP、IO等集成于一个硅片或封装逻辑系统。**SiP/封装系统** 可含多个裸片与存储。**平台** 还包含外置 modem-RF、FastConnect、软件和认证。**参考设计** 是供 OEM开发的板卡/终端起点，不是零售设备。

平台页写“支持”表示设计能力，终端可能裁剪。参考设计跑出的散热和性能也不能代表不同机壳。公开资料未说明单片/多片时，不根据照片推测。

## 3. Scorpion、Krait、Kryo、Oryon

Scorpion和Krait是 Qualcomm早期自定义 Arm兼容 CPU；Kryo品牌跨越自定义和基于 Arm核心的多代组合；Oryon是新一轮完全自定义 CPU路线。相同品牌不保证相同微架构，相同指令集也不保证性能。

Oryon先进入 Snapdragon X PC，再进入8 Elite手机并演进到第三代平台。[Q008][Q022][Q005][Q020] PC和手机版本受核心数、缓存、频率、内存和功耗调整，不能视为同一芯片。

## 4. Adreno

Adreno是 Qualcomm GPU品牌，承担图形、通用计算和显示相关工作。手机、PC与XR对 API、分辨率和持续功耗要求不同。官方通常不披露可与桌面 GPU直接比较的完整执行单元，第三方“核心数”不能作为唯一规格。

光线追踪是功能能力，实际帧率需游戏、驱动、内存和热。Elite Gaming是跨硬件/软件功能集合，不是一颗额外处理器。[Q063]

## 5. Hexagon、DSP、HTP 与 NPU

Hexagon起源于数字信号处理，现代实现含标量、向量和张量加速。资料中 HTP/NPU常指 AI后端，DSP也处理音频、传感和视觉。具体目标名随 SDK/平台变化，应按官方工具查询。

NPU TOPS是特定精度的理论操作率，不是模型速度。算子覆盖、量化、形状、内存和温度决定利用。QNN后端负责把模型映射到目标处理器。[Q042][Q044]

## 6. Qualcomm AI Engine

AI Engine是 CPU、GPU、Hexagon及软件的异构 AI集合，不等同 Hexagon单块 NPU。应用可把不同节点分配给不同后端。宣传中的“AI Engine性能”与“NPU TOPS”可能是不同口径，不能混用。

Sensing Hub负责低功耗始终感知，适合唤醒/情境，不等同主 NPU吞吐。微 NPU或 DSP让大处理器保持休眠，价值在平均功耗。

## 7. Spectra 与 ISP

Spectra是 Qualcomm图像信号处理品牌。ISP做传感器 RAW处理、多帧、颜色和输出，AI ISP表示与 AI/语义处理更紧密协同。20-bit描述内部处理能力，不直接等于照片文件位深。[Q020][Q037]

ISP像素率、摄像头数量和视频模式是平台上限，终端受传感器、镜头、内存、存储和热。画质是 OEM算法和硬件结果。

## 8. Modem、RF 与 Modem-RF System

modem处理数字基带协议和调制；RF收发器把数字/模拟信号连接射频；前端含功放、滤波、开关和调谐。Qualcomm用 Modem-RF System强调全链协同。X85是系统品牌，理论速率需网络条件。[Q038]

集成于 SoC、同封装和平台搭配是不同物理关系。PC平台支持 5G也可能由可选模块提供，不能从平台名判断每台终端。

## 9. FastConnect 与 Snapdragon Connect

FastConnect是 Wi-Fi/蓝牙/UWB连接系统，例如7900；Snapdragon Connect是更高层端到端体验/认证品牌。[Q039][Q040] Wi-Fi代际支持需要终端天线、路由器、法规和驱动。蓝牙 codec需要手机与耳机两端。

MLO是多链路操作，可改善吞吐、可靠或时延，实际策略由设备/网络。UWB提供精确测距，不等于 GPS，也需要双方支持与安全协议。

## 10. LPDDR、MT/s 与 GB/s

LPDDR是低功耗双倍数据率内存。MT/s是每秒百万次传输，理论 GB/s由传输率乘总位宽除八。它不含协议效率，也不表示延迟。共享内存表示多个处理器使用系统内存，不保证零拷贝和完全一致。

最大容量是控制器能力，OEM实配才是用户容量。GPU/NPU/ISP共享带宽，所有模块的峰值不能同时相加。

## 11. PCIe、USB 与 USB-C

PCIe代际和 lane共同决定理论链路，SSD还受控制器、闪存和热。USB-C是连接器，USB协议、USB4、DisplayPort和供电是不同能力。OEM可在同机不同端口实现不同功能。

用户态 x86仿真不提供 Arm64内核驱动，因此专用 USB/PCIe外设可能不兼容 Windows on Snapdragon。[Q016]

## 12. QNN、QAIRT 与 SNPE

QAIRT是当前 Qualcomm AI Runtime SDK分发入口；QNN/AI Engine Direct提供模型图和后端接口；SNPE是长期存在的神经网络部署 SDK。[Q041][Q042][Q043] 三者版本、工件和目标支持不应假定互换。

AI Hub提供模型优化与目标设备画像，[Q046] 不是设备运行时本身。Gen AI扩展封装生成模型流程，[Q045] 也不改变模型许可证。

## 13. Arm64、仿真与 Arm64EC

Arm64是 Windows on Arm原生架构；Windows可仿真许多 x86/x64用户态应用。Arm64EC允许同一进程混合 Arm64EC与 x64组件，用于渐进迁移。[Q016][Q017]

内核驱动必须为 Arm64。应用启动不代表插件、驱动、安装器、反作弊或更新器兼容。原生通常更高效，但仿真性能要实测。

## 14. Copilot+ 与 TOPS

Copilot+是 Microsoft定义的设备/Windows体验类别，NPU达到门槛只是条件之一。功能受 OS、地区、语言和应用影响。Qualcomm的45或80 TOPS是对应 NPU官方口径，不等于 Copilot服务质量。

TOPS跨厂商必须匹配精度、稀疏和计数。CPU/GPU/NPU总 AI性能与单 NPU TOPS也不是同一字段。

## 15. XR、VR、MR 与 AR

VR以虚拟显示为主；MR把现实透视与虚拟内容融合；AR叠加信息，形态可从全显示到无显示 AI眼镜。XR是总称。XR2适合一体头显，AR2适合分布式眼镜，AR1+适合轻量眼镜。[Q052][Q054][Q055]

运动到光子是姿态到显示反馈的端到端延迟；重投影用新姿态修正旧帧，不能替代真实渲染。

## 16. Snapdragon Sound、codec、ANC

Snapdragon Sound是手机—耳机端到端体验集合；codec是音频编码方式；ANC是主动降噪；通透把环境声送入。高码率、低延迟、稳定和低功耗存在权衡。[Q060]

“无损”是特定输入和链路条件，不保证扬声器输出无失真。codec显示、固件与两端认证必须核实。

## 17. Digital Chassis、Cockpit、Ride

Digital Chassis包含 Auto Connectivity、Cockpit、Ride和Car-to-Cloud。[Q073] Cockpit是座舱，Ride是ADAS/自动驾驶，Ride Flex可做混合关键性，Car-to-Cloud做生命周期服务。它不是单颗 SoC。

ASIL是功能安全完整性等级概念，平台面向标准不等于整车自动认证。设计赢单、采样、SOP与量产是不同状态。

## 18. Cloud AI、Dragonfly 与推理

Cloud AI100/Ultra是既有推理加速产品；Dragonfly是2026数据中心产品组合。[Q079][Q082] 推理不同于训练，在线延迟不同于离线吞吐。OpenAI兼容 API统一调用形状，不保证模型行为一致。[Q083]

卡级功耗不同于服务器/机架功耗，峰值吞吐不同于生产利用率。TCO包含主机、网络、软件和工程。

## 19. QCT 与 QTL

QCT是半导体和系统产品业务，QTL是技术许可业务。[Q001][Q004] QCT出货、终端出货和 QTL许可收入不是同一数量。购买芯片与签订专利许可是不同关系。

财年、自然年、设计赢单、管线和确认收入必须分开。市场分析应回到 SEC/IR定义。[Q002]

## 20. Active、发布、采样与上市

Active是网站目录状态；发布是责任主体公布；采样是向合作伙伴供样；预计可用是未来计划；OEM宣布是设备公布；上市/量产需要更强证据。任何路线图都保留这些词。

术语辨析的目的不是挑字眼，而是防止层次错误。Qualcomm产品体系横跨多个市场，同一个词若不带对象、状态和口径，很容易把能力上限写成用户事实。
