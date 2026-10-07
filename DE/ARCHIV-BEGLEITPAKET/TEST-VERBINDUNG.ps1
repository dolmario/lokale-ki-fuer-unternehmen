param([string]$BaseUrl = "http://127.0.0.1:1234")
$ErrorActionPreference = "Stop"
$testUri = [Uri]$BaseUrl
if ($testUri.Scheme -notin @("http","https") -or -not $testUri.IsLoopback -or $testUri.UserInfo -or $testUri.Query -or $testUri.Fragment) {
    throw "Use a loopback URL without credentials, query or fragment."
}
$testEndpoint = $BaseUrl.TrimEnd("/") + "/v1/models"
try {
    Invoke-RestMethod -Uri $testEndpoint -Method Get -TimeoutSec 20 | ConvertTo-Json -Depth 6
} catch {
    throw "Model listing failed. Check your existing server and documented authentication. No server was started, no model loaded and no permissions changed. $($_.Exception.Message)"
}
