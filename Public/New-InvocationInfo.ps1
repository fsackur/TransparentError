function New-InvocationInfo
{
    param
    (
        [Parameter(Mandatory, Position = 0)]
        [System.Management.Automation.CommandInfo]$Command,

        [Parameter(Mandatory, Position = 1)]
        [System.Management.Automation.Language.IScriptExtent]$ScriptExtent,

        [Parameter()]
        [System.Threading.ExecutionContext]$Context
    )


    $InvocationInfo = [System.Runtime.Serialization.FormatterServices]::GetUninitializedObject([System.Management.Automation.InvocationInfo])

    $Fields = @{}
    $BindingFlags = [System.Reflection.BindingFlags]::NonPublic -bor
                    [System.Reflection.BindingFlags]::Instance

    [System.Management.Automation.InvocationInfo].GetFields($BindingFlags) |
        ForEach-Object {$Fields.Add($_.Name, $_)}

    $Fields._commandInfo.SetValue($InvocationInfo, $Command)
    $Fields._scriptPosition.SetValue($InvocationInfo, $ScriptExtent)
    $Fields._invocationName.SetValue($InvocationInfo, $ScriptExtent.Text)


    $InvocationInfo
}
