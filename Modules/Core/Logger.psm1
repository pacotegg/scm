Set-StrictMode -Version Latest

function Write-SCMLog {

    param(
        [string]$Message
    )

    $Root = Split-Path $PSScriptRoot -Parent -Parent

    $LogFolder = Join-Path $Root "Logs"

    if (!(Test-Path $LogFolder)) {
        New-Item $LogFolder -ItemType Directory | Out-Null
    }

    $LogFile = Join-Path $LogFolder "$(Get-Date -Format 'yyyy-MM-dd').log"

    Add-Content $LogFile "$(Get-Date -Format 'HH:mm:ss')  $Message"
}

Export-ModuleMember -Function *