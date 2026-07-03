Set-StrictMode -Version Latest
$ErrorActionPreference = "Continue"

$Root = Split-Path $PSCommandPath

Import-Module "$Root\Modules\Core\Core.psm1" -Force
Import-Module "$Root\Modules\Core\Config.psm1" -Force
Import-Module "$Root\Modules\Core\Logger.psm1" -Force
Import-Module "$Root\Modules\Core\LibraryCleaner.psm1" -Force
Import-Module "$Root\Modules\Library\Scanner.psm1" -Force
Import-Module "$Root\Modules\Library\Parser.psm1" -Force
Import-Module "$Root\Modules\Library\Metadata.psm1" -Force
Import-Module "$Root\Modules\Library\CollectionStats.psm1" -Force
Import-Module "$Root\Modules\Database\Database.psm1" -Force
Import-Module "$Root\Modules\UI\Selector.psm1" -Force
Import-Module "$Root\Modules\UI\Browser.psm1" -Force


$config = Get-Content "$Root\config.json" -Raw | ConvertFrom-Json

do {

    Show-SCMHeader $config.Application.Version

    Write-Host "ScummVM :" -NoNewline

    if (Test-Path $config.Paths.ScummVM) {
        Write-Host " Found" -ForegroundColor Green
    }
    else {
        Write-Host " Missing" -ForegroundColor Red
    }

    Write-Host ""
    Write-Host "ROM Folder"
    Write-Host $config.Paths.RomFolder -ForegroundColor Yellow
    Write-Host ""
    Write-Host "────────────────────────────────────────────────────────────"
    Write-Host ""

    Write-Host "1  Scan Collection"
    Write-Host "2  Browse Collection"
    Write-Host "3  Settings"
    Write-Host "4  About"
    Write-Host "0  Exit"
    Write-Host ""

    $option = Read-Host "Option"

    switch ($option) {

        "1" {

            $Library = Invoke-SCMScan
            Pause-SCM
        }

        "2" {

    $Games = @(Get-SCMDatabase)

    if ($Games.Count -eq 0) {

        Write-Host ""
        Write-Host "Database is empty." -ForegroundColor Yellow
        Pause-SCM
        break

    }

    Show-SCMBrowseMenu -Games $Games
}

        "3" {

            Write-Host ""
            Write-Host "Settings are not implemented yet." -ForegroundColor Yellow
            Pause-SCM
        }

        "4" {

            Show-SCMHeader $config.Application.Version

            Write-Host "SCM"
            Write-Host ""
            Write-Host "ScummVM Collection Manager"
            Write-Host ""
            Write-Host "Developed for maintaining large"
            Write-Host "ScummVM collections."
            Write-Host ""
            Write-Host "Current version:"
            Write-Host $config.Application.Version -ForegroundColor Cyan

            Pause-SCM
        }

    }

} until ($option -eq "0")