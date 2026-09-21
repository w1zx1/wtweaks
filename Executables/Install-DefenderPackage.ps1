#Requires -RunAsAdministrator
# Trimmed Atlas OS packageInstall.ps1 (Atlas 0.4.1, GPL-3.0-only):
# installs/uninstalls CBS packages (used for the NoDefender package only).
# Always non-interactive. Safe Mode fallback, repair source and UI prompts
# from the original were intentionally left out.
param (
    [array]$InstallPackages,
    [array]$UninstallPackages,
    [string]$PackagesPath = (Join-Path $PSScriptRoot 'Packages')
)

if (!([Security.Principal.WindowsIdentity]::GetCurrent().User.Value -eq 'S-1-5-18')) {
    throw 'This script must be ran as TrustedInstaller/SYSTEM.'
}

$arch = 'amd64'
$errorLevel = 0

function Install-Cab($cabPath) {
    $fileName = Split-Path $cabPath -Leaf
    Write-Output "Installing $fileName..."

    Write-Output '[INFO] Checking certificate...'
    try {
        $cert = (Get-AuthenticodeSignature $cabPath).SignerCertificate
        if ($cert.Extensions.EnhancedKeyUsages.Value -ne '1.3.6.1.4.1.311.10.3.6') {
            Write-Output "[ERROR] Cert doesn't have proper key usages, can't continue."
            $script:errorLevel++
            return
        }

        # Add Atlas test cert, required by servicing afterwards
        $certRegPath = 'HKLM:\Software\Microsoft\SystemCertificates\ROOT\Certificates\8A334AA8052DD244A647306A76B8178FA215F344'
        if (!(Test-Path "$certRegPath")) {
            New-Item -Path $certRegPath -Force | Out-Null
        }
    } catch {
        Write-Output "[ERROR] Cert error from '$cabPath': $_"
        $script:errorLevel++
        return
    }

    Write-Output '[INFO] Adding package...'
    try {
        Add-WindowsPackage -Online -PackagePath $cabPath -NoRestart -IgnoreCheck -LogLevel 1 *>$null
    } catch {
        Write-Output "[ERROR] Error when adding package '$cabPath': $_"
        $script:errorLevel++
        return
    }

    Write-Output '[INFO] Completed sucessfully.'
}

if ($UninstallPackages) {
    $installedPackages = @()
    (Get-WindowsPackage -Online).PackageName | ForEach-Object {
        $current = $_
        foreach ($package in $UninstallPackages) {
            if (($current -like $package) -and ($current -match "$arch")) {
                $installedPackages += $current
                break
            }
        }
    }

    if ($installedPackages.Count -eq 0) {
        Write-Output "[WARN] '$UninstallPackages' matched no installed packages, nothing to do."
    } else {
        foreach ($package in $installedPackages) {
            try {
                Write-Output "[INFO] Uninstalling '$package'..."
                Remove-WindowsPackage -Online -PackageName $package -NoRestart -LogLevel 1 *>$null
            } catch {
                Write-Output "[ERROR] $package failed to uninstall: $_"
                $script:errorLevel++
            }
        }
    }
}

if ($InstallPackages) {
    $matchedPackages = @()
    $notMatchedPackages = @($InstallPackages)
    (Get-ChildItem $PackagesPath -File -Filter '*.cab').FullName | Sort-Object -Descending | ForEach-Object {
        $current = $_
        foreach ($package in @($notMatchedPackages)) {
            if (($current -like $package) -and ($current -match "$arch")) {
                $matchedPackages += $current
                $notMatchedPackages = @($notMatchedPackages | Where-Object { $_ -ne $package })
                break
            }
        }
    }

    if ($matchedPackages.Count -eq 0) {
        Write-Output "[ERROR] The specified CABs ($InstallPackages) to install weren't found."
        exit 1
    }
    if ($notMatchedPackages.Count -gt 0) {
        Write-Output "[WARN] These CABs to install weren't found: $notMatchedPackages"
    }

    foreach ($cab in $matchedPackages) {
        Install-Cab $cab
    }
}

if ($script:errorLevel -ne 0) {
    Write-Output "Completed with $script:errorLevel error(s). A reboot is required to apply the changes."
} else {
    Write-Output 'Completed! A reboot is required to apply the changes.'
}
exit $script:errorLevel
