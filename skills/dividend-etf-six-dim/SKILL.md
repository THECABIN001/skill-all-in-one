---
name: dividend-etf-six-dim
description: 红利ETF六维监测——红利拥挤度评分 RCS 可视化。六维度加权合成 0-100 拥挤度评分，输出 HTML 可视化仪表盘。Use when user says「红利六维」「红利拥挤度」「红利etf六维监测」「RCS」。
---

# 金融-红利ETF六维监测：红利拥挤度评分（RCS）· 可视化监测

> **一句话**：把「红利是否拥挤」拆成六个可量化维度（估值温度 / 资金流入 / 相对动量 / 交易热度 / 持仓集中 / 基本面背离），加权合成 0–100 分，最终输出一份**优雅的 HTML 可视化网页**——仪表盘是仪表盘，不是水晶球。
>
> **触发方式**：`/金融-红利etf六维监测`；运行时的唯一交付物是**一个 HTML 文件**（排版合理、数据自洽、可直接浏览器打开）。
>
> **研究用途，不构成投资建议。** 历史分位、阈值与权重是**待回测校准的起点**，不是自然定律。

---

## 1. 模型框架

### 1.1 三个问题 → 六个维度

拥挤的实质是「投资者之间的差异正在消失：持仓相似、预期相似、退出方向也相似」。我们无法看到每户真实仓位，只能用公开数据从**价格、资金、基本面**三个侧面间接观察，对应回答三个问题：

| 问题 | 覆盖维度 | 权重 |
|---|---|---|
| **钱，来了多少？** | ② 资金流入 | **29%** |
| **价格，热了多少？** | ③ 相对动量 + ④ 交易热度 | 21% + 21% |
| **现金流，跟上了多少？** | ⑥ 基本面背离 | **29%** |
| **贵了吗？**（独立温度计） | ① 估值温度 | 不计入总分 |
| （退出风险，独立标注） | ⑤ 持仓集中与重叠 | 不计入总分 |
| | **合计** | **100%** |

> **v1.6 架构升级**：综合分只回答"拥挤吗"（资金/动量/热度/背离 4 维），估值温度独立成"贵吗"仪表，持仓集中独立成"退出风险"标注。**估值不计入总分**——它只在三信号共振成立时作确认/升级条件，避免"贵"污染"拥挤"的信号纯度。权重配方仍是**等待回测与校准的起点**。

### 1.2 常见误区（建模前先排除）

1. **ETF 规模大 ≠ 最近资金大量流入**。规模 = 份额 × 净值，净值上涨规模也会自然变大。看资金流重点看**份额变化**；估算净申购额 = 本期份额变化 × 上一期单位净值。
2. **估值上涨 ≠ 持仓已高度趋同**。
3. **讨论度高 ≠ 投资者已真金白银重仓**。
4. 任何一个单项都不能替代组合。

### 1.3 评分方法：历史百分位

不同指标单位不同，不能直接相加。**把每个指标换算成历史百分位**：处于过去 10 年 90% 分位即记 90 分。

- 对**股息率、股债利差**这类「越低越危险」的指标，用**反向百分位**（= 100 − 正向百分位，值越低分越高 → 拥挤分越高）。
- 对 **PE、PB** 这类「**越高越危险**」的指标，**直接用正向百分位**（不反向），分位越高 → 拥挤分越高。
- 建议**每日采集、按周输出**；窗口不足 10 年时至少用 5 年。

### 1.4 综合分区间

综合分 RCS = 4 维拥挤分（资金/动量/热度/背离），区间：

| 综合分 | 状态 |
|---|---|
| < 40 | 低拥挤 |
| 40–60 | 正常 |
| 60–75 | 明显升温 |
| 75–85 | 高拥挤 |
| > 85 | 极端拥挤 |

**估值温度计单独分档**：`< 40 低估 · 40–60 中性 · 60–80 偏高 · > 80 高估`（不参与上表）。

### 1.5 预警规则（过滤单周异常）

- **更稳妥的预警条件**：综合分**连续四周 > 75**，且**至少三个分项 > 80**。
- 阈值应在**历史样本外检验**，而不是根据已知结果倒推。
- 不要因某一周超 75 分就断言见顶。

### 1.6 三信号共振（真正接近危险拥挤的充分必要条件）

1. **ETF 份额持续快速增长**；
2. **价格与相对动量明显升温**；
3. **盈利 / 自由现金流 / 分红覆盖开始背离**。

> **少一个条件，结论都要更克制。** 拥挤不是风险，退出时所有人方向一致才是风险。

### 1.7 拥挤 × 韧性 四象限

横轴 = 基本面韧性（100 − 基本面背离分），纵轴 = 拥挤度（综合分）：

| | 强基本面 | 弱基本面 |
|---|---|---|
| **低拥挤** | 舒适区 | 价值陷阱（警惕） |
| **高拥挤** | 热门但有现金流支撑 | **最危险组合** |

### 1.8 红利指数的反拥挤机制

股息率选样/加权的红利指数自带一点反拥挤机制（股价大涨而分红不变 → 股息率下降 → 定期调整时降权），但它是**调仓时点生效**，两次调仓之间资金仍可能集中；单只权重上限消除不了**行业集中与跨指数持仓重叠**。结论：**有反拥挤机制，绝不是拥挤免疫系统**。

---

## 2. 数据获取（必须联网，禁止用训练知识）

每个维度独立取数，所有数据记录**观察日 + 来源 + 口径**。搜索关键词一律带「最新」。

### 2.1 数据源优先级

1. 中证指数官网 / 基金定期报告 / 交易所（官方口径优先「计算用股本」）
2. 基金公司官网、指数公司事实表
3. 理杏仁 / Wind / 蛋卷等可复现数据库
4. 券商研报与媒体仅作交叉验证

### 2.2 数据质量分级

| 等级 | 条件 | 处理 |
|---|---|---|
| A | 官方或两家独立可靠来源一致 | 正常输出 |
| B | 单一可靠来源，或分位差 ≤ 10pp | 可输出，标注「交叉验证待补」 |
| C | 分位差 > 10pp、滞后或关键字段缺失 | 仅观察，综合分标注「低置信」 |
| D | 口径不明 / 无法复现 | 不评分，标注缺失维度 |

### 2.3 各维度取数清单

| 维度 | 子指标 | 搜索/取数方式 |
|---|---|---|
| **① 估值温度** | 股息率（含历史分位） | **理杏仁 API**（见 §2.5）：`dyr.y10.mcw.cvpos` 直接返回 10 年市值加权分位；`dyr.mcw` 当前值 |
| | 股债利差（股息率 − 10年国债） | 理杏仁 `dyr.mcw` − akshare `bond_zh_us_rate` 10年国债 |
| | PE 分位（**正向，不反向**） | **理杏仁 API**：`pe_ttm.y10.mcw.cvpos`（PE 越高越险，直接用分位） |
| **② 资金流入** | 20日ETF总份额增长率 | `红利ETF 份额 变化 最新`（天天基金/东财，需按产品分类汇总：红利/红利低波/央企红利，同基金不同份额去重，勿与底层ETF重复） |
| | 60日估算净申购额 | 份额变化 × 上期单位净值 |
| | 红利净申购占权益ETF净申购比 | `红利ETF 净申购 资金流向 最新` |
| | 资金容量比（红利类规模 / 成分股20日均额） | `红利指数 成分股 成交额` 估算 |
| **③ 相对动量** | 12个月超额（红利 vs 沪深300） | `中证红利 沪深300 超额收益 最新` |
| | 价格偏离250日均线 / 年波动率 | 行情数据自行计算 |
| | 60日相对收益加速 | 行情数据自行计算 |
| **④ 交易热度** | 成分股换手率分位 | `红利指数 换手率 分位 最新` |
| | 红利ETF成交占权益ETF成交比 | `红利ETF 成交额 占比 最新` |
| | ETF 溢价/折价与买卖价差异常 | `红利ETF 溢价 折价 最新` |
| **⑤ 持仓集中** | 指数前十大成分股权重 | `中证红利 前十大权重 最新` |
| | 第一大/前三大行业权重 | `中证红利 行业分布 最新` |
| | 主流红利指数持仓重合度（Σmin共同成分权重） | `红利低波 央企红利 成分重合 最新` |
| **⑥ 基本面背离** | 价格 vs 加权净利润增速背离 | `红利指数 成分股 净利润 增速 最新` |
| | 股利支付率变化 | `红利指数 成分股 股利支付率 最新` |
| | 自由现金流 / 现金分红覆盖 | `红利指数 自由现金流 分红 覆盖 最新` |
| | 削减分红/盈利下修成分股比例 | `红利指数 成分股 分红 下修 最新` |

