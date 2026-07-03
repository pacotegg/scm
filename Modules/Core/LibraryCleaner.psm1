Set-StrictMode -Version Latest

function Invoke-SCMLibraryCleanup {

    param(
        [Parameter(Mandatory)]
        [array]$Games
    )

    $config = Get-SCMConfig
    $prefs = $config.Preferences

    $Clean = foreach ($group in ($Games | Group-Object ShortID)) {

        $best =
            $group.Group |
            Sort-Object {

                $score = 1000

                # Ignore unwanted entries
                if ($prefs.IgnoreUnknown -and $_.Description -match "Unknown") {
                    $score += 500
                }

                if ($prefs.IgnoreDemo -and $_.Description -match "Demo") {
                    $score += 500
                }

                # Preferred language
                for ($i = 0; $i -lt $prefs.Languages.Count; $i++) {
                    if ($_.Description -match [regex]::Escape($prefs.Languages[$i])) {
                        $score -= (200 - $i)
                        break
                    }
                }

                # Preferred platform
                for ($i = 0; $i -lt $prefs.Platforms.Count; $i++) {
                    if ($_.Description -match [regex]::Escape($prefs.Platforms[$i])) {
                        $score -= (100 - $i)
                        break
                    }
                }

                if ($prefs.PreferCD -and $_.Description -match "CD") {
                    $score -= 20
                }

                if ($prefs.PreferTalkie -and $_.Description -match "Talkie") {
                    $score -= 10
                }

                if ($prefs.PreferRestored -and $_.Description -match "Restored") {
                    $score -= 10
                }

                $score
            } |
            Select-Object -First 1

        $best
    }

    return $Clean
}

Export-ModuleMember -Function Invoke-SCMLibraryCleanup