# Nessus API Keys
$accessKey = "f4ac1198a18cb148f2dfb06799bf32e3b1c1687e385c1697a93310eb7a5b9262"
$secretKey = "36663f98886886f75e362549ca6e7240b861d1d4aa492e7c18d3e14d2195710b"
# Scan IDs
$preScanId  = "5"   # <-- Paste Pre-scan ID here
$postScanId = "8"   # <-- Paste Post-scan ID here

$headers = @{
    "X-ApiKeys" = "accessKey=$accessKey; secretKey=$secretKey"
}

Write-Host "Launching Pre-Patch Scan..."
Invoke-RestMethod -Uri "https://localhost:8834/scans/$preScanId/launch" `
    -Method Post `
    -Headers $headers `
    -SkipCertificateCheck

Write-Host "Pre-Patch Scan Triggered."

# (Optional delay before post-scan)
Start-Sleep -Seconds 10

Write-Host "Launching Post-Patch Scan..."
Invoke-RestMethod -Uri "https://localhost:8834/scans/$postScanId/launch" `
    -Method Post `
    -Headers $headers `
    -SkipCertificateCheck

Write-Host "Post-Patch Scan Triggered."

