function Set-ErrorRecord
{
    <#
        .SYNOPSIS
        Sets the InvocationInfo and ScriptStackTrace properties of an ErrorRecord.

        .DESCRIPTION
        Sets the InvocationInfo and ScriptStackTrace properties of an ErrorRecord.
    #>
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    [OutputType([void], ParameterSetName = 'Default')]
    [OutputType([System.Management.Automation.ErrorRecord], ParameterSetName = 'PassThru')]
    param
    (
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [System.Management.Automation.ErrorRecord]$ErrorRecord,

        [Parameter()]
        [System.Management.Automation.InvocationInfo]$InvocationInfo,

        [Parameter()]
        [System.Management.Automation.CallStackFrame[]]$CallStack
    )

    begin
    {
        $SetInvocationInfo = $_scriptStackTrace = $null
    }

    process
    {
        if ($InvocationInfo)
        {
            if (-not $SetInvocationInfo)
            {
                $SetInvocationInfo = [System.Management.Automation.ErrorRecord].GetMethod(
                    'SetInvocationInfo',
                    ([System.Reflection.BindingFlags]::Instance -bor [System.Reflection.BindingFlags]::NonPublic)
                )
            }

            $SetInvocationInfo.Invoke(
                $ErrorRecord,
                $InvocationInfo
            )
        }

        if ($CallStack)
        {
            $sb = [System.Text.StringBuilder]::new()
            $First = $true
            foreach ($Frame in $CallStack)
            {
                if (-not $First)
                {
                    $null = $sb.Append([Environment]::NewLine)
                }
                $First = $false
                $null = $sb.Append($Frame.ToString())
            }
            $ScriptStackTrace = $sb.ToString()


            if (-not $_scriptStackTrace)
            {
                $_scriptStackTrace = [System.Management.Automation.ErrorRecord].GetField(
                    '_scriptStackTrace',
                    ([System.Reflection.BindingFlags]::Instance -bor [System.Reflection.BindingFlags]::NonPublic)
                )
            }

            $_scriptStackTrace.SetValue(
                $ErrorRecord,
                $ScriptStackTrace
            )
        }
    }
}
