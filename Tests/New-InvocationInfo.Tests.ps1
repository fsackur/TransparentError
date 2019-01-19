Describe 'New-InvocationInfo' {

    $HelperFile = Join-Path $PSScriptRoot 'Helper.ps1'
    . $HelperFile
    foo

    $ExpectedPosition = (
        "At $HelperFile`:9 char:5",
        '+     foo',
        '+     ~~~'
    ) -join [Environment]::NewLine


    $ExtentSplat = @{
        File              = $HelperFile
        StartLineNumber   = 9
        StartColumnNumber = 5
        StartLine         = '    foo'
        EndLineNumber     = 9
        EndColumnNumber   = 8
        EndLine           = '    foo'
    }

    $ScriptExtent = & (Get-Module TransparentError) {
        $ExtentSplat = $args[0]
        New-ScriptExtent @ExtentSplat
    } $ExtentSplat


    $FooCommand = Get-Command foo

    $Splat = @{
        Command      = $FooCommand
        ScriptExtent = $ScriptExtent
    }

    $Global:Result = New-InvocationInfo @Splat


    It 'Outputs an ErrorRecord' {
        $Result | Should -BeOfType ([System.Management.Automation.InvocationInfo])

        $Result.MyCommand       | Should -Be $FooCommand
        $Result.ScriptName      | Should -Be $HelperFile
        $Result.PositionMessage | Should -Be $ExpectedPosition
        $Result.InvocationName  | Should -Be 'foo'
    }
}
