# skill-all-in-one

本仓库把本机 `~/.agents/skills/` 下的全部 agent 技能（skill）打包成一版，用于在一台新电脑上快速装回同一套技能。

This repo packages **all** of the agent skills from `~/.agents/skills/` so you can restore the exact same set on a fresh machine.

## 内容 / Contents

- `skills/` — 全部 `136` 个技能目录，每个目录内是 `SKILL.md`（直接可被 agent 加载）。
- `scripts/install.ps1` — Windows 安装脚本（用 junction 链接进技能目录）。
- `scripts/install.sh` — macOS / Linux 安装脚本（用符号链接）。
- 技能清单（每项：名字 + 描述）见下方 `## 技能清单`。

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

如需同时装进 Claude Code 的技能目录 `%USERPROFILE%\.claude\skills`，加 `-Claude`：

```powershell
.\scripts\install.ps1 -Claude
```

**macOS / Linux** — 链接进 `~/.agents/skills`：

```bash
bash scripts/install.sh
```

如需同时装进 `~/.claude/skills`：

```bash
bash scripts/install.sh --claude
```

### 更新 / 3. Update

因为安装用的是链接（junction/symlink），技能指向仓库里的源文件——拉取并更新即可生效：

```bash
git pull
```

## 链接还是拷贝 / Links vs copies

安装脚本默认用链接（Windows junction / Unix symlink），好处是 `git pull` 后技能自动跟着更新。若你想脱离仓库使用（怕误删仓库），把 `skills/*` 复制成真实目录即可（Windows 用 `Copy-Item -Recurse`，Unix 用 `cp -r`），或直接在脚本里改为拷贝。

## 维护 / Maintain

在 `skills/` 里直接修改技能文件，提交回本仓库：

```bash
git add skills && git commit -m "update skills"
git push
```

## 凭据 / Credentials（私有仓库）

本仓库为**私有**。新机器克隆前需先认证 GitHub：

- 配置 SSH 密钥：`ssh-keygen -t ed25519` → 把公钥加到 GitHub → `git@github.com:THECABIN001/skill-all-in-one.git`；或
- 配置 PAT（HTTPS）：`git clone https://github.com/THECABIN001/skill-all-in-one.git` 时用 PAT 作为密码。

## 技能清单 / Skills

共 `136` 个技能，全部在 `skills/` 目录下，安装脚本逐目录链接。完整的名字与描述以每个技能的 `SKILL.md` 开头 frontmatter 为准。