> 若某项无法精确取数，可用近似口径并在报告标注「估算」。**缺口超过 30% 的维度该维度按余项重新归一，且综合分质量降级。**

### 2.4 百分位数据来源与可靠性（诚实说明）

不同指标的「历史百分位」可靠度差异很大，输出时必须按下列口径如实标注（对应数据质量 §2.2），**不得把所有百分位都当作同等可靠**：

| 可靠度 | 指标 | 现状与建议 |
|---|---|---|
| **较可靠**（有权威实时源） | 股息率、PE、PB、股债息差的 10 年/5 年分位 | 理杏仁/蛋卷/中证官网可查绝对值+分位；**必须统一统计窗口**（10年 vs 5年 vs 1年差异可达 20pp+），报告须注明所用窗口 |
| **部分可靠**（需自行累计） | 20日份额增长率、60日估算净申购额、成交额占比、溢价折价 | 天天基金/东财有份额与成交日数据，需自行滚动累计 20/60 日；百分位需要历史序列，无历史序列时标注「估算」 |
| **估算为主**（无公开实时序列） | 换手率分位、净利增速背离、股利支付率变化、自由现金流覆盖、削减分红/盈利下修占比 | 无公开的 10 年成分股级序列，只能靠研报二手数据或抽样估算，**必须标「~」并降数据质量为 C** |

**结论**：估值三件套（股息率 / PE / 息差）的百分位可靠可复现，占估值维度的全部权重；其余五个维度的部分子项当前为近似估计，报告中逐项标注「~」。若要整体严谨，需引入本地数据管道（如 akshare 拉指数与成分股历史序列）或订阅理杏仁 / Wind API，把每个指标的历史分位真正算出后回填——这是 v2.0 的升级方向。

### 2.5 理杏仁 API（已验证可用 · 官方数据接口全维度覆盖）

**通用**：`POST https://open.lixinger.com/api/cn/...`，JSON body 带 `token`（用户专属 key）。token 只认证、无签名。**指标用市值加权 `mcw`（官方权威口径），优先于等权 `ew`。** 请求须带 `date` 或 `startDate+endDate`（不带会 400）。

**各维度对应接口**（全部实测返回真实数据，中证红利 000922）：

| 维度 | 接口 | 请求要点 | 关键返回 |
|---|---|---|---|
| **① 估值** | `/index/fundamental` | `metricsList`: `pe_ttm.y10.mcw.cvpos`, `pb.y10.mcw.cvpos`, `dyr.y10.mcw.cvpos`, `pe_ttm.mcw`, `dyr.mcw`, `cp` | PE/PB/股息率 **10年市值加权分位** + 当前值（估值维度全部子项） |
| **② 资金** | `/index/hot/ifet_sni` | `stockCodes` | `ifet_as`（场内基金规模）、`ifet_sni_w1/w2/m1/m3/m6/y1/fys`（净流入：1周~2年+今年以来） |
| **③ 动量** | `/index/hot/cp` | `stockCodes` + 周期参数 | 1周~10年各周期收益率（算 12 月超额、60 日加速） |
| **④ 热度** | `/index/hot/tr` | `stockCodes` | `tr_d1/5/10/20/60/120/240`（各周期换手率）、`ta`（成交额） |
| **⑤ 集中** | `/index/hot/ic` | `stockCodes` | `ic_t10_ws`（前十大权重占比）、`ic_num`（样本数） |
| | `/index/constituent-weightings` | **`stockCode`（单数）** + 日期范围 | 成分股逐日权重（算行业集中/重叠） |
| **⑥ 基本面** | `/index/fs/hybrid` | `metricsList`: `q.ps.np.t`, `q.ps.np.ttm`, `q.cfs.ncffoa.ttm` | 净利润/归母净利/经营现金流（季度/TTM，算背离） |
| **宏观** | `/macro/...` | 国债收益率 | 股债利差 |

**估值指标格式**：`[metricsName].[granularity].[metricsType].[statisticsDataType]`
- `metricsName`：`pe_ttm`/`pb`/`ps_ttm`/`dyr`（股息率）/`cp`（点位）/`to_r`（换手率）/`fet_snif_ma`（基金净流入）
- `granularity`：`y1`/`y3`/`y5`/`y10`/`y20`/`fs`（上市以来）
- `metricsType`：`mcw`（市值加权）/`ew`（等权）/`median`/`avg`
- `statisticsDataType`：`cvpos`（分位%）、`cv`（当前值）、`q2v/q5v/q8v`（分位值）、`avgv/maxv/minv`

**财务指标格式**：`[报表].[指标].[统计]`，如 `q.ps.np.ttm`（季度净利润 TTM）、`q.cfs.ncffoa.ttm`（经营现金流 TTM）、`q.ps.toi.ttm`（营收 TTM）。报表前缀 `q`(季度)/`hy`(半年)/`y`(年)，指标 `ps.*`(利润表)/`bs.*`(资产负债表)/`cfs.*`(现金流量表)。

**实测数据**（2026-07-31，中证红利 000922，**市值加权 mcw**）：股息率 **4.14%**（10年分位 **21.5%**）· PE **8.73**（10年分位 **82.8%**，**直接用分位不反向**）· PB 分位 51.6% · 前十大权重 **18.97%** · 场内基金规模 339亿 · 20日换手率 3.39% · **近1周净流出6.6亿、近2周流出13.5亿、3月净流入83.9亿**。
> 注意：必须用 **`mcw`（市值加权）** 口径，与理杏仁网站一致；`ew`（等权）分位会与网站显示差异很大（如股息率分位 ew=31% vs mcw=21.5%）。

**指数代码**：中证红利 `000922`；红利低波 `H30269`；上证红利 `000015`。
**注意**：`fundamental`/`fs` 接口传 `startDate` 时只能传**单**指数；`constituent-weightings` 用 `stockCode`（单数）。理杏仁官方 skill 包位于 `C:\Users\Cabin\Downloads\lixinger-open-skill`，接口文档在 `api-docs/` 目录。

---

## 3. 评分计算

### 3.1 维度结构与权重（v1.6 重构：拥挤分 4 维 + 独立估值温度计）

**模型改为「拥挤分 + 估值温度计」双轨**：
- **综合分 RCS**（回答"拥挤吗"）= 4 维：资金 / 动量 / 热度 / 背离
- **估值温度计**（回答"贵吗"）= 独立仪表，**不参与拥挤总分**，只在三信号共振成立时作确认/升级条件
- **持仓集中** = 独立"退出风险"标注（前十大权重、行业集中），不混入总分

**综合分 4 维权重**（资金20/动量15/热度15/背离20 归一化）：

