# Standalone version of Atlas OS STARTMENU.ps1 (Atlas 0.4.1), trimmed.
# Applies an empty default layout and drops the tilegrid database, so pinned
# tiles on the right side are gone. App-list ghosts need no extra cleanup:
# Win11Debloat-style AllUsers removal already takes them with it.
# Must run as the user (runas: currentUserElevated), NOT as SYSTEM/TI, as it
# touches HKCU and the user's LocalAppData.

$appData = $env:LOCALAPPDATA
if ([string]::IsNullOrEmpty($appData) -or !(Test-Path $appData)) {
    throw "Couldn't find Local AppData!"
}

# Kill the host here (not just via taskKill) so it can't relaunch and restore
# the tile database between the kill and the cleanup below
Write-Output 'Stopping StartMenuExperienceHost'
Stop-Process -Name 'StartMenuExperienceHost' -Force -EA 0

Write-Output 'Copying default layout XML'
Copy-Item -Path '.\Layout.xml' -Destination "$appData\Microsoft\Windows\Shell\LayoutModification.xml" -Force

# Same layout for future (new) users, best effort
$defaultShell = "$env:SystemDrive\Users\Default\AppData\Local\Microsoft\Windows\Shell"
if (Test-Path $defaultShell) {
    Copy-Item -Path '.\Layout.xml' -Destination "$defaultShell\LayoutModification.xml" -Force
}

Write-Output "Clearing default 'tilegrid'"
$tilegrid = Get-ChildItem -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount' -Recurse -EA 0 | Where-Object { $_.Name -match 'start.tilegrid' }
foreach ($key in $tilegrid) {
    Remove-Item -Path $key.PSPath -Force
}
