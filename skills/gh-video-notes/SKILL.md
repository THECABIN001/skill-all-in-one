---
name: gh-video-notes
description: 视频读书笔记全流程——从本地视频提取MP3音频 → AsrTools CLI 自动转字幕 → 结构化读书笔记。全流程自动化，支持多种视频格式（mp4/avi/mkv/mov/ts/flv/wmv/webm）。Use when user says '视频笔记', '视频读书笔记', '从视频做笔记', '提取视频字幕做笔记', '把视频转成笔记', 'video notes', or provides a local video file path wanting structured study notes.
user_invocable: true
version: "2.0.0"
---

# gh-视频读书笔记：视频 → 字幕 → 读书笔记 全自动流程

输入一个本地视频文件，自动完成三步流水线：提取 MP3 音频 → 语音转字幕 → 结构化读书笔记。全程命令行自动化，无需手动 GUI 操作。

## 完整流程

```
┌──────────────┐     ┌──────────────────┐     ┌──────────────────┐     ┌──────────────────┐
│  本地视频     │ ──→ │  MP3 音频        │ ──→ │  SRT 字幕文件     │ ──→ │  结构化读书笔记    │
│  (任意格式)   │     │  (ffmpeg 提取)   │     │  (asr_cli.py)    │     │  (/gh-读书笔记)   │
└──────────────┘     └──────────────────┘     └──────────────────┘     └──────────────────┘
  全自动 ✓              全自动 ✓                全自动 ✓                 全自动 ✓
```

## 工具清单

| 工具 | 路径 | 用途 |
|------|------|------|
| ffmpeg | 系统 PATH | 视频 → MP3 音频提取 |
| AsrTools CLI | `L:\AsrTools-v1.0.1\asr_cli.py` | MP3 → SRT 字幕转录 |
| Python runtime | `L:\AsrTools-v1.0.1\runtime\python.exe` | 运行 asr_cli.py |

---

## 第一步：环境检查

执行以下检查，全部通过才进入下一步：

### 1.1 检查 ffmpeg

```powershell
ffmpeg -version
```

**如果未安装：**

```powershell
winget install ffmpeg
```

安装后需重启终端。如果 winget 不可用，手动下载：https://ffmpeg.org/download.html

### 1.2 检查 AsrTools CLI

```powershell
Test-Path "L:\AsrTools-v1.0.1\asr_cli.py"
```

如果返回 `False`，报错：AsrTools CLI 脚本未找到，请确认 AsrTools 安装路径。

### 1.3 检查 AsrTools Python 运行时

```powershell
& "L:\AsrTools-v1.0.1\runtime\python.exe" --version
```

应输出 `Python 3.10.9`。

### 1.4 检查结果模板

```
✅ ffmpeg:  已安装 (版本 X.X.X)
✅ asr_cli: 已就绪 (L:\AsrTools-v1.0.1\asr_cli.py)
✅ Python:  已就绪 (Python 3.10.9)
```

全部通过 → 进入第二步。任何一项失败 → 引导用户修复后重试。

---

## 第二步：提取 MP3 音频

### 支持格式

输入视频支持：`.mp4` `.avi` `.mkv` `.mov` `.ts` `.flv` `.wmv` `.webm` `.m4v` `.3gp`

### 操作

**1. 确认视频路径**

如果用户没有提供完整路径，主动询问。相对路径基于当前工作目录解析。

**2. 先检查音频流是否存在**

```powershell
ffprobe "视频路径" -show_streams -select_streams a 2>&1
```

如果没有任何输出（无音频流），告知用户该视频无法处理，终止流程。

**3. 执行提取**

```powershell
ffmpeg -i "视频路径" -vn -acodec libmp3lame -q:a 2 "输出路径_audio.mp3"
```

参数说明：
- `-vn`：去掉视频流
- `-acodec libmp3lame`：MP3 编码
- `-q:a 2`：高质量 VBR（约 190kbps）

**输出路径规则：** `{视频文件所在目录}\{视频文件名（不含扩展名）}_audio.mp3`。

如果目标文件已存在，先询问用户是否覆盖。不要静默覆盖。

**4. 确认输出**

```powershell
Get-Item "输出路径_audio.mp3" | Select-Object Name, @{N="Size(MB)";E={[math]::Round($_.Length/1MB,2)}}
```

告知用户：MP3 文件路径、大小、ffmpeg 耗时。

### 多视频处理

如果用户提供了目录路径，遍历目录筛选支持的视频格式，逐个提取。用 `Get-ChildItem` 列出文件，按上述流程逐个处理。

---

## 第三步：AsrTools CLI 语音转字幕

### 命令格式

```powershell
& "L:\AsrTools-v1.0.1\runtime\python.exe" "L:\AsrTools-v1.0.1\asr_cli.py" "音频文件.mp3" -e <引擎> [-o 输出.srt] [--txt]
```

### 引擎选择

| 参数 | 引擎 | 特点 | 推荐场景 |
|------|------|------|----------|
| `-e b` | BcutASR (必剪) | 免费, 速度快, 中文准确率高 | **默认，首选** |
| `-e j` | JianYingASR (剪映) | 免费, 准确率最高, 速度稍慢 | 高精度需求 |
| `-e k` | KuaiShouASR (快手) | 免费, 备选 | B/J 不可用时 |

**默认使用 `-e b`。** 除非用户明确要求其他引擎。

### 操作

**1. 执行转录**

