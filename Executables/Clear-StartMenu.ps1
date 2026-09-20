# Standalone version of Atlas OS STARTMENU.ps1 (Atlas 0.4.1).
# Cleans the Start Menu after AppX removal: applies an empty default layout,
# drops StartMenuExperienceHost tile caches and the tilegrid database, so tiles
# of removed apps (ghosts) disappear immediately instead of lingering in Start.
# Must run as the user (runas: currentUserElevated), NOT as SYSTEM/TI, as it
# touches HKCU and the user's LocalAppData.

$appData = $env:LOCALAPPDATA
if ([string]::IsNullOrEmpty($appData) -or !(Test-Path $appData)) {
    throw "Couldn't find Local AppData!"
}

Write-Output 'Copying default layout XML'
Copy-Item -Path '.\Layout.xml' -Destination "$appData\Microsoft\Windows\Shell\LayoutModification.xml" -Force

# Same layout for future (new) users, best effort
$defaultShell = "$env:SystemDrive\Users\Default\AppData\Local\Microsoft\Windows\Shell"
if (Test-Path $defaultShell) {
    Copy-Item -Path '.\Layout.xml' -Destination "$defaultShell\LayoutModification.xml" -Force
}

Write-Output 'Clearing Start Menu pinned items'
$packages = Get-ChildItem -Path "$appData\Packages" -Directory -EA 0 | Where-Object { $_.Name -match 'Microsoft.Windows.StartMenuExperienceHost' }
foreach ($package in $packages) {
    $bins = Get-ChildItem -Path "$appData\Packages\$($package.Name)\LocalState" -File -EA 0 | Where-Object { $_.Name -like 'start*.bin' }
    foreach ($bin in $bins.FullName) {
        Remove-Item -Path $bin -Force
    }
}

Write-Output "Clearing default 'tilegrid'"
$tilegrid = Get-ChildItem -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount' -Recurse -EA 0 | Where-Object { $_.Name -match 'start.tilegrid' }
foreach ($key in $tilegrid) {
    Remove-Item -Path $key.PSPath -Force
}

Write-Output 'Removing advertisements/stubs from Start Menu (23H2+)'
Remove-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Start' -Name 'Config' -Force -EA 0
