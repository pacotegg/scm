Set-StrictMode -Version Latest

function Get-SCMDefinitions {

    $Config = Get-SCMConfig

    $File = Join-Path $Config.Paths.Definitions "games.json"

    if (-not (Test-Path $File)) {
        throw "Definitions file not found: $File"
    }

    Get-Content $File -Raw | ConvertFrom-Json

}

function Get-SCMDefinition {

    param(
        [Parameter(Mandatory)]
        [string]$GameID
    )

    $Definitions = Get-SCMDefinitions

    return $Definitions | Where-Object GameID -eq $GameID

}

Export-ModuleMember -Function Get-SCMDefinitions, Get-SCMDefinition