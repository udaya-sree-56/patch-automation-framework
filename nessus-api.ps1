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

# ---------------------------------------------------
# Launch Post-Patch Scan
# ---------------------------------------------------

Write-Host "Launching Post-Patch Scan..."

Invoke-RestMethod -Uri "https://localhost:8834/scans/$postScanId/launch" `
    -Method Post `
    -Headers $headers `
    -SkipCertificateCheck

Write-Host "Post-Patch Scan Triggered."
Write-Host "Waiting for Post-Patch Scan to Complete..."

# ---------------------------------------------------
# Wait Until Scan Completes
# ---------------------------------------------------

$status = ""

while ($status -ne "completed") {

    Start-Sleep -Seconds 30

    $scanDetails = Invoke-RestMethod -Uri "https://localhost:8834/scans/$postScanId" `
        -Method Get `
        -Headers $headers `
        -SkipCertificateCheck

    $status = $scanDetails.info.status

    Write-Host "Current Scan Status: $status"
}

Write-Host "Scan Completed Successfully."

# ---------------------------------------------------
# Check Vulnerability Counts
# ---------------------------------------------------

$critical = $scanDetails.info.severitycount.critical
$high = $scanDetails.info.severitycount.high

Write-Host "Critical Vulnerabilities: $critical"
Write-Host "High Vulnerabilities: $high"

if ($critical -gt 0 -or $high -gt 0) {

    Write-Host "Vulnerabilities still exist!"
    exit 1   # Jenkins build FAIL

}
else {

    Write-Host "System is secure. No Critical/High vulnerabilities."
}




