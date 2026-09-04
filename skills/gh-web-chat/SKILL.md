---
name: gh-web-chat
description: 启动/重启本地 Web Chat 服务器，在浏览器中打开 Claude Code Chat 界面（含 Skills 面板、会话管理）。Use when user says '网页对话', '网页聊天', '打开聊天', '启动聊天', 'chat ui', 'open chat'.
user_invocable: true
version: "1.0.0"
---

# gh-网页对话：启动网页聊天界面

启动本地的 Claude Code Web Chat 服务器，并在浏览器中打开。

## 操作

执行以下步骤：

1. 关闭端口 3456 上的旧进程（如果存在）
2. 启动 `C:\Users\Cabin\.claude\web-chat\server.js`
3. 提示用户在浏览器打开 `http://localhost:3456`

如果服务器已在运行，告知用户直接访问即可。

## 实现

用 PowerShell 执行：

```powershell
# kill old
$pids = (netstat -ano | Select-String ":3456.*LISTENING" | ForEach-Object { ($_ -split '\s+')[4] } | Select-Object -Unique)
foreach ($pid in $pids) { Stop-Process -Id $pid -Force -ErrorAction SilentlyContinue }
# start new
Start-Process -FilePath "node" -ArgumentList "C:\Users\Cabin\.claude\web-chat\server.js" -WindowStyle Hidden
Start-Sleep -Seconds 3
Write-Host "✅ http://localhost:3456 已启动"
```
