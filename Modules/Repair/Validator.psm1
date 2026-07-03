Set-StrictMode -Version Latest

function Test-SCMCollection {

    param(
        [Parameter(Mandatory)]
        [array]$Games
    )

    Clear-Host

    Write-Host ""
    Write-Host "========== VALIDATING COLLECTION ==========" -ForegroundColor Cyan
    Write-Host ""

    $Problems = 0

    foreach ($Game in $Games) {

        $ExpectedFolder = $Game.Title -replace '[\\/:*?"<>|]', ''
        $ExpectedFolder = $ExpectedFolder -replace ' ', '_'

        $ActualFolder = Split-Path $Game.FullPath -Leaf

        if ($ActualFolder -eq $ExpectedFolder) {

            Write-Host ("[ OK ] {0}" -f $Game.Title) -ForegroundColor Green

        }
        else {

            Write-Host ("[FAIL] {0}" -f $Game.Title) -ForegroundColor Red
            Write-Host ("       Current : {0}" -f $ActualFolder)
            Write-Host ("       Expected: {0}" -f $ExpectedFolder)
            Write-Host ""

            $Problems++
        }

    }

    Write-Host ""
    Write-Host ("Problems found: {0}" -f $Problems) -ForegroundColor Yellow
    Pause-SCM
}

Export-ModuleMember -Function Test-SCMCollection