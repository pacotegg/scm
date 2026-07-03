Set-StrictMode -Version Latest

function Show-SCMBrowseMenu {

    param(
        [Parameter(Mandatory)]
        [array]$Games
    )

    Clear-Host

    Write-Host ""
    Write-Host "========== COLLECTION ==========" -ForegroundColor Cyan
    Write-Host ""

    Write-Host "1  Browse by Title"
    Write-Host "2  Browse by Series"
    Write-Host "3  Browse by Engine"
    Write-Host "4  Browse by Language"
    Write-Host "5  Browse by Platform"
    Write-Host "0  Back"

    Write-Host ""

    $option = Read-Host "Option"

    switch ($option) {

    "1" {

        foreach ($Game in ($Games | Sort-Object Title)) {
            Write-Host ("{0,-20} {1}" -f $Game.ShortID, $Game.Title)
        }

        Pause-SCM
    }

    "2" {

        $Series = $Games |
            Where-Object { $_.Series } |
            Group-Object Series |
            Sort-Object Name

        foreach ($Group in $Series) {

            Write-Host ""
            Write-Host $Group.Name -ForegroundColor Cyan

            foreach ($Game in ($Group.Group | Sort-Object Title)) {
                Write-Host ("    {0}" -f $Game.Title)
            }
        }

        Pause-SCM
    }

    "3" {
        Write-Host "Not implemented yet."
        Pause-SCM
    }

    "4" {
        Write-Host "Not implemented yet."
        Pause-SCM
    }

     "5" {
        Write-Host "Not implemented yet."
        Pause-SCM
    }

    "0" { }

}

}

Export-ModuleMember -Function Show-SCMBrowseMenu