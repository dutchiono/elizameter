<#
.SYNOPSIS
  Install Elizameter — plugin + Rainmeter skins — into the local system,
  without modifying Milady's working tree.

.DESCRIPTION
  Strategy: keep Milady pristine.

  1. Creates NTFS junctions from Milady's node_modules into this repo's
     plugin source at three resolution points (root, apps/app, apps/home).
     This mirrors the semantics of Milady's own link-external-plugins.mjs
     without editing that file.
  2. Adds "@elizameter/plugin-widgets" to the plugins.allow list in
     ~/.milady/milady.json (idempotent — runs outside the Milady repo).
  3. Copies Skins/Elizameter to %APPDATA%\Rainmeter\Skins\Elizameter.
  4. Tells Rainmeter to refresh if it's running.

  Caveat: `bun install` inside Milady will wipe the junction. Re-run
  this script after any Milady reinstall.

.PARAMETER MiladyRoot
  Path to the local Milady checkout. Default: ~/Documents/Playground/milady.

.PARAMETER MiladyStateDir
  Path to the Milady state dir holding milady.json. Default: ~/.milady.

.PARAMETER SkipPlugin
  Skip the plugin link + config update (only refresh skins).

.PARAMETER SkipSkins
  Skip the Rainmeter skin copy.

.EXAMPLE
  ./install.ps1
#>

[CmdletBinding()]
param(
    [string]$MiladyRoot = "$env:USERPROFILE\Documents\Playground\milady",
    [string]$MiladyStateDir = "$env:USERPROFILE\.milady",
    [switch]$SkipPlugin,
    [switch]$SkipSkins
)

$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "Elizameter installer" -ForegroundColor Cyan
Write-Host "  repo:   $repoRoot"
Write-Host "  milady: $MiladyRoot"
Write-Host "  state:  $MiladyStateDir"
Write-Host ""

# ── Plugin: junctions + config.plugins.allow ────────────────────────

if (-not $SkipPlugin) {
    $pluginSrc = Join-Path $repoRoot "plugin\@elizameter\plugin-widgets"
    if (-not (Test-Path $pluginSrc)) {
        throw "plugin source not found at $pluginSrc"
    }

    if (-not (Test-Path $MiladyRoot)) {
        Write-Warning "Milady checkout not found at $MiladyRoot — pass -MiladyRoot to override. Skipping plugin link."
    } else {
        $linkTargets = @(
            (Join-Path $MiladyRoot "node_modules\@elizameter\plugin-widgets"),
            (Join-Path $MiladyRoot "apps\app\node_modules\@elizameter\plugin-widgets"),
            (Join-Path $MiladyRoot "apps\home\node_modules\@elizameter\plugin-widgets")
        )

        foreach ($target in $linkTargets) {
            $parent = Split-Path -Parent $target
            if (-not (Test-Path $parent)) {
                New-Item -ItemType Directory -Path $parent -Force | Out-Null
            }
            # Remove whatever's there — stale dir, broken junction, real copy.
            if (Test-Path $target) {
                Remove-Item -Path $target -Recurse -Force
            }
            # Junction survives bun/npm resolution and doesn't need admin.
            New-Item -ItemType Junction -Path $target -Target $pluginSrc | Out-Null
            Write-Host "  linked: $target → $pluginSrc" -ForegroundColor Green
        }

        # Fix up @elizaos/core inside the plugin's node_modules so the
        # plugin's own import of @elizaos/core resolves to Milady's copy.
        # (Mirrors the postinstall fixup in link-external-plugins.mjs.)
        $rootCore = Join-Path $MiladyRoot "node_modules\@elizaos\core"
        if (Test-Path $rootCore) {
            $pluginCoreLink = Join-Path $pluginSrc "node_modules\@elizaos\core"
            $pluginCoreParent = Split-Path -Parent $pluginCoreLink
            if (-not (Test-Path $pluginCoreParent)) {
                New-Item -ItemType Directory -Path $pluginCoreParent -Force | Out-Null
            }
            if (Test-Path $pluginCoreLink) {
                Remove-Item -Path $pluginCoreLink -Recurse -Force
            }
            New-Item -ItemType Junction -Path $pluginCoreLink -Target $rootCore | Out-Null
            Write-Host "  linked @elizaos/core back to Milady's copy" -ForegroundColor Green
        } else {
            Write-Warning "Milady's @elizaos/core not found at $rootCore — run 'bun install' in Milady first."
        }
    }

    # Add the plugin to the allowlist in ~/.milady/milady.json. This
    # file lives OUTSIDE the Milady repo, so it's safe to touch.
    $miladyJson = Join-Path $MiladyStateDir "milady.json"
    if (-not (Test-Path $miladyJson)) {
        Write-Warning "$miladyJson not found — Milady hasn't run yet, or state dir is elsewhere. Skipping allowlist update; plugin will need to be added manually to plugins.allow."
    } else {
        Write-Host "  updating plugins.allow in $miladyJson" -ForegroundColor Green
        $config = Get-Content $miladyJson -Raw | ConvertFrom-Json
        if (-not $config.PSObject.Properties.Name.Contains("plugins")) {
            $config | Add-Member -NotePropertyName plugins -NotePropertyValue (New-Object PSObject)
        }
        if (-not $config.plugins.PSObject.Properties.Name.Contains("allow")) {
            $config.plugins | Add-Member -NotePropertyName allow -NotePropertyValue @()
        }
        $current = @($config.plugins.allow)
        if ($current -notcontains "@elizameter/plugin-widgets") {
            $config.plugins.allow = $current + "@elizameter/plugin-widgets"
            $config | ConvertTo-Json -Depth 32 | Set-Content -Path $miladyJson -Encoding UTF8
            Write-Host "    added @elizameter/plugin-widgets" -ForegroundColor Green
        } else {
            Write-Host "    already present" -ForegroundColor DarkGray
        }
    }
}

# ── Skins ───────────────────────────────────────────────────────────

if (-not $SkipSkins) {
    $skinSrc = Join-Path $repoRoot "Skins\Elizameter"
    $skinDst = Join-Path $env:APPDATA "Rainmeter\Skins\Elizameter"
    if (-not (Test-Path $skinSrc)) {
        throw "skins source not found at $skinSrc"
    }
    Write-Host ""
    Write-Host "  skins → $skinDst" -ForegroundColor Green
    if (-not (Test-Path $skinDst)) {
        New-Item -ItemType Directory -Path $skinDst | Out-Null
    }
    Copy-Item -Path (Join-Path $skinSrc "*") -Destination $skinDst -Recurse -Force
}

# ── Rainmeter refresh ───────────────────────────────────────────────

$rainmeterExe = Join-Path $env:ProgramFiles "Rainmeter\Rainmeter.exe"
if (Test-Path $rainmeterExe) {
    if (Get-Process -Name Rainmeter -ErrorAction SilentlyContinue) {
        & $rainmeterExe "!RefreshApp"
        Write-Host "  rainmeter refreshed" -ForegroundColor Green
    } else {
        Write-Host "  Rainmeter not running — skins load on next launch" -ForegroundColor DarkGray
    }
} else {
    Write-Warning "Rainmeter not installed at $rainmeterExe — skins copied but need Rainmeter to render."
}

Write-Host ""
Write-Host "done." -ForegroundColor Cyan
Write-Host ""
Write-Host "next steps:"
Write-Host "  1. start (or restart) Milady: bun run dev"
Write-Host "  2. Rainmeter → Manage → 'Elizameter\Status\Status.ini' → Load"
Write-Host ""
Write-Host "re-run this script after any 'bun install' in Milady — the junction will be wiped."
