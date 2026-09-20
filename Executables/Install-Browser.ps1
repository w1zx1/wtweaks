param (
	[switch]$Chrome,
	[switch]$Firefox
)

# Trimmed Atlas OS SOFTWARE.ps1 (0.4.1): browser installation only.
# Software is downloaded directly, no package manager, to be as fast and reliable as possible.

$timeouts = @("--connect-timeout", "10", "--retry", "5", "--retry-delay", "0", "--retry-all-errors")
$arm = ((Get-CimInstance -Class Win32_ComputerSystem).SystemType -match 'ARM64') -or ($env:PROCESSOR_ARCHITECTURE -eq 'ARM64')

# Create temporary directory
function Remove-TempDirectory { Pop-Location; Remove-Item -Path $tempDir -Force -Recurse -EA 0 }
# NOTE (wtweaks): Atlas provides Get-SystemDrive via its modules, which are not
# vendored here. $env:SystemDrive is the stock equivalent (e.g. 'C:').
$tempDir = Join-Path -Path $env:SystemDrive -ChildPath $([System.Guid]::NewGuid())
New-Item $tempDir -ItemType Directory -Force | Out-Null
Push-Location $tempDir

if (!$Firefox -and !$Chrome) {
	Write-Error "No browser selected, pass -Firefox or -Chrome."
	Remove-TempDirectory
	exit 1
}

# Firefox
if ($Firefox) {
	$firefoxArch = ('win64', 'win64-aarch64')[$arm]

	Write-Output "Downloading Firefox..."
	& curl.exe -LSs "https://download.mozilla.org/?product=firefox-latest-ssl&os=$firefoxArch&lang=en-US" -o "$tempDir\firefox.exe" $timeouts
	Write-Output "Installing Firefox..."
	Start-Process -FilePath "$tempDir\firefox.exe" -WindowStyle Hidden -ArgumentList '/S /ALLUSERS=1' -Wait

	Remove-TempDirectory
	exit
}

# Chrome
if ($Chrome) {
	Write-Output "Downloading Google Chrome..."
	$chromeArch = ('64', '_Arm64')[$arm]
	& curl.exe -LSs "https://dl.google.com/dl/chrome/install/googlechromestandaloneenterprise$chromeArch.msi" -o "$tempDir\chrome.msi" $timeouts
	Write-Output "Installing Google Chrome..."
	Start-Process -FilePath "$tempDir\chrome.msi" -WindowStyle Hidden -ArgumentList '/qn' -Wait

	Remove-TempDirectory
	exit
}
