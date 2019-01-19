@{
    Description       = "A proxy for Write-Error that doesn't obliterate an ErrorRecord's stack trace or position message."
    ModuleVersion     = '0.0.0.1'
    GUID              = '996550e9-c94a-463f-ac92-baa99e329f71'
    ModuleToProcess   = 'TransparentError.psm1'

    Author            = 'Freddie Sackur'
    CompanyName       = 'dustyfox.uk'
    Copyright         = '(c) 2019 Freddie Sackur. All rights reserved.'

    RequiredModules   = @()
    FunctionsToExport = @(
        'New-ErrorRecord',
        'Set-ErrorRecord',
        'Write-ErrorTransparent'
    )
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @()


    PrivateData       = @{
        PSData = @{
            LicenseUri = 'https://raw.githubusercontent.com/fsackur/TransparentError/master/LICENSE'
            ProjectUri = 'https://fsackur.github.io/TransparentError/'
            Tags       = @(
                'Error',
                'Throw',
                'Write-Error',
                'Transparent',
                'Stack',
                'StackTrace',
                'Position',
                'Proxy'
            )
        }
    }
}
