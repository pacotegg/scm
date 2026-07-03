Set-StrictMode -Version Latest

function Show-SCMBrowseMenu {

    param(
        [Parameter(Mandatory)]
        [array]$Games
    )

    do {

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

        $Option = Read-Host "Option"

        switch ($Option) {

            "1" {
                Show-SCMBrowseByTitle -Games $Games
            }

            "2" {
                Show-SCMBrowseBySeries -Games $Games
            }

            "3" {
                Write-Host ""
                Write-Host "Not implemented yet." -ForegroundColor Yellow
                Pause-SCM
            }

            "4" {
                Write-Host ""
                Write-Host "Not implemented yet." -ForegroundColor Yellow
                Pause-SCM
            }

            "5" {
                Write-Host ""
                Write-Host "Not implemented yet." -ForegroundColor Yellow
                Pause-SCM
            }

        }

    } until ($Option -eq "0")
}

function Show-SCMBrowseByTitle {

    param(
        [Parameter(Mandatory)]
        [array]$Games
    )

    Clear-Host

    Write-Host ""
    Write-Host "========== BY TITLE ==========" -ForegroundColor Cyan
    Write-Host ""

    $Index = 1

    foreach ($Game in ($Games | Sort-Object Title)) {

        Write-Host ("{0,3}. {1}" -f $Index, $Game.Title)

        $Index++
    }

    Write-Host ""
    Pause-SCM
}

function Show-SCMBrowseBySeries {

    param(
        [Parameter(Mandatory)]
        [array]$Games
    )

    Clear-Host

    Write-Host ""
    Write-Host "========== BY SERIES ==========" -ForegroundColor Cyan
    Write-Host ""

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

    Write-Host ""
    Pause-SCM
}

Export-ModuleMember -Function Show-SCMBrowseMenu