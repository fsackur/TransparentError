Describe 'New-ScriptExtent' {

    $Splat = @{
        File              = "$PSScriptRoot\Helper.ps1"
        StartLineNumber   = 12
        StartColumnNumber = 10
        StartLine         = 'function baz'
        EndLineNumber     = 12
        EndColumnNumber   = 13
        EndLine           = 'function baz'
    }


    $Result = & (Get-Module TransparentError) {
        $Splat = $args[0]
        New-ScriptExtent @Splat
    } $Splat


    It 'Outputs a script position' {

        $Splat.Remove('StartLine')
        $Splat.Remove('EndLine')
        $Splat.Add('Text', 'baz')

        $Splat.GetEnumerator() | ForEach-Object {
            $Result.$($_.Key) | Should -BeExactly $_.Value
        }
    }
}
