function New-ScriptExtent
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory, Position = 0)]
        [string]$File,

        [Parameter(Mandatory)]
        [int]$StartLineNumber,

        [Parameter(Mandatory)]
        [int]$StartColumnNumber,

        [Parameter(Mandatory)]
        [string]$StartLine,

        [Parameter(Mandatory)]
        [int]$EndLineNumber,

        [Parameter(Mandatory)]
        [int]$EndColumnNumber,

        [Parameter(Mandatory)]
        [string]$EndLine
    )

    $StartSplat = @{
        File         = $File
        LineNumber   = $StartLineNumber
        ColumnNumber = $StartColumnNumber
        Line         = $StartLine
    }

    $EndSplat = @{
        File         = $File
        LineNumber   = $EndLineNumber
        ColumnNumber = $EndColumnNumber
        Line         = $EndLine
    }

    $StartPosition = New-ScriptPosition @StartSplat
    $EndPosition   = New-ScriptPosition @EndSplat

    $ScriptExtentCtor = [System.Management.Automation.Language.ScriptExtent].GetConstructors() |
        Where-Object {$_.GetParameters().Count -eq 2}

    $ScriptExtentCtor.Invoke(
        @($StartPosition, $EndPosition)
    )
}
