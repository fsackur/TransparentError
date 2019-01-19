function New-ErrorRecord
{
    <#
        .SYNOPSIS
        Creates a new ErrorRecord.

        .DESCRIPTION
        Creates a new ErrorRecord.
    #>
    [CmdletBinding(DefaultParameterSetName = 'NoException', HelpUri = 'https://docs.microsoft.com/en-us/dotnet/api/system.management.automation.errorrecord')]
    [OutputType([System.Management.Automation.ErrorRecord])]
    param
    (
        [Parameter(ParameterSetName = 'NoException', Mandatory, Position = 0, ValueFromPipeline)]
        [string]$Message,

        [Parameter(ParameterSetName = 'WithException', Mandatory)]
        [System.Exception]$Exception,

        [Parameter(ParameterSetName = 'WithException')]
        [string]$ErrorId,

        [Parameter(ParameterSetName = 'WithException')]
        [System.Management.Automation.ErrorCategory]$ErrorCategory,

        [Parameter()]
        [System.Object]$TargetObject = $null
    )

    process
    {
        if ($PSCmdlet.ParameterSetName -eq 'NoException')
        {
            $Exception = [Microsoft.PowerShell.Commands.WriteErrorException]::new($Message)
        }

        if ([string]::IsNullOrEmpty($ErrorId))
        {
            $ErrorId = $Exception.GetType().FullName
        }

        if ($null -eq $ErrorCategory)
        {
            $ErrorCategory = [System.Management.Automation.ErrorCategory]::NotSpecified
        }

        [System.Management.Automation.ErrorRecord]::new(
            $Exception,
            $ErrorId,
            $ErrorCategory,
            $TargetObject
        )
    }
}
