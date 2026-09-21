# Standalone AppX remover, removal engine inspired by Win11Debloat by Raphire (MIT).
# Removes each listed app for ALL users plus its provisioned package, so nothing
# has to be cleaned up manually afterwards and nothing gets reinstalled.
# Must run elevated (needs -AllUsers and Get/Remove-AppxProvisionedPackage).
# Failures AND hangs are isolated per app: one stubborn package never stops
# the rest (each removal runs as a job with a timeout, like Win11Debloat does).

$perAppTimeoutSeconds = 60

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
    'A025C540.Yandex.Music', # Yandex Music (RU region preinstall)
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
    param ([string]$app, [string[]]$packageFullNames, [string[]]$provisionedNames)
    foreach ($fullName in $packageFullNames) {
        Remove-AppxPackage -Package $fullName -AllUsers -EA SilentlyContinue
    }
    foreach ($name in $provisionedNames) {
        Remove-ProvisionedAppxPackage -Online -AllUsers -PackageName $name -EA SilentlyContinue | Out-Null
    }
    return "Removed $app (packages: $($packageFullNames.Count), provisioned: $($provisionedNames.Count))"
}

# Single inventory upfront: per-app DISM/Appx enumeration is what made this slow
Write-Output 'Listing installed and provisioned packages...'
$allPackages = @(Get-AppxPackage -AllUsers -EA SilentlyContinue)
$allProvisioned = @(Get-AppxProvisionedPackage -Online -EA SilentlyContinue)

$failures = @()
$removedCounts = @{}
foreach ($app in $removeList) {
    $pattern = "*$app*"
    $packageFullNames = @($allPackages | Where-Object { $_.Name -like $pattern } | Select-Object -ExpandProperty PackageFullName)
    $provisionedNames = @($allProvisioned | Where-Object { $_.PackageName -like $pattern } | Select-Object -ExpandProperty PackageName)
    $removedCounts[$app] = @($packageFullNames.Count, $provisionedNames.Count)
    if (($packageFullNames.Count -eq 0) -and ($provisionedNames.Count -eq 0)) {
        Write-Output "Removed $app (packages: 0, provisioned: 0)"
        continue
    }
    $job = Start-Job -ScriptBlock $removeOneApp -ArgumentList $app, $packageFullNames, $provisionedNames
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

# Single verification pass at the end instead of re-querying per app
Write-Output 'Verifying removal...'
$checkPackages = @(Get-AppxPackage -AllUsers -EA SilentlyContinue)
$checkProvisioned = @(Get-AppxProvisionedPackage -Online -EA SilentlyContinue)
foreach ($app in $removeList) {
    if ($failures -contains $app) { continue }
    $pattern = "*$app*"
    $stillThere = @($checkPackages | Where-Object { $_.Name -like $pattern }).Count
    $stillProv = @($checkProvisioned | Where-Object { $_.PackageName -like $pattern }).Count
    if (($stillThere -ne 0) -or ($stillProv -ne 0)) {
        Write-Output "Failed to remove $app : still present ($stillThere packages, $stillProv provisioned)"
        $failures += $app
    }
}

if ($failures.Count -gt 0) {
    Write-Output "Failed to remove: $($failures -join ', ')"
    exit 1
}
Write-Output 'AppX removal done.'
