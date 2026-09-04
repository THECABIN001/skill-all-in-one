# skill-all-in-one

本仓库把本机 `~/.agents/skills/` 下的全部 agent 技能（skill）打包成一版，用于在一台新电脑上快速装回同一套技能。

This repo packages **all** of the agent skills from `~/.agents/skills/` so you can restore the exact same set on a fresh machine.

## 内容 / Contents

- `skills/` — 全部 `136` 个技能目录，每个目录内是 `SKILL.md`（直接可被 agent 加载）。
- `scripts/install.ps1` — Windows 安装脚本（可链接或拷贝进技能目录）。
- `scripts/install.sh` — macOS / Linux 安装脚本（可链接或拷贝进技能目录）。
- 技能清单（每项：名字 + 简介）见下方 `## 技能清单 / Skills`。

## 在新电脑上装回 / Install on a fresh machine

前提：装了 git，且目标 agent 的技能目录是 `~/.agents/skills/`（DSH / Claude Code 类 agent 默认路径）。

### 先克隆 / 1. Clone

```bash
git clone git@github.com:THECABIN001/skill-all-in-one.git
cd skill-all-in-one
```

（私有仓库：新机器上要先配置好 GitHub 凭据，见下方“凭据”。）

### 再安装 / 2. Install

**Windows（PowerShell）** — 链接进 `%USERPROFILE%\.agents\skills`（DSH）：

```powershell
.\scripts\install.ps1
```

直接拷贝（不依赖仓库路径）用 `--copy`（PowerShell 也接受 `-Copy`）：

```powershell
.\scripts\install.ps1 --copy
```

同时装进 Claude Code 目录 `%USERPROFILE%\.claude\skills`，加 `-Claude`：

```powershell
.\scripts\install.ps1 -Claude
```

**macOS / Linux** — 链接进 `~/.agents/skills`：

```bash
bash scripts/install.sh
```

拷贝模式：`bash scripts/install.sh --copy`；同步装进 `~/.claude/skills`：`bash scripts/install.sh --claude`（可与 `--copy` 组合）。

### 更新 / 3. Update

**链接模式**下技能指向仓库源文件，拉取即生效：

```bash
git pull
```

**拷贝模式**下技能是独立副本，需要重新 `git pull` 后再跑一次 `--copy` 才同步。

## 链接 vs 拷贝 / Link vs copy

- **链接（默认）**：Windows junction / Unix symlink，技能指向仓库里的文件，`git pull` 后自动更新，省空间。
- **拷贝（`--copy`）**：把技能复制成真实目录，脱离仓库也能用；但更新需重跑安装脚本。

## 维护 / Maintain

在 `skills/` 里直接修改技能，提交回本仓库：

```bash
git add skills && git commit -m "update skills"
git push
```

## 凭据 / Credentials（私有仓库）

本仓库为**私有**。新机器克隆前需先认证 GitHub：

- 配置 SSH 密钥：`ssh-keygen -t ed25519` → 把公钥加到 GitHub → `git@github.com:THECABIN001/skill-all-in-one.git`；或
- 配置 PAT（HTTPS）：`git clone https://github.com/THECABIN001/skill-all-in-one.git` 时用 PAT 作为密码。

## 技能清单 / Skills

共 `136` 个技能，全部在 `skills/` 目录下（名字 + 简介取自各 `SKILL.md` 的 frontmatter `description`）。

