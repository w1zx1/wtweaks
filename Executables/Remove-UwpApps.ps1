# Standalone AppX remover, removal engine inspired by Win11Debloat by Raphire (MIT).
# Removes each listed app for ALL users plus its provisioned package, so nothing
# has to be cleaned up manually afterwards and nothing gets reinstalled.
# Must run elevated (needs -AllUsers and Get/Remove-AppxProvisionedPackage).
# Failures AND hangs are isolated per app: one stubborn package never stops
# the rest (each removal runs as a job with a timeout, like Win11Debloat does).

$perAppTimeoutSeconds = 120

$removeList = @(
    # AppX Microsoft Teams (legacy)
    'MicrosoftTeams',
    # New AppX Teams
    'MSTeams',
    'Microsoft.Copilot',
    # Other apps
    'Clipchamp.Clipchamp',
    'Disney.37853FC22B2CE',
    'SpotifyAB.SpotifyMusic',
    'Microsoft.549981C3F5F10', # Cortana
    'Microsoft.XboxApp', # Xbox Console Companion (deprecated)
    'microsoft.windowscommunicationsapps', # Mail and Calendar
    'Microsoft.MSPaint', # Paint 3D
    'Microsoft.Getstarted', # Tips (deprecated)
    'Microsoft.ZuneVideo', # Films & TV
    'MicrosoftCorporationII.MicrosoftFamily',
    'Microsoft.MixedReality.Portal',
    'Microsoft.Windows.DevHome',
    'Microsoft.BingWeather',
    'Microsoft.BingNews',
    'Microsoft.BingSearch',
    'Microsoft.OutlookForWindows',
    'Microsoft.GetHelp',
    'Microsoft.Microsoft3DViewer',
    'Microsoft.MicrosoftOfficeHub',
    'Microsoft.MicrosoftSolitaireCollection',
    'Microsoft.MicrosoftStickyNotes',
    'Microsoft.Office.OneNote',
    'Microsoft.People',
    'Microsoft.PowerAutomateDesktop',
    'Microsoft.ScreenSketch', # Snipping Tool
    'Microsoft.SkypeApp',
    'Microsoft.Todos',
    'Microsoft.WindowsAlarms',
    'Microsoft.WindowsCamera',
    'Microsoft.WindowsFeedbackHub',
    'Microsoft.WindowsMaps',
    'Microsoft.WindowsSoundRecorder'
    # NOTE: Microsoft.YourPhone is handled separately in remove-uwp-apps.yml
    # (plain !appx removal pulls Cross Device Experience Host with it)
)

$removeOneApp = {
    param ([string]$app)
    $pattern = "*$app*"
    $packages = @(Get-AppxPackage -Name $pattern -AllUsers -EA Stop)
    foreach ($package in $packages) {
        Remove-AppxPackage -Package $package.PackageFullName -AllUsers -EA Stop
    }
    $provisioned = @(Get-AppxProvisionedPackage -Online -EA Stop | Where-Object { $_.PackageName -like $pattern })
    foreach ($package in $provisioned) {
        Remove-ProvisionedAppxPackage -Online -AllUsers -PackageName $package.PackageName -EA Stop
    }
    return "Removed $app (packages: $($packages.Count), provisioned: $($provisioned.Count))"
}

$failures = @()
foreach ($app in $removeList) {
    $job = Start-Job -ScriptBlock $removeOneApp -ArgumentList $app
    if (Wait-Job $job -Timeout $perAppTimeoutSeconds) {
        $result = Receive-Job $job
        if ($job.State -eq 'Failed') {
            $reason = $job.ChildJobs[0].JobStateInfo.Reason.Message
            Write-Output "Failed to remove $app : $reason"
            $failures += $app
        } else {
            Write-Output $result
        }
    } else {
        Write-Output "Timed out removing $app after $perAppTimeoutSeconds s, skipping"
        $failures += $app
    }
    Stop-Job $job -EA 0 | Out-Null
    Remove-Job $job -Force -EA 0
}

if ($failures.Count -gt 0) {
    Write-Output "Failed to remove: $($failures -join ', ')"
    exit 1
}
Write-Output 'AppX removal done.'