```powershell
& "L:\AsrTools-v1.0.1\runtime\python.exe" "L:\AsrTools-v1.0.1\asr_cli.py" "第二步的输出_audio.mp3" -e b
```

命令会自动：
- 上传音频到云端 ASR 服务
- 轮询等待转录完成
- 将 SRT 字幕写入与输入同目录的 `.srt` 文件

**注意：此步骤需要联网，耗时取决于音频长度。** 一般 10 分钟音频约需 30-60 秒。

**2. 确认输出**

```powershell
Get-Item "输出路径_audio.srt" | Select-Object Name, @{N="Size(KB)";E={[math]::Round($_.Length/1KB,2)}}
```

检查 SRT 文件非空：读取前几行确认内容有效。

**3. 错误处理**

如果 CLI 报错：
- `文件不存在` → 检查 MP3 路径
- `转录失败` → 检查网络连接，或换引擎重试（`-e j`）
- `转录结果为空` → 音频可能无有效语音，或用 ffprobe 检查音频流

---

## 第四步：生成读书笔记

### 4.1 读取并清洗 SRT 字幕

SRT 格式示例：

```
1
00:00:01,234 --> 00:00:04,567
大家好今天我们来聊一聊

2
00:00:05,000 --> 00:00:08,900
关于投资的一些思考
```

清洗规则：
1. 去掉纯数字行（序号）
2. 去掉含 `-->` 的时间戳行
3. 去掉空行
4. 剩余文本行合并为连续段落

用 PowerShell 快速清洗：

```powershell
$srt = Get-Content "输出_audio.srt" -Encoding UTF8 -Raw
$text = $srt -replace '\d+\r?\n', '' -replace '.*-->.*\r?\n', '' -replace '\r?\n\r?\n', "`n"
```

实际处理时，用 Read 工具读取 SRT 文件后，在上下文中完成清洗：只保留文本行，合并为完整段落。

### 4.2 调用 gh-读书笔记

将清洗后的纯文本内容传给 `/gh-读书笔记` 技能。用 Skill 工具调用：`skill="gh-读书笔记"`。

调用时在 prompt 中拼接：

```
请为以下视频字幕内容生成结构化读书笔记：

视频文件：{原始视频文件名}
字幕来源：AsrTools {引擎名称} 自动转录

---
{清洗后的纯文本内容}
---
```

然后等待 gh-读书笔记 输出完整的三层结构化笔记。

### 4.3 保存笔记

将生成的笔记保存为 markdown 文件：

```
{视频文件所在目录}\{视频文件名（不含扩展名）}_笔记.md
```

---

## 全局交互流程

```
用户提供视频路径
    │
    ▼
【第一步：环境检查】
  检查 ffmpeg / asr_cli.py / Python runtime
  ├─ 全部通过 → 继续
  └─ 缺少工具 → 引导安装 → 重新检查
    │
    ▼
【第二步：提取 MP3】
  ffprobe 检查音频流 → ffmpeg 提取 → 确认输出
    │
    ▼
【第三步：ASR 转录】
  asr_cli.py -e b → 等待完成 → 确认 SRT 输出
    │
    ▼
【第四步：生成笔记】
  读取 SRT → 清洗纯文本 → 调用 /gh-读书笔记 → 保存 markdown
```

**每一步执行后汇报结果**，不要跳过汇报环节。

---

## 常见问题

### Q: 视频没有声音轨道？
A: 在第二步用 `ffprobe` 预检。无音频流 → 直接终止，告知用户。

### Q: asr_cli.py 报"转录失败"？
A: 可能原因：
- **网络问题**：B/J/K 接口都需要联网。检查网络，重试。
- **引擎限流**：换引擎 `-e j` 或 `-e k` 重试。
- **MP3 文件过大**：先分段再用 CLI 分别处理。

### Q: SRT 字幕识别不准确？
A:
- 确保 MP3 音频清晰，背景噪音小
- 换用 `-e j`（剪映引擎），准确率通常更高
- 中文内容用 `-e b` 或 `-e j`，英文内容用 `-e k` 试试

### Q: 视频时长很长（>2 小时）？
A: 用 ffmpeg 分段提取，然后分别转录：

```powershell
ffmpeg -i "视频.mp4" -vn -acodec libmp3lame -q:a 2 -f segment -segment_time 1800 "输出_%03d.mp3"
```

每段 30 分钟（1800 秒），然后在 PowerShell 中循环调用 asr_cli.py 处理每段。

---

## 反翻译腔自查

- **通过...的方式** → 直接动词
- **进行（处理/转换/提取）** → 用具体动词
- **值得注意的是** → 删掉
- 步骤描述用祈使句："提取音频"而非"我们需要提取音频"

---

## 红线

1. **三步必须完整走完。** 提取 MP3 → ASR 转录 → 生成笔记，不可跳过任何一步。
2. **环境检查必须先行。** 不要在 ffmpeg 未装或 asr_cli.py 缺失时强行执行。
3. **SRT 清洗必须彻底。** 序号行、时间戳行、空白行必须全部去掉，不能把 `00:01:23,456 --> 00:01:25,789` 传给读书笔记引擎。
4. **视频文件不存在时立即终止。** 不要让用户等了一圈才发现路径有问题。
5. **已有同名 MP3 文件时必须询问。** 不要静默覆盖用户已有的文件。
6. **转录结果为空时必须报错。** 不要拿空白内容去生成读书笔记。
7. **笔记必须保存为文件。** 不要只在聊天窗口输出，要写入 `.md` 文件。