- **adopt** — Brownfield onboarding — audits existing project artifacts for template format compliance (not just existence), classifies gaps by impact, and produces a numbered migration plan. Run this when joining an in-progress project or upgrading from an older template version. Distinct from /project-stage-detect (which checks what exists) — this checks whether what exists will actually work with the template's skills.
- **architecture-decision** — Creates an Architecture Decision Record (ADR) documenting a significant technical decision, its context, alternatives considered, and consequences. Every major technical choice should have an ADR.
- **architecture-review** — Validates completeness and consistency of the project architecture against all GDDs. Builds a traceability matrix mapping every GDD technical requirement to ADRs, identifies coverage gaps, detects cross-ADR conflicts, verifies engine compatibility consistency across all decisions, and produces a PASS/CONCERNS/FAIL verdict. The architecture equivalent of /design-review.
- **art-bible** — Guided, section-by-section Art Bible authoring. Creates the visual identity specification that gates all asset production. Run after /brainstorm is approved and before /map-systems or any GDD authoring begins.
- **asset-audit** — Audits game assets for compliance with naming conventions, file size budgets, format standards, and pipeline requirements. Identifies orphaned assets, missing references, and standard violations.
- **asset-spec** — Generate per-asset visual specifications and AI generation prompts from GDDs, level docs, or character profiles. Produces structured spec files and updates the master asset manifest. Run after art bible and GDD/level design are approved, before production begins.
- **balance-check** — Analyzes game balance data files, formulas, and configuration to identify outliers, broken progressions, degenerate strategies, and economy imbalances. Use after modifying any balance-related data or design. Use when user says 'balance report', 'check game balance', 'run a balance check'.
- **book-study** — Reading coach: guides users through books systematically with knowledge compilation, mastery testing, spaced repetition, and knowledge querying. Use when user says 'read this book with me', 'book study', 'start studying X', 'reading plan', 'ingest this chapter', 'review what I read', 'quiz me on the book', 'what did the book say about X', or invokes /book-study. Supports sub-commands: ingest, query, review, compare, status. Triggers: book, study, read, chapter, ingest, review, quiz, reading plan, book notes.
- **bottleneck-hunter** — 供应链瓶颈猎手——AI 驱动的全球产业链瓶颈套利。Use when user says「瓶颈猎手」「供应链瓶颈」「bottleneck hunter」。
- **brainstorm** — Guided game concept ideation — from zero idea to a structured game concept document. Uses professional studio ideation techniques, player psychology frameworks, and structured creative exploration.
- **bug-report** — Creates a structured bug report from a description, or analyzes code to identify potential bugs. Ensures every bug report has full reproduction steps, severity assessment, and context.
- **bug-triage** — Read all open bugs in production/qa/bugs/, re-evaluate priority vs. severity, assign to sprints, surface systemic trends, and produce a triage report. Run at sprint start or when the bug count grows enough to need re-prioritization.
- **changelog** — Auto-generates a changelog from git commits, sprint data, and design documents. Produces both internal and player-facing versions.
- **code-review** — Performs an architectural and quality code review on a specified file or set of files. Checks for coding standard compliance, architectural pattern adherence, SOLID principles, testability, and performance concerns.
- **code-review-expert** — Expert code review of current git changes with a senior engineer lens. Detects SOLID violations, security risks, and proposes actionable improvements.
- **company-longform-series** — 深度公司系列——8 篇长文拆一家公司。系统化产出 8 篇深度长文，从多角度拆解一家公司。Use when user says「公司系列长文」「深度公司系列」「8篇长文」。
- **consistency-check** — Scan all GDDs against the entity registry to detect cross-document inconsistencies: same entity with different stats, same item with different values, same formula with different variables. Grep-first approach — reads registry then targets only conflicting GDD sections rather than full document reads.
- **content-audit** — Audit GDD-specified content counts against implemented content. Identifies what's planned vs built.
- **create-architecture** — Guided, section-by-section authoring of the master architecture document for the game. Reads all GDDs, the systems index, existing ADRs, and the engine reference library to produce a complete architecture blueprint before any code is written. Engine-version-aware: flags knowledge gaps and validates decisions against the pinned engine version.
- **create-control-manifest** — After architecture is complete, produces a flat actionable rules sheet for programmers — what you must do, what you must never do, per system and per layer. Extracted from all Accepted ADRs, technical preferences, and engine reference docs. More immediately actionable than ADRs (which explain why).
- **create-epics** — Translate approved GDDs + architecture into epics — one epic per architectural module. Defines scope, governing ADRs, engine risk, and untraced requirements. Does NOT break into stories — run /create-stories [epic-slug] after each epic is created.
- **create-stories** — Break a single epic into implementable story files. Reads the epic, its GDD, governing ADRs, and control manifest. Each story embeds its GDD requirement TR-ID, ADR guidance, acceptance criteria, story type, and test evidence path. Run after /create-epics for each epic.
- **day-one-patch** — Prepare a day-one patch for a game launch. Scopes, prioritises, implements, and QA-gates a focused patch addressing known issues discovered after gold master but before or immediately after public launch. Treats the patch as a mini-sprint with its own QA gate and rollback plan.
- **deep-research-report** — 投资研究——巴菲特-芒格-段永平-李录四大师综合分析框架。Use when user says「深度研报」「四大师」「deep research report」。
- **design-review** — Reviews a game design document for completeness, internal consistency, implementability, and adherence to project design standards. Run this before handing a design document to programmers.
- **design-system** — Guided, section-by-section GDD authoring for a single game system. Gathers context from existing docs, walks through each required section collaboratively, cross-references dependencies, and writes incrementally to file.
- **dev-story** — Read a story file and implement it. Loads the full context (story, GDD requirement, ADR guidelines, control manifest), routes to the right programmer agent for the system and engine, implements the code and test, and confirms each acceptance criterion. The core implementation skill — run after /story-readiness, before /code-review and /story-done.
- **dividend-etf-six-dim** — 红利ETF六维监测——红利拥挤度评分 RCS 可视化。六维度加权合成 0-100 拥挤度评分，输出 HTML 可视化仪表盘。Use when user says「红利六维」「红利拥挤度」「红利etf六维监测」「RCS」。
- **dividend-etf-trade-signal** — 红利ETF买卖检测——买入+卖出双维度信号扫描。Use when user says「红利etf买卖检测」「红利买卖信号」。
- **dividend-etf-trade-signal-v2** — 红利ETF买卖检测 v2——多周期+动量增强+机构级量化。Use when user says「红利买卖检测v2」「红利etf v2」。
- **dividend-etf-trade-signal-v3** — 红利ETF买卖检测 v3——修订版待回测验证。Use when user says「红利买卖检测v3」「红利etf v3」。
- **dividend-etf-valuation-only** — 红利ETF买卖检测纯估值版。只用估值温度计判断红利ETF买卖点。Use when user says「红利纯估值」「红利估值版」「纯估值买卖检测」。
- **duan-yongping-qa** — 段永平问答——以他的方式思考。用段永平的投资理念与思维框架回答问题、分析公司。Use when user says「段永平」「段永平问答」「老段怎么说」。
- **earnings-deep-read** — 财报精读——一手资料深度解读。对公司财报逐项深读，还原管理层真实意图、识别会计操纵与质量信号。Use when user says「财报精读」「读财报」「分析年报」「深度解读财报」。
- **earnings-review-team** — 财报精读团队——四大师并行解读 + 公众号发布。多角色并行拆解一份财报并产出公众号文章。Use when user says「财报精读团队」「财报团队」。
- **estimate** — Estimates task effort by analyzing complexity, dependencies, historical velocity, and risk factors. Produces a structured estimate with confidence levels.
- **financial-data** — 财务数据获取与交叉验证规范。规范财务数据来源、口径与交叉验证方法。Use when user says「财务数据」「获取财务数据」「财务数据验证」。
- **find-skills** — Helps users discover and install agent skills when they ask questions like "how do I do X", "find a skill for X", "is there a skill that can...", or express interest in extending capabilities. This skill should be used when the user is looking for functionality that might exist as an installable skill.
- **fix-ljg-org-to-md** — 扫描 skills 目录，把 org 输出格式改为 markdown，提交代码，同步到全局。Use when user says '/fix-ljg-org-to-md', 'fix org format', 'org 转 md', '把 org 改成 md', '修正输出格式'.
- **gate-check** — Validate readiness to advance between development phases. Produces a PASS/CONCERNS/FAIL verdict with specific blockers and required artifacts. Use when user says 'are we ready to move to X', 'can we advance to production', 'check if we can start the next phase', 'pass the gate'.
- **gh-reading-notes** — 读书笔记引擎——从视频字幕/电子书/文章内容中提炼结构化读书笔记。第一性原理萃取核心知识点，中间层梳理重点内容与落地案例，尾层从多维批判视角审视内容优缺点与盲点。Use when user says '读书笔记', '帮我做笔记', '总结一下这个视频', '整理成笔记', 'reading notes', 'notes', or pastes subtitle/ebook/article content wanting structured notes.
- **gh-systems-thinking** — 系统思考实践技能——基于德内拉·梅多斯《系统之美》的系统分析框架。用存量-流量-反馈回路模型拆解任何复杂问题，定位系统陷阱，找到最高杠杆干预点。Use when user says '系统思考', '系统分析', '结构分析', '杠杆点', '反馈回路', '系统陷阱', 'systems thinking', 'xitong', '用系统视角', or asks to '分析这个系统' '为什么老反复'. NOT FOR 个人心理分析（用 ljg-relationship）、个人习惯设计（可用但要把人看作系统的一部分而非责任人）、纯因果链归因（系统思考认为结构决定行为而非事件因果）.
- **gh-video-notes** — 视频读书笔记全流程——从本地视频提取MP3音频 → AsrTools CLI 自动转字幕 → 结构化读书笔记。全流程自动化，支持多种视频格式（mp4/avi/mkv/mov/ts/flv/wmv/webm）。Use when user says '视频笔记', '视频读书笔记', '从视频做笔记', '提取视频字幕做笔记', '把视频转成笔记', 'video notes', or provides a local video file path wanting structured study notes.
- **gh-web-chat** — 启动/重启本地 Web Chat 服务器，在浏览器中打开 Claude Code Chat 界面（含 Skills 面板、会话管理）。Use when user says '网页对话', '网页聊天', '打开聊天', '启动聊天', 'chat ui', 'open chat'.
- **grilling** — 对你的计划、决策或想法进行穷追不舍的连环拷问，一次一个问题逐步深入，直到达成共识。Use when user says「拷问我」「压力测试」「质疑这个想法」「grill」。
- **grill-me** — 开启一轮 relentless 拷问，磨砺一个计划或设计。
- **help** — Analyzes what is done and the users query and offers advice on what to do next. Use if user says what should I do next or what do I do now or I'm stuck or I don't know what to do
- **hotfix** — Emergency fix workflow that bypasses normal sprint processes with a full audit trail. Creates hotfix branch, tracks approvals, and ensures the fix is backported correctly.
- **html-ppt-skill** — HTML PPT 工作室——用模板制作专业静态 HTML 演示文稿，内置多套风格、布局与动画，含演讲者模式。Use when user says「做PPT」「做幻灯片」「做演示」「slides」「keynote」「deck」「演讲稿」「分享稿」「小红书图文」「pitch deck」。
- **industry-funnel** — 行业漏斗筛选——从全市场到 3 家的价值投资精选流程。Use when user says「行业漏斗」「industry funnel」。
- **industry-research** — 行业投资研究——产业链全景扫描 + 四大师个股分析框架。Use when user says「行业研究」「industry research」。
- **launch-checklist** — Complete launch readiness validation covering every department: code, content, store, marketing, community, infrastructure, legal, and go/no-go sign-offs.
- **ljg-book** — 拆一本书，以「问题」为轴心走一条线。五件事：作者在答什么问题（问题），这个问题之前各流派/社会共识怎么答（零点），作者带来什么独特洞见——公式/理论框架/模型/概念四选一——相对共识挪动了什么（位移/delta），落成哪句结论（落点），最后萃一个 takeaway 作为精神内核（行囊）。收尾画一张 ASCII 参考系图（千脑智能式）：各流派、旧共识、作者钉到同一张图的位置上，delta 是图上一段看得见的距离，再走两步做预测——看懂这本书在认知史里挪动了哪一步，还能拿它预测书外的新事。Use when user says '拆书', '拆这本', '分析这本书', '这本书在讲什么', '上帝之眼看这本书', '压缩一本书', 'book', or shares a book name wanting structural analysis. NOT FOR 章节摘要（用 Fabric extract_wisdom）、论文（用 ljg-paper）、单一观点深钻（用 ljg-think）、一个领域降秩（用 ljg-rank）.
- **ljg-card** — Content caster (铸). Transforms content into PNG visuals. Seven molds: -l (default) long reading card, -i infograph, -m multi-card reading cards (1080x1440), -v editorial sketchnote (problem→failure→pivot→insight→naming, magazine + archive layout), -c comic (manga-style B&W), -w whiteboard (marker-style board layout), -b big-fonts attachment card (1080x1440, weathered 碑刻 style for 小红书). Output to ~/Downloads/. Use when user says '铸', 'cast', '做成图', '做成卡片', '做成信息图', '做成海报', '视觉笔记', 'sketchnote', '杂志', 'editorial', '漫画', 'comic', 'manga', '白板', 'whiteboard', '大字', '附件图', 'big fonts', '小红书卡片'. Replaces ljg-cards and ljg-infograph.
- **ljg-invest** — 投资分析, 生成一份深度投资分析报告。不做传统投资分析——核心判断是项目是否是一台「秩序创造机器」。Use when user says '投资报告', '投资分析', '分析这个项目', '写投资报告', 'investment report', 'invest analysis', or provides entrepreneur conversation records wanting investment evaluation. Also trigger when user pastes or references meeting notes, pitch decks, or founder interviews and asks for analysis.
- **ljg-learn** — Deep concept anatomist that deconstructs any concept through 8 exploration dimensions (history, dialectics, phenomenology, linguistics, formalization, existentialism, aesthetics, meta-philosophy) and compresses insights into an epiphany. Use when user asks to explain, dissect, or deeply understand a concept, term, or idea. Triggers on '解剖概念', '概念解剖', 'explain concept', 'learn concept', '/ljg-learn'. Produces markdown output.
- **ljg-library** — 一本书 → 一幅清晰的「取景框」意向画面 → 一张 2050 图书馆借书卡（PNG）。取景框 = 作者从哪个角度看什么问题、看到了哪幅画面；卡上有真实封面、作者头像、书目信息。取景框 block 用费曼式讲解把这幅意向画面讲得通俗又准确；图解 block 用 AI 生图把这幅画面画出来，继刚是固定主角（从其墨像参考生成、认得出的他）。两种风格 mold：默认 -a 动物森友会（暖萌治愈），可选 -b 吉田诚治（绘本感异世界日常空间、暖光治愈）。浅色光学玻璃卡身、强调色从封面动态提取、宽高自适应。合上书记住这幅画面，就没白读。Use when user says '取景框卡', '图书馆卡', 'library card', '书卡', '铸书卡', '一本书一句话一张卡', '/ljg-library', or provides a book name and wants it distilled into one collectible card. 风格：默认 -a 动森，加 -b 走吉田诚治。NOT FOR 拆书结构分析（用 ljg-book）、纯文字金句（用 ljg-card -b）、信息图（用 ljg-card -i）、视觉笔记（用 ljg-card -v）。
- **ljg-map** — 一个行业 → 一张生态地形图卡（PNG）。以《千脑智能》参考系理论为地基：把行业摊成一张可俯瞰的「生态地形」——价值像河一样流过地貌，再在地形上标出两处——「瓶颈」（流量/产能在此收窄的隘口/水坝）和「价值捕获点」（利润在此沉淀的宝藏堆）。地形让权力结构一眼可见：卡流量的地方常常不是钱沉淀的地方。配三个关键指标的 base rate（刻度）+ 三个「大问题」（前沿）。deep research 真联网，图用 AI 生图（默认 -a 动物森友会暖萌风，可选 -c pixel+cyber），继刚作小测量员立在地形上俯瞰。Use when user says '行业地图', '产业地图', '生态地形图', '画一下这个行业', 'industry map', 'map this industry', '行业版图', '产业链地图', '/ljg-map', or gives an industry/领域 name wanting its terrain mapped. 风格：默认 -a 动森，加 -c 走 cyber。NOT FOR 一个领域降秩找生成器（用 ljg-rank）、拆一本书（用 ljg-book）、单个项目投资分析（用 ljg-invest）、一个概念深钻（用 ljg-think）。
- **ljg-paper** — Paper reader for non-academics. Reads a paper and tells it back as one continuous story — the life of the paper's core proposition (命题), told on a seven-beat spine (主角 / 困境 / 旧路 / 转折 / 解法 / 结局 / 内核): born in a bind on a base-rate ruler, crystallized as a bold conjecture, argued through mechanism and evidence, distilled into a new way of seeing, then walked out of the paper — life-tested and cashed into falsifiable predictions (检验). Output opens with a scannable 速读 card (一句话 / 大想法 / 只记三件事) that compresses the whole story three ways for the time-poor reader and the six-months-later self, then tells the full story. The job is storytelling that makes the paper land, not academic critique. Use when user shares an arxiv link, paper URL, PDF, or asks to analyze a research paper. Trigger words: '读论文', '讲论文', '把这篇讲给我听', '分析论文', 'paper', or when user shares an academic paper.
- **ljg-paper-flow** — Paper workflow: read papers + cast 取景框 library cards in one go. Takes one or more arxiv links, paper URLs, PDFs, or paper names. For each paper, runs ljg-paper (generates org analysis) then ljg-library (distills the paper's 取景框 into a 2050 library card PNG). Use when user says '论文流', 'paper flow', '读论文并做卡片', '论文卡片', or provides multiple papers wanting both analysis and cards.
- **ljg-paper-river** — 论文倒读法：给一篇论文，递归找出它批判和改进的前序论文（最多5层），再找它之后的最新进展，从源头正向讲述问题演化史。以问题为轴，费曼式讲解每篇论文看到的问题和解法创新。Use when user shares a paper and wants to understand its intellectual lineage, citation chain, problem evolution, or says '倒读', '论文溯源', '论文脉络', 'paper river', 'paper connects', 'trace back', '这篇论文的来龙去脉', '论文演化'. Also trigger when user wants to understand how a research problem evolved across multiple papers.
- **ljg-plain** — Cognitive atom: Plain (白). Rewrites any content so a smart 12-year-old groks it. Structure-free — form follows content. Use when user says '白话说', '说人话', '解释一下', 'plain', 'grok'.
- **ljg-present** — 演讲铸造器（Outline-Faithful）。基于 orgmode/markdown outline 层级 1:1 视觉化呈现——色块大字、ultra-bold 错位，原文不动只做美化。三档主题色 black/red/yellow（默认 black 或按 filetags 推断），可用 -r/-b/-y 显式覆盖；可用 --cyber 走黑底绿字 cyber-hacker 风。使用时用户会说：'讲这个'、'present'、'做成演讲'、'呈现一下'、'铸成演示'、'做个 slides'、'标语流'、'宣言体'、'slogan'、'manifesto'、'按 outline 美化'。输出单文件 HTML 到 ~/Downloads/。
- **ljg-push** — 把 ~/.claude/skills/ljg-* 里所有更新过的 skills 同步到 github repo (ljg-skills)，先推 master 分支（markdown 输出风格），再切 md 分支（markdown 输出风格）做基础 markdown 化后推。Use when user says '/ljg-push', 'push skills', '推送 skills', '同步 skills', 'sync ljg', or whenever ljg-* skills get updated and need shipping. NOT FOR pushing non-ljg skills or arbitrary git repos.
- **ljg-qa** — 信息提问机。给一篇文章/论文/书，把核心观点抽成 Q-A 对——Question 切要害，不教科书；Answer 简洁清晰，有形式化收口，逻辑链完整。读者顺 Q 链走过，每个 A 砸下一枚钉子，复现作者整套推理。Use when user says '问答', 'Q&A', 'QA', '提问', '抽取问题', '/ljg-qa', or shares an article/paper/book and asks for Q-A extraction. Triggers when the user wants ideas extracted not as a summary but as a sequence of incisive questions with answered. NOT FOR FAQ generation, glossary creation, or comprehension quizzes — this is intellectual scaffolding, not study aids.
- **ljg-rank** — 给一个领域，找出背后真正撑着它的几根独立的力。十几个现象砍到不可再少的生成器——砍完能把现象一个个生回来，才算数。Use when user says '降秩', '找秩', '秩是什么', '这个领域靠什么撑着', '背后是什么', or wants to decompose any domain to its irreducible generators.
- **ljg-read** — Reading companion agent. Accompanies user through any text (books, articles, essays, papers, news) with translation, structural annotation, deep questioning, and cross-domain insights. Detects language, translates English to Chinese (faithfulness-expressiveness-elegance), guides reader to understand the author and encounter real questions. Use when user says '伴读', '陪我读', '读这篇', 'read with me', 'companion read', or shares a text/URL wanting guided reading.
- **ljg-relationship** — Relationship analyst combining structural diagnostics (5-layer framework) with psychoanalytic depth (transference, unconscious patterns, resistance). Guides users through dialogue to "see" the real structure of their relationship issues. Use when user says "关系分析", "分析关系", "relationship", "人际关系", or describes a specific relationship problem they want to understand.
- **ljg-roundtable** — Structured roundtable discussion framework with a truth-seeking moderator who invites representative figures for dialectical debate on any topic. Use when user says "圆桌讨论", "圆桌", "roundtable", "辩论", or wants to explore a topic through multi-perspective structured debate.
- **ljg-skill-map** — Skill map viewer. Scans all installed skills and renders a visual overview — name, version, description, category at a glance. Use when user says 'skills', '技能', '技能地图', 'skill map', '我有哪些技能', '看看技能', '列出技能', 'list skills'. Also trigger when user asks what skills are available or installed.
- **ljg-think** — 追本之箭——纵向深钻思维工具。给一个观点、现象或问题，像箭一样一路向下钻到不可再分的本质。Use when user says '想透', '追本', '本质是什么', '为什么会这样', '深挖', '钻到底', 'think deep', 'drill down', or wants to trace any idea/phenomenon vertically to its irreducible root. Also trigger when user provides a statement and wants depth analysis, not breadth survey.
- **ljg-travel** — Deep travel research workflow for museums and ancient architecture. Input a city name, auto-generates structured knowledge document (markdown) + portable reference cards (PNG). Covers historical background, museum highlights, archaeological significance, and architectural heritage. Use when user says '旅行研究', '博物馆功课', '古建功课', 'travel research', '出发前功课', or provides a city name with intent to do deep cultural travel preparation.
- **ljg-word** — Deep-dive English word mastery tool. Deconstructs a single English word into core semantics and epiphany. Use when user asks to explain/master a specific English word.
- **ljg-word-flow** — Word flow: deep-dive word analysis + infograph card in one go. Takes one or more English words, runs ljg-word (generates deep semantics analysis) then ljg-card -i (generates infograph PNG). Use when user says '词卡', 'word card', 'word flow', or provides English words wanting both analysis and visual card.
- **ljg-writes** — 写作引擎。像手术刀剖开一个观点，一层层剥到底。1000-1500 字。
- **localize** — Full localization pipeline: scan for hardcoded strings, extract and manage string tables, validate translations, generate translator briefings, run cultural/sensitivity review, manage VO localization, test RTL/platform requirements, enforce string freeze, and report coverage.
- **management-research** — 管理层纵深研究——买股票就是买人。深度研究公司管理层能力、诚信与资本配置记录。Use when user says「管理层研究」「研究管理层」。
- **map-systems** — Decompose a game concept into individual systems, map dependencies, prioritize design order, and create the systems index.
- **milestone-review** — Generates a comprehensive milestone progress review including feature completeness, quality metrics, risk assessment, and go/no-go recommendation. Use at milestone checkpoints or when evaluating readiness for a milestone deadline.
- **news-pulse** — 公司新闻脉搏：股价异动时快速归因。用 4 个并行 Agent 侦察公司事件/监管政策/行业对手/市场情绪，产出"事件时间线 + 异动主因判断 + 是否触发论文重审"。
- **onboard** — Generates a contextual onboarding document for a new contributor or agent joining the project. Summarizes project state, architecture, conventions, and current priorities relevant to the specified role or area.
- **patch-notes** — Generate player-facing patch notes from git history, sprint data, and internal changelogs. Translates developer language into clear, engaging player communication.
- **perf-profile** — Structured performance profiling workflow. Identifies bottlenecks, measures against budgets, and generates optimization recommendations with priority rankings.
- **playtest-report** — Generates a structured playtest report template or analyzes existing playtest notes into a structured format. Use this to standardize playtest feedback collection and analysis.
- **portfolio-management** — 组合管理——从研究公司到管理组合。Use when user says「组合管理」「portfolio management」。
- **pre-buy-checklist** — 巴菲特价值投资买入前 Checklist。Use when user says「买入前检查」「买入checklist」「pre-buy checklist」。
- **pre-restart-check** — 重启前自检规则——任何一次建议或执行 DSH 宿主重启之前，必须先运行 dsh_preflight_check 工具（或等效手动检查），全部 PASS 才允许提示重启；存在 FAIL 必须先修复。也用于插件安装、profile 改配置后需要重启的场景。
- **project-stage-detect** — Automatically analyze project state, detect stage, identify gaps, and recommend next steps based on existing artifacts. Use when user asks 'where are we in development', 'what stage are we in', 'full project audit'.
- **propagate-design-change** — When a GDD is revised, scans all ADRs and the traceability index to identify which architectural decisions are now potentially stale. Produces a change impact report and guides the user through resolution.
- **prototype** — Concept prototype — validate the core idea is worth designing before writing GDDs. Run right after /brainstorm and /setup-engine. Routes to HTML, Engine, or Paper path based on game type. Produces a throwaway build and a PROCEED/PIVOT/KILL verdict.
- **qa-plan** — Generate a QA test plan for a sprint or feature. Reads GDDs and story files, classifies stories by test type (Logic/Integration/Visual/UI), and produces a structured test plan covering automated tests required, manual test cases, smoke test scope, and playtest sign-off requirements. Run before sprint begins or when starting a major feature.
- **quality-screen** — 去劣筛选——7 条指标快速排除非一流公司。Use when user says「去劣筛选」「质量筛选」「quality screen」。
- **quick-design** — Lightweight design spec for small changes — tuning adjustments, minor mechanics, balance tweaks. Skips full GDD authoring when a system GDD already exists or the change is too small to warrant one. Produces a Quick Design Spec that embeds directly into story files.
- **regression-suite** — Map test coverage to GDD critical paths, identify fixed bugs without regression tests, flag coverage drift from new features, and maintain tests/regression-suite.md. Run after implementing a bug fix or before a release gate.
- **release-checklist** — Generates a comprehensive pre-release validation checklist covering build verification, certification requirements, store metadata, and launch readiness.
- **research-team** — 投研团队——四角色并行分析框架。Use when user says「投研团队」「research team」。
- **retrospective** — Generates a sprint or milestone retrospective by analyzing completed work, velocity, blockers, and patterns. Produces actionable insights for the next iteration.
- **reverse-document** — Generate design or architecture documents from existing implementation. Works backwards from code/prototypes to create missing planning docs.
- **review-all-gdds** — Holistic cross-GDD consistency and game design review. Reads all system GDDs simultaneously and checks for contradictions between them, stale references, ownership conflicts, formula incompatibilities, and game design theory violations (dominant strategies, economic imbalance, cognitive overload, pillar drift). Run after all MVP GDDs are written, before architecture begins.
- **scope-check** — Analyze a feature or sprint for scope creep by comparing current scope against the original plan. Flags additions, quantifies bloat, and recommends cuts. Use when user says 'any scope creep', 'scope review', 'are we staying in scope'.
- **security-audit** — Audit the game for security vulnerabilities: save tampering, cheat vectors, network exploits, data exposure, and input validation gaps. Produces a prioritised security report with remediation guidance. Run before any public release or multiplayer launch.
- **setup-engine** — Configure the project's game engine and version. Pins the engine in CLAUDE.md, detects knowledge gaps, and populates engine reference docs via WebSearch when the version is beyond the LLM's training data.
- **sigma** — Personalized 1-on-1 AI tutor using Bloom's 2-Sigma mastery learning. Guides users through any topic with Socratic questioning, adaptive pacing, and rich visual output (HTML dashboards, Excalidraw concept maps, generated images). Use when user wants to learn something, study a topic, understand a concept, requests tutoring, says 'teach me', 'I want to learn', 'explain X to me step by step', 'help me understand', or invokes /sigma. Triggers on: learn, study, teach, tutor, understand, master, explain step by step.
- **skill-forge** — Create high-quality, production-grade skills for Claude Code. Expert guidance on skill architecture, workflow design, prompt engineering, and packaging. Use when user wants to create a new skill, build a skill, design a skill, write a skill, update an existing skill, improve a skill, refactor a skill, debug a skill, or package a skill. Triggers: 'create skill', 'build skill', 'new skill', 'skill creation', 'write a skill', 'make a skill', 'design a skill', 'improve skill', 'package skill', 'skill development', 'skill template', 'skill best practices', 'write SKILL.md'.
- **skill-improve** — Improve a skill using a test-fix-retest loop. Runs static checks, proposes targeted fixes, rewrites the skill, re-tests, and keeps or reverts based on score change.
- **skill-review** — Quality review and audit for Claude Code skills. Analyzes skill structure, description quality, workflow design, token efficiency, and anti-patterns against best practices. Use when user wants to review a skill, audit a skill, check skill quality, evaluate a skill, critique a skill, lint a skill, or validate a skill. Triggers: 'review skill', 'audit skill', 'skill quality', 'check my skill', 'evaluate skill', 'skill lint', 'validate skill', 'skill review', 'is this skill good', 'improve this skill'.
- **skill-test** — Validate skill files for structural compliance and behavioral correctness. Three modes: static (linter), spec (behavioral), audit (coverage report).
- **smoke-check** — Run the critical path smoke test gate before QA hand-off. Executes the automated test suite, verifies core functionality, and produces a PASS/FAIL report. Run after a sprint's stories are implemented and before manual QA begins. A failed smoke check means the build is not ready for QA.
- **soak-test** — Generate a soak test protocol for extended play sessions. Defines what to observe, measure, and log during long play sessions to surface slow leaks, fatigue effects, and edge cases that only appear after sustained play. Primarily used in Polish and Release phases.
- **sprint-plan** — Generates a new sprint plan or updates an existing one based on the current milestone, completed work, and available capacity. Pulls context from production documents and design backlogs.
- **sprint-status** — Fast sprint status check. Reads the current sprint plan, scans story files for status, and produces a concise progress snapshot with burndown assessment and emerging risks. Run at any time during a sprint for quick situational awareness. Use when user asks 'how is the sprint going', 'sprint update', 'show sprint progress'.
- **start** — First-time onboarding — asks where you are, then guides you to the right workflow. No assumptions.
- **story-done** — End-of-story completion review. Reads the story file, verifies each acceptance criterion against the implementation, checks for GDD/ADR deviations, prompts code review, updates story status to Complete, and surfaces the next ready story from the sprint.
- **story-readiness** — Validate that a story file is implementation-ready. Checks for embedded GDD requirements, ADR references, engine notes, clear acceptance criteria, and no open design questions. Produces READY / NEEDS WORK / BLOCKED verdict with specific gaps. Use when user says 'is this story ready', 'can I start on this story', 'is story X ready to implement'.
- **team-audio** — Orchestrate audio team: audio-director + sound-designer + technical-artist + gameplay-programmer for full audio pipeline from direction to implementation.
- **team-combat** — Orchestrate the combat team: coordinates game-designer, gameplay-programmer, ai-programmer, technical-artist, sound-designer, and qa-tester to design, implement, and validate a combat feature end-to-end.
- **team-level** — Orchestrate level design team: level-designer + narrative-director + world-builder + art-director + systems-designer + qa-tester for complete area/level creation.
- **team-live-ops** — Orchestrate the live-ops team for post-launch content planning: coordinates live-ops-designer, economy-designer, analytics-engineer, community-manager, writer, and narrative-director to design and plan a season, event, or live content update.
- **team-narrative** — Orchestrate the narrative team: coordinates narrative-director, writer, world-builder, and level-designer to create cohesive story content, world lore, and narrative-driven level design.
- **team-polish** — Orchestrate the polish team: coordinates performance-analyst, technical-artist, sound-designer, and qa-tester to optimize, polish, and harden a feature or area for release quality.
- **team-qa** — Orchestrate the QA team through a full testing cycle. Coordinates qa-lead (strategy + test plan) and qa-tester (test case writing + bug reporting) to produce a complete QA package for a sprint or feature. Covers: test plan generation, test case writing, smoke check gate, manual QA execution, and sign-off report.
- **team-release** — Orchestrate the release team: coordinates release-manager, qa-lead, devops-engineer, and producer to execute a release from candidate to deployment.
- **team-ui** — Orchestrate the UI team through the full UX pipeline: from UX spec authoring through visual design, implementation, review, and polish. Integrates with /ux-design, /ux-review, and studio UX templates.
- **tech-debt** — Track, categorize, and prioritize technical debt across the codebase. Scans for debt indicators, maintains a debt register, and recommends repayment scheduling.
- **test-evidence-review** — Quality review of test files and manual evidence documents. Goes beyond existence checks — evaluates assertion coverage, edge case handling, naming conventions, and evidence completeness. Produces ADEQUATE/INCOMPLETE/MISSING verdict per story. Run before QA sign-off or on demand.
- **test-flakiness** — Detect non-deterministic (flaky) tests by reading CI run logs or test result history. Aggregates pass rates per test, identifies intermittent failures, recommends quarantine or fix, and maintains a flaky test registry. Best run during Polish phase or after multiple CI runs.
- **test-helpers** — Generate engine-specific test helper libraries for the project's test suite. Reads existing test patterns and produces tests/helpers/ with assertion utilities, factory functions, and mock objects tailored to the project's systems. Reduces boilerplate in new test files.
- **test-setup** — Scaffold the test framework and CI/CD pipeline for the project's engine. Creates the tests/ directory structure, engine-specific test runner configuration, and GitHub Actions workflow. Run once during Technical Setup phase before the first sprint begins.
- **thesis-drift** — 投资论文漂移检测——分清事实变化与措辞变化。Use when user says「论文漂移」「投资论文漂移」「thesis drift」。
- **thesis-tracking** — 投资论文追踪——买入后的纪律系统。Use when user says「论文追踪」「投资论文追踪」「thesis tracking」。
- **unlisted-company-research** — 未上市公司研究——多 Agent 并行深度研究框架。Use when user says「未上市公司」「未上市研究」「unlisted company」。
- **ux-design** — Guided, section-by-section UX spec authoring for a screen, flow, or HUD. Reads game concept, player journey, and relevant GDDs to provide context-aware design guidance. Produces ux-spec.md (per screen/flow) or hud-design.md using the studio templates.
- **ux-review** — Validates a UX spec, HUD design, or interaction pattern library for completeness, accessibility compliance, GDD alignment, and implementation readiness. Produces APPROVED / NEEDS REVISION / MAJOR REVISION NEEDED verdict with specific gaps.
- **vertical-slice** — Pre-Production validation — build a production-quality end-to-end build to confirm the full game loop is achievable before committing to Production. Run after GDDs, architecture, and UX specs are complete. Produces a PROCEED/PIVOT/KILL verdict that gates the Pre-Production → Production transition.
- **wechat-article** — 微信公众号文章——作者-编辑-读者三 Agent 协作生产。Use when user says「公众号文章」「写公众号」。
- **wiki-ingest** — Compile articles, documents, or notes into a structured wiki knowledge base. Use when user says 'ingest to wiki', 'compile to knowledge base', 'update wiki', 'wiki ingest', 'add this to wiki', or invokes /wiki-ingest. Supports single or batch ingest. Triggers: wiki, ingest, knowledge base, compile, digest, index, catalog.
