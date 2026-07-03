Set-StrictMode -Version Latest

function Get-SCMConfig {

    $Root = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent

    $ConfigFile = Join-Path $Root "config.json"

    if (!(Test-Path $ConfigFile)) {
        throw "Configuration file not found: $ConfigFile"
    }

    Get-Content $ConfigFile -Raw | ConvertFrom-Json
}

Export-ModuleMember -Function *