| 维度 | 归一化权重 | 子项权重 |
|---|---|---|
| ② 资金流入 | **29%** | 场内基金净流入(周/月/季) 40% · 近1周净流入 30% · 近3月净流入 15% · 近6月净流入 15% |
| ③ 相对动量 | **21%** | 近1年涨跌幅 40% · 近1月涨跌幅 35% · 250日线偏离 25% |
| ④ 交易热度 | **21%** | 20日换手率 40% · 60日换手率 35% · 日成交额 25% |
| ⑥ 基本面背离 | **29%** | 净利TTM同比 35% · 营收TTM同比 25% · 经营现金流TTM 25% · 盈利健康度 15% |

**独立估值温度计**（V 因子骨架 + 息差 Z 值，不参与总分）：

```
第一步：三个"危险度"（高分=危险）
  股息率反分   = 100 − 股息率分位        （越低越险）
  PE正分      = PE 分位                  （越高越险，直接用）
  PB正分      = PB 分位                  （越高越险，直接用）

第二步：股息率经息差 Z 校正（min 消除镜像冗余）
  息差        = 股息率 − 10年国债
  息差Z       = (当前息差 − 近4年均值) / 近4年标准差
  息差便宜度   = clamp(50 + 25×息差Z, 0, 100)   （Z 高=息差大=便宜）
  息差危险度   = clamp(50 − 25×息差Z, 0, 100)   （本模型方向：息差窄=危险）
  有效股息危险度 = min(股息率反分, 息差危险度)    ← 两个都指向危险才计高

第三步：合成估值温度
  估值温度 = 30%×PE正分 + 30%×PB正分 + 40%×有效股息危险度
```

**估值温度分档**（独立仪表）：`< 40 低估 · 40–60 中性 · 60–80 偏高 · > 80 高估`。仅当三信号共振成立时，作为确认/升级条件（估值偏高→升级一档）。

### 3.2 合成

```
维度分 = Σ(子项反向百分位/百分位分 × 子项权重)
综合分 RCS = ②资金×29% + ③动量×21% + ④热度×21% + ⑥背离×29%   ← 保留整数，限 [0,100]
```

- **反向百分位**：股息率、现金流覆盖 = 100 − 正向分位（**值越低越危险**）。
- **正向百分位（直接用，不反向）**：**PE、PB**（**值越高越危险**）、换手率、成交额等越高越险指标，直接用历史分位即拥挤分。
- **背离类**（⑥）：价格上涨而基本面下行 → 背离加大 → 分项得分升高（拥挤分更高）。
- 所有子项先换 0–100 分再加权，禁止把不同单位直接相加。
- **估值温度不计入综合分**——它是独立温度计，仅在共振预警时调节。

### 3.3 三个问题卡（hero 区自检）

```
钱来了多少    = ②资金流入 分
价格热了多少  = (③动量 + ④热度) / 2
现金流跟上了吗 = 100 − ⑥基本面背离分
贵了吗（独立）= 估值温度计分（不参与总分）
```

> 这三个值必须与维度分严格一致，输出前用「自检规则」（见 §4.5）核对，否则报告数据不自洽。

---

## 4. 输出：HTML 可视化网页

### 4.1 输出位置与命名

```
目录：L:\理财\ETF\红利拥挤度监测\     （不存在则创建；可用 L:\理财\ 下任一你指定的目录替代）
文件：红利拥挤度六维监测-YYYY-MM-DD.html
```

生成后**用浏览器打开核对**（排版、指针角度、表格对齐），确认无误后向用户报告输出路径与一句话结论。

### 4.2 页面结构（自上而下 · 专业研报风格）

设计语言：**暖米色纸张质感 · 墨绿-琥珀黄-砖红低饱和风险色阶 · 衬线标题（Georgia/宋体）+ 无衬线正文数字 · 居中窄栏单流（≤880px）· 极小圆角 · 全页左对齐 · 无夸张动效**。

| # | 模块 | 内容 |
|---|---|---|
| 1 | **顶部标签栏 + 大标题** | 标签（RCS/周度/观察日/数据质量）+ 衬线大标题 + 英文小标 + 副题 |
| 2 | **核心总览** | 左右分栏：左 = 超大综合分 + 状态标签 + 色带条；右 = **三问拆解**（钱来了多少=资金分 / 价格热了多少=(动量+热度)/2 / 现金流跟上了吗=100−背离分） |
| 3 | **区间定位** | 横向色带标尺（40/20/15/10/15 比例）+ 边界刻度 + 区间说明块 |
| 4 | **估值温度计（独立）** | 单独仪表卡：V 因子估值温度 + 分档（低估/中性/偏高/高估）+ PE/PB/股息率子项；**不计入综合分**，标注"仅共振时确认/升级" |
| 5 | **拥挤四维明细** | 行式布局 ×4（资金/动量/热度/背离）：维度名+权重 / 得分 / 进度条 / 子项说明 |
| 6 | **集中度标注（独立）** | 前十大权重 / 样本数 / 行业集中一行展示，标注"退出风险" |
| 7 | **条件判定** | 三信号共振等宽三列卡片，每张带状态标签 + 判定脚注；估值温度在此作确认/升级条件 |
| 8 | **四象限矩阵** | 2×2 网格，高亮当前位置格 |
| 9 | **预警清单** | 带等级标识（高/中/低）的列表 |
| 10 | **数据明细（附录）** | 全部分数逐行可溯源（含估值温度计子项） |
| 11 | **底部备注** | 数据口径 / 观察日 / 免责声明小字 |

### 4.3 替换表（模板演示值 → 真实值）

模板内嵌的演示数据以 `<!-- 数据点 NN -->` 注释标注。生成真实报告时按下表替换，**结构与全部 CSS 原样保留**：

| 数据点 | 模板演示值 | 替换为 |
|---|---|---|
| ① 标签栏日期 / 数据质量 / 底部备注 | 2026-08-02 / B / 2026-08-09 | 真实观察日 / §2.2 判定 / 下周同日 |
| ① **综合分（唯一必填）** | 62 | 加权计算值 → **改 JS 里 `score = 62` 这一处**；大数字/状态标签/区间色带定位/区间说明/四象限韧性标注全部自动 |
| ① 核心结论三条（右栏） | 演示文字 | 按 §3.3 与真实判定改写 |
| ② 六个维度行 ×6：维度分、子项值·分位 | 演示值 | 真实取数 + 评分；进度条宽度与颜色由 JS 自动同步 |
| ② 维度行子项（当前值·分位双块） | 4.71%·42% / 297bp·39% / 8.5·35% | 真实「当前值 + 历史百分位」两块（见 §4.5 第6条） |
| ② 三信号共振卡片：状态标签 + 文案 | 部分成立/已成立/背离初现 + 演示 | 真实判定（标签文字+卡片 `--js` 色阶可调） |
| ② 预警清单：等级 + 文案 | 高/中/低 + 演示 | 真实判定（等级徽标 `--wlv` 色阶） |
| ② 四象限：高亮格 + 韧性值 | 高拥挤·强基本面 / 韧性演示 | `qcell.cur` 移到真实象限；韧性=100−⑥背离分（JS 自动标注） |
| ② 数据明细表全部行 | 演示值 | 真实值（含每个子项「当前值 · 分位」） |
| ④ 免责声明 | 模板说明 | 若非演示，去掉「演示值」字样，改为真实口径与数据日期 |

### 4.4 模板

直接输出以下完整 HTML 模板，替换演示数据。**CSS 与 DOM 结构一个字都不要动**——它是排版质量的保证：

