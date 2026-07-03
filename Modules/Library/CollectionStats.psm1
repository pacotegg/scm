Set-StrictMode -Version Latest

function Show-SCMCollectionStats {

    param(
        [Parameter(Mandatory)]
        [array]$Games
    )

    Write-Host ""
    Write-Host "========== COLLECTION ==========" -ForegroundColor Cyan
    Write-Host ""

    Write-Host ("Games     : {0}" -f $Games.Count)

    Write-Host ("Engines   : {0}" -f (
        ($Games.Engine | Sort-Object -Unique).Count
    ))

    Write-Host ("Languages : {0}" -f (
        ($Games.Language | Sort-Object -Unique).Count
    ))

    Write-Host ("Platforms : {0}" -f (
        ($Games.Platform | Sort-Object -Unique).Count
    ))

    Write-Host ("Folders   : {0}" -f (
        ($Games.FullPath | Sort-Object -Unique).Count
    ))

    Write-Host ""
}

Export-ModuleMember -Function Show-SCMCollectionStats