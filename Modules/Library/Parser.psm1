Set-StrictMode -Version Latest

function Get-SCMDetectionLines {

    param(
        [string[]]$ScummVMOutput
    )

    $Lines = @()
    $buffer = ""

    foreach ($Line in $ScummVMOutput) {

        if ([string]::IsNullOrWhiteSpace($Line)) {
            continue
        }

        # Skip headers
        if ($Line -match 'GameID|Description|Full Path|Scanning|Detected') {
            continue
        }

        # If line looks like a new game entry
        if ($Line -match '^\S') {

            # flush previous buffered line
            if ($buffer -ne "") {
                $Lines += $buffer.Trim()
            }

            $buffer = $Line
        }
        else {
            # continuation line → append
            $buffer += " " + $Line.Trim()
        }
    }

    # flush last entry
    if ($buffer -ne "") {
        $Lines += $buffer.Trim()
    }

    return $Lines
}

function Convert-SCMDetectionLine {

    param(
        [string]$Line
    )

    $Match = [regex]::Match(
        $Line,
        '^(?<GameID>\S+)\s+(?<Description>.+?)\s{2,}(?<FullPath>[A-Za-z]:\\.+)$'
    )

    if (-not $Match.Success) {
        return $null
    }

    $GameID = $Match.Groups["GameID"].Value

    $Parts = $GameID.Split(":",2)

    if ($Parts.Count -eq 2) {
        $Engine = $Parts[0]
        $ShortID = $Parts[1]
    }
    else {
        $Engine = ""
        $ShortID = $GameID
    }

    [PSCustomObject]@{
        GameID      = $GameID
        Engine      = $Engine
        ShortID     = $ShortID
        Description = $Match.Groups["Description"].Value.Trim()
        FullPath    = $Match.Groups["FullPath"].Value
    }
}

Export-ModuleMember -Function *

