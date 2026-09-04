---
name: pre-restart-check
description: 重启前自检规则——任何一次建议或执行 DSH 宿主重启之前，必须先运行 dsh_preflight_check 工具（或等效手动检查），全部 PASS 才允许提示重启；存在 FAIL 必须先修复。也用于插件安装、profile 改配置后需要重启的场景。
---

# Pre-Restart Check（重启前自检）

## When to Use This Skill

- 你正要建议用户重启 DSH 宿主（`pnpm dsh web` 重启、CLI 重启等）
- 安装/卸载插件、修改 profile 配置后需要重启生效
- 用户说"重启了打不开/重启报错"之后的复查
- 任何"重启才生效"的改动落地之后、用户动手重启之前

## 铁律

**检查不通过，就不允许提示重启。** 先修好，再复检，最后才说"可以重启"。

## 步骤

### 1. 优先用工具

调用工具 `dsh_preflight_check`（参数可选：`profile` 默认 web，`checkout` 自动探测）。

它依次检查：
1. profile 补丁层重复 entry id（含与 bundle 补丁撞 id——loader 装配冲突会启动崩）
2. profile 本地 bundle 插件的模块可加载（顶层 import 解析冒烟测试——`module not found` 是启动崩头号原因）
3. pnpm peer 依赖完整（`pnpm peers check`）
4. 启动装配模拟（`pnpm dsh --profile <p> --dump-config`，与启动同路径、不开服务器）
5. `llm-pi-ai` 路由的 `apiKeyEnv` 引用有对应凭据（缺 key 运行时 401）

结果格式：每项 ✅/❌ + 明细，末尾一句结论（"可以重启"或"先修复再重启"）。

- **全部 ✅** → 明确告诉用户：可以重启。
- **有 ❌** → 逐条修复 → 重跑工具直到全绿 → 才允许提示重启。修复不了的要如实报告阻塞点，而不是让用户碰运气。

### 2. 工具不可用时的手动等价检查（按序执行）

工具没出现在目录里（比如插件没装上）时，用 pwsh 手动跑：

```powershell
# ① 补丁重复 id：每个 profile 的 cordis.patch.yml 及 profile node_modules 下
#    各插件的 cordis.patch.yml，grep "- id:"（跳过 # 注释行），查同文件重复与
#    insert 行跨文件撞 id。
# ② 模块冒烟（在 profile 目录）：
cd C:\Users\Cabin\.dsh\profiles\web
node --input-type=module -e "import('dsh-vision-router').then(m=>console.log('OK')).catch(e=>{console.error(e.code,e.message);process.exit(1)})"
#    ——对 profiles/web/package.json 的 dsh.profile.bundles 里每个本地包跑一遍
# ③ peer 完整：pnpm peers check（profile 目录）
# ④ 装配模拟：在 checkout 目录跑 pnpm dsh --profile web --dump-config，看 exit code
# ⑤ 凭据引用：settings.yaml 里 apiKeyEnv: X → 检查 .credentials.yaml 或进程环境有 X
```

### 3. 重启后复查

用户重启完成后：
- 让用户确认启动无报错、页面能打开
- 用 `dev_plugin_status` 核对关键插件 fiber 状态
- 涉及视觉/模型链路时，发一张图或跑一次对应工具做冒烟验证

## 历史教训（为什么必须自检）

- 2026-08：把没有 `dsh.bundle.patch` 声明的插件塞进 profile bundles → 启动即崩（`declares no dsh.bundle`）。
- 2026-08：`dsh-vision-router` 的 npm 版依赖链缺 9 个 `@deepseek-ai/*` peer → 模块顶层 import 解析失败，重启必崩；补装 peer 后冒烟通过。
- 2026-08：准入补丁改核心代码（api-proxy 的 src + lib），忘了先跑装配模拟，用户重启前才发现。

规则来源：这些事故都是"没检查就重启"造成的。每次重启前跑一遍 dsh_preflight_check，是本环境的强制纪律。