```html
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>红利拥挤度监测 RCS · 2026-08-02</title>
<style>
/* =========================================================
   红利拥挤度监测 RCS · 专业研报版 v1.2
   设计语言：暖纸质感 · 墨绿-琥珀黄-砖红低饱和色阶 · 衬线标题
   布局：居中窄栏单流 · 总→分→判定→预警→备注
   ========================================================= */
:root{
  color-scheme: light;
  --paper:        #f6f3ec;   /* 暖米色纸张 */
  --surface:      #fdfbf6;   /* 卡片表面 */
  --surface-2:    #efeadf;   /* 次级块 */
  --line:         #e3dccb;   /* 分隔线 */
  --line-strong:  #d3cab6;
  --ink-1:        #2a2a26;   /* 主文字 */
  --ink-2:        #6d6a5e;   /* 次级文字 */
  --ink-3:        #a39e8f;   /* 三级文字 */
  --serif: Georgia,"Songti SC","SimSun","Noto Serif SC",serif;
  --sans: system-ui,-apple-system,"PingFang SC","Microsoft YaHei","Segoe UI",sans-serif;
  --r1:#44684f;   /* 墨绿 · 低拥挤 */
  --r2:#7d9177;   /* 灰绿 · 正常 */
  --r3:#b98a3e;   /* 琥珀 · 明显升温 */
  --r4:#a04f3a;   /* 砖红 · 高拥挤 */
  --r5:#7c3024;   /* 深砖红 · 极端 */
  --track:#e8e2d3;/* 进度条轨道 */
  --radius:4px;
}
*{box-sizing:border-box;margin:0;padding:0}
html{-webkit-font-smoothing:antialiased}
body{
  background:var(--paper);color:var(--ink-1);
  font-family:var(--sans);line-height:1.65;font-size:14px;
}
a{color:inherit;text-decoration:none}
.wrap{max-width:880px;margin:0 auto;padding:36px 28px 56px}

/* ============ 顶部：标签栏 + 大标题 ============ */
.tagbar{display:flex;flex-wrap:wrap;gap:8px;margin-bottom:18px}
.tag{font-size:11.5px;font-weight:600;letter-spacing:.4px;color:var(--ink-2);
  background:var(--surface);border:1px solid var(--line);border-radius:var(--radius);
  padding:3px 9px}
.tag b{color:var(--ink-1);font-weight:700}
.h-title{font-family:var(--serif);font-size:29px;font-weight:700;letter-spacing:1px;line-height:1.25}
.h-title .en{font-family:var(--sans);font-size:11px;font-weight:600;color:var(--ink-3);
  letter-spacing:2.5px;display:block;margin-top:8px;text-transform:uppercase}
.h-sub{font-size:12.5px;color:var(--ink-2);margin-top:10px}
.rule{height:1px;background:var(--line-strong);margin:22px 0}

/* ============ 核心总览：左右分栏 ============ */
.overview{display:grid;grid-template-columns:280px 1fr;gap:16px;margin-bottom:26px}
@media(max-width:640px){.overview{grid-template-columns:1fr}}
.ov-score{background:var(--surface);border:1px solid var(--line);border-radius:var(--radius);padding:22px 20px;text-align:left}
.ov-score .lb{font-size:12px;font-weight:600;color:var(--ink-3);letter-spacing:1px}
.ov-score .num{font-family:var(--sans);font-size:64px;font-weight:800;line-height:1.1;
  font-variant-numeric:tabular-nums;letter-spacing:-2px;margin:10px 0 2px}
.ov-score .st{display:inline-block;font-size:13px;font-weight:700;padding:3px 10px;
  border-radius:var(--radius);letter-spacing:.5px}
.ov-score .sc{margin-top:10px;height:6px;border-radius:3px;background:var(--track);position:relative;overflow:hidden}
.ov-score .sc i{position:absolute;left:0;top:0;bottom:0;background:var(--sc);width:62%}
.ov-score .sc .tic{position:absolute;top:-1px;bottom:-1px;width:2px;background:var(--ink-3);opacity:.6}
.ov-score .min{margin-top:10px;font-size:11px;color:var(--ink-3);font-variant-numeric:tabular-nums}
.ov-score .min span{display:inline-block;width:25%}
.ov-notes{background:var(--surface);border:1px solid var(--line);border-radius:var(--radius);padding:20px 22px}
.ov-notes h3{font-family:var(--serif);font-size:14.5px;font-weight:700;margin-bottom:12px;letter-spacing:.5px}
.ov-notes .item{display:flex;gap:10px;padding:7px 0;border-top:1px solid var(--line);font-size:13px;color:var(--ink-2)}
.ov-notes .item:first-of-type{border-top:none}
.ov-notes .item .no{flex:none;font-family:var(--serif);font-weight:700;color:var(--ink-3);font-size:12px;margin-top:1px}
.ov-notes .item b{color:var(--ink-1);font-weight:700}

/* ============ 区间定位：色带标尺 ============ */
.zone-sec{margin-bottom:26px}
.zone-sec h4{font-family:var(--serif);font-size:13.5px;font-weight:700;margin-bottom:10px;letter-spacing:.5px}
.ruler{position:relative;height:14px;border-radius:3px;overflow:hidden;display:flex}
.ruler span{flex:1}
.ruler span:nth-child(1){flex:40;background:var(--r1)}
.ruler span:nth-child(2){flex:20;background:var(--r2)}
.ruler span:nth-child(3){flex:15;background:var(--r3)}
.ruler span:nth-child(4){flex:10;background:var(--r4)}
.ruler span:nth-child(5){flex:15;background:var(--r5)}
.ruler .cur{position:absolute;top:-3px;bottom:-3px;width:2px;background:var(--ink-1);z-index:3;box-shadow:0 0 0 3px var(--paper)}
.ruler-scale{position:relative;height:16px;margin-top:4px;font-size:10.5px;color:var(--ink-3);font-variant-numeric:tabular-nums}
.ruler-scale b{position:absolute;transform:translateX(-50%)}
.ruler-scale b:first-child{transform:none}
.ruler-scale b:last-child{transform:translateX(-100%)}
/* 估值温度计专用色带：<30 / 30-50 / 50-70 / 70-85 / >85 */
.ruler-val{position:relative;height:14px;border-radius:3px;overflow:hidden;display:flex;margin-top:10px}
.ruler-val span{flex:1}
.ruler-val span:nth-child(1){flex:30;background:var(--r1)}
.ruler-val span:nth-child(2){flex:20;background:var(--r2)}
.ruler-val span:nth-child(3){flex:20;background:var(--r3)}
.ruler-val span:nth-child(4){flex:15;background:var(--r4)}
.ruler-val span:nth-child(5){flex:15;background:var(--r5)}
.ruler-val .cur{position:absolute;top:-3px;bottom:-3px;width:2px;background:var(--ink-1);z-index:3;box-shadow:0 0 0 3px var(--paper)}
.zone-caption{margin-top:10px;padding:11px 14px;background:var(--surface-2);border-left:3px solid var(--zc);border-radius:2px;font-size:12.5px;color:var(--ink-2);line-height:1.7}
.zone-caption b{color:var(--ink-1);font-weight:700}

/* ============ 维度明细：行式 ============ */
.dim-sec{margin-bottom:26px}
.dim-sec h4{font-family:var(--serif);font-size:13.5px;font-weight:700;margin-bottom:12px;letter-spacing:.5px}
.dim{display:grid;grid-template-columns:150px 46px 1fr 2fr;align-items:center;gap:12px;
  padding:11px 14px;background:var(--surface);border:1px solid var(--line);border-radius:var(--radius);margin-bottom:7px}
.dim .nm{font-size:13px;font-weight:700;color:var(--ink-1)}
.dim .nm .no{font-family:var(--serif);color:var(--ink-3);font-size:11.5px;margin-right:6px}
.dim .wt{font-size:10.5px;color:var(--ink-3);font-weight:500;margin-top:1px;display:block}
.dim .sc{font-size:20px;font-weight:800;font-variant-numeric:tabular-nums;color:var(--dc);text-align:right}
.dim .bar{height:7px;border-radius:3px;background:var(--track);position:relative;overflow:hidden}
.dim .bar i{position:absolute;left:0;top:0;bottom:0;border-radius:3px;background:var(--dc);width:55%}
.dim .bar .tic{position:absolute;top:-1px;bottom:-1px;width:2px;background:var(--paper)}
.dim .ds{font-size:11.5px;color:var(--ink-2);line-height:1.6}
.dim .ds .k{color:var(--ink-3)}
.dim .ds b{color:var(--ink-1);font-weight:600;font-variant-numeric:tabular-nums}
@media(max-width:640px){.dim{grid-template-columns:1fr 44px;grid-template-areas:"a b" "c c" "d d"}.dim .nm{grid-area:a}.dim .sc{grid-area:b}.dim .bar{grid-area:c;margin-top:2px}.dim .ds{grid-area:d}}

/* ============ 条件判定：等宽多列 ============ */
.judge-sec{margin-bottom:26px}
.judge-sec h4{font-family:var(--serif);font-size:13.5px;font-weight:700;margin-bottom:12px;letter-spacing:.5px}
.judge{display:grid;grid-template-columns:repeat(3,1fr);gap:10px}
@media(max-width:640px){.judge{grid-template-columns:1fr}}
.jd{background:var(--surface);border:1px solid var(--line);border-radius:var(--radius);padding:14px 15px;border-top:3px solid var(--js)}
.jd .tag{display:inline-block;font-size:10.5px;font-weight:700;letter-spacing:.5px;padding:1px 7px;border-radius:3px;color:#fff;background:var(--js);margin-bottom:8px}
.jd .tt{font-size:12.5px;font-weight:700;margin-bottom:6px;line-height:1.5}
.jd .tx{font-size:11.5px;color:var(--ink-2);line-height:1.6}
.jd .tx b{color:var(--ink-1);font-variant-numeric:tabular-nums}
.judge-foot{margin-top:10px;font-size:12px;color:var(--ink-2);padding:10px 14px;background:var(--surface-2);border-radius:var(--radius)}
.judge-foot b{color:var(--ink-1)}

/* ============ 四象限矩阵 ============ */
.quad-sec{margin-bottom:26px}
.quad-sec h4{font-family:var(--serif);font-size:13.5px;font-weight:700;margin-bottom:12px;letter-spacing:.5px}
.quad-grid{display:grid;grid-template-columns:1fr 1fr;gap:7px;max-width:560px}
.qcell{position:relative;padding:14px 16px;border:1px solid var(--line);border-radius:var(--radius);background:var(--surface);min-height:96px}
.qcell .qn{font-size:12.5px;font-weight:700}
.qcell .qd{font-size:11px;color:var(--ink-3);margin-top:3px;line-height:1.55}
.qcell.cur{border-color:var(--dc);border-width:2px;background:var(--surface-2)}
.qcell.cur .mark{position:absolute;top:-8px;right:12px;font-size:9.5px;font-weight:700;letter-spacing:.5px;
  background:var(--dc);color:#fff;padding:2px 7px;border-radius:3px}
.quad-axis{font-size:10.5px;color:var(--ink-3);max-width:560px;display:flex;justify-content:space-between;margin-top:6px}

/* ============ 预警清单 ============ */
.warn-sec{margin-bottom:26px}
.warn-sec h4{font-family:var(--serif);font-size:13.5px;font-weight:700;margin-bottom:12px;letter-spacing:.5px}
.wlist{display:flex;flex-direction:column;gap:6px}
.witem{display:flex;gap:12px;align-items:flex-start;padding:10px 14px;background:var(--surface);border:1px solid var(--line);border-radius:var(--radius);font-size:12.5px}
.witem .lv{flex:none;font-size:10.5px;font-weight:700;letter-spacing:.5px;padding:2px 8px;border-radius:3px;color:#fff;background:var(--wlv);margin-top:1px}
.witem .tx{color:var(--ink-2)}
.witem .tx b{color:var(--ink-1);font-variant-numeric:tabular-nums}

/* ============ 数据明细（附录） ============ */
.table-sec{margin-bottom:26px}
.table-sec h4{font-family:var(--serif);font-size:13.5px;font-weight:700;margin-bottom:12px;letter-spacing:.5px}
table{width:100%;border-collapse:collapse;font-size:12px}
th,td{padding:7px 10px;text-align:right;border-bottom:1px solid var(--line);white-space:nowrap}
th{font-weight:600;color:var(--ink-3);font-size:10.5px;letter-spacing:.5px}
th:first-child,td:first-child{text-align:left}
td.lv{font-weight:700;color:var(--ink-1)}
.num{font-variant-numeric:tabular-nums}

/* ============ 底部备注 ============ */
.foot{margin-top:26px;border-top:1px solid var(--line-strong);padding-top:16px;font-size:11.5px;color:var(--ink-3);line-height:1.9}
.foot .src{color:var(--ink-2)}
.foot b{color:var(--ink-2);font-weight:600}
.foot .disc{color:var(--ink-3);margin-top:8px}
</style>
</head>
<body>
<div class="wrap">

  <!-- ===== 顶部：标签栏 + 大标题 ===== -->
  <div class="tagbar">
    <span class="tag">红利拥挤度 <b>RCS</b></span>
    <span class="tag">周度监测</span>
    <span class="tag">观察日 <b>2026-08-02</b></span>
    <span class="tag">数据质量 <b>B</b></span>
  </div>
  <h1 class="h-title">红利拥挤度监测
    <span class="en">Crowding Radar · Six-Dimension Monitor</span>
  </h1>
  <div class="h-sub">从估值、资金、动量、热度、集中、背离六个侧面，判断红利策略是否正从「低估值+现金流」转向「依赖资金流入维持」的热门。</div>
  <div class="rule"></div>

  <!-- ===== 核心总览 ===== -->
  <section class="overview">
    <div class="ov-score">
      <div class="lb">综合拥挤度得分</div>
      <div class="num" id="bigNum">62</div>
      <span class="st" id="bigZone" style="background:var(--r3);color:#fff">明显升温</span>
      <div class="sc"><i style="width:62%"></i><span class="tic" style="left:62%"></span></div>
      <div class="min"><span>0</span><span>40</span><span>60</span><span>75</span><span>100</span></div>
    </div>
    <div class="ov-notes">
      <h3>三问拆解</h3>
      <div class="item"><span class="no">钱</span><div><b>钱，来了多少？</b> ②资金流入 <b>72</b> 分 —— 20日份额 +1.8%、60日净申购 46 亿，资金仍在进场。</div></div>
      <div class="item"><span class="no">价</span><div><b>价格，热了多少？</b> (③动量+④热度)/2 = <b>64</b> 分 —— 12月超额 +9.2%、换手分位 63%，热度升温。</div></div>
      <div class="item"><span class="no">金</span><div><b>现金流，跟上了吗？</b> 100−⑥背离 = <b>36</b> —— 覆盖降至 1.4x、支付率升至 61%，背离初现。</div></div>
    </div>
  </section>

  <!-- ===== 区间定位 ===== -->
  <section class="zone-sec">
    <h4>区间定位</h4>
    <div class="ruler">
      <span></span><span></span><span></span><span></span><span></span>
      <div class="cur" id="rulerCur" style="left:62%"></div>
    </div>
    <div class="ruler-scale">
      <b style="left:0%">0</b><b style="left:40%">40</b><b style="left:60%">60</b><b style="left:75%">75</b><b style="left:85%">85</b><b style="left:100%">100</b>
    </div>
    <div class="zone-caption" id="zoneCaption">
      <b>当前 62 分 → 明显升温区间。</b>预警需「综合分连续四周 &gt; 75」且「至少三个分项 &gt; 80」才进入高拥挤预警；单周超 75 不作数。
    </div>
    <!-- 各档含义说明 -->
    <div style="margin-top:10px;border:1px solid var(--line);border-radius:var(--radius);overflow:hidden">
      <table style="font-size:11.5px">
        <thead><tr><th style="width:90px">区间</th><th>含义 · 操作</th></tr></thead>
        <tbody>
          <tr><td style="color:var(--r1)"><b>&lt; 40 低拥挤</b></td><td>资金/动量/热度/背离全线偏冷，无人抢筹。若估值也低（温度计低估），是<b>布局加仓窗口</b>；若估值高，可能"贵而冷"，需甄别。</td></tr>
          <tr><td style="color:var(--r2)"><b>40–60 正常</b></td><td>拥挤度中性，无过热也无恐慌。<b>正常持有/定投</b>，维持节奏。</td></tr>
          <tr><td style="color:var(--r3)"><b>60–75 明显升温</b></td><td>资金与动量开始变热，<b>警惕追高</b>。若估值同步偏高（温度计&gt;70），提前做好减仓预案。</td></tr>
          <tr><td style="color:var(--r4)"><b>75–85 高拥挤</b></td><td>交易方向趋同，<b>逐步分批止盈</b>。需连续 4 周 &gt;75 且 ≥3 分项 &gt;80 才确认为高危。</td></tr>
          <tr><td style="color:var(--r5)"><b>&gt; 85 极端拥挤</b></td><td>踩踏风险高，<b>加速减仓</b>。结合三信号共振 + 估值温度计共同判断。</td></tr>
        </tbody>
      </table>
    </div>
  </section>

  <!-- ===== 估值温度计（独立，不计入综合分） ===== -->
  <section class="dim-sec">
    <h4>估值温度计 <span style="font-size:11px;color:var(--ink-3);font-weight:500">独立仪表 · 不计入综合分 · 仅在三信号共振时作确认/升级条件</span></h4>

    <div class="dim" style="border-left:3px solid var(--r3)">
      <div class="nm"><span class="no">估</span>估值温度<span class="wt">V 因子骨架</span></div>
      <div class="sc" id="valScore" style="color:var(--r3)">72</div>
      <div class="bar"><i style="width:72%;background:var(--r3)"></i><span class="tic" style="left:72%"></span></div>
      <div class="ds"><span class="k">PE正分</span> <b>82.8</b> ｜ <span class="k">PB正分</span> <b>51.6</b> ｜ <span class="k">有效股息危险度</span> <b>78.5</b>（min 股息率反分78.5 / 息差危险度84.8）</div>
    </div>
    <!-- 估值温度区间色带 -->
    <div class="ruler-val">
      <span></span><span></span><span></span><span></span><span></span>
      <div class="cur" id="valRulerCur" style="left:72%"></div>
    </div>
    <div class="ruler-scale">
      <b style="left:0%">0</b><b style="left:30%">30</b><b style="left:50%">50</b><b style="left:70%">70</b><b style="left:85%">85</b><b style="left:100%">100</b>
    </div>
    <div class="zone-caption" id="valCaption" style="--zc:var(--r3)">
      <b>当前 72°C → 正常偏高（70–85）· 持有并关注。</b>估值温度不计入综合分，仅作参考。分档：&lt;30 低估加重仓 · 30–50 偏低正常定投 · 50–70 标准持有 · 70–85 偏高持有关注 · &gt;85 偏贵分批止盈。
    </div>
    <!-- 估值各档操作说明 -->
    <div style="margin-top:10px;border:1px solid var(--line);border-radius:var(--radius);overflow:hidden">
      <table style="font-size:11.5px">
        <thead><tr><th style="width:90px">温度</th><th>含义 · 操作</th></tr></thead>
        <tbody>
          <tr><td style="color:var(--r1)"><b>&lt; 30°C 低估</b></td><td>股息率/息差极具吸引力（如股息率&gt;5.5%），<b>重仓加仓</b>时机。</td></tr>
          <tr><td style="color:var(--r2)"><b>30–50°C 偏低</b></td><td>估值合理偏低，<b>正常定投</b>。</td></tr>
          <tr><td style="color:var(--r3)"><b>50–70°C 标准</b></td><td>估值中性，<b>正常持有</b>。</td></tr>
          <tr><td style="color:var(--r4)"><b>70–85°C 偏高</b></td><td>PE 分位走高，<b>持有并关注</b>，做好止盈预案。</td></tr>
          <tr><td style="color:var(--r5)"><b>&gt; 85°C 偏贵</b></td><td>估值显著透支，<b>分批止盈</b>。</td></tr>
        </tbody>
      </table>
    </div>

    <!-- ===== 拥挤四维明细 ===== -->
    <h4 style="margin-top:22px">拥挤度四维（构成综合分）</h4>

    <div class="dim">
      <div class="nm"><span class="no">②</span>资金流入<span class="wt">权重 29%</span></div>
      <div class="sc" style="color:var(--r2)">51</div>
      <div class="bar"><i style="width:51%;background:var(--r2)"></i><span class="tic" style="left:51%"></span></div>
      <div class="ds"><span class="k">场内基金规模</span> <b>339亿</b> ｜ <span class="k">近1周净流入</span> <b>-6.6亿</b> ｜ <span class="k">近3月</span> <b>+83.9亿</b></div>
    </div>
    <div class="dim">
      <div class="nm"><span class="no">③</span>相对动量<span class="wt">权重 21%</span></div>
      <div class="sc" style="color:var(--r2)">44</div>
      <div class="bar"><i style="width:44%;background:var(--r2)"></i><span class="tic" style="left:44%"></span></div>
      <div class="ds"><span class="k">近1月</span> <b>-7.9%</b> ｜ <span class="k">近1年</span> <b>+12.6%</b> ｜ <span class="k">250日线</span> <b>-0.45%</b></div>
    </div>
    <div class="dim">
      <div class="nm"><span class="no">④</span>交易热度<span class="wt">权重 21%</span></div>
      <div class="sc" style="color:var(--r2)">45</div>
      <div class="bar"><i style="width:45%;background:var(--r2)"></i><span class="tic" style="left:45%"></span></div>
      <div class="ds"><span class="k">20日换手</span> <b>3.39%</b> ｜ <span class="k">60日换手</span> <b>9.71%</b> ｜ <span class="k">成交额</span> <b>815亿</b></div>
    </div>
    <div class="dim">
      <div class="nm"><span class="no">⑥</span>基本面背离<span class="wt">权重 29%</span></div>
      <div class="sc" style="color:var(--r2)">38</div>
      <div class="bar"><i style="width:38%;background:var(--r2)"></i><span class="tic" style="left:38%"></span></div>
      <div class="ds"><span class="k">净利TTM同比</span> <b>+6.5%</b> ｜ <span class="k">营收同比</span> <b>+0.2%</b> ｜ <span class="k">现金流TTM</span> <b>15.8万亿</b></div>
    </div>

    <!-- ===== 集中度独立标注 ===== -->
    <div class="judge-foot" style="margin-top:10px">
      <b>退出风险标注（不计入综合分）</b>：前十大成分股权重 <b>19.0%</b> · 样本数 <b>100</b> · 行业结构 银行煤炭为主。集中度低，退出踩踏风险较小。
    </div>
  </section>

  <!-- ===== 条件判定：三信号共振 ===== -->
  <section class="judge-sec">
    <h4>条件判定 · 三信号共振（危险拥挤的必要条件）</h4>
    <div class="judge">
      <div class="jd" style="--js:var(--r3)">
        <span class="tag">部分成立</span>
        <div class="tt">① ETF 份额持续快速增长</div>
        <div class="tx">20日份额 <b>+1.8%</b>，连续 3 周为正——增速放缓，未达「快速增长」标准。</div>
      </div>
      <div class="jd" style="--js:var(--r4)">
        <span class="tag">已成立</span>
        <div class="tt">② 价格与相对动量明显升温</div>
        <div class="tx">12月超额 <b>+9.2%</b>、偏离250日线 <b>+6.4%</b>——价格与动量均已升温。</div>
      </div>
      <div class="jd" style="--js:var(--r3)">
        <span class="tag">背离初现</span>
        <div class="tt">③ 盈利 / 现金流 / 分红覆盖背离</div>
        <div class="tx">覆盖降至 <b>1.4x</b>、支付率升至 <b>61%</b>——背离初现，未显著恶化。</div>
      </div>
    </div>
    <div class="judge-foot">三个条件<b>缺一不可</b>，少一个结论都要更克制。当前成立 <b>1/3</b> → <b>尚未构成危险拥挤</b>。</div>
  </section>

  <!-- ===== 四象限矩阵 ===== -->
  <section class="quad-sec">
    <h4>拥挤 × 韧性 四象限</h4>
    <div class="quad-grid">
      <div class="qcell"><div class="qn">低拥挤 · 强基本面</div><div class="qd">「舒适区」——最理想状态。</div></div>
      <div class="qcell cur" style="--dc:var(--r3)">
        <span class="mark">当前位置</span>
        <div class="qn">高拥挤 · 强基本面</div><div class="qd">很热门，但现金流仍有支撑。</div>
      </div>
      <div class="qcell"><div class="qn">低拥挤 · 弱基本面</div><div class="qd">「价值陷阱」——警惕。</div></div>
      <div class="qcell"><div class="qn">高拥挤 · 弱基本面</div><div class="qd">「最危险组合」——踩踏风险。</div></div>
    </div>
    <div class="quad-axis"><span>横轴 · 基本面韧性</span><span>纵轴 · 拥挤度</span><span>韧性 = 100 − 基本面背离分</span></div>
  </section>

  <!-- ===== 预警清单 ===== -->
  <section class="warn-sec">
    <h4>预警清单</h4>
    <div class="wlist">
      <div class="witem" style="--wlv:var(--r4)"><span class="lv">高</span><div class="tx">综合分<b>连续四周 &gt; 75</b>且<b>≥3 分项 &gt; 80</b> → 当前<b> 0 周</b>，未触发。</div></div>
      <div class="witem" style="--wlv:var(--r3)"><span class="lv">中</span><div class="tx"><b>估值温度 55</b>：PE 分位 65%，若继续抬升将率先触及 80 分预警线。</div></div>
      <div class="witem" style="--wlv:var(--r3)"><span class="lv">中</span><div class="tx"><b>基本面背离 64</b>：现金流覆盖降至 1.4x，背离初现，需盯下季度财报。</div></div>
      <div class="witem" style="--wlv:var(--r2)"><span class="lv">低</span><div class="tx"><b>资金流入增速放缓</b>：20日份额增速 +0.5%，连续流入但斜率下降。</div></div>
    </div>
  </section>

  <!-- ===== 数据明细（附录） ===== -->
  <section class="table-sec">
    <h4>数据明细 · 附录</h4>
    <table>
      <thead><tr><th>维度</th><th>子指标</th><th>当前值 · 分位</th><th>方向</th><th>分</th><th>权</th></tr></thead>
      <tbody>
        <tr><td>估值温度</td><td>股息率（越低越险）</td><td class="num">4.71% · 42%</td><td>越低越险</td><td class="num">58</td><td class="num">35%</td></tr>
        <tr><td></td><td>股债利差（越低越险）</td><td class="num">297bp · 39%</td><td>越低越险</td><td class="num">61</td><td class="num">30%</td></tr>
        <tr><td></td><td>PE（越高越险）</td><td class="num">8.5 · 35%</td><td>越高越险</td><td class="num">45</td><td class="num">35%</td></tr>
        <tr><td>资金流入</td><td>20日ETF总份额增长率</td><td class="num">+1.8%</td><td>越高越险</td><td class="num">78</td><td class="num">40%</td></tr>
        <tr><td></td><td>60日估算净申购额</td><td class="num">46.2亿</td><td>越高越险</td><td class="num">66</td><td class="num">30%</td></tr>
        <tr><td></td><td>红利净申购/权益净申购</td><td class="num">9.4%</td><td>越高越险</td><td class="num">63</td><td class="num">15%</td></tr>
        <tr><td></td><td>资金容量比</td><td class="num">0.9日</td><td>越高越险</td><td class="num">74</td><td class="num">15%</td></tr>
        <tr><td>相对动量</td><td>12个月超额（vs 沪深300）</td><td class="num">+9.2%</td><td>越高越险</td><td class="num">71</td><td class="num">40%</td></tr>
        <tr><td></td><td>250日线偏离/年波动率</td><td class="num">+6.4%</td><td>越高越险</td><td class="num">66</td><td class="num">35%</td></tr>
        <tr><td></td><td>60日相对收益加速</td><td class="num">+3.1%</td><td>越高越险</td><td class="num">64</td><td class="num">25%</td></tr>
        <tr><td>交易热度</td><td>成分股换手率分位</td><td class="num">63%</td><td>越高越险</td><td class="num">63</td><td class="num">40%</td></tr>
        <tr><td></td><td>红利ETF成交/权益ETF成交</td><td class="num">4.8%</td><td>越高越险</td><td class="num">57</td><td class="num">35%</td></tr>
        <tr><td></td><td>溢价/折价与价差异常</td><td class="num">+0.12%</td><td>越高越险</td><td class="num">58</td><td class="num">25%</td></tr>
        <tr><td>持仓集中</td><td>指数前十大成分股权重</td><td class="num">31.5%</td><td>越高越险</td><td class="num">52</td><td class="num">35%</td></tr>
        <tr><td></td><td>第一大/前三大行业权重</td><td class="num">22%/47%</td><td>越高越险</td><td class="num">45</td><td class="num">30%</td></tr>
        <tr><td></td><td>主流红利指数持仓重合度</td><td class="num">54%</td><td>越高越险</td><td class="num">47</td><td class="num">35%</td></tr>
        <tr><td>基本面背离</td><td>价格 vs 加权净利增速背离</td><td class="num">+7.1/+2.3%</td><td>背离越大越险</td><td class="num">66</td><td class="num">35%</td></tr>
        <tr><td></td><td>股利支付率变化</td><td class="num">+4pct→61%</td><td>无增利提升更险</td><td class="num">58</td><td class="num">25%</td></tr>
        <tr><td></td><td>自由现金流/现金分红覆盖</td><td class="num">1.4x</td><td>越低越险</td><td class="num">70</td><td class="num">25%</td></tr>
        <tr><td></td><td>削减分红/盈利下修成分比例</td><td class="num">11%</td><td>越高越险</td><td class="num">57</td><td class="num">15%</td></tr>
        <tr style="border-top:2px solid var(--line-strong)"><td colspan="5"><b>综合分 RCS</b>（加权合计）</td><td class="lv num">62</td></tr>
      </tbody>
    </table>
  </section>

  <!-- ===== 底部备注 ===== -->
  <footer class="foot">
    <div class="src"><b>数据口径：</b>演示数据（非真实市场打分）· 行情截至 2026-07-30 收盘 · 估值分位窗口 近10年（2013 以来）</div>
    <div>观察日 2026-08-02 · 下次输出 2026-08-09 · 数据质量 B</div>
    <div class="disc">本页为模型演示。红利拥挤度模型是监测仪表盘，不是水晶球——它判断「低估值+现金流回报」策略是否正变成依赖资金流入维持的热门，而非精准猜顶。权重与阈值待回测校准。<b>研究用途，不构成投资建议</b>；历史表现不代表未来结果。</div>
  </footer>

</div>
<script>
(function(){
  var score = 50; /* ★ 唯一必填：综合分 RCS 0–100 */
  var valScore = 72; /* ★ 估值温度（V因子，独立不计入综合分）0–100 */
  var VALZONES=[
    {lo:0,  hi:30, name:'低估',       op:'加重仓'},
    {lo:30, hi:50, name:'正常偏低',   op:'正常定投'},
    {lo:50, hi:70, name:'标准',       op:'正常持有'},
    {lo:70, hi:85, name:'正常偏高',   op:'持有并关注'},
    {lo:85, hi:101,name:'偏贵',       op:'分批止盈'}
  ];
  var vz = VALZONES.find(function(x){return valScore>=x.lo && valScore<x.hi;}) || VALZONES[4];
  // 估值温度条定位
  var vrc=document.getElementById('valRulerCur'); if(vrc) vrc.style.left = valScore+'%';
  var vcap=document.getElementById('valCaption');
  if(vcap){
    vcap.innerHTML = '<b>当前 '+valScore+'°C → '+vz.name+'（'+vz.lo+'–'+(vz.hi>100?100:vz.hi)+'）· '+vz.op+'。</b>估值温度不计入综合分，仅作参考。分档：&lt;30 低估加重仓 · 30–50 偏低正常定投 · 50–70 标准持有 · 70–85 偏高持有关注 · &gt;85 偏贵分批止盈。';
  }
  var ZONES=[
    {lo:0, hi:40, name:'低拥挤',  color:'var(--r1)'},
    {lo:40, hi:60, name:'正常',    color:'var(--r2)'},
    {lo:60, hi:75, name:'明显升温',color:'var(--r3)'},
    {lo:75, hi:85, name:'高拥挤',  color:'var(--r4)'},
    {lo:85, hi:101,name:'极端拥挤',color:'var(--r5)'}
  ];
  var z = ZONES.find(function(x){return score>=x.lo && score<x.hi;}) || ZONES[4];
  var zi = ZONES.indexOf(z);

  // 核心总览
  var bn=document.getElementById('bigNum'), bz=document.getElementById('bigZone');
  bn.textContent = score;
  bz.textContent = z.name; bz.style.background = z.color;

  // 区间标尺当前位 + 说明
  var rc=document.getElementById('rulerCur'); if(rc) rc.style.left = score+'%';
  var zc=document.getElementById('zoneCaption');
  if(zi < ZONES.length-1){
    var nx=ZONES[zi+1];
    zc.innerHTML = '<b>当前 '+score+' 分 → '+z.name+'区间。</b>距「'+nx.name+'」'+nx.lo+' 分还差 <b>'+(nx.lo-score)+'</b> 分。预警需「综合分连续四周 &gt; 75」且「至少三个分项 &gt; 80」才进入高拥挤预警；单周超 75 不作数。';
  } else {
    zc.innerHTML = '<b>当前 '+score+' 分 → '+z.name+'区间。</b>已无更高档位。';
  }

  // 维度进度条自动同步 + 四象限韧性定位
  var dims = document.querySelectorAll('.dim');
  var scores = [];
  dims.forEach(function(d){
    var s=parseInt(d.querySelector('.sc').textContent,10);
    if(isNaN(s)) return;
    scores.push(s);
    var bar=d.querySelector('.bar');
    var i=bar.querySelector('i'), t=bar.querySelector('.tic');
    var col=getComputedStyle(d.querySelector('.sc')).color;
    if(i){ i.style.width=s+'%'; i.style.background=col; }
    if(t) t.style.left=s+'%';
  });
  // 若四象限高亮格在，标注韧性=100-背离分(第6个)
  var qcur=document.querySelector('.qcell.cur');
  if(qcur && scores.length>=6){
    var resilience=100-scores[5];
    var mark=qcur.querySelector('.mark');
    if(mark) mark.textContent = '当前位置 · 韧性'+resilience;
  }
})();
</script>
</body>
</html>




```

