# install.ps1 — link every skill in this repo into the local agent skills dir.
# Usage (Windows PowerShell):
#   .\install.ps1                 # link into %USERPROFILE%\.agents\skills  (DSH)
#   .\install.ps1 -Claude         # also link into %USERPROFILE%\.claude\skills (Claude Code)
[CmdletBinding()]
param(
    [string]$RepoPath = (Split-Path -Parent $PSScriptRoot),
    [string]$Target   = (Join-Path $env:USERPROFILE ".agents\skills"),
    [switch]$Claude
)
$SkillDir = Join-Path $RepoPath "skills"
if (-not (Test-Path $SkillDir)) { Write-Error "skills/ not found under '$RepoPath'"; exit 1 }
New-Item -ItemType Directory -Path $Target -Force | Out-Null

foreach ($d in (Get-ChildItem $SkillDir -Directory)) {
    $link = Join-Path $Target $d.Name
    if (Test-Path $link) {
        $item = Get-Item $link -Force
        if ($item.LinkType) { Remove-Item $link -Force -ErrorAction SilentlyContinue }
        else { Write-Warning "'$link' exists and is not a link -- skipping (remove it first)"; continue }
    }
    New-Item -ItemType Junction -Path $link -Target $d.FullName | Out-Null
    Write-Host "linked $($d.Name)"
}
Write-Host "Installed $((Get-ChildItem $SkillDir -Directory).Count) skills into $Target"

if ($Claude) {
    $ct = Join-Path $env:USERPROFILE ".claude\skills"
    if (-not (Test-Path $ct)) { New-Item -ItemType Directory -Path $ct -Force | Out-Null }
    foreach ($d in (Get-ChildItem $SkillDir -Directory)) {
        $link = Join-Path $ct $d.Name
        if (Test-Path $link) { Remove-Item $link -Force -ErrorAction SilentlyContinue }
        New-Item -ItemType Junction -Path $link -Target $d.FullName | Out-Null
    }
    Write-Host "Also linked into $ct"
}
