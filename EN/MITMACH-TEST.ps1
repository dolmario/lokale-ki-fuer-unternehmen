param(
    [Parameter(Mandatory=$true)][string]$Model,
    [Parameter(Mandatory=$true)][string]$OutputDirectory,
    [ValidateSet('de','en')][string]$Language = 'de',
    [string]$BaseUrl = 'http://127.0.0.1:8091',
    [string]$ExerciseDirectory = $PSScriptRoot,
    [ValidateRange(1,3)][int]$Runs = 3,
    [switch]$PrepareOnly
)
$ErrorActionPreference = 'Stop'
$uri = [Uri]$BaseUrl
if ($uri.Scheme -notin @('http','https') -or -not $uri.IsLoopback -or $uri.UserInfo -or $uri.Query -or $uri.Fragment -or $uri.AbsolutePath -ne '/') {
    throw 'Use a loopback base URL without credentials or a path. Existing authentication remains required.'
}
if ([string]::IsNullOrWhiteSpace($Model)) { throw 'An exact model ID is required.' }
if (Test-Path -LiteralPath $OutputDirectory) { throw 'Output directory already exists. Choose a NEW directory; previous results are preserved.' }
$tasks = Get-Content -LiteralPath (Join-Path $ExerciseDirectory 'TASKS.json') -Raw -Encoding UTF8 | ConvertFrom-Json
if ($tasks.language -ne $Language -or -not $tasks.synthetic -or -not $tasks.not_original_benchmark -or $tasks.tasks.Count -ne 6) { throw 'Exercise language or scope does not match.' }
$sourceTexts = @()
foreach ($name in @('AKTUELL.md','VERALTET.md')) {
    $text = Get-Content -LiteralPath (Join-Path $ExerciseDirectory "FAKTEN\$name") -Raw -Encoding UTF8
    $sourceTexts += "--- FAKTEN/$name ---`n$text`n--- END ---"
}
$systemText = if ($Language -eq 'de') {
    'Beantworte die einzelne Frage. Firmenfakten nur aus den bereitgestellten Quellen belegen. Nenne Dateiname und Version. Unbekanntes als unbekannt benennen. Die Rechnung ist theoretisch. Erfinde weder Belege noch Namen oder Hardware.'
} else {
    'Answer the single question. Substantiate business facts only with provided sources. Cite filename and version. Identify unknowns explicitly. The calculation is theoretical. Do not invent evidence, names, or hardware.'
}
$requests = @()
foreach ($condition in @('A','B')) {
    for ($run=1; $run -le $Runs; $run++) {
        foreach ($task in $tasks.tasks) {
            $content = [string]$task.question
            if ($condition -eq 'B') { $content = ($sourceTexts -join "`n`n") + "`n`n" + $content }
            $body = [ordered]@{ model=$Model; messages=@(@{role='system';content=$systemText},@{role='user';content=$content}); temperature=0; max_tokens=512; stream=$false }
            $requests += [pscustomobject]@{condition=$condition;run=$run;task=$task.id;body=$body}
        }
    }
}
if (-not $PrepareOnly) {
    Write-Host 'This sends real requests to your EXISTING local model. No server, model or tool integration is installed. B pastes source text; this is not an MCP or permission test.'
    if ((Read-Host 'Type START after checking available resources and your server/model') -cne 'START') { throw 'No requests sent.' }
}
New-Item -ItemType Directory -Path $OutputDirectory | Out-Null
$requests | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath (Join-Path $OutputDirectory 'REQUESTS.json') -Encoding UTF8
$state = [ordered]@{ prepared_only=[bool]$PrepareOnly; real_requests_sent=0; model=$Model; language=$Language; runs=$Runs; source_delivery='B: pasted source text; no retrieval tools'; benchmark_reproduction=$false; server_started=$false; errors=0; automatic_scores=$false }
$state | ConvertTo-Json | Set-Content -LiteralPath (Join-Path $OutputDirectory 'STATE.json') -Encoding UTF8
if ($PrepareOnly) { Write-Host "Prepared $($requests.Count) requests; ZERO network calls or model requests."; return }
$headers = @{}
$secret = Read-Host 'Existing local API token if required; leave empty only for a documented unauthenticated loopback server' -AsSecureString
if ($secret.Length -gt 0) {
    $pointer = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secret)
    try { $headers.Authorization = 'Bearer ' + [Runtime.InteropServices.Marshal]::PtrToStringBSTR($pointer) }
    finally { [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($pointer) }
}
try {
    $models = Invoke-RestMethod -Uri ($BaseUrl.TrimEnd('/')+'/v1/models') -Method Get -Headers $headers -TimeoutSec 20
    if ($Model -notin @($models.data | ForEach-Object { $_.id })) { throw 'Exact requested model ID is not listed. No automatic model selection/loading attempted.' }
    foreach ($request in $requests) {
        $timer = [Diagnostics.Stopwatch]::StartNew()
        $entry = [ordered]@{condition=$request.condition;run=$request.run;task=$request.task;answer=$null;seconds=$null;error=$null;evidence_correct=$null;did_not_guess=$null}
        $state.real_requests_sent++
        try {
            $json = $request.body | ConvertTo-Json -Depth 10 -Compress
            $response = Invoke-RestMethod -Uri ($BaseUrl.TrimEnd('/')+'/v1/chat/completions') -Method Post -Headers $headers -ContentType 'application/json; charset=utf-8' -Body ([Text.Encoding]::UTF8.GetBytes($json)) -TimeoutSec 180
            $entry.answer = [string]$response.choices[0].message.content
            if ([string]::IsNullOrWhiteSpace($entry.answer)) { throw 'No visible answer returned; record as failure, not success.' }
        } catch { $entry.error = $_.Exception.Message; $state.errors++ }
        finally { $timer.Stop(); $entry.seconds=[Math]::Round($timer.Elapsed.TotalSeconds,3) }
        $entry | ConvertTo-Json -Depth 6 -Compress | Add-Content -LiteralPath (Join-Path $OutputDirectory 'RESPONSES.ndjson') -Encoding UTF8
        $state | ConvertTo-Json | Set-Content -LiteralPath (Join-Path $OutputDirectory 'STATE.json') -Encoding UTF8
        if ($entry.error) { throw 'Request failed. Partial results are preserved; no automatic retry or server restart.' }
    }
} finally { $headers.Clear(); $secret.Dispose() }
Write-Host 'Real answers saved. Review citations and unknown facts yourself; no scores were invented.'
