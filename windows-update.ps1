Write-Host "Starting Advanced Patch & Hardening Process..."

# Install Windows Updates
Write-Host "Installing Windows Updates..."

Install-Module PSWindowsUpdate -Force -Confirm:$false -ErrorAction SilentlyContinue
Import-Module PSWindowsUpdate

Get-WindowsUpdate -AcceptAll -Install -IgnoreReboot

Write-Host "Windows Updates Completed."

#  Install Chocolatey (if not installed)
if (!(Get-Command choco -ErrorAction SilentlyContinue)) {

    Write-Host "Installing Chocolatey..."
    Set-ExecutionPolicy Bypass -Scope Process -Force
    iwr https://community.chocolatey.org/install.ps1 -UseBasicParsing | iex
}


#  Upgrade All Third-Party Software
Write-Host "Updating Third-Party Applications..."
choco upgrade all -y

Write-Host "Third-Party Updates Completed."

# Disable SMBv1 (Critical vulnerability fix)
Write-Host "Disabling SMBv1..."
Disable-WindowsOptionalFeature -Online -FeatureName SMB1Protocol -NoRestart -ErrorAction SilentlyContinue

#  Enable Windows Firewall

Write-Host "Enabling Windows Firewall..."
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled True

#  Disable Remote Registry Service

Write-Host "Disabling Remote Registry..."
Stop-Service -Name RemoteRegistry -ErrorAction SilentlyContinue
Set-Service -Name RemoteRegistry -StartupType Disabled

#  Disable TLS 1.0 (Removes SSL vulnerabilities)

Write-Host "Disabling TLS 1.0..."
New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Server" -Force | Out-Null
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Server" `
    -Name Enabled -Value 0 -PropertyType DWORD -Force


Write-Host "Advanced Hardening Completed Successfully."
