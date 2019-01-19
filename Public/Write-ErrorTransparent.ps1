function Write-ErrorTransparent
{
    <#
        .ForwardHelpTargetName Microsoft.PowerShell.Utility\Write-Error

        .ForwardHelpCategory Cmdlet
    #>
    [CmdletBinding(DefaultParameterSetName = 'NoException', HelpUri = 'http://go.microsoft.com/fwlink/?LinkID=113425', RemotingCapability = 'None')]
    param
    (
        [Parameter(ParameterSetName = 'WithException', Mandatory)]
        [System.Exception]$Exception,

        [Parameter(ParameterSetName = 'WithException')]
        [Parameter(ParameterSetName = 'NoException', Mandatory, Position = 0, ValueFromPipeline)]
        [Alias('Msg')]
        [AllowNull()]
        [AllowEmptyString()]
        [string]$Message,

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

    process
    {
        try
        {
            $steppablePipeline.Process($_)
        }
        catch
        {
            throw
        }
    }

    end
    {
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
