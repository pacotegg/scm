Set-StrictMode -Version Latest

function Convert-SCMMetadata {

    param(
        [Parameter(Mandatory)]
        $Game
    )

    # -------------------------
    # BASE VALUES (DO NOT TOUCH)
    # -------------------------

    $rawTitle = $Game.Description
    $title = $rawTitle

    $edition  = ""
    $platform = ""
    $language = ""

    # -------------------------
    # EXTRA METADATA PARSING
    # -------------------------

    if ($rawTitle -match '^(.*?)\s*\((.*?)\)$') {

        $title = $Matches[1].Trim()
        $parts = $Matches[2].Split('/')

        switch ($parts.Count) {
            1 { $edition  = $parts[0].Trim() }
            2 {
                $platform = $parts[0].Trim()
                $language = $parts[1].Trim()
            }
            default {
                $edition  = $parts[0].Trim()
                $platform = $parts[1].Trim()
                $language = $parts[2].Trim()
            }
        }
    }

    # -------------------------
    # SERIES RULES (READ ONLY)
    # -------------------------

    $rulesFile = Join-Path (Get-SCMConfig).Paths.Database "SeriesRules.json"

    $rules = @()
    if (Test-Path $rulesFile) {
        $rules = Get-Content $rulesFile -Raw | ConvertFrom-Json
    }

    $seriesId   = ""
    $seriesName = ""
    $gameTitle  = $title

    foreach ($rule in $rules) {

        if ($title -match $rule.Pattern) {

            $seriesId   = $rule.SeriesId
            $seriesName = $rule.Series

            if ($rule.PSObject.Properties.Name -contains "RemovePrefix") {
                $gameTitle = $title.Substring($rule.RemovePrefix.Length)
            }
            else {
                $gameTitle = $title -replace $rule.Pattern, ""
            }

            $gameTitle = $gameTitle.Trim(" :-").Trim()
            break
        }
    }

    # -------------------------
    # DISPLAY TITLE (SAFE)
    # -------------------------

    $displayTitle = if ($seriesName) {
        "$seriesName: $gameTitle"
    } else {
        $gameTitle
    }

    # -------------------------
    # OUTPUT OBJECT
    # -------------------------

    [PSCustomObject]@{
        GameID   = $Game.GameID
        Engine   = $Game.Engine
        ShortID  = $Game.ShortID

        SeriesId   = $seriesId
        SeriesName = $seriesName

        Title        = $gameTitle
        DisplayTitle = $displayTitle

        Edition  = $edition
        Platform = $platform
        Language = $language

        Description = $rawTitle
        FullPath    = $Game.FullPath
    }
}

Export-ModuleMember -Function Convert-SCMMetadata