### 4.5 自检规则（输出前逐条核对）

1. **综合分 = 六维加权和**：`Σ(维度分×权重)` 四舍五入后必须等于 JS 里的 `score` 变量（±1 内）。
2. **核心结论右栏**：三条结论与综合分、三信号共振、最该盯分项一致。
3. **区间定位一致**：大数字状态标签、区间色带定位、区间说明块三者指向同一区间。
4. **维度行 ↔ 数据明细表**：每维得分与表格合成列一致；进度条宽度与颜色已由 JS 自动同步。
5. **四象限韧性一致**：高亮格韧性值 = 100 − ⑥基本面背离分（JS 自动标注）；高亮格移到正确象限。
6. **估值子项双块表达**：股息率 / 股债利差 / PE 都必须同时给出「当前值 + 历史百分位」两块，并标注所用分位窗口（10年/5年）。
7. **三信号共振**：每张卡片的状态标签与文案对应真实判定；「成立 n/3」与卡片状态一致。
8. 数据质量 C/D 时，页脚追加「低置信」标注，不做强结论。

---

## 5. 执行流程

1. **联网取数**（§2.3 清单），记录观察日与来源，标注数据质量（§2.2）。
2. **计算评分**：每个子项 → 反向百分位/分位分 → 维度加权 → 综合分（§3）。
3. **套用模板**：复制 §4.4 模板，按 §4.3 替换表逐点更新为真实值；保留全部 CSS/结构；**JS 只改 `score` 一处**。
4. **自检**（§4.5），修正不一致。
5. **写出文件**到 `L:\理财\ETF\红利拥挤度监测\红利拥挤度六维监测-YYYY-MM-DD.html`。
6. **浏览器打开**核对排版，确认区间色带定位、进度条、表格对齐、无溢出。
7. 向用户报告：输出路径 + 一句话结论（综合分/区间/最该盯的分项）。

