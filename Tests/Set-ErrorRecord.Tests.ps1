function foo
{
    $script:CallStack = Get-PSCallStack
    $script:InvocationInfo = $MyInvocation
}

function bar
{
    foo
}

function baz
{
    bar
}


Describe 'Set-ErrorRecord' {

    $MyFile = $MyInvocation.MyCommand.ScriptBlock.File

    $ExpectedPosition = (
        "At $MyFile`:9 char:5",
        '+     foo',
        '+     ~~~'
    ) -join [Environment]::NewLine

    $ExpectedStack = (
        "at foo, $MyFile`: line 3",
        "at bar, $MyFile`: line 9",
        "at baz, $MyFile`: line 14",
        "at <ScriptBlock>, $MyFile`: line 20"
    ) -join [Environment]::NewLine


    baz
    $ErrorRecord = New-ErrorRecord -Message "I am an error"
    $ErrorRecord | Set-ErrorRecord -InvocationInfo $Script:InvocationInfo -CallStack $Script:CallStack


    It 'Sets invocation info' {

        $ErrorRecord.InvocationInfo.ScriptName | Should -Be $MyFile
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
