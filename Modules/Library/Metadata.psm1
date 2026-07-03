Set-StrictMode -Version Latest

function Convert-SCMMetadata {

    param(
        [Parameter(Mandatory)]
        $Game
    )

    #-------------------------------------------------------
    # Parse Description
    #-------------------------------------------------------

    $Title = $Game.Description
    $Edition = ""
    $Platform = ""
    $Language = ""

    if ($Game.Description -match '^(.*?)\s*\((.*?)\)$') {

        $Title = $Matches[1].Trim()

        $Parts = $Matches[2].Split('/')

        switch ($Parts.Count) {

            1 {
                $Edition = $Parts[0].Trim()
            }

            2 {
                $Platform = $Parts[0].Trim()
                $Language = $Parts[1].Trim()
            }

            default {
                $Edition  = $Parts[0].Trim()
                $Platform = $Parts[1].Trim()
                $Language = $Parts[2].Trim()
            }
        }
    }

    #-------------------------------------------------------
    # Series detection
    #-------------------------------------------------------

    $Series = ""
    $GameTitle = $Title

    $RulesFile = Join-Path (Get-SCMConfig).Paths.Database "SeriesRules.json"

    if (Test-Path $RulesFile) {

        $Rules = Get-Content $RulesFile -Raw | ConvertFrom-Json

        foreach ($Rule in $Rules) {

            if ($Title -match $Rule.Pattern) {

                $Series = $Rule.Series

                if ($Rule.PSObject.Properties.Name -contains "RemovePrefix") {

                    $GameTitle = $Title -replace "^$([regex]::Escape($Rule.RemovePrefix))", ""
                    $GameTitle = $GameTitle.Trim(" :-")

                }
                else {

                    $GameTitle = $Title

                }

                break
            }
        }
    }

    #-------------------------------------------------------
    # Display title
    #-------------------------------------------------------

    if ([string]::IsNullOrWhiteSpace($Series)) {
        $DisplayTitle = $GameTitle
    }
    else {
        $DisplayTitle = "${Series}: $GameTitle"
    }

    #-------------------------------------------------------
    # Result
    #-------------------------------------------------------

    [PSCustomObject]@{

        GameID       = $Game.GameID
        Engine       = $Game.Engine
        ShortID      = $Game.ShortID

        Series       = $Series
        Title        = $GameTitle
        DisplayTitle = $DisplayTitle

        Edition      = $Edition
        Platform     = $Platform
        Language     = $Language

        Description  = $Game.Description
        FullPath     = $Game.FullPath
    }
}

Export-ModuleMember -Function Convert-SCMMetadata