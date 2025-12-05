# Install-Scoop.ps1
Write-Host "[~] Starting Scoop installation..." -ForegroundColor Cyan

# Ensure script is running with PowerShell
if ($PSVersionTable.PSVersion.Major -lt 5) {
    Write-Host "[!] PowerShell 5 or higher is required." -ForegroundColor Red
    exit 1
}

# Set execution policy for current user
Write-Host "[~] Setting execution policy to RemoteSigned..."
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

# Check if Scoop is already installed
if (Test-Path "$env:USERPROFILE\scoop") {
    Write-Host "[✓] Scoop is already installed at $env:USERPROFILE\scoop" -ForegroundColor Green
} else {
    Write-Host "[~] Installing Scoop..."
    Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')
    Write-Host "[✓] Scoop installation complete." -ForegroundColor Green
}

# Add buckets
scoop bucket add extras
scoop bucket add nerd-fonts

# Install apps (split across lines for readability)
scoop install `
    git `
    fastfetch `
    mpv `
    spotify `
    vscode `
    discord `
    brave `
    neovim `
    winrar `
    oh-my-posh `
    windows-terminal `
    Hack-NF `
    Hack-NF-Mono