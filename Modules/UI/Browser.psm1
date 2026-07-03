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

    $SortedGames = @($Games | Sort-Object Title)

    while ($true) {

        $Selection = Show-SCMSelector `
            -Title "Browse by Title" `
            -Items ($SortedGames | ForEach-Object DisplayTitle)

        if ($Selection -lt 0) {
            return
        }

        Show-SCMGameDetails -Game $SortedGames[$Selection]
    }
}

function Show-SCMBrowseBySeries {

    param(
        [Parameter(Mandatory)]
        [array]$Games
    )

    $Series = @(
        $Games |
        Where-Object { -not [string]::IsNullOrWhiteSpace($_.Series) } |
        Group-Object Series |
        Sort-Object Name
    )

    if ($Series.Count -eq 0) {

        Write-Host ""
        Write-Host "No series found." -ForegroundColor Yellow
        Pause-SCM
        return
    }

    while ($true) {

        $Selection = Show-SCMSelector `
            -Title "Browse by Series" `
            -Items ($Series | ForEach-Object Name)

        if ($Selection -lt 0) {
            return
        }

        $GamesInSeries = @(
            $Series[$Selection].Group |
            Sort-Object DisplayTitle
        )

        $GameSelection = Show-SCMSelector `
            -Title $Series[$Selection].Name `
            -Items ($GamesInSeries | ForEach-Object DisplayTitle)

        if ($GameSelection -lt 0) {
            continue
        }

        Show-SCMGameDetails -Game $GamesInSeries[$GameSelection]
    }
}

function Show-SCMGameDetails {

    param(
        [Parameter(Mandatory)]
        $Game
    )

    while ($true) {

        Clear-Host

        Write-Host ""
        Write-Host "========================================" -ForegroundColor Cyan
        Write-Host ""

        if ($Game.Series) {
            Write-Host $Game.Series -ForegroundColor Yellow
        }

        Write-Host $Game.Title -ForegroundColor White
        Write-Host ""

        Write-Host ("Engine     : {0}" -f $Game.Engine)
        Write-Host ("Edition    : {0}" -f $Game.Edition)
        Write-Host ("Platform   : {0}" -f $Game.Platform)
        Write-Host ("Language   : {0}" -f $Game.Language)
        Write-Host ("Short ID   : {0}" -f $Game.ShortID)
        Write-Host ("Game ID    : {0}" -f $Game.GameID)

        Write-Host ""
        Write-Host "Folder"
        Write-Host $Game.FullPath -ForegroundColor DarkGray

        Write-Host ""
        Write-Host "1  Launch Game"
        Write-Host "2  Open Folder"
        Write-Host "0  Back"
        Write-Host ""

        switch (Read-Host "Option") {

            "1" {
                Write-Host ""
                Write-Host "Launch not implemented yet." -ForegroundColor Yellow
                Pause-SCM
            }

            "2" {
                Start-Process explorer.exe $Game.FullPath
            }

            "0" {
                return
            }
        }
    }
}

Export-ModuleMember -Function Show-SCMBrowseMenu