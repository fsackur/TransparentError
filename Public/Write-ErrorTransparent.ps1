function Write-ErrorTransparent
{
    <#
        .ForwardHelpTargetName Microsoft.PowerShell.Utility\Write-Error

        .ForwardHelpCategory Cmdlet
    #>
    [CmdletBinding(DefaultParameterSetName = 'NoException', HelpUri = 'http://go.microsoft.com/fwlink/?LinkID=113425', RemotingCapability = 'None')]
    param
    (
        [Parameter(ParameterSetName = 'Transparent', Mandatory)]
        [switch]$Transparent,

        [Parameter(ParameterSetName = 'WithException', Mandatory)]
        [System.Exception]$Exception,

        [Parameter(ParameterSetName = 'WithException')]
        [Parameter(ParameterSetName = 'NoException', Mandatory, Position = 0, ValueFromPipeline)]
        [Alias('Msg')]
        [AllowNull()]
        [AllowEmptyString()]
        [string]$Message,

        [Parameter(ParameterSetName = 'Transparent', Mandatory, Position = 0, ValueFromPipeline)]
        [Parameter(ParameterSetName = 'ErrorRecord', Mandatory)]
        [System.Management.Automation.ErrorRecord]$ErrorRecord,

        [Parameter(ParameterSetName = 'WithException')]
        [Parameter(ParameterSetName = 'NoException')]
        [System.Management.Automation.ErrorCategory]$Category,

        [Parameter(ParameterSetName = 'WithException')]
        [Parameter(ParameterSetName = 'NoException')]
        [string]$ErrorId,

        [Parameter(ParameterSetName = 'NoException')]
        [Parameter(ParameterSetName = 'WithException')]
        [System.Object]$TargetObject,

        [string]$RecommendedAction,

        [Alias('Activity')]
        [string]$CategoryActivity,

        [Alias('Reason')]
        [string]$CategoryReason,

        [Alias('TargetName')]
        [string]$CategoryTargetName,

        [Alias('TargetType')]
        [string]$CategoryTargetType
    )

    begin
    {
        if (-not $Transparent)
        {
            # Proxy without alteration
            try
            {
                $outBuffer = $null
                if ($PSBoundParameters.TryGetValue('OutBuffer', [ref]$outBuffer))
                {
                    $PSBoundParameters['OutBuffer'] = 1
                }
                $wrappedCmd = $ExecutionContext.InvokeCommand.GetCommand('Microsoft.PowerShell.Utility\Write-Error', [System.Management.Automation.CommandTypes]::Cmdlet)
                $scriptCmd = {& $wrappedCmd @PSBoundParameters }
                $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
                $steppablePipeline.Begin($PSCmdlet)
            }
            catch
            {
                throw
            }
        }
    }

    process
    {
        if ($Transparent)
        {
            $Runtime = $PSCmdlet.CommandRuntime

            # Assert that the current host has a runtime of type MshCommandRuntime
            $RuntimeType = $Runtime.GetType()                                                                  # Not a fully-populated type object because it's an internal class
            $RuntimeType = $RuntimeType.Assembly.GetType('System.Management.Automation.MshCommandRuntime')     # It is now
            if (-not ($RuntimeType -and $RunTime -is $RuntimeType))
            {
                throw "Runtime is not MshCommandRuntime; command '$($MyInvocation.MyCommand.Name)' will not work in this host."
            }

            # Use reflection to get internal method
            # https://github.com/PowerShell/PowerShell/blob/master/src/System.Management.Automation/engine/MshCommandRuntime.cs
            $_WriteErrorSkipAllowCheck = $Runtime.GetType().GetMethod(
                '_WriteErrorSkipAllowCheck',
                ([System.Reflection.BindingFlags]::Instance -bor [System.Reflection.BindingFlags]::NonPublic)
            )

            # Write the error
            $_WriteErrorSkipAllowCheck.Invoke(
                $Runtime,
                @($ErrorRecord, $null)
            )
        }
        else
        {
            # Proxy without alteration
            try
            {
                $steppablePipeline.Process($_)
            }
            catch
            {
                throw
            }
        }
    }

    end
    {
        if (-not $Transparent)
        {
            # Proxy without alteration
            try
            {
                $steppablePipeline.End()
            }
            catch
            {
                throw
            }
        }
    }
}
