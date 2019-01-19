Get-ChildItem $PSScriptRoot\Public -Filter '*.ps1' | Foreach-Object {. $_.FullName}
