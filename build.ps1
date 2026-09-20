#Requires -Version 5.1
<#
.SYNOPSIS
  Packs wtweaks AME Wizard playbook into .apbx archives (7z with password 'malte').
  Builds two variants:
    - full: everything (wtweaks_<version>.apbx)
    - lite: QoL tweaks only (wtweaks_<version>-lite.apbx)
  Used by .vscode/launch.json (Run and Debug) and .vscode/tasks.json (build task).
#>
[CmdletBinding()]
param(
  [string]$OutputFile = ""
)

$ErrorActionPreference = 'Stop'
$root = $PSScriptRoot

# Lite variant tasks with their categories (mirrors full main.yml order).
# Everything else is full-only.
$qolTasks = @(
  @{ file = 'disable-game-bar.yml'; category = 'performance' },
  @{ file = 'search-indexing.yml'; category = 'performance' },
  @{ file = 'disable-bing-search.yml'; category = 'privacy' },
  @{ file = 'disable-content-delivery.yml'; category = 'debloat' },
  @{ file = 'hide-folders-this-pc.yml'; category = 'QoL' },
  @{ file = 'removable-drives-only-this-pc.yml'; category = 'QoL' },
  @{ file = 'disable-network-pane.yml'; category = 'QoL' },
  @{ file = 'open-to-this-pc.yml'; category = 'QoL' },
  @{ file = 'transfer-details.yml'; category = 'QoL' },
  @{ file = 'sendto-debloat.yml'; category = 'QoL' },
  @{ file = 'hide-frequently-used-items.yml'; category = 'QoL' },
  @{ file = 'hide-recently-added-start-menu.yml'; category = 'QoL' },
  @{ file = 'disable-start-recommendations.yml'; category = 'QoL' },
  @{ file = 'disable-aero-shake.yml'; category = 'QoL' },
  @{ file = 'disable-network-wizard.yml'; category = 'QoL' },
  @{ file = 'disable-mouse-accel.yml'; category = 'QoL' },
  @{ file = 'disable-menu-delay.yml'; category = 'QoL' },
  @{ file = 'disable-startup-delay.yml'; category = 'QoL' },
  @{ file = 'decrease-shutdown-time.yml'; category = 'QoL' },
  @{ file = 'disable-auto-updates.yml'; category = 'QoL' },
  @{ file = 'disable-delivery-optimization.yml'; category = 'QoL' },
  @{ file = 'disable-lockscreen-blur.yml'; category = 'QoL' },
  @{ file = 'oem-info.yml'; category = 'QoL' },
  @{ file = 'update-psreadline.yml'; category = 'QoL' }
)
# Executables needed by the lite variant (sendto-debloat and search-indexing tasks).
$liteExecutables = @(
  'Debloat-SendTo.ps1',
  'SearchIndexing'
)
# Stable UniqueId for the lite variant so AME Wizard sees it as a separate playbook.
$liteUniqueId = '1bd966f1-fd8b-4028-901c-c8da93d5d241'

# 1. Read Name + Version from playbook.conf
$confPath = Join-Path $root 'playbook.conf'
if (-not (Test-Path -LiteralPath $confPath)) { throw "playbook.conf not found at $confPath" }
[xml]$conf = Get-Content -LiteralPath $confPath -Raw
$name = $conf.Playbook.Name
$version = $conf.Playbook.Version
$description = $conf.Playbook.Description
if ([string]::IsNullOrWhiteSpace($name)) { throw 'Playbook <Name> is empty in playbook.conf' }
if ([string]::IsNullOrWhiteSpace($version)) { throw 'Playbook <Version> is empty in playbook.conf' }

if ([string]::IsNullOrWhiteSpace($OutputFile)) {
  $OutputFile = Join-Path $root "$($name)_$($version).apbx"
}
$liteOutputFile = Join-Path $root "$($name)_$($version)-lite.apbx"

# 2. Validate playbook layout
$required = @('playbook.conf', 'Configuration', 'Executables')
foreach ($item in $required) {
  if (-not (Test-Path -LiteralPath (Join-Path $root $item))) {
    throw "Required playbook item missing: $item"
  }
}
$mainYml = Join-Path $root 'Configuration\main.yml'
if (-not (Test-Path -LiteralPath $mainYml)) { throw 'Configuration\main.yml not found' }
foreach ($t in $qolTasks) {
  if (-not (Test-Path -LiteralPath (Join-Path $root "Configuration\Tasks\$($t.file)"))) {
    throw "Lite task missing: $($t.file)"
  }
}

