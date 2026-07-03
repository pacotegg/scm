Set-StrictMode -Version Latest

function Convert-SCMMetadata {

    param(
        [Parameter(Mandatory)]
        $Game
    )

    # Load definitions
    $Definitions = Get-SCMDefinitions

    $Definition = $Definitions | Where-Object { $_.gameid -eq $Game.GameID }

    # -------------------------
    # BASE VALUES (fallback)
    # -------------------------

    $Title = $Game.Description
    $Edition = ""
    $Platform = ""
    $Language = ""

    # -------------------------
    # PARSE PARENTHESIS METADATA
    # -------------------------

    if ($Game.Description -match '^(.*?)\s*\((.*?)\)$') {

        $Title = $Matches[1].Trim()

        $Parts = $Matches[2].Split('/')

        switch ($Parts.Count) {
            1 { $Edition = $Parts[0].Trim() }
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

    # -------------------------
    # APPLY DEFINITION OVERRIDES
    # -------------------------

    $CanonicalFolder = $Game.ShortID
    $DisplayTitle = $Title
    $Series = ""

    if ($Definition) {

        if ($Definition.displayTitle) {
            $DisplayTitle = $Definition.displayTitle
        }

        if ($Definition.canonicalFolder) {
            $CanonicalFolder = $Definition.canonicalFolder
        }

        if ($Definition.series) {
            $Series = $Definition.series
        }
    }

    # -------------------------
    # OUTPUT OBJECT
    # -------------------------

    [PSCustomObject]@{

        GameID          = $Game.GameID
        Engine          = $Game.Engine
        ShortID         = $Game.ShortID

        Series          = $Series
        Title           = $Title
        DisplayTitle    = $DisplayTitle

        CanonicalFolder = $CanonicalFolder

        Edition         = $Edition
        Platform        = $Platform
        Language        = $Language

        Description     = $Game.Description
        FullPath        = $Game.FullPath
    }
}

Export-ModuleMember -Function Convert-SCMMetadata