Set-StrictMode -Version Latest

function Show-SCMHeader {

    param (
        [string]$Version
    )

    Clear-Host

    Write-Host ""
    Write-Host "╔══════════════════════════════════════════════════════════════════╗" -ForegroundColor DarkCyan
    Write-Host "║                                                                  ║" -ForegroundColor DarkCyan
    Write-Host "║                 ScummVM Collection Manager                       ║" -ForegroundColor Cyan
    Write-Host "║                                                                  ║" -ForegroundColor DarkCyan
    Write-Host ("║                       Version {0,-16}                 ║" -f $Version) -ForegroundColor Gray
    Write-Host "╚══════════════════════════════════════════════════════════════════╝" -ForegroundColor DarkCyan
    Write-Host ""
}

function Pause-SCM {

    Write-Host ""
    Read-Host "Press ENTER to continue"
}

Export-ModuleMember -Function *