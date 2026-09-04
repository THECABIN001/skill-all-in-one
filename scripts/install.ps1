# install.ps1 — copy or LINK every skill in this repo into the local agent skills dir.
# Usage (Windows PowerShell):
#   .\install.ps1                 # LINK into %USERPROFILE%\.agents\skills  (DSH)
#   .\install.ps1 -Copy           # COPY (no repo dependency) into %USERPROFILE%\.agents\skills
#   .\install.ps1 --copy          # same as -Copy (GNU-style flag)
#   .\install.ps1 -Claude         # ALSO install to %USERPROFILE%\.claude\skills (Claude Code)
param(
    [string]$RepoPath = (Split-Path -Parent $PSScriptRoot),
    [string]$Target   = (Join-Path $env:USERPROFILE ".agents\skills"),
    [switch]$Copy,
    [switch]$Claude
)
$WantCopy   = $Copy -or ($args -contains '--copy')
$WantClaude = $Claude -or ($args -contains '--claude')
$SkillDir = Join-Path $RepoPath "skills"
if (-not (Test-Path $SkillDir)) { Write-Error "skills/ not found under '$RepoPath'"; exit 1 }
$mode = if ($WantCopy) { 'copy' } else { 'link' }

function Install-Dir([string]$destRoot) {
    New-Item -ItemType Directory -Path $destRoot -Force | Out-Null
    foreach ($d in (Get-ChildItem $SkillDir -Directory)) {
        $dest = Join-Path $destRoot $d.Name
        if ($WantCopy) {
            if (Test-Path $dest) { Remove-Item $dest -Recurse -Force -ErrorAction SilentlyContinue }
            Copy-Item $d.FullName $dest -Recurse -Force
            Write-Host "  copy $($d.Name)"
        } else {
            if (Test-Path $dest) {
                $item = Get-Item $dest -Force
                if ($item.LinkType) { Remove-Item $dest -Force -ErrorAction SilentlyContinue }
                else { Write-Warning "'$dest' exists -- skipping (remove it first)"; continue }
            }
            New-Item -ItemType Junction -Path $dest -Target $d.FullName | Out-Null
            Write-Host "  link $($d.Name)"
        }
    }
    Write-Host "done: $((Get-ChildItem $SkillDir -Directory).Count) skills ($mode) -> $destRoot"
}

Write-Host "mode: $mode"
Install-Dir $Target
if ($WantClaude) { Install-Dir (Join-Path $env:USERPROFILE ".claude\skills") }
