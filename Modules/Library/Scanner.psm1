Set-StrictMode -Version Latest

function Invoke-SCMScan {

    $config = Get-SCMConfig
	if (!(Test-Path "C:\temp")) {
    New-Item -ItemType Directory -Path "C:\temp" | Out-Null
}

    $ScummVM = $config.Paths.ScummVM
    $RomFolder = $config.Paths.RomFolder
    $LogFolder = $config.Paths.Logs

    if (!(Test-Path $ScummVM)) {
        Write-Host ""
        Write-Host "ScummVM executable not found." -ForegroundColor Red
        return
    }

    if (!(Test-Path $RomFolder)) {
        Write-Host ""
        Write-Host "ROM folder not found." -ForegroundColor Red
        return
    }

    if (!(Test-Path $LogFolder)) {
        New-Item -ItemType Directory -Path $LogFolder | Out-Null
    }

    $LogFile = Join-Path $LogFolder ("Scan_{0}.txt" -f (Get-Date -Format "yyyy-MM-dd_HH-mm-ss"))

    Write-Host ""
    Write-Host "Scanning collection..." -ForegroundColor Cyan
    Write-Host ""

  $OutFile = "C:\temp\scummvm_out.txt"
  $ErrFile = "C:\temp\scummvm_err.txt"

Remove-Item $OutFile -ErrorAction SilentlyContinue
Remove-Item $ErrFile -ErrorAction SilentlyContinue

Start-Process -FilePath $ScummVM `
    -ArgumentList "--detect","--recursive","--path=$RomFolder" `
    -NoNewWindow -Wait -PassThru `
    -RedirectStandardOutput $OutFile `
    -RedirectStandardError $ErrFile | Out-Null

# HARD SAFETY WAIT (IMPORTANT)
while (!(Test-Path $OutFile)) {
    Start-Sleep -Milliseconds 100
}

Start-Sleep -Milliseconds 300

$Output = Get-Content $OutFile

$ErrorOutput = if (Test-Path $ErrFile) { Get-Content $ErrFile } else { @() }

$Output | Out-File "C:\temp\DEBUG_RAW.txt" -Encoding UTF8

$Output | Out-File $LogFile -Encoding UTF8

$DetectionLines = Get-SCMDetectionLines -ScummVMOutput $Output

$Games = foreach ($Line in $DetectionLines) {
    Convert-SCMDetectionLine $Line
}

# Remove invalid parses (just in case)
$Games = $Games | Where-Object { $_ -ne $null }

Write-Host ""
Write-Host "Games detected: $($Games.Count)" -ForegroundColor Cyan
Write-Host ""

$Games |
    ConvertTo-Json -Depth 5 |
    Out-File "C:\temp\library_raw.json"

$CleanGames = Invoke-SCMLibraryCleanup -Games $Games

if (-not $CleanGames) {
    Write-Host "Cleanup failed - using raw list" -ForegroundColor Yellow
    $CleanGames = $Games
}

Write-Host ""
Write-Host "Clean games: $(@($CleanGames).Count)" -ForegroundColor Green
Write-Host ""

Write-Host ""
Write-Host "===== CLEAN LIBRARY =====" -ForegroundColor Cyan

foreach ($game in ($CleanGames | Sort-Object Description)) {
    Write-Host ("{0,-20} {1}" -f $game.ShortID, $game.Description)
}

$MetadataGames = foreach ($Game in $CleanGames) {
    Convert-SCMMetadata $Game
}

$MetadataGames |
    ConvertTo-Json -Depth 5 |
    Out-File "C:\temp\library_clean.json"

$MetadataGames |
    ConvertTo-Json -Depth 5 |
    Out-File (Join-Path $config.Paths.Database "games.json")

Show-SCMCollectionStats -Games $MetadataGames

return $MetadataGames
}