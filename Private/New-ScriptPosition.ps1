function New-ScriptPosition
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory, Position = 0)]
        [string]$File,

        [Parameter(Mandatory, Position = 1)]
        [int]$LineNumber,

        [Parameter(Mandatory, Position = 2)]
        [int]$ColumnNumber,

        [Parameter(Mandatory, Position = 3)]
        [string]$Line
    )

    $ScriptPositionCtor = [System.Management.Automation.Language.ScriptPosition].GetConstructors() |
        Where-Object {$_.GetParameters().Count -eq 4}

    $ScriptPositionCtor.Invoke(
        @($File, $LineNumber, $ColumnNumber, $Line)
    )
}
