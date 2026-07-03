Set-StrictMode -Version Latest

function Show-SCMSelector {

    param(
        [Parameter(Mandatory)]
        [string]$Title,

        [Parameter(Mandatory)]
        [array]$Items
    )

    $Index = 0

    while ($true) {

        Clear-Host

        Write-Host ""
        Write-Host ("========== {0} ==========" -f $Title) -ForegroundColor Cyan
        Write-Host ""

        $Top = [Math]::Max(0, $Index - 7)
        $Bottom = [Math]::Min($Items.Count - 1, $Top + 14)

        for ($i = $Top; $i -le $Bottom; $i++) {

            if ($i -eq $Index) {

                Write-Host ("> {0}" -f $Items[$i]) -ForegroundColor Yellow

            }
            else {

                Write-Host ("  {0}" -f $Items[$i])

            }

        }

        Write-Host ""
        Write-Host "↑↓ Move   Enter Select   Esc Back" -ForegroundColor DarkGray

        $Key = [Console]::ReadKey($true)

        switch ($Key.Key) {

            "UpArrow" {

                if ($Index -gt 0) {
                    $Index--
                }

            }

            "DownArrow" {

                if ($Index -lt ($Items.Count - 1)) {
                    $Index++
                }

            }

            "Enter" {

                return $Index

            }

            "Escape" {

                return -1

            }

        }

    }

}

Export-ModuleMember -Function Show-SCMSelector