# Standalone version of Atlas OS Set-LockscreenImage (Atlas 0.4.1, Themes.psm1)
# Sets the lockscreen image via WinRT API, works on all Windows editions.
param (
    [ValidateNotNullOrEmpty()]
    [string]$Path
)

if (!(Test-Path $Path)) {
    throw "Path ('$Path') for lockscreen not found."
}
$newImagePath = [System.IO.Path]::GetTempPath() + (New-Guid).Guid + [System.IO.Path]::GetExtension($Path)
Copy-Item $Path $newImagePath

# setup WinRT namespaces
Add-Type -AssemblyName System.Runtime.WindowsRuntime
[Windows.System.UserProfile.LockScreen, Windows.System.UserProfile, ContentType = WindowsRuntime] | Out-Null

# setup async
$asTaskGeneric = ([System.WindowsRuntimeSystemExtensions].GetMethods() | ? {
    $_.Name -eq 'AsTask' -and
    $_.GetParameters().Count -eq 1 -and
    $_.GetParameters()[0].ParameterType.Name -eq 'IAsyncOperation`1'
})[0]
Function Await($WinRtTask, $ResultType) {
    $asTask = $asTaskGeneric.MakeGenericMethod($ResultType)
    $netTask = $asTask.Invoke($null, @($WinRtTask))
    $netTask.Wait(-1) | Out-Null
    $netTask.Result
}
Function AwaitAction($WinRtAction) {
    $asTask = ([System.WindowsRuntimeSystemExtensions].GetMethods() | ? { $_.Name -eq 'AsTask' -and $_.GetParameters().Count -eq 1 -and !$_.IsGenericMethod })[0]
    $netTask = $asTask.Invoke($null, @($WinRtAction))
    $netTask.Wait(-1) | Out-Null
}

# make image object
[Windows.Storage.StorageFile, Windows.Storage, ContentType = WindowsRuntime] | Out-Null
$image = Await ([Windows.Storage.StorageFile]::GetFileFromPathAsync($newImagePath)) ([Windows.Storage.StorageFile])

# execute
AwaitAction ([Windows.System.UserProfile.LockScreen]::SetImageFileAsync($image))

# cleanup
Remove-Item $newImagePath
