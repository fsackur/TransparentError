Describe 'Set-ErrorRecord' {

    $HelperFile = Join-Path $PSScriptRoot 'Helper.ps1'
    . $HelperFile

    $ExpectedPosition = (
        "At $HelperFile`:9 char:5",
        '+     foo',
        '+     ~~~'
    ) -join [Environment]::NewLine

    $ExpectedStack = (
        "at foo, $HelperFile`: line 3",
        "at bar, $HelperFile`: line 9",
        "at baz, $HelperFile`: line 14",
        "at <ScriptBlock>, $HelperFile`: line 20"
    ) -join [Environment]::NewLine


    baz
    $ErrorRecord = New-ErrorRecord -Message "I am an error"
    $ErrorRecord | Set-ErrorRecord -InvocationInfo $Script:InvocationInfo -CallStack $Script:CallStack


    It 'Sets invocation info' {

        $ErrorRecord.InvocationInfo.ScriptName | Should -Be $HelperFile
        $ErrorRecord.InvocationInfo.InvocationName | Should -Be 'foo'
        $ErrorRecord.InvocationInfo.PositionMessage | Should -Be $ExpectedPosition
    }


    It 'Sets stack trace' {

        $FrameStrings = $ErrorRecord.ScriptStackTrace -split ([regex]::Escape([Environment]::NewLine))
        for ($i = 0; $i++; $i -lt $FrameStrings.Count)
        {
            $FrameStrings[$i] | Should -Be $ExpectedStack[$i]   # Pester will have further frames on the stack, whcih we'll ignore.
        }
    }
}
