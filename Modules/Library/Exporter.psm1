Set-StrictMode -Version Latest

function Export-SCMLibrary {

    param(
        [Parameter(Mandatory)]
        [array]$Games
    )

    $Games |
        ConvertTo-Json -Depth 5 |
        Out-File "C:\temp\library_clean.json"

}

Export-ModuleMember -Function Export-SCMLibrary