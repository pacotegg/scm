Set-StrictMode -Version Latest

function Get-SCMDatabase {

    $config = Get-SCMConfig

    $File = Join-Path $config.Paths.Database "games.json"

    if (!(Test-Path $File)) {
        return @()
    }

    Get-Content $File -Raw |
        ConvertFrom-Json
}

Export-ModuleMember -Function Get-SCMDatabase