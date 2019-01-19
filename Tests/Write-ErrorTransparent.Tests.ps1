Describe 'Write-ErrorTransparent' {

    $HelperFile = Join-Path $PSScriptRoot 'Helper.ps1'
    . $HelperFile

    baz
    $ErrorRecord = New-ErrorRecord -Message "I am an error"
    $ErrorRecord | Set-ErrorRecord -InvocationInfo $Script:InvocationInfo -CallStack $Script:CallStack
    $ErrorRecord | Write-ErrorTransparent -ErrorAction SilentlyContinue -ErrorVariable Result

    It 'Proxies transparently' {

        $Result.Count | Should -Be 1
        $Result = $Result[0]

        # The steppable pipeline in the proxy prevents Pester from mocking
        # We'll rely on Write-Error behaviour
        $Result.InvocationInfo.InvocationName  | Should -Not -BeLike $ErrorRecord.InvocationInfo.InvocationName
        $Result.InvocationInfo.PositionMessage | Should -Not -BeLike $ErrorRecord.InvocationInfo.PositionMessage
        $Result.ScriptStackTrace               | Should -Not -BeLike $ErrorRecord.ScriptStackTrace
    }


    $ErrorRecord | Write-ErrorTransparent -Transparent -ErrorAction SilentlyContinue -ErrorVariable Result

    It 'Outputs errors unaltered with -Transparent switch' {

        $Result.Count | Should -Be 1
        $Result = $Result[0]

        $Result.InvocationInfo.InvocationName  | Should -BeLike $ErrorRecord.InvocationInfo.InvocationName
        $Result.InvocationInfo.PositionMessage | Should -BeLike $ErrorRecord.InvocationInfo.PositionMessage
        $Result.ScriptStackTrace               | Should -BeLike $ErrorRecord.ScriptStackTrace
    }
}