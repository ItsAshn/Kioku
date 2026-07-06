<#
    KIOKU Windows installer

    Downloads the latest NSIS installer, removes the Mark-of-the-Web so
    SmartScreen does not block it, and runs it. The installer is per-user
    (no admin required).

        irm https://raw.githubusercontent.com/ItsAshn/Kioku/main/scripts/install-windows.ps1 | iex
#>

$ErrorActionPreference = 'Stop'
$Repo = 'ItsAshn/Kioku'

Write-Host '==> Installing KIOKU for Windows'

Write-Host '==> Fetching latest release metadata'
$api = "https://api.github.com/repos/$Repo/releases/latest"
$release = Invoke-RestMethod -Uri $api -Headers @{ 'User-Agent' = 'KIOKU-Installer' }

$asset = $release.assets |
    Where-Object { $_.name -like '*.exe' } |
    Select-Object -First 1

if (-not $asset) {
    Write-Error "Could not find an .exe asset in the latest release. Download manually from https://github.com/$Repo/releases"
    return
}
Write-Host "==> Found: $($asset.name)"

$dest = Join-Path $env:TEMP $asset.name
Write-Host '==> Downloading'
Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $dest -UseBasicParsing

# Drop the Mark-of-the-Web (Zone.Identifier) so SmartScreen doesn't block it.
Write-Host '==> Removing Mark-of-the-Web (SmartScreen bypass)'
Unblock-File -Path $dest

Write-Host '==> Running installer'
Start-Process -FilePath $dest -Wait
Remove-Item $dest -Force -ErrorAction SilentlyContinue

Write-Host ''
Write-Host 'KIOKU installed. It lives in your system tray and starts tracking immediately.'