# 3. Locate 7-Zip
$sevenZ = $null
$cmd = Get-Command 7z -ErrorAction SilentlyContinue | Select-Object -First 1
if ($cmd) { $sevenZ = $cmd.Source }
foreach ($p in @("$env:ProgramFiles\7-Zip\7z.exe", "${env:ProgramFiles(x86)}\7-Zip\7z.exe", "$env:LOCALAPPDATA\Programs\7-Zip\7z.exe")) {
  if (-not $sevenZ -and (Test-Path -LiteralPath $p)) { $sevenZ = $p }
}
if (-not $sevenZ) { throw '7-Zip (7z.exe) not found. Install it from https://7-zip.org/download.html or via `scoop install 7zip`.' }
Write-Host "Using 7-Zip: $sevenZ"

function Pack-Playbook([string]$stagingDir, [string]$outFile) {
  if (Test-Path -LiteralPath $outFile) { Remove-Item -LiteralPath $outFile -Force }
  $items = @('playbook.conf', 'playbook.png', 'Configuration', 'Executables', 'Images') | Where-Object {
    Test-Path -LiteralPath (Join-Path $stagingDir $_)
  }
  Push-Location -LiteralPath $stagingDir
  try {
    & $sevenZ a -t7z -pmalte -mx=9 $outFile @items
    if ($LASTEXITCODE -ne 0) { throw "7z exited with code $LASTEXITCODE" }
  }
  finally {
    Pop-Location
  }
  $item = Get-Item -LiteralPath $outFile
  Write-Host "Done: $($item.FullName) ($([math]::Round($item.Length / 1KB)) KB)"
}

# 4. Full variant (pack the workspace as-is)
Write-Host "Packing $name $version (full) -> $OutputFile"
Pack-Playbook $root $OutputFile

# 5. Lite variant (QoL tasks only, assembled in a staging dir)
Write-Host "Packing $name-lite $version (lite) -> $liteOutputFile"
$staging = Join-Path ([IO.Path]::GetTempPath()) 'wtweaks-lite-staging'
if (Test-Path -LiteralPath $staging) { Remove-Item -LiteralPath $staging -Recurse -Force }
New-Item -ItemType Directory -Path "$staging\Configuration\Tasks" -Force | Out-Null
New-Item -ItemType Directory -Path "$staging\Executables" -Force | Out-Null

[xml]$liteConf = Get-Content -LiteralPath $confPath -Raw
$liteConf.Playbook.Name = "$name-lite"
$liteConf.Playbook.Title = "$name-lite"
$liteConf.Playbook.UniqueId = $liteUniqueId
# Lite has no option-gated tasks, so drop the options pages entirely.
$fp = $liteConf.Playbook.SelectSingleNode('FeaturePages')
if ($fp) { $liteConf.Playbook.RemoveChild($fp) | Out-Null }
$liteConf.Save("$staging\playbook.conf")

$liteMain = @"
---
title: $name-lite
description: $description (lite)
actions:
  - !writeStatus: {status: 'Applying $name-lite'}
"@
$lastCategory = ''
foreach ($t in $qolTasks) {
  Copy-Item -LiteralPath (Join-Path $root "Configuration\Tasks\$($t.file)") -Destination "$staging\Configuration\Tasks\$($t.file)" -Force
  if ($t.category -ne $lastCategory) {
    $liteMain += "`r`n  - !writeStatus: {status: 'Running $($t.category) tweaks'}"
    $lastCategory = $t.category
  }
  $liteMain += "`r`n  - !task: {path: 'Tasks/$($t.file)'}"
}
$liteMain += "`r`n  - !writeStatus: {status: 'Restarting Explorer'}"
$liteMain += "`r`n  - !task: {path: 'Tasks/restart-explorer.yml'}"
Copy-Item -LiteralPath (Join-Path $root 'Configuration\Tasks\restart-explorer.yml') -Destination "$staging\Configuration\Tasks\restart-explorer.yml" -Force
$liteMain | Set-Content -LiteralPath "$staging\Configuration\main.yml" -Encoding utf8

# Lite branding: mark OEM model as lite.
$oemLite = "$staging\Configuration\Tasks\oem-info.yml"
(Get-Content -LiteralPath $oemLite -Raw) -replace "    data: 'wtweaks'", "    data: 'wtweaks lite'" |
  Set-Content -LiteralPath $oemLite -Encoding utf8 -NoNewline

foreach ($e in $liteExecutables) {
  Copy-Item -LiteralPath (Join-Path $root "Executables\$e") -Destination "$staging\Executables\$e" -Recurse -Force
}
Copy-Item -LiteralPath (Join-Path $root 'playbook.png') -Destination "$staging\playbook.png" -Force

Pack-Playbook $staging $liteOutputFile
Remove-Item -LiteralPath $staging -Recurse -Force