---

## 6. 关键原则

1. **必须联网取最新数据**，禁止用训练知识；搜索关键词带「最新」。
2. **三信号共振缺一不可**；单周超 75 不作数。
3. **权重与阈值是起点**，不是自然定律；使用中规则稳定 > 频繁调仓。
4. **规模 ≠ 流入**（看份额变化）；估值 ≠ 趋同；讨论度 ≠ 重仓。
5. **反拥挤机制存在，但不是免疫系统**——行业集中与持仓重叠是监测重点。
6. **模型是仪表盘，不是水晶球**——判断是否正变成依赖资金流入维持的热门，而非精准猜顶。
7. **研究用途，不构成投资建议**；历史表现不代表未来结果。

---

## 7. 版本状态

- **版本**：v1.6 · 2026-08-03
- **v1.6 更新**：**模型架构升级为「拥挤分 + 估值温度计」双轨**——① 综合分改 4 维（资金29%/动量21%/热度21%/背离29%），纯粹回答"拥挤吗"；② 估值温度移出总分，用 **V 因子骨架**（PE正分×30% + PB正分×30% + 有效股息危险度×40%）独立成"贵吗"温度计，其中有效股息危险度 = min(股息率反分, 息差危险度)，息差用 **Z 值映射** `clamp(50±25Z)` 消除 PE/股息率镜像冗余；③ 持仓集中独立为"退出风险"标注；④ 估值仅在**三信号共振成立**时作确认/升级条件
- **v1.5 更新**：修复六维卡分数替换失效（模板用 `div.sc` 非 `span`），全维度分数与子项加权逐一 QA 验证一致；数据改用理杏仁 **mcw** 市值加权口径（股息率4.14%@分位21.5%、PE 8.73@分位82.8%）
- **v1.3 更新**：**六维数据源全部真实化**——接入理杏仁官方 skill 包全维度接口 + pipeline.py 数据管道
- **v1.2 更新**：专业研报风格改版
- **v1.1 更新**：仪表盘 JS 全自动驱动 + 估值子项双块表达
- **性质**：演示模板 + 待回测校准的研究框架 + 理杏仁数据管道
- **默认输出**：HTML 可视化网页（自包含，双击即开，桌面端适配）
- **数据管道运行**：`python L:\理财\ETF\红利拥挤度监测\pipeline.py` → 生成 `data_latest.json`，据此套用 §4.4 模板输出报告
- **与既有命令的关系**：与「金融-红利ETF买卖检测」系列互补——本命令专注**拥挤度监测**，输出可视化仪表盘；买入/卖出信号见既有系列命令。
