<#
.SYNOPSIS
  Install Elizameter — plugin + Rainmeter skins — into the local system.

.DESCRIPTION
  1. Links plugin/@elizameter/plugin-widgets into the local Milady plugin
     search path (via MILADY_EXTRA_PLUGINS env var or a directory link,
     depending on whether a Milady checkout is found).
  2. Copies Skins/Elizameter into %APPDATA%\Rainmeter\Skins\Elizameter.
  3. Refreshes Rainmeter if it's running.

.PARAMETER MiladyRoot
  Path to a local Milady checkout. Default: C:\Users\$env:USERNAME\Documents\Playground\milady.

.PARAMETER SkipPlugin
  Skip plugin linking. Useful if you only want the skins refreshed.

.PARAMETER SkipSkins
  Skip skin copy.

.EXAMPLE
  ./install.ps1
#>

[CmdletBinding()]
param(
    [string]$MiladyRoot = "$env:USERPROFILE\Documents\Playground\milady",
    [switch]$SkipPlugin,
    [switch]$SkipSkins
)

$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "Elizameter installer" -ForegroundColor Cyan
Write-Host "repo root: $repoRoot"

# ── Plugin ──────────────────────────────────────────────────────────

if (-not $SkipPlugin) {
    $pluginSrc = Join-Path $repoRoot "plugin\@elizameter\plugin-widgets"
    if (-not (Test-Path $pluginSrc)) {
        throw "plugin source not found at $pluginSrc"
    }
    if (-not (Test-Path $MiladyRoot)) {
        Write-Warning "Milady checkout not found at $MiladyRoot — skipping plugin link. Rerun with -MiladyRoot or copy the plugin manually."
    } else {
        Write-Host "linking plugin into Milady at: $MiladyRoot" -ForegroundColor Green
        # TODO(install): decide final plugin-link strategy. Options:
        #   1. Append to MILADY_EXTRA_PLUGINS env var so the runtime auto-loads it.
        #   2. Drop a symlink into eliza/plugins/plugin-widgets and add to
        #      the character's enabled plugins list.
        # For now, print the manual step so first-time users aren't surprised.
        Write-Host "  → manual step (for now):" -ForegroundColor Yellow
        Write-Host "    bun add --dev file:$pluginSrc   # from your Milady root" -ForegroundColor Yellow
        Write-Host "    then add '@elizameter/plugin-widgets' to your character's plugins list"
    }
}

# ── Skins ───────────────────────────────────────────────────────────

if (-not $SkipSkins) {
    $skinSrc = Join-Path $repoRoot "Skins\Elizameter"
    $skinDst = Join-Path $env:APPDATA "Rainmeter\Skins\Elizameter"
    if (-not (Test-Path $skinSrc)) {
        throw "skins source not found at $skinSrc"
    }
    Write-Host "copying skins to: $skinDst" -ForegroundColor Green
    if (-not (Test-Path $skinDst)) {
        New-Item -ItemType Directory -Path $skinDst | Out-Null
    }
    Copy-Item -Path (Join-Path $skinSrc "*") -Destination $skinDst -Recurse -Force
}

# ── Rainmeter refresh ───────────────────────────────────────────────

$rainmeterExe = Join-Path $env:ProgramFiles "Rainmeter\Rainmeter.exe"
if (Test-Path $rainmeterExe) {
    $rainmeterProc = Get-Process -Name Rainmeter -ErrorAction SilentlyContinue
    if ($rainmeterProc) {
        Write-Host "refreshing Rainmeter" -ForegroundColor Green
        & $rainmeterExe "!RefreshApp"
    } else {
        Write-Host "Rainmeter not running — skins will load on next start" -ForegroundColor Yellow
    }
} else {
    Write-Warning "Rainmeter not found at $rainmeterExe — skins were copied but Rainmeter will need to be installed to use them."
}

Write-Host ""
Write-Host "done." -ForegroundColor Cyan
Write-Host "next: open Rainmeter → Manage → find 'Elizameter\Status\Status.ini' → Load"
