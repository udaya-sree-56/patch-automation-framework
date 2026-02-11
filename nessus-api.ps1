$accessKey = "f4ac1198a18cb148f2dfb06799bf32e3b1c1687e385c1697a93310eb7a5b9262"
$secretKey = "36663f98886886f75e362549ca6e7240b861d1d4aa492e7c18d3e14d2195710b"

$headers = @{
    "X-ApiKeys" = "accessKey=$accessKey; secretKey=$secretKey"
}

Invoke-RestMethod -Uri "https://localhost:8834/scans" `
    -Method Get `
    -Headers $headers `
    -SkipCertificateCheck
