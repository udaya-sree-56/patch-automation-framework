# Import Windows Update Module
Import-Module PSWindowsUpdate

# Install all available Windows updates
Install-WindowsUpdate -AcceptAll -AutoReboot
