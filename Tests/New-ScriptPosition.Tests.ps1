Describe 'New-ScriptPosition' {

    $Splat = @{
        File         = "$PSScriptRoot\Helper.ps1"
        LineNumber   = 12
        ColumnNumber = 10
        Line         = 'function baz'
    }

    $Result = & (Get-Module TransparentError) {
        $Splat = $args[0]
        New-ScriptPosition @Splat
    } $Splat

    It 'Outputs a script position' {

        $Splat.GetEnumerator() | ForEach-Object {
            $Result.$($_.Key) | Should -BeExactly $_.Value
        }
    }
